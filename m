Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CB849F12D;
	Mon, 31 Aug 2026 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183663; cv=none; b=h88FLestt6DC88XmxUuaAoBnIOf63lb0HXx4KA5Z6sHYBrhkWzcpZfwKe/2Uu8qa0udhIbOEPTL/iIGdY2V2ZsVf9FNxHKddo/aojK+1sHKZM9U2Di+8YHoXApZbtgKG7RX7V4R7+LQbmhr8ITRIiSfxPJrG3DarENMwlUCB05w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183663; c=relaxed/simple;
	bh=Rv3qjL8sceuueb6MHetqiJvkM4+O0Bgr0JPgj6gn/Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KqVG6vVQ54I06XJd6B6rwNFGGQYTzju9p+KMsU2IU2bTlEfnSTM+01hFyh7ziKMHjP+SV2UKY9htU9Yekb2905vDCPUjv7SmWRL98dfPiFhW0L12HtDl0LlMZh/BElzQAJmYDppkKc+R5cyPOGYkQX7EJ4PYiyxam+ODF1YP0WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YD4Ouxkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YD4Ouxkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D53D1F00ADE;
	Mon, 31 Aug 2026 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183661;
	bh=i0ZpJkYJD921bgjORyjmDdYBtyr54hMFY/R9ZuVo8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YD4OuxkjK4vT4DHX/aryyZ1HFkW3N4oal3WESEISSK0omY6cTxDU+y+ygCot+c1O6
	 7uWkIHNXmzqf2mQzJizSwRFiZCbCo4MouVF933FIEqy4Tak6OT34Rn1jWVYrv2rt/o
	 wT1YvrdXMf2+f7JGw/G2MHoWwAQbrAMQw211VQxv1h3VYYZFFQE0jY2TgXgFvbL0dw
	 m65Qc6xEsJVDr98V1XWTfv1oXnlEXicIX+xX3MFOtytiIa1UVtqiypx7dQ2XhZbhau
	 /TAw+F4/xM86gHONIMNMfqCboywgZSB0zzgs6da1jy/3eLyF4O5pppeA7OQRiSI1iv
	 3Hl0Vc9nDt7BQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Mon, 31 Aug 2026 09:24:16 -0400
Message-ID: <20260831133314.4125787-228-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhaoyang Yu <2426767509@qq.com>

[ Upstream commit 3eaac9e02d8591d3c790db572ef1c8fa5a841fdb ]

The return value of dm1105_dma_map(), which handles DMA memory allocation,
is ignored in dm1105_hw_init(). If dma_alloc_coherent() fails, the driver
will proceed using a NULL pointer for DMA transfers, leading to a kernel
oops or invalid hardware access.

Fix this by checking the return value and propagating -ENOMEM on failure.

Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `media: dm1105: fix missing error check for
dma_alloc_coherent`

**Local tree:** `stable/linux-6.18.y` at `v6.18.43` (`6.18.43`)
**Upstream commit:** `3eaac9e02d8591d3c790db572ef1c8fa5a841fdb` (not in
this tree yet)
**Candidate on autosel:** `c01c5e056e60f`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 – Subject line**
Record: `[media/dm1105] [fix] missing error check for dma_alloc_coherent
in dm1105_hw_init()`

**Step 1.2 – Tags**
Record:
- `Signed-off-by: Zhaoyang Yu <2426767509@qq.com>` (author)
- `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (media
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`
- Pipeline-added markers (`[Upstream commit ...]`, Sasha Levin SOB)
  ignored per instructions

**Step 1.3 – Body analysis**
Record:
- **Bug:** `dm1105_dma_map()` return value ignored in `dm1105_hw_init()`
- **Symptom:** If `dma_alloc_coherent()` fails, driver continues with
  NULL `ts_buf` → kernel oops or invalid hardware DMA access
- **Fix:** Check return value, propagate `-ENOMEM`
- **Root cause:** Missing error propagation on DMA buffer allocation
  failure during hardware init

**Step 1.4 – Hidden bug fix?**
Record: No — explicitly labeled and described as a bug fix (missing
error check → NULL pointer use).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 – Inventory**
Record:
- **File:** `drivers/media/pci/dm1105/dm1105.c` (+6 / -1 lines)
- **Function modified:** `dm1105_hw_init()`
- **Scope:** Single-file, surgical fix

**Step 2.2 – Code flow change**
Record:
- **Before:** `dm1105_dma_map(dev);` — return ignored; always `return 0`
- **After:** `ret = dm1105_dma_map(dev); if (ret) return -ENOMEM;` —
  failure aborts init
- **Path:** Probe-time initialization error path (`dm1105_probe()` →
  `dm1105_hw_init()`)

**Step 2.3 – Bug mechanism**
Record:
- **Category:** NULL pointer dereference / missing error-path handling
- **Mechanism:** `dm1105_dma_map()` returns non-zero when
  `dma_alloc_coherent()` returns NULL (`return !dev->ts_buf`). Without
  the check, probe succeeds, IRQ/work handlers later dereference
  `dev->ts_buf` (e.g. in `dm1105_dmx_buffer()` at lines 676–698)

**Step 2.4 – Fix quality**
Record:
- Obviously correct and minimal
- Matches existing probe pattern (`if (ret < 0) goto err_pci_iounmap`)
- On failure, probe goes to `err_pci_iounmap` without calling
  `dm1105_hw_exit()` — correct, since no DMA buffer was allocated
- Low regression risk

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 – Blame**
Record: Buggy ignore of `dm1105_dma_map()` present at `dm1105_hw_init()`
line 781 since file entry in this tree (`5d324e5159d9e`). Original
driver commit `519a4bdcf822` (2008) had the identical pattern in
`dm1105dvb_hw_init()` — bug present since driver inception.

**Step 3.2 – Fixes: tag**
Record: N/A — no `Fixes:` tag. Bug introduced in original driver
`519a4bdcf822` ("V4L/DVB (11984): Add support for yet another SDMC
DM1105 based DVB-S card.").

**Step 3.3 – Related file history**
Record:
- `08ddfd628a2db` — unrelated workqueue leak fix (already in 6.18.y, had
  `Cc: stable`)
- `e250b672d40a9` — rc subsystem race fix (indirect, different issue)
- No prior fix for this DMA error-check bug in this tree

**Step 3.4 – Author context**
Record: Zhaoyang Yu submitted similar `dma_alloc_coherent()` error-check
fixes (e.g. `pch_uart` on autosel). Hans Verkuil (media maintainer)
committed upstream.

**Step 3.5 – Dependencies**
Record: Standalone. b4 shows v1 was patch 7/7 of a series, but
committed/applied v2 is a single independent patch. No prerequisite
commits required; `dm1105_dma_map()` already returns `int` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 – Original discussion**
Record:
- `b4 dig -c 3eaac9e02d8591d3c790db572ef1c8fa5a841fdb` → https://patch.m
  sgid.link/tencent_2F5A25B0AB50C4D77CFB3DDEA852BEBE6509@qq.com
- v2 standalone patch (not a multi-patch dependency for backport)
- No stable nominations, NAKs, or reviewer objections found in saved
  mbox

**Step 4.2 – Reviewers**
Record: CC'd to `mchehab@kernel.org`, `linux-media@vger.kernel.org`,
`linux-kernel@vger.kernel.org`. Hans Verkuil committed upstream (strong
maintainer endorsement).

**Step 4.3 – Bug report**
Record: N/A — no external bug report or syzbot link. Bug identified by
code review.

**Step 4.4 – Series context**
Record: v1 was 7/7; v2 is standalone. This fix does not depend on
patches 1–6.

**Step 4.5 – Stable list history**
Record: Could not search lore stable archive (Anubis bot protection). No
stable discussion found via b4 mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 – Key functions**
Record: `dm1105_hw_init()`, `dm1105_dma_map()`, `dm1105_set_dma_addr()`

**Step 5.2 – Callers**
Record: `dm1105_hw_init()` called only from `dm1105_probe()` (line
1031). Probe already handles negative return via `goto err_pci_iounmap`.

**Step 5.3 – Callees**
Record: `dm1105_dma_map()` → `dma_alloc_coherent()`; on success,
`dm1105_set_dma_addr()` programs hardware with DMA address.

**Step 5.4 – Reachability**
Record: Triggered at PCI probe when `CONFIG_DVB_DM1105` is enabled and
DM1105 hardware is present. DMA alloc failure possible under memory/CMA
pressure. Without fix, probe succeeds and later IRQ →
`dm1105_dmx_buffer()` NULL-dereferences `dev->ts_buf`.

**Step 5.5 – Similar patterns**
Record: Same long-standing bug pattern in original 2008 driver
(`dm1105dvb_dma_map` return ignored). Author has submitted similar fixes
elsewhere.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

**Step 6.1 – Buggy code present?**
Record: **YES** — current tree at lines 781–782 ignores
`dm1105_dma_map()` return. Upstream fix `3eaac9e02d859` is **not** an
ancestor of HEAD.

**Step 6.2 – Backport complications**
Record: **Clean apply** — `git diff HEAD c01c5e056e60f` shows only the
6-line hunk with no conflicts.

**Step 6.3 – Related fixes already present?**
Record: No duplicate fix. Related `08ddfd628a2db` (workqueue leak) is
separate.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 – Subsystem**
Record: `drivers/media/pci/dm1105` — DVB media PCI driver.
**Criticality: PERIPHERAL** (niche TV/DVB capture hardware).

**Step 7.2 – Activity**
Record: Low churn in 6.18.y; driver is mature/legacy with occasional
maintenance fixes.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 – Who is affected**
Record: Users with SDMC DM1105-based DVB-S PCI cards and
`CONFIG_DVB_DM1105` enabled (driver-specific, small population).

**Step 8.2 – Trigger conditions**
Record: `dma_alloc_coherent()` failure during probe (memory pressure,
CMA exhaustion). Uncommon but realistic. Requires hardware present; not
userspace-triggerable without the device.

**Step 8.3 – Failure severity**
Record: **HIGH** — kernel oops from NULL dereference in
`dm1105_dmx_buffer()` when DMA interrupts fire; also possible invalid
DMA programming via `dm1105_set_dma_addr()` with garbage/zero address.

**Step 8.4 – Risk vs benefit**
Record:
- **Benefit:** Prevents probe-from-failure crash on affected hardware;
  correct error propagation
- **Risk:** Very low — 6 lines, no API/behavior change on success path
- **Ratio:** Favorable for backport despite niche hardware

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 – Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real NULL-deref bug since 2008 | Niche hardware, few users |
| Kernel oops on failure path | DMA alloc failure is uncommon |
| Tiny, obviously correct fix | No syzbot/user report |
| Applies cleanly to 6.18.y | |
| Maintainer (Hans Verkuil) signed off | |
| Probe error path already wired | |

**Unresolved:** No user crash reports; lore stable-thread search
blocked.

**Step 9.2 – Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is trivial; maintainer
   committed upstream
2. Fixes real bug affecting users? **PASS** — NULL deref on DMA alloc
   failure with DM1105 hardware
3. Important issue? **PASS** — kernel oops (HIGH severity when
   triggered)
4. Small and contained? **PASS** — 6 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 – Exception category**
Record: N/A (standard bug fix, not quirk/ID/DT/build/doc exception).

**Step 9.4 – Decision rationale**
This is a textbook stable candidate: a long-standing missing error check
that can cause a kernel oops when DMA allocation fails during probe. The
fix is minimal, maintainer-reviewed, self-contained, and applies cleanly
to the local 6.18.y tree where the buggy code is confirmed present.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show 3eaac9e02d859`
  / `c01c5e056e60f`
- [Phase 1] No Reported-by/syzbot/Fixes: tags found
- [Phase 2] Read current `dm1105.c` lines 605–612, 669–698, 769–793,
  1031–1033, 1160–1163
- [Phase 2] Confirmed `dm1105_dma_map()` returns `!dev->ts_buf` (non-
  zero on failure)
- [Phase 2] Confirmed `dm1105_dmx_buffer()` dereferences `dev->ts_buf`
  without NULL check
- [Phase 3] `git describe HEAD` → `v6.18.43`; `make kernelversion` →
  `6.18.43`
- [Phase 3] `git blame` on hw_init/dma_map lines → present since
  `5d324e5159d9e` in this file
- [Phase 3] `git show 519a4bdcf822` → identical bug in original 2008
  driver
- [Phase 3] `git merge-base --is-ancestor 3eaac9e02d859 HEAD` → exit 1
  (fix NOT in tree)
- [Phase 4] `b4 dig -c 3eaac9e02d859` → lore URL found; v2 standalone
  patch
- [Phase 4] `b4 dig -a` → v2 only revision listed as matching
- [Phase 4] `b4 dig -w` → mchehab, linux-media CC'd
- [Phase 4] Saved mbox to `/tmp/dm1105_thread.mbox` — no stable
  nomination or NAK found
- [Phase 5] `grep dm1105_hw_init` → single caller in `dm1105_probe()`
- [Phase 6] `git diff HEAD c01c5e056e60f` → clean 6-line apply
- [Phase 6] Confirmed buggy `dm1105_dma_map(dev);` at line 781 in
  current tree
- [Phase 8] Failure mode: NULL deref in work handler after failed DMA
  alloc — severity HIGH
- [UNVERIFIED] No end-user crash reports located (none cited in commit
  or lore thread)

**YES**

 drivers/media/pci/dm1105/dm1105.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index c1d55b9836744..abd86488064b5 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -768,6 +768,8 @@ static void dm1105_ir_exit(struct dm1105_dev *dm1105)
 
 static int dm1105_hw_init(struct dm1105_dev *dev)
 {
+	int ret;
+
 	dm1105_disable_irqs(dev);
 
 	dm_writeb(DM1105_HOST_CTR, 0);
@@ -778,7 +780,10 @@ static int dm1105_hw_init(struct dm1105_dev *dev)
 	dm_writew(DM1105_TSCTR, 0xc10a);
 
 	/* map DMA and set address */
-	dm1105_dma_map(dev);
+	ret = dm1105_dma_map(dev);
+	if (ret)
+		return -ENOMEM;
+
 	dm1105_set_dma_addr(dev);
 	/* big buffer */
 	dm_writel(DM1105_RLEN, 5 * DM1105_DMA_BYTES);
-- 
2.53.0

