Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627594FDA4B;
	Mon, 19 Oct 2026 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418342; cv=none; b=IRFCUMyEqTUiIsWyDcxC8F0NOpPlKHXfDbpNF7OXdI3Umxv6xEcPrx0T+EUesfz9IOpFNvtHF/i+Y5MXy7O03+LK4xFSH6xG80rdjYYmMmUYo/A0w1DuDVWb6TMeQUf54S9dd0Ul5TIzmrXHm30Q01Mroy7MdKXL9avaVUiyttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418342; c=relaxed/simple;
	bh=cadGJAcYab2bHwIlTTNQclq6NuGd9Sleo9IMdKXrayI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkB7UYbGiegKhRmdMBbR2oeelovGfmH8tstdjTWXepnmhk8jFTeRJGkBWy8Qa0OC8x2s3Z12uo3s2L4ZKocMDEtTj0PJk86lFDhcnWyDO+aq3mvQsX2ssIgHQJZ/HwBR3hH2bfarrT983N4FiVYhe1Gnv+FzHadCOFKcl2E5dIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwFd7HJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwFd7HJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575BF1F000C6;
	Mon, 19 Oct 2026 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418339;
	bh=ZJkC+fDbJ70Bl5y8ELPPo2YhqcptmGDpY1J0f9mKeho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwFd7HJpmSNqaywlRZpHBSYBY1cXUmf9Em1FoS/nun7kA1IGh8eaLK+BI54j7ilIB
	 9DGFSJCwFC7rF6iB8pHikiJV9UolG4RFNYH4MzbXUhsu2+vx/l/FAjUXanaGBGRydd
	 xWHNLG4iYJiIU7UB9aSG1oxp/X+VfyzLSjF5DlSeh2QwKhDmi1v8sW0AuxuEu9I1I6
	 1l9MDsfLmUd1FcTXG+m5pOv2dA8/ZoatUmYQOKMtZpyoaRY15wsLNp55YBsxT3XMaz
	 SPlgg4lPX7xoZKBQG+IoOBFaiQ0wi4sjyuC5wLa/kyCt12jWq8zKaTyyePcMH4nJok
	 iy/cI3sz/kyNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	awalls@md.metrocast.net,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: ivtv: stop VBI start-code scan before short tail
Date: Mon, 19 Oct 2026 09:47:48 -0400
Message-ID: <20261019135441.1420968-177-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f373cf17fb8e7a530bc6e1e36fc41cb5dab2cdaa ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[media/ivtv] [stop] stop VBI start-code scan before a short
tail so a 4-byte SAV check cannot read past the buffer**

**Step 1.2: Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (media/V4L
  maintainer; applied the patch)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable`
- Absence of `Fixes:` / `Cc: stable` is expected for this review and is
  not a negative signal

**Step 1.3: Body**
Record:
- **Bug:** `compress_sliced_buf()` walks one byte at a time while
  testing a four-byte VBI start code (SAV: `0xff 0x00 0x00 sav`).
- **Symptom/failure mode:** last loop iterations read past the remaining
  buffer tail (out-of-bounds read of up to 3 bytes).
- **Version info:** none in the message.
- **Root cause:** loop bound is `i < size` while the body reads
  `buf[0]`..`buf[3]`.

**Step 1.4: Hidden bug fix?**
Record: **Not hidden.** This is an explicit bounds fix, not
cleanup/refactoring.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/media/pci/ivtv/ivtv-vbi.c` — **1 insertion, 1
  deletion**
- Function: `compress_sliced_buf()`
- Scope: **single-file surgical one-liner**

**Step 2.2: Code flow**
Record:
- **Before:** `for (i = 0; i < size; i++, buf++)` then `buf[0]==0xff &&
  !buf[1] && !buf[2] && buf[3]==sav`
  - When `i == size-1`, `buf[1]`, `buf[2]`, `buf[3]` are 1–3 bytes past
    the declared `size`.
  - When `size` is 1, 2, or 3, the first iteration already overreads.
- **After:** `for (i = 0; i + 3 < size; i++, buf++)` — stop once fewer
  than 4 bytes remain.
- Path: **normal VBI parse path** (finding the first SAV), not an error-
  only path.

Verified pre-image:

```334:336:drivers/media/pci/ivtv/ivtv-vbi.c
                if (buf[0] == 0xff && !buf[1] && !buf[2] && buf[3] ==
sav)
                        break;
```

(with the new `i + 3 < size` bound on the `for` line immediately above)

**Step 2.3: Bug mechanism**
Record: **Memory safety / out-of-bounds read.** The four-byte SAV test
used a one-byte walk with an inclusive `size` bound. The remaining `size
-= i` / `size < line_size` logic still bails out on a short tail, so
this is an **overread**, not a later overflow write.

**Step 2.4: Fix quality**
Record:
- **Obviously correct:** the predicate now matches the 4-byte access.
  Same pattern as the sibling `cx18` fix (`bf533acaaa7de`).
- **Minimal:** one loop condition, no API/data-structure change.
- **Regression risk: very low.** If `size < 4`, the loop does not run,
  `i` stays 0, then `size < line_size` (51/272/284) returns as before. A
  4-byte SAV at the last valid position is still seen (`i + 3 < size`
  allows `i == size-4`).

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: The scan loop (including `buf[3]`) was introduced in
**`1a0adaf37c30e`** — *V4L/DVB (5345): ivtv driver for Conexant
cx23416/cx23415 MPEG encoder/decoder* (Hans Verkuil, **2007-04-27**).
The bug is as old as the driver.

**Step 3.2: Fixes: tag**
Record: **No Fixes: tag.** The introducing commit is the original ivtv
merge (`1a0adaf37c30e`), present in this tree (`git merge-base --is-
ancestor` exit 0).

**Step 3.3: File history**
Record: Recent commits on this file are email-address churn, an
uninitialized `vbi.type` fix (`31218df77e7f1`), SPDX, and this bounds
fix. **No prerequisite refactor.** Standalone; not `patch X/Y`.

**Step 3.4: Author**
Record: Pengpeng Hou’s only ivtv commit is this one. Same
day/author/message as **`bf533acaaa7de`** (`media: cx18: stop VBI start-
code scan before short tail`). Hans Verkuil applied both; he is the
long-time V4L maintainer and original ivtv author. That is a strong
quality signal.

**Step 3.5: Dependencies**
Record: **None.** The loop, `sav` argument, and `buf[3]` access already
exist. The cx18 sibling is independent (different driver). **Applies
standalone.**

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c f373cf17fb8e7` →
  https://patch.msgid.link/2026063008027101.2-ccfa108-0015-media-ivtv-
  stop-VBI-start-c-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (2026-06-30), no later revisions.
- Saved mbox: **patch only, no replies.** No NAK, no reviewer
  commentary, no in-thread `Cc: stable`.
- lore.kernel.org HTML fetch returned **403** (Anubis bot-wall). Thread
  content was recovered via `b4 dig -m`.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: To/Cc included **Andy Walls** (IVTV maintainer in MAINTAINERS),
**Mauro Carvalho Chehab**, `linux-media@vger.kernel.org`, `linux-
kernel@vger.kernel.org`. Applied by **Hans Verkuil**.

**Step 4.3: Bug report**
Record: **No user/syzbot/bugzilla report.** Looks like a static-
analysis/audit fix (author has many similar bounds patches). The
mechanism is still a real OOB read, verified from the code.

**Step 4.4: Related series**
Record: Paired with **cx18** commit `bf533acaaa7de` (same wording, same
day). Each is self-contained. This ivtv commit does not need the cx18
change.

**Step 4.5: Stable list**
Record: **UNVERIFIED** — lore.kernel.org/stable returned 403. No
evidence in-tree of a prior rejection.

---

## Phase 5: Semantic / call-chain

**Step 5.1: Functions**
Record: `compress_sliced_buf()` only.

**Step 5.2: Callers**
Record: Only `ivtv_process_vbi_data()` in the same file, twice:

```398:404:drivers/media/pci/ivtv/ivtv-vbi.c
                lines = compress_sliced_buf(itv, 0, p, size / 2,
                        itv->vbi.sliced_decoder_sav_odd_field);
                /* second field */
                /* experimentation shows that the second half does not
always begin
                   at the exact address. So start a bit earlier (hence
32). */
                lines = compress_sliced_buf(itv, lines, p + size / 2 -
32, size / 2 + 32,
                        itv->vbi.sliced_decoder_sav_even_field);
```

`ivtv_process_vbi_data()` callers:
- `ivtv_get_buffer()` in `ivtv-fileops.c` (userspace read of MPEG/VBI
  streams)
- `dma_post()` in `ivtv-irq.c` (decoder VBI DMA completion)

**Step 5.3: Callees**
Record: After the scan, `v4l2_subdev_call(..., decode_vbi_line, ...)`.
The OOB is in the scan itself, before that call.

**Step 5.4: Reachability**
Record: Reachable when sliced VBI capture/processing runs on **Hauppauge
PVR-150/250/350/500** (and other cx23415/cx23416 cards),
`CONFIG_VIDEO_IVTV`. Needs the hardware; not a generic syscall fuzz
path. Real for those devices.

**Step 5.5: Similar patterns**
Record: `cx18` had the identical bug and the same one-line fix.
`compress_raw_buf()` indexes `p[0..3]` at `buf + i * line_size` with `i
< lines`, a different bound; not the same bug.

---

## Phase 6: This tree

**Step 6.1: Local tree and buggy code**
Record:
- `git describe HEAD` → **`v7.3-rc4-27-gf0100363d8c37`** (`VERSION=7`,
  `PATCHLEVEL=3`, `SUBLEVEL=0`, `EXTRAVERSION=-rc4`)
- Candidate **`f373cf17fb8e7` is already an ancestor of HEAD**
- Buggy loop existed here from **2007** until that commit; pre-image
  confirmed via `git show f373cf17fb8e7^:drivers/media/pci/ivtv/ivtv-
  vbi.c`

This checkout is **7.3-rc4 mainline**, not an older -stable branch. The
bug class and the surrounding code are the same ones every current LTS
still carries.

**Step 6.2: Backport difficulty**
Record: **Clean apply.** The `for (i = 0; i < size; i++, buf++)` line
has been unchanged since 2007.

**Step 6.3: Related fixes already here**
Record: Only this commit and the cx18 sibling. No alternate ivtv fix for
the same scan.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **media/pci/ivtv** — Hauppauge PVR / Conexant cx2341x MPEG
encoder. **PERIPHERAL** (specific old PCI capture cards), but a
supported in-tree driver, not staging.

**Step 7.2**
Record: The file is **mature/quiet**. The driver has been stable for
years; this is a long-standing latent bounds bug, not fallout from a new
feature.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: **Driver-specific / config-specific** (`CONFIG_VIDEO_IVTV`),
users capturing **sliced VBI** on those cards.

**Step 8.2: Trigger**
Record: Hardware DMA fills an ivtv buffer; `ivtv_process_vbi_data()`
scans for SAV. Fires whenever the start code is missing or near the tail
(including a full walk with no match). Unprivileged users can hit it if
they can open the V4L VBI/MPEG node. Not a remote network path.

Buffers are `kmalloc(s->buf_size + 256)` and DMA last-SG size is also
`+= 256` (`ivtv-queue.c`, `ivtv-irq.c`). `dma_post()` may do
`buf->bytesused += s->dma_last_offset` (cookie search up to 252 bytes).
A 3-byte overread of the **logical** `size` often still sits inside that
256-byte DMA window, so a crash is not guaranteed; it is still an out-
of-bounds access relative to the length the scan is given, and
`bytesused` can sit close to the allocation.

**Step 8.3: Failure mode**
Record: **Out-of-bounds read (up to 3 bytes).** Severity **MEDIUM–HIGH**
as memory safety; practical oops risk **MEDIUM** (small overread, extra
DMA padding). Remaining length after a false SAV in the tail is `< 4`,
so `size < line_size` returns without treating the overread as payload.
**Not data corruption of the VBI output**, but a real buffer-tail
overread.

**Step 8.4: Risk–benefit**
Record:
- **Benefit:** stops a real OOB read on a path that runs during VBI
  capture; same class as other stable OOB one-liners; bug present on
  every LTS.
- **Risk:** one loop bound, no locking/API change — **very low**.
- **Ratio:** strongly favors taking the fix.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real 4-byte load on a 1-byte scan; last iterations read past `size`
- One-line, obviously correct, no new API
- Bug in tree since 2007 (`1a0adaf37c30e`); clean apply
- Applied by Hans Verkuil; To: Andy Walls (ivtv maintainer)
- Sibling cx18 fix of the same bug
- Standalone; no series dependency

Against:
- No crash/syzbot/`Reported-by`
- Niche, aging PCI hardware
- +256 DMA/kmalloc padding makes a guaranteed heap oops less likely
- No mailing-list review comments (v1 applied as-is)

Unresolved:
- Stable-list discussion (lore 403)
- Exact KASAN behavior vs. the +256 allocation (not reproduced here)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — bound matches the 4-byte
   access; maintainer applied it; v1 needed no respin.
2. Real bug affecting users? **PASS** — OOB read on sliced-VBI
   processing for ivtv hardware.
3. Important (crash/security/corruption/deadlock)? **PASS** — memory-
   safety OOB read; practical crash is not certain, but this is the
   standard small OOB class, not a style tweak.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — already in 7.3-rc4; pre-fix line
   is the original 2007 loop, so older stables should take it cleanly.

**Step 9.3: Exception category**
Record: Not a device-ID/quirk/DT/build/doc exception. It is a **small
memory-safety fix**.

**Step 9.4: Decision**
The commit is a one-line, obviously correct stop of a four-byte SAV scan
that walked off the declared VBI buffer. That bug has been in ivtv since
2007, needs no prerequisites, and is the same fix already used on cx18.
It belongs in stable.

---

## Verification

- **[Phase 1]** Parsed tags: only author + Hans Verkuil SOBs; no
  Fixes/Reported-by/Cc: stable
- **[Phase 2]** Diff: 1 line in `compress_sliced_buf()`; `i < size` → `i
  + 3 < size`
- **[Phase 2]** Confirmed `buf[0]..buf[3]` SAV test in current file at
  lines 333–335
- **[Phase 3]** `git blame`: loop from `1a0adaf37c30e` (2007-04-27);
  bound line is this commit
- **[Phase 3]** `git merge-base --is-ancestor 1a0adaf37c30e HEAD` → yes
- **[Phase 3]** `git show f373cf17fb8e7^:...ivtv-vbi.c` → old `i < size`
  loop present
- **[Phase 3]** File log: no prerequisite refactor; sibling
  `bf533acaaa7de` is cx18-only
- **[Phase 4]** `b4 dig -c f373cf17fb8e7`: lore/msgid link above; `b4
  dig -a`: v1 only
- **[Phase 4]** `b4 dig -w`: Andy Walls, Mauro Chehab, linux-media,
  linux-kernel
- **[Phase 4]** `b4 dig -m`: 81-line mbox, patch only, no replies
- **[Phase 4]** WebFetch/curl to lore: 403 — stable-list search
  UNVERIFIED
- **[Phase 5]** Callers: `ivtv_process_vbi_data` ← `ivtv-fileops.c`,
  `ivtv-irq.c`
- **[Phase 5]** cx18 `compress_sliced_buf` uses the same `i + 3 < size`
  bound after `bf533acaaa7de`
- **[Phase 6]** `git describe HEAD` = v7.3-rc4-27-g…; `make
  kernelversion` = 7.3.0-rc4
- **[Phase 6]** `git merge-base --is-ancestor f373cf17fb8e7 HEAD` →
  already in this tree
- **[Phase 7]** MAINTAINERS: IVTV → Andy Walls, linux-media
- **[Phase 8]** kmalloc `buf_size+256` and DMA `size += 256` /
  `bytesused += dma_last_offset` verified in `ivtv-queue.c` and `ivtv-
  irq.c`
- **UNVERIFIED:** whether this overread was ever KASAN-reported; whether
  stable@ discussed it

The fix is small, surgical, and meets the stable criteria for an out-of-
bounds read.

**YES**

 drivers/media/pci/ivtv/ivtv-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
index ae7a00f462574..af086c4cbe1a7 100644
--- a/drivers/media/pci/ivtv/ivtv-vbi.c
+++ b/drivers/media/pci/ivtv/ivtv-vbi.c
@@ -330,7 +330,7 @@ static u32 compress_sliced_buf(struct ivtv *itv, u32 line, u8 *buf, u32 size, u8
 	unsigned lines = 0;
 
 	/* find the first valid line */
-	for (i = 0; i < size; i++, buf++) {
+	for (i = 0; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] && buf[3] == sav)
 			break;
 	}
-- 
2.53.0

