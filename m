Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C978864331E;
	Mon, 19 Oct 2026 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418782; cv=none; b=M8Q5K8BvqQj8VD5TwjvN8m1yYa8OtN1z8vY47I1jaAoiTdvkiqjRgHv5HV09474aRW8EKi4a2LGTibslN+LDx21naoxApsfg72DEUCOa4GGacHtstcQ8/rw0CGxhTd2lhg1tOAC0ejQVU8CD7l4mgvZZpcTEY72S8Xdx5af2I2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418782; c=relaxed/simple;
	bh=lcCkEv8Vk6O3kHUw9vVYnyOcA2IzqYKvR7/s8zziZhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BV3d16oVoOWlJwoiQUp0SrydniZxq+egGYliQHvIq6V9KXlS+7iTX9jRAHAo6PAT0L89X6Dm7lRWdMZ2EgxobPWv4rNY8F01XwJKfV8lYtS9iw7zk8bLwaqXgfClLiwlEZepOFEF3NMnlqa5RzAAd77g+HfXCLQeg5ZyFrvE0FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8NeMag4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8NeMag4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080B21F000C7;
	Mon, 19 Oct 2026 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418779;
	bh=lYU6BWVNUbVi7f+tvFt82iAZ3w46Qd4BFcdyIPaiWnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8NeMag4T+m81bpxbZhihUYxJSzi53HdWTghI75ojKKAjSvVhyt2WJ9mVrvSxscqO
	 sxebZL9qyPysb2g/L3uNsETzE6kdEG44d1XBHRaybXs49mNb+JL4gCkQdgCBjgEyhI
	 se61j1OFVsWj0jhhq5CVq9XC06pCVgJYOxAYnTeetZEX96UJZxmJSFKzQbaxiEfvjk
	 5//deUp2fFXOW1BWoDdCP68ATtwYbUhY7bmzD3trfNfnFq+OflYTumFp4Xdgac0PG3
	 zLnimyN7oDm7EggsHr+EilvOcwcp8nxDgSMm3mG7vf0bspVUjDHeX92Gv/3DtAcwMv
	 /6ZRAA9NQ0M5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shiji Yang <yangshiji66@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nbd@nbd.name,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: ethernet: mtk_wed: increase WED v2 WDMA RESV_BUFF to 0x80
Date: Mon, 19 Oct 2026 09:53:01 -0400
Message-ID: <20261019135441.1420968-490-sashal@kernel.org>
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

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit c0ef04232f9fac083c3d8a77ce58ba32243e6734 ]

Change WDMA RESV_BUFF from 0x40 to 0x80 to avoid CDM TX FIFO overflow.
Without this patch mt7986 and mt7981 may have WDMA TX hang issue. This
patch was pulled from mtk-openwrt-feeds GPL open source project.

Link: https://github.com/mediatek/mtk-openwrt-feeds/commit/07c87502e854b68b48544d101b6fe17ec059b97b
Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/OSZPR01MB779537889255E2F606E47EABBCA52@OSZPR01MB7795.jpnprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This 6.12.111 tree has the WED v2 DMA path without the RESV_BUFF bump.
The change is a small MediaTek hardware workaround for a WDMA TX hang on
mt7986/mt7981.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[net: ethernet: mtk_wed:] [increase] [WED v2 WDMA RESV_BUFF
0x40 -> 0x80]`

**Step 1.2 — Tags**
Record:
- `Link: https://github.com/mediatek/mtk-openwrt-
  feeds/commit/07c87502e854b68b48544d101b6fe17ec059b97b` (vendor source)
- `Signed-off-by: Shiji Yang <yangshiji66@outlook.com>` (author)
- `Reviewed-by: Simon Horman <horms@kernel.org>`
- `Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>` (mtk_wed maintainer)
- `Link: https://patch.msgid.link/OSZPR01MB779...` (netdev submission)
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (applied to
  netdev/net)
- No `Fixes:` and no `Cc: stable` on the committed version (expected for
  this pipeline)
- No `Reported-by:` / `Tested-by:` / syzbot

**Step 1.3 — Body**
Record:
- Bug: default WDMA `RESV_BUFF` of `0x40` can overflow the CDM TX FIFO
  on WED v2.
- Symptom: WDMA TX hang on mt7986 and mt7981.
- Root cause: reserved WDMA buffer too small for v2 hardware.
- Source: MediaTek OpenWrt GPL feeds (`Fix WED 2.0 WDMA TX hang issue`).
- Version info: v2 only (mt7986/mt7981). Rex Lu later said v3 dropped
  this register.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Explicit hang fix / hardware workaround. Vendor
subject was also a hang fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- `drivers/net/ethernet/mediatek/mtk_wed.c`: +5 in
  `mtk_wed_dma_enable()`
- `drivers/net/ethernet/mediatek/mtk_wed_regs.h`: +1
  (`MTK_WDMA_GLO_CFG_RESV_BUFF` = `GENMASK(23, 16)`)
- Scope: single-driver surgical change (~6 lines)

**Step 2.2 — Flow change**
Record: After the existing v1/v2 vs v3 `MTK_WDMA_GLO_CFG` setup, and
before enabling WED GLO DMA, v2 now RMWs bits 23:16 of
`MTK_WDMA_GLO_CFG` to `0x80`. v1 and v3 are unchanged. Init/enable path
only.

**Step 2.3 — Bug mechanism**
Record: Hardware workaround. Default `RESV_BUFF` is `0x40`; raising it
to `0x80` leaves more WDMA reserved buffer so CDM TX FIFO does not
overflow and stall TX. `wdma_m32()` already does `(read & ~mask) | val`.

**Step 2.4 — Fix quality**
Record: Minimal, gated by `mtk_wed_is_v2()`, uses existing helpers.
Regression risk is low: only WED v2 register bits 23:16. MediaTek
confirmed v3 must not get this write because the field was removed.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: `mtk_wed_dma_enable()` came from `cf26df8833cc` (2022-09-22,
“add mtk_wed_configure_irq and mtk_wed_dma_{enable/disable}”).
Surrounding v2/v3 split is `e2f64db13aa1d` (2023-09-18, MT7988 WED). The
missing programming is a long-standing omission, not new 6.12 code.

**Step 3.2 — Fixes: tag**
Record: Committed patch has none. Simon Horman and Lorenzo Bianconi both
named `cf26df8833cc`. That commit **is** an ancestor of this tree (`git
merge-base --is-ancestor` succeeded).

**Step 3.3 — File history**
Record: Recent 6.12 `mtk_wed.c` work is leaks/UAF/reset, not RESV_BUFF.
No competing local fix. Standalone, not patch N/M.

**Step 3.4 — Author**
Record: Shiji Yang has no other `drivers/net/ethernet/mediatek/` commits
in this tree. Original vendor author is Rex Lu (MediaTek). Lorenzo
(maintainer) acked.

**Step 3.5 — Prerequisites**
Record: Needs `mtk_wed_is_v2()`, `wdma_m32()`, `FIELD_PREP`,
`MTK_WDMA_GLO_CFG`. All present. Upstream SHA `c0ef04232f9f` is **not**
in this tree (ancestor check failed). Can apply standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c c0ef04232f9f` → https://patch.msgid.link/OSZPR01MB779537889
  255E2F606E47EABBCA52@OSZPR01MB7795.jpnprd01.prod.outlook.com
- Single revision (v1). Applied as-is to netdev/net.git.
- Simon: target `net`, **CC stable**, add Fixes; still `Reviewed-by`.
- Jakub asked Lorenzo to review, including the Fixes suggestion.
- Lorenzo asked if v3 needs it; Rex Lu: v2 only, v3 removed the
  register.
- Lorenzo: `Acked-by`.
- No NAK.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: netdev, linux-mediatek, Lorenzo Bianconi, Felix Fietkau, Rex Lu,
netdev maintainers. Right people.

**Step 4.3 — Bug report**
Record: Vendor feeds commit `07c87502e854`: “Fix WED 2.0 WDMA TX hang
issue” / “without this patch mt7986 and mt7981 may have WDMA TX hang”.
Same 6-line change. No public syzbot/bugzilla thread found.

**Step 4.4 — Series**
Record: Standalone 1/1. No companion patches.

**Step 4.5 — Stable list**
Record: UNVERIFIED for lore.kernel.org/stable (HTTP 403). Simon’s review
is an explicit stable nomination. No evidence of a stable NAK.

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: `mtk_wed_dma_enable()` plus a register `#define`.

**Step 5.2 — Callers**
Record: Only `mtk_wed_start()` → `mtk_wed_dma_enable()`. That is
`wed_ops.start`, invoked as `mtk_wed_device_start()` from mt76
(`mt7915/dma.c`, `mt7996/dma.c`). mt7915 is the usual WiFi partner for
mt7986/mt7981 (WED v2).

**Step 5.3 — Callees**
Record: `wdma_m32` → `wdma_r32`/`wdma_w32` (MMIO RMW). No alloc, no
locks.

**Step 5.4 — Reachability**
Record: Yes. Bringing WiFi up with WED offload on Filogic 820/830 hits
this. Not a rare debug path.

**Step 5.5 — Similar patterns**
Record: No other `RESV_BUFF` users. Nearby `wdma_set(MTK_WDMA_GLO_CFG,
...)` already programs this register for TX enable / prerest bits.

## Phase 6: This tree (6.12.111)

**Step 6.1 — Buggy code present?**
Record: Yes. `make kernelversion` / `git describe` → **6.12.111**
(`p-6.12-3-gc504cf0baa3d8`). `mtk_wed_dma_enable()` has the v2/v3 split
and does **not** set RESV_BUFF. `mt7981_data` / `mt7986_data` have
`.version = 2`. `hw->version = eth->soc->version`. Bug dates to WED
dma_enable (2022), well before 6.12.

**Step 6.2 — Backport difficulty**
Record: Clean apply. Insertion context around the v3 `else` branch and
`MTK_WDMA_GLO_CFG` bit defines matches the upstream hunk.

**Step 6.3 — Already fixed?**
Record: No. `git log --grep=RESV_BUFF` / `WDMA TX hang` / `increase WED
v2` on these files is empty. `c0ef04232f9f` is not an ancestor.

## Phase 7: Subsystem

**Step 7.1**
Record: MediaTek ethernet WED (WiFi/Ethernet dispatch offload).
**IMPORTANT** for Filogic routers, not core-mm/VFS. OpenWrt 6.12 devices
(BPI-R3, GL-MT6000, many AX3000/AX6000 boards) use this.

**Step 7.2**
Record: Mature driver; v2 support is years old. This is a vendor hang
workaround, not churn from a new API.

## Phase 8: Impact / risk

**Step 8.1 — Who**
Record: Driver/SoC specific: `CONFIG_NET_MEDIATEK_SOC` + WED,
mt7981/mt7986, WiFi WED offload.

**Step 8.2 — Trigger**
Record: WED DMA enable when WiFi starts. Can be common on those APs.
Unprivileged users do not poke the register; they can trigger it by
using the AP. Timing-dependent FIFO overflow under TX load is plausible.

**Step 8.3 — Severity**
Record: WDMA TX hang → WiFi/Ethernet TX stall. **HIGH** (hang / loss of
forwarding). Not a KASAN UAF, but a real production hang on shipping
routers.

**Step 8.4 — Benefit vs risk**
Record: Benefit high for Filogic v2 users (fixes hang). Risk very low (6
lines, v2-only, maintainer + MediaTek + netdev review). Ratio strongly
favors backport.

## Phase 9: Synthesis

**For backporting**
- Real hang: CDM TX FIFO overflow → WDMA TX stall on mt7986/mt7981.
- Hardware quirk/workaround (stable exception).
- Tiny, obviously correct RMW of a documented field.
- Code and helpers exist in 6.12; applies cleanly.
- Simon Horman asked for `Cc: stable`; Lorenzo acked; MediaTek confirmed
  v2-only.
- Vendor already shipped the same change in OpenWrt feeds.

**Against**
- No kernel.org `Reported-by` / crash log (vendor description only).
- Affects one SoC family, not all machines.
- Committed patch omitted `Fixes:` / `Cc: stable` (Simon noted that; not
  a technical reason to skip).

**Unresolved**
- Could not query lore.kernel.org/stable (403). No sign it was rejected.

**Stable rules**
1. Obviously correct and tested — **PASS** (review + vendor feeds +
   MediaTek confirmation)
2. Real user bug — **PASS** (TX hang)
3. Important (hang) — **PASS** (HIGH)
4. Small/contained — **PASS** (6 lines, two files)
5. No new features/APIs — **PASS** (register programming)
6. Applies to this tree — **PASS** (clean context on 6.12.111)

**Exception:** hardware workaround / quirk.

This should be backported to this 6.12.y tree.

Verification:
- [Phase 1] Parsed tags: vendor GitHub link, Reviewed-by Horman, Acked-
  by Bianconi, applied by Kicinski; no Fixes/Cc: stable on the commit
- [Phase 2] Diff: +5 in `mtk_wed_dma_enable()`, +1 GENMASK; v2-only
  `wdma_m32` of bits 23:16 to 0x80
- [Phase 2] `wdma_m32()` in this tree is `(read & ~mask) | val` at
  `mtk_wed.c:111-114`
- [Phase 3] Blame: `mtk_wed_dma_enable` from `cf26df8833cc`
  (2022-09-22); v2/v3 split from `e2f64db13aa1d`
- [Phase 3] `git merge-base --is-ancestor cf26df8833cc HEAD` succeeded;
  `c0ef04232f9f` is not in this tree
- [Phase 3] `mtk_wed_is_v2` from `d274d523c71c82` is in this tree
- [Phase 4] `b4 dig -c c0ef04232f9f`: v1 only; lore msgid
  OSZPR01MB7795...
- [Phase 4] Horman review (openwall 2026/08/21/128): “Be CCed to
  stable”, Fixes `cf26df8833cc`, Reviewed-by
- [Phase 4] Rex Lu: v2 only; v3 removed RESV_BUFF
- [Phase 4] Lorenzo Acked-by after that confirmation
- [Phase 4] GitHub `07c87502e854`: same 6-line hang fix
- [Phase 4] lore.kernel.org/stable: UNVERIFIED (403)
- [Phase 5] Caller: `mtk_wed_start` → `mtk_wed_dma_enable`;
  `mtk_wed_device_start` from mt76 mt7915/mt7996
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111;
  RESV_BUFF define absent; insertion context matches
- [Phase 6] `mt7981_data`/`mt7986_data`.version = 2; `hw->version =
  eth->soc->version`
- [Phase 8] Failure mode: WDMA TX hang, severity HIGH
- UNVERIFIED: whether anyone already requested this on stable@ (lore
  403)

The hang is real on WED v2 hardware this tree supports, the fix is a
six-line register quirk, and it applies cleanly here.

**YES**

 drivers/net/ethernet/mediatek/mtk_wed.c      | 5 +++++
 drivers/net/ethernet/mediatek/mtk_wed_regs.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 1ed1f88dd7f8b..fdb487e5d46e1 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -2071,6 +2071,11 @@ mtk_wed_dma_enable(struct mtk_wed_device *dev)
 		wdma_set(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
 	}
 
+	if (mtk_wed_is_v2(dev->hw))
+		wdma_m32(dev, MTK_WDMA_GLO_CFG,
+			 MTK_WDMA_GLO_CFG_RESV_BUFF,
+			 FIELD_PREP(MTK_WDMA_GLO_CFG_RESV_BUFF, 0x80));
+
 	wed_set(dev, MTK_WED_GLO_CFG,
 		MTK_WED_GLO_CFG_TX_DMA_EN |
 		MTK_WED_GLO_CFG_RX_DMA_EN);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index c71190924816c..e5f83100ded52 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -433,6 +433,7 @@ struct mtk_wdma_desc {
 #define MTK_WDMA_GLO_CFG_TX_DMA_BUSY			BIT(1)
 #define MTK_WDMA_GLO_CFG_RX_DMA_EN			BIT(2)
 #define MTK_WDMA_GLO_CFG_RX_DMA_BUSY			BIT(3)
+#define MTK_WDMA_GLO_CFG_RESV_BUFF			GENMASK(23, 16)
 #define MTK_WDMA_GLO_CFG_RX_INFO3_PRERES		BIT(26)
 #define MTK_WDMA_GLO_CFG_RX_INFO2_PRERES		BIT(27)
 #define MTK_WDMA_GLO_CFG_RX_INFO1_PRERES		BIT(28)
-- 
2.53.0

