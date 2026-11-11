// Mengubah modul praktikum (.md) menjadi .docx dengan gaya modul DM099.
// Pemakaian: NODE_PATH=$(npm root -g) node tools/md2docx.js <modul.md> <keluaran.docx> "<judul header>"
const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, ImageRun, Table, TableRow, TableCell,
  AlignmentType, BorderStyle, WidthType, ShadingType, LevelFormat, PageBreak,
  Header, Footer, PageNumber, ExternalHyperlink, TableLayoutType, VerticalAlign,
  TabStopType,
} = require("docx");

const [, , SRC, OUT, HEADER_TEXT = "DM099 Perancangan Basis Data"] = process.argv;
const BASE = path.dirname(SRC);
const md = fs.readFileSync(SRC, "utf8").replace(/\r/g, "");

// ---- Gaya ----
const NAVY = "1F3864";
const GRAY = "595959";
const FONT = "Arial";
const MONO = "Courier New";
const PAGE_W = 11906, MARGIN = 1247;          // A4, margin 2,2 cm
const CONTENT_W = PAGE_W - 2 * MARGIN;        // 9412 DXA
const BODY = 21;                              // 10,5 pt
const CELL_BORDER = { style: BorderStyle.SINGLE, size: 4, color: "A6A6A6" };

// ---- Inline: **tebal**, *miring*, `kode`, [teks](url) ----
function inline(text, base = {}) {
  const out = [];
  const re = /(\*\*(.+?)\*\*)|(`([^`]+)`)|(\[([^\]]+)\]\(([^)]+)\))|(\*([^*]+)\*)/g;
  let last = 0, m;
  const plain = (t, st) => t && out.push(new TextRun({ text: t, font: FONT, size: base.size || BODY, ...st }));
  while ((m = re.exec(text))) {
    plain(text.slice(last, m.index), base);
    if (m[1]) out.push(...inline(m[2], { ...base, bold: true }));
    else if (m[3]) out.push(new TextRun({ text: m[4], font: MONO, size: (base.size || BODY) - 2, bold: base.bold, italics: base.italics, color: base.color }));
    else if (m[5]) out.push(new ExternalHyperlink({ link: m[7], children: inline(m[6], { ...base, color: "1F4E9A", underline: {} }) }));
    else if (m[8]) out.push(...inline(m[9], { ...base, italics: true }));
    last = re.lastIndex;
  }
  plain(text.slice(last), base);
  return out;
}

// ---- Tabel ----
function columnWidths(rows) {
  const n = rows[0].length;
  const clean = t => (t || "").replace(/[*`]/g, "");
  // lebar minimum: kata terpanjang (nama berkas, jam) tidak boleh terpotong
  const minW = Array.from({ length: n }, (_, c) =>
    Math.max(...rows.map(r => Math.max(...clean(r[c]).split(/[ \t]+/).map(w => w.length)))) * 105 + 260);
  const score = Array.from({ length: n }, (_, c) => {
    const lens = rows.map(r => clean(r[c]).length);
    return Math.max(4, lens.reduce((a, b) => a + b, 0) / lens.length);
  });
  const base = minW.reduce((a, b) => a + b, 0);
  const extra = Math.max(0, CONTENT_W - base);
  const total = score.reduce((a, b) => a + b, 0);
  const w = minW.map((m, c) => Math.round(m + (extra * score[c]) / total));
  const scale = CONTENT_W / w.reduce((a, b) => a + b, 0);
  const out = w.map(x => Math.round(x * scale));
  out[n - 1] += CONTENT_W - out.reduce((a, b) => a + b, 0);
  return out;
}

function table(rows) {
  const widths = columnWidths(rows);
  return new Table({
    width: { size: CONTENT_W, type: WidthType.DXA },
    columnWidths: widths,
    layout: TableLayoutType.FIXED,
    rows: rows.map((r, i) => new TableRow({
      tableHeader: i === 0,
      cantSplit: true,
      children: r.map((cell, c) => new TableCell({
        width: { size: widths[c], type: WidthType.DXA },
        borders: { top: CELL_BORDER, bottom: CELL_BORDER, left: CELL_BORDER, right: CELL_BORDER },
        shading: i === 0 ? { type: ShadingType.CLEAR, fill: "D9E2F3", color: "auto" } : undefined,
        margins: { top: 60, bottom: 60, left: 100, right: 100 },
        verticalAlign: VerticalAlign.CENTER,
        children: [new Paragraph({
          keepNext: rows.length <= 10 && i < rows.length - 1,
          spacing: { before: 0, after: 0, line: 252 },
          children: inline(cell.replace(/^\*\*(.*)\*\*$/, "$1"), { size: 19, bold: i === 0, color: i === 0 ? NAVY : undefined }),
        })],
      })),
    })),
  });
}

// ---- Blok kode: paragraf berlatar abu-abu dengan garis kiri ----
function codeBlock(lines) {
  return lines.map((ln, i) => new Paragraph({
    shading: { type: ShadingType.CLEAR, fill: "F2F2F2", color: "auto" },
    border: { left: { style: BorderStyle.SINGLE, size: 18, color: NAVY, space: 6 } },
    indent: { left: 170, right: 113 },
    spacing: { before: i === 0 ? 60 : 0, after: i === lines.length - 1 ? 160 : 0, line: 240 },
    keepLines: true,
    keepNext: i < lines.length - 1,
    children: [new TextRun({ text: ln.length ? ln : " ", font: MONO, size: 18 })],
  }));
}

// ---- Gambar ----
function image(file) {
  const buf = fs.readFileSync(path.join(BASE, file));
  const w = buf.readUInt32BE(16), h = buf.readUInt32BE(20);   // header PNG
  const width = 610;
  return new Paragraph({
    alignment: AlignmentType.CENTER, keepNext: true, spacing: { before: 120, after: 60 },
    children: [new ImageRun({ type: "png", data: buf, transformation: { width, height: Math.round((width * h) / w) } })],
  });
}

// ---- Sampul (bagian sebelum garis "---") ----
function cover(block) {
  const lines = block.split("\n").map(s => s.trim()).filter(Boolean).map(s => s.replace(/^\*\*(.*)\*\*$/, "$1"));
  const p = (text, size, opts = {}) => new Paragraph({
    alignment: AlignmentType.CENTER, spacing: { before: opts.before || 0, after: opts.after ?? 120 },
    children: [new TextRun({ text, font: FONT, size, bold: opts.bold, color: opts.color || NAVY })],
  });
  const rule = new Paragraph({
    spacing: { before: 120, after: 360 }, indent: { left: 2600, right: 2600 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 12, color: NAVY, space: 1 } }, children: [],
  });
  const [l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11] = lines;
  return [
    p(l1, 24, { bold: true, before: 2600, after: 360 }),
    p(l2, 56, { bold: true, after: 60 }),
    p(l3, 56, { bold: true, after: 240 }),
    p(l4, 26, { bold: true, after: 0 }),
    rule,
    p(l5, 24, { bold: true, after: 160 }),
    p(l6, 34, { bold: true, after: 720 }),
    p(l7, 21, { color: GRAY, after: 100 }),
    p(l8, 21, { color: GRAY, after: 100 }),
    p(l9, 21, { color: GRAY, after: 2400 }),
    p(l10, 22, { bold: true, after: 100 }),
    p(l11, 22, { bold: true, after: 0 }),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ---- Isi ----
const [coverMd, bodyMd] = md.split(/\n---\n/);
const lines = bodyMd.split("\n");
const children = [];
let listInstance = 0, inList = false;

const para = (text, opts = {}) => new Paragraph({
  alignment: opts.align || AlignmentType.JUSTIFIED,
  spacing: { before: 0, after: 120, line: 276 },
  keepNext: opts.keepNext,
  children: inline(text, opts.run || {}),
});

for (let i = 0; i < lines.length; i++) {
  const ln = lines[i];
  if (!ln.trim()) continue;

  if (ln.startsWith("```")) {
    const buf = [];
    for (i++; i < lines.length && !lines[i].startsWith("```"); i++) buf.push(lines[i]);
    children.push(...codeBlock(buf));
    continue;
  }
  if (ln.startsWith("|")) {
    const rows = [];
    for (; i < lines.length && lines[i].startsWith("|"); i++) {
      if (/^\|\s*-/.test(lines[i])) continue;
      rows.push(lines[i].slice(1, -1).split("|").map(s => s.trim().replace(/(\d) (menit)/g, "$1\u00A0$2")));
    }
    i--;
    children.push(table(rows), new Paragraph({ spacing: { before: 0, after: 120 }, children: [] }));
    continue;
  }
  let m;
  if ((m = ln.match(/^# (.*)/))) {
    inList = false;
    children.push(new Paragraph({
      keepNext: true, spacing: { before: 360, after: 140 },
      border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: NAVY, space: 3 } },
      children: [new TextRun({ text: m[1], font: FONT, size: 28, bold: true, color: NAVY })],
    }));
    continue;
  }
  if ((m = ln.match(/^## (.*)/))) {
    inList = false;
    children.push(new Paragraph({
      keepNext: true, spacing: { before: 280, after: 120 },
      children: inline(m[1], { size: 24, bold: true, color: NAVY }),
    }));
    continue;
  }
  if ((m = ln.match(/^!\[[^\]]*\]\(([^)]+)\)/))) { children.push(image(m[1])); continue; }
  if ((m = ln.match(/^\*(Gambar \d+\..*)\*$/))) {
    const [, label, rest] = m[1].match(/^(Gambar \d+\.)(.*)$/);
    children.push(new Paragraph({
      alignment: AlignmentType.CENTER, spacing: { before: 0, after: 200 },
      children: [...inline(label, { size: 18, bold: true, italics: true, color: GRAY }), ...inline(rest, { size: 18, italics: true, color: GRAY })],
    }));
    continue;
  }
  if ((m = ln.match(/^(Tabel \d+\.)(.*)$/))) {
    children.push(new Paragraph({
      alignment: AlignmentType.CENTER, keepNext: true, spacing: { before: 120, after: 80 },
      children: [...inline(m[1], { size: 19, bold: true, color: NAVY }), ...inline(m[2], { size: 19 })],
    }));
    continue;
  }
  if ((m = ln.match(/^- ☐ (.*)/))) {
    children.push(new Paragraph({
      spacing: { before: 0, after: 80, line: 276 }, indent: { left: 400, hanging: 400 },
      tabStops: [{ type: TabStopType.LEFT, position: 400 }],
      children: [new TextRun({ text: "☐\t", font: "Segoe UI Symbol", size: BODY }), ...inline(m[1])],
    }));
    continue;
  }
  if ((m = ln.match(/^(\d+)\. (.*)/))) {
    if (m[1] === "1" || !inList) listInstance++;
    inList = true;
    children.push(new Paragraph({
      numbering: { reference: "angka", level: 0, instance: listInstance },
      alignment: AlignmentType.JUSTIFIED, spacing: { before: 0, after: 100, line: 276 },
      children: inline(m[2]),
    }));
    continue;
  }
  if ((m = ln.match(/^\*\*(MODUL PRAKTIKUM \d+)\*\*$/))) {
    children.push(new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 0, after: 60 },
      children: [new TextRun({ text: m[1], font: FONT, size: 30, bold: true, color: NAVY })] }));
    const t = lines[++i] && lines[i].trim() ? lines[i] : lines[++i];
    children.push(new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 0, after: 360 },
      border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: NAVY, space: 8 } },
      children: [new TextRun({ text: t.replace(/\*\*/g, ""), font: FONT, size: 28, bold: true, color: NAVY })] }));
    continue;
  }
  if (/^\*\*[^*]+\*\*$/.test(ln)) { children.push(para(ln, { keepNext: true, align: AlignmentType.LEFT })); continue; }
  // paragraf biasa; daftar bernomor yang diselingi blok kode/gambar tetap berlanjut
  if (!/^\d+\. /.test(lines.slice(i + 1).find(l => l.trim() && !l.startsWith("```") && !l.startsWith("!") && !l.startsWith("*Gambar")) || "")) inList = false;
  children.push(para(ln));
}

// ---- Dokumen ----
const small = (t, opts = {}) => new TextRun({ text: t, font: FONT, size: 16, color: GRAY, ...opts });
const doc = new Document({
  creator: "DM099 Perancangan Basis Data",
  title: (bodyMd.match(/\*\*(MODUL PRAKTIKUM \d+)\*\*\s*\n\s*\n?\*\*([^*]+)\*\*/) || []).slice(1).join(": ") || HEADER_TEXT,
  styles: { default: { document: { run: { font: FONT, size: BODY } } } },
  numbering: {
    config: [{
      reference: "angka",
      levels: [{ level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 400, hanging: 400 } }, run: { font: FONT, size: BODY } } }],
    }],
  },
  sections: [{
    properties: {
      page: { size: { width: PAGE_W, height: 16838 }, margin: { top: 1247, bottom: 1247, left: MARGIN, right: MARGIN, header: 567, footer: 567 } },
      titlePage: true,
    },
    headers: {
      default: new Header({ children: [new Paragraph({
        alignment: AlignmentType.RIGHT, spacing: { after: 0 },
        border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: "BFBFBF", space: 4 } },
        children: [small(HEADER_TEXT)],
      })] }),
      first: new Header({ children: [new Paragraph({ children: [] })] }),
    },
    footers: {
      default: new Footer({ children: [new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [small("Halaman "), new TextRun({ children: [PageNumber.CURRENT], font: FONT, size: 16, color: GRAY })],
      })] }),
      first: new Footer({ children: [new Paragraph({ children: [] })] }),
    },
    children: [...cover(coverMd), ...children],
  }],
});

Packer.toBuffer(doc).then(b => { fs.writeFileSync(OUT, b); console.log("ditulis:", OUT); });
