Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6C44C661;
	Mon, 31 Aug 2026 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183719; cv=none; b=Ipoy+OCCIUHEZA9OvsPw2+vLU4UeG5JiIzpEEPxnqB2RqvG5UG4bbtgQ3oy+Ti+wcxHF8rKGC1ya9DGMPbq3gvWbQRv0SYkeSkDUe9i2bqd57hVXAbPz09DE8N9OJKHVsT2PLjnXNTwL/Vsk2tqfG/DTxhwwVYCVo6kgzwevNP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183719; c=relaxed/simple;
	bh=t5p6h4sHwiice89Cbl+eDokuMQZamDoWSrdz3mbcHRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ov4wXmhWuhY6jwqyKVPYgNEVaFYGZWTQMOVKPYyTZtiLDMrY0Z0wKSlJbwmaVNwUjmOAdJwsD0VJDAhLs6vpmJxXJVGsArjZAKu5HErgnEOGDY4Kyov6SVOmCOwWLKsUD8yaZglOYqI2nYY+p3A1WKktKmFE2B3HfDK6SlNy3mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6tjZme/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6tjZme/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6821F00A3E;
	Mon, 31 Aug 2026 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183716;
	bh=9waQiWmGIRreL2pS/vRF0HC/WvchDTgVV64118m7PDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6tjZme/UAej6dvIG6QuzVr1jWsV90B4VaEnkEcq2Tf8qbmXh290HH01n19CFD4A4
	 ILrLC1BQaZm1YSoiUVRvqMEOXFw32KuUfn2IFK5q6bhkymzIudVBj8owDBd0J3CNAL
	 /BqmnbFJWSnnTJ3emtUQAar50ff/lU/OhzHt4ZeHEWKlX1TqzlJd94VZDA6a9YvcjY
	 2GbCwIBi4KQcLLbWUxoqIrdADLbQjluOr7+++7NtJ3KbxYFH/kKbD/McQyeaxJZack
	 u44/Z7SinV00sioB/5HoiyfHnJp+tKV2aJqGPjGlmA+/Y+Fwa0+drqDIZQ93HDiKn+
	 hilyNxLhxitMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	p.zabel@pengutronix.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	matthias.bgg@gmail.com,
	dri-devel@lists.freedesktop.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/mediatek: dsi: Add compatible for mt8167-dsi
Date: Mon, 31 Aug 2026 09:24:50 -0400
Message-ID: <20260831133314.4125787-262-sashal@kernel.org>
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

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 6428eaf0c1f39815b08d57054895c1934d5782f3 ]

The mt8167 DSI controller is fully compatible with the one found in
mt2701. Unfortunately the device tree has a dedicated compatible for
mt8167 since 2022 and it cannot be changed with a fallback nor removed at
this point. The only way to get the device to work is to add the
compatible to the driver.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260505214541.333657-3-l.scorcia@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/mediatek: dsi: Add compatible for
mt8167-dsi

**Local tree:** `v6.18.43` (Makefile: 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[drm/mediatek: dsi]` `[Add]` — Add `mediatek,mt8167-dsi`
compatible string to the existing MediaTek DSI platform driver so MT8167
boards can bind.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Luca Leonardo Scorcia `<l.scorcia@gmail.com>`
  (author)
- **Reviewed-by:** AngeloGioacchino Del Regno
  `<angelogioacchino.delregno@collabora.com>`
- **Reviewed-by:** CK Hu `<ck.hu@mediatek.com>` (MediaTek maintainer)
- **Link:** https://patchwork.kernel.org/project/dri-
  devel/patch/20260505214541.333657-3-l.scorcia@gmail.com/
- **Signed-off-by:** Chun-Kuang Hu `<chunkuang.hu@kernel.org>` (applied
  to mediatek-drm-next)
- No Fixes:, Reported-by:, Cc: stable, or syzbot tags
- Notable: two subsystem Reviewed-by tags, including MediaTek maintainer

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** MT8167 DSI hardware is register-compatible with MT2701, but
  the DSI platform driver’s `of_match` table lacks
  `mediatek,mt8167-dsi`.
- **Symptom:** DSI platform device does not probe; display pipeline
  cannot complete on MT8167 boards whose DT uses `mediatek,mt8167-dsi`.
- **Root cause:** DT binding has listed `mediatek,mt8167-dsi` since
  2022; that compatible cannot be removed or replaced with a fallback;
  driver was never updated to match.
- **Version info:** Binding present since 2022; fix is May 2026.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised as cleanup. This is explicit hardware-
enablement: a missing `of_device_id` entry leaves DSI non-functional on
affected hardware. Functionally a driver/DT mismatch bug, not a new
feature API.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/gpu/drm/mediatek/mtk_dsi.c` (+1 line)
- **Functions/areas:** `mtk_dsi_of_match[]` static table
- **Scope:** Single-file, one-line surgical change

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** `mtk_dsi_probe()` only runs for `mt2701-dsi`,
  `mt8173-dsi`, `mt8183-dsi`, `mt8186-dsi`, `mt8188-dsi` compatibles.
- **After:** Also runs for `mediatek,mt8167-dsi`, using
  `mt2701_dsi_driver_data` (same register offsets as MT2701).
- **Path affected:** Platform probe → `of_device_get_match_data()` → DSI
  host/bridge registration → DRM component bind.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic/correctness — missing hardware identification
  entry (compatible-string quirk).
- **Mechanism:** `mtk_drm_drv.c` already recognizes
  `mediatek,mt8167-dsi` in `mtk_ddp_comp_dt_ids[]` and adds a component
  match, but `mtk_dsi_driver` never probes the device without a matching
  `of_match` entry. DRM bind stalls or fails for the DSI component.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Obviously correct: reuses existing `mt2701_dsi_driver_data`; author
  and reviewers confirm hardware identity.
- Minimal, no unrelated changes.
- Regression risk: very low — only adds a new match entry pointing at
  proven driver data.
- No API, structure, or locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** In this checkout, `git blame` on `mtk_dsi_of_match[]`
attributes all lines to a single squashed base commit (`a112b91dd6349`);
per-file history is not useful for dating the omission. The omission is
the absence of `mt8167-dsi` while other MT8167 compatibles exist
elsewhere in the same driver tree.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Patch is **v4, 2/2** of series “Add support for mt8167 display
  blocks”.
- **v4, 1/2:** `arm64: dts: mediatek: mt8167: Add DRM nodes` (adds DSI
  and other display nodes to `mt8167.dtsi`).
- This driver patch is standalone: it only needs a DT node with
  `mediatek,mt8167-dsi`, which the binding has documented since 2022 and
  which `mtk_drm_drv.c` already handles.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Luca Leonardo Scorcia is an active MT8167 display
contributor. Maintainer Chun-Kuang Hu applied the patch to `mediatek-
drm-next`. Git history in this tree is too squashed to enumerate author
commits locally.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:**
- No kernel-code prerequisites beyond existing `mt2701_dsi_driver_data`
  and `mtk_dsi` driver (both present in 6.18.43).
- DTS patch 1/2 is **not** required for the driver fix to apply cleanly;
  it is required for in-tree `mt8167.dtsi` to expose a DSI node.
  Vendor/out-of-tree DTS may already use `mediatek,mt8167-dsi`.
- **Can apply standalone:** PASS for the driver change.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c <sha>` failed (commit not in this repo).
- Patchwork: https://patchwork.kernel.org/project/dri-
  devel/patch/20260505214541.333657-3-l.scorcia@gmail.com/
- Series: v4, 2/2; v4, 1/2 adds DRM DT nodes.
- Reviewed-by from AngeloGioacchino Del Regno and CK Hu on list.
- Chun-Kuang Hu: “Applied to mediatek-drm-next”.
- No stable nomination or NAK found in thread.
- lore.kernel.org fetch blocked (bot protection).

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC list included `linux-mediatek`, `dri-devel`,
`devicetree`, `chunkuang.hu@kernel.org`, `ck.hu@mediatek.com`, and other
DRM/DT maintainers. MediaTek maintainer reviewed and applied.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No formal bug report or syzbot link. Impact inferred from
incomplete driver/DT binding alignment and partial MT8167 DRM support
already in-tree.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Companion patch adds DSI node to `mt8167.dtsi`. In **this**
tree, `mt8167.dtsi` has mmsys/SMI nodes but **no DSI node**;
`mt8167-pumpkin.dts` also has no display nodes. Driver fix still matters
for downstream/vendor DTS and for when patch 1/2 lands.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched (lore blocked). No stable discussion found on
Patchwork.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `mtk_dsi_of_match[]`, `mtk_dsi_probe()`, `mtk_dsi_driver`
(platform driver registration via `mtk_drm_init()`).

### Step 5.2: TRACE CALLERS
**Record:**
- `mtk_dsi_driver` registered in `mtk_drm_init()` →
  `platform_register_drivers()`.
- `mtk_drm_probe()` iterates MMSYS children, matches
  `mediatek,mt8167-dsi` via `mtk_ddp_comp_dt_ids[]`, calls
  `drm_of_component_match_add()` for DSI nodes.
- Without `mtk_dsi` probe, component bind cannot succeed.

### Step 5.3: TRACE CALLEES
**Record:** `mtk_dsi_probe()` uses `of_device_get_match_data()`,
clock/PHY/IRQ setup, `mipi_dsi_host_register()`, DRM bridge setup — all
standard, unchanged by this patch.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Boot → DT populates DSI platform device → `mtk_dsi_probe()`
(needs `of_match`) → component bind in `mtk_drm_bind()` → display
pipeline. Reachable on any MT8167 board with a DSI DT node; not a
syscall path, but normal embedded boot/display init.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `mtk_drm_drv.c` already lists many `mediatek,mt8167-*`
compatibles (mmsys, ovl, rdma, **dsi**, etc.) while `mtk_dsi.c` lacked
the DSI entry — clear inconsistency, same pattern as other SoC-specific
compat strings in `mtk_dsi_of_match[]`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE (6.18.43)

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.**
- `mtk_dsi.c` lines 1303–1309: `mtk_dsi_of_match[]` has no `mt8167-dsi`.
- `mtk_drm_drv.c` line 813: `mediatek,mt8167-dsi` **is** in
  `mtk_ddp_comp_dt_ids[]`.
- `Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.yaml`
  line 28: `mt8167-dsi` documented.
- `mt2701_dsi_driver_data` exists at line 1271.
- Partial MT8167 DRM support is already in 6.18.43; DSI driver match is
  the missing piece.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply** — single line insertion after the
`mt2701-dsi` entry. No structural conflicts observed; table layout
matches the upstream diff context.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No existing commit in this tree adds `mt8167-dsi` to
`mtk_dsi.c`. `git log --grep="mt8167-dsi"` returned nothing.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/gpu/drm/mediatek` — **IMPORTANT** (embedded/display
on MediaTek SoCs; not core kernel, but user-visible on affected
hardware).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** MT8167 display support is actively being completed (v4
series, May 2026). 6.18.43 already carries substantial MT8167 DRM driver
data, indicating the platform is in scope for this stable series.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of MT8167-based devices with DSI panels (tablets,
embedded boards such as Pumpkin, vendor trees using
`mediatek,mt8167-dsi`). Config-dependent on `CONFIG_DRM_MEDIATEK` and
MT8167 DT support.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Boot on MT8167 hardware with a DSI node using `compatible =
"mediatek,mt8167-dsi"`. Common on intended display bring-up; not
userspace-triggered. Likelihood: **certain** on any such board without
this fix.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** DSI driver does not probe → display does not work (no
framebuffer/DRM output). **Severity: MEDIUM** — hardware broken for
display use, but not a crash, security issue, or data corruption.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Enables DSI display on MT8167; fixes inconsistency with
  binding and `mtk_drm_drv.c`.
- **Risk:** One line, existing driver data, maintainer-reviewed — **very
  low**.
- **Ratio:** Favorable for stable; fits the “compatible / device ID
  addition to existing driver” exception.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Fixes real broken display on MT8167 when DT uses `mediatek,mt8167-dsi`
- One-line, obviously correct; reviewed by MediaTek maintainer
- Reuses `mt2701_dsi_driver_data` — no new APIs or logic
- Binding and `mtk_drm_drv.c` already expect this compatible in 6.18.43
- Classic stable exception: compatible-string addition to existing
  driver
- Very low regression risk

**AGAINST backport:**
- Could be framed as “new hardware enablement” rather than crash fix
- In-tree `mt8167.dtsi` in 6.18.43 still lacks DSI nodes (patch 1/2 not
  merged)
- No syzbot/user crash reports
- Display failure is functional, not a kernel oops

**UNRESOLVED:**
- Exact mainline commit SHA not in this repo (`b4 dig` failed)
- lore.kernel.org thread not readable (403)
- When `mt8167-dsi` first entered the DT binding in mainline history
  (squashed git in this checkout)

Neither unresolved item changes the technical conclusion for 6.18.43.

### Step 9.2: STABLE RULES CHECKLIST
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — maintainer Reviewed-by;
maps to known-good MT2701 data |
| 2. Fixes a real bug affecting users? | **PASS** — DSI cannot probe
without this entry |
| 3. Important issue? | **PASS (MEDIUM)** — display non-functional on
affected hardware |
| 4. Small and contained? | **PASS** — 1 line, 1 file |
| 5. No new features/APIs? | **PASS** — compatible quirk only; exception
applies |
| 6. Can apply to local tree? | **PASS** — clean one-line apply;
prerequisites present |

### Step 9.3: EXCEPTION CATEGORIES
**Record:** **Hardware quirk / device compatible addition** — adding
`mediatek,mt8167-dsi` to an existing driver’s `of_match` table, reusing
established `mt2701_dsi_driver_data`. Explicitly allowed for stable.

### Step 9.4: DECISION RATIONALE

For **6.18.43**, MT8167 DRM support is already partially merged:
`mtk_drm_drv.c` recognizes `mediatek,mt8167-dsi` and builds an MT8167
display pipeline, but `mtk_dsi.c` omits the compatible. That is a clear
driver bug/oversight, not greenfield feature work. The fix is one line,
low risk, maintainer-reviewed, and aligns driver behavior with the DT
binding that has documented `mt8167-dsi` since 2022. Stable trees
routinely take such compatible-string additions for existing drivers.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message and Patchwork
- **[Phase 2]** Confirmed diff: +1 line in `mtk_dsi_of_match[]` pointing
  to `mt2701_dsi_driver_data`
- **[Phase 3]** `git describe HEAD` → `v6.18.43`; `git blame` on
  `mtk_dsi.c:1303-1310` and `mtk_drm_drv.c:813-814`
- **[Phase 3]** `git log --grep="mt8167-dsi"` → no results in this tree
- **[Phase 4]** Patchwork fetch: v4 2/2 series, Reviewed-by, applied to
  mediatek-drm-next
- **[Phase 4]** `b4 dig -c 2257966bbaa9a` → commit not found in repo
- **[Phase 4]** lore.kernel.org → 403 Forbidden
- **[Phase 5]** Read `mtk_dsi_probe()`, `mtk_drm_probe()`,
  `mtk_drm_init()` registration path
- **[Phase 5]** `grep mt8167` in `drivers/gpu/drm/mediatek/` → extensive
  MT8167 support in `mtk_drm_drv.c`, HDMI in `mtk_hdmi.c`
- **[Phase 6]** `grep mt8167-dsi` → present in `mtk_drm_drv.c` and
  binding; **absent** in `mtk_dsi.c`
- **[Phase 6]** Read `mt8167.dtsi`, `mt8167-pumpkin.dts` → no DSI node
  in-tree yet
- **[Phase 6]** Confirmed `mt2701_dsi_driver_data` exists at
  `mtk_dsi.c:1271-1275`
- **[Phase 7]** Identified subsystem as DRM/MediaTek display driver
- **[Phase 8]** Assessed failure as non-probing DSI / no display (MEDIUM
  severity)

**YES**

 drivers/gpu/drm/mediatek/mtk_dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index acee2227275b7..6845bb8043254 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -1302,6 +1302,7 @@ static const struct mtk_dsi_driver_data mt8188_dsi_driver_data = {
 
 static const struct of_device_id mtk_dsi_of_match[] = {
 	{ .compatible = "mediatek,mt2701-dsi", .data = &mt2701_dsi_driver_data },
+	{ .compatible = "mediatek,mt8167-dsi", .data = &mt2701_dsi_driver_data },
 	{ .compatible = "mediatek,mt8173-dsi", .data = &mt8173_dsi_driver_data },
 	{ .compatible = "mediatek,mt8183-dsi", .data = &mt8183_dsi_driver_data },
 	{ .compatible = "mediatek,mt8186-dsi", .data = &mt8186_dsi_driver_data },
-- 
2.53.0

