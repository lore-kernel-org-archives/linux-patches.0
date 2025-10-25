Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D629E303A19;
	Sat, 25 Oct 2025 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408859; cv=none; b=Vw0+XVw0D4MJh7kLikc4m4qzcsW8qySeug5x6xWHPAOVfp8c0ueRBVwE48yHPvu+tGaegVn5c7IBVmF/+9aJraG4kvntK/A3mhPBe4d5uvOFcIqVQtBtuM4zAVDMK4MpXbZBeLrQ3sqtqoSutBfe9MakAHEvB8o4+0XOw6L++OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408859; c=relaxed/simple;
	bh=5RSeeB3S1/J0HAC9USlhoReBSTAQtB4d0Cwrm1UEPPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MVbl+d3Z9/6u4J/6nBWNPKFxF/segn6VJr+sqtKlNRiqOUrY30/rYmI0eZ2nbuYsxjQEaKeIv9ikUAktNzqbvAC6G3UBJbceu90qG8Q16xfClt1ELhq4nclQF+E1kUG2LWsWw1rjRgyl2pgnI3cWBir1aGFw9Wo0lDid3XI6E4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gykMPVNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gykMPVNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA40C4CEF5;
	Sat, 25 Oct 2025 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408859;
	bh=5RSeeB3S1/J0HAC9USlhoReBSTAQtB4d0Cwrm1UEPPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gykMPVNAK5IXa2QP6LtlEen4ukgR6leNQ229jmGF1+Ic0YomiwSpM4OSQQf8YGEYO
	 vQBMV1O3tu8il/Bd49c85URgr3WCsfvAioVzlKnuWVFPa4oEZIYt1i6rphflvcrZJl
	 ioof5Qe5ujnwrgCD2SwI8wocpDX9ZT8In7ADzT33rK212lHPvVxNaX/Rfr7h/w/cq8
	 h6to6MMMz+qjc0JjUxd7Mos1R7neKoyuZR9c79sCEcn828t9+aY+a4K4g9Sm5zPd3u
	 ZO8ppGO4bH2dVTnk0Cy5u/rFrp48gaHi6+091t0WpE4aZsJDI51joFntqe2vG5zqLM
	 nJCPpfV6URWGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	mripard@kernel.org,
	lumag@kernel.org,
	srinivasan.shanmugam@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)
Date: Sat, 25 Oct 2025 11:55:35 -0400
Message-ID: <20251025160905.3857885-104-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 585b2f685c56c5095cc22c7202bf74d8e9a73cdd ]

Update the legacy (non-DC) display code to respect the maximum
pixel clock for HDMI and DVI-D. Reject modes that would require
a higher pixel clock than can be supported.

Also update the maximum supported HDMI clock value depending on
the ASIC type.

For reference, see the DC code:
check max_hdmi_pixel_clock in dce*_resource.c

v2:
Fix maximum clocks for DVI-D and DVI/HDMI adapters.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real user-visible bug: previously the legacy (non-DC) amdgpu
  mode validator could accept out-of-spec TMDS/HDMI pixel clocks or
  reject supported ones, leading to blank screens/unstable links
  (accepting too-high clocks on older ASICs) or missing modes (rejecting
  4K60 on HDMI 2.0 ASICs). The patch makes validation match hardware
  limits per ASIC and connector type.

- Introduces ASIC-aware HDMI TMDS limits via
  `amdgpu_max_hdmi_pixel_clock()`:
  - `drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1201`
  - Returns 600000 kHz for `CHIP_POLARIS10` and newer, 300000 kHz for
    `CHIP_TONGA`+, else 297000 kHz. This corrects the prior hard-coded
    HDMI cap of 340000 kHz, which was too high for pre-Tonga and too low
    for HDMI 2.0 parts.

- Corrects digital mode validation logic in
  `amdgpu_connector_dvi_mode_valid()`:
  - Start: `drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1221`
  - Computes per-connector digital pixel clock ceilings:
    - HDMI Type A → `max_hdmi_pixel_clock`
      (`drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1235`)
    - Single-link DVI (I/D) → 165000 kHz
    - Dual-link DVI (I/D) and HDMI Type B → 330000 kHz
  - Critically, if EDID reports HDMI
    (`connector->display_info.is_hdmi`), it overrides to the HDMI limit
    even on DVI connectors, correctly handling DVI↔HDMI adapters and
    DVI-I digital paths.
  - Rejects modes above the computed limit with `MODE_CLOCK_HIGH`.

- Preserves existing global guard: still rejects modes exceeding the
  board’s max pixel clock (`(mode->clock/10) >
  adev->clock.max_pixel_clock`;
  `drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1261`), so this change
  tightens/enables only the connector/ASIC-specific limit without
  relaxing the overall cap.

- Applies to both DVI and HDMI connectors in the legacy path:
  - Mode validator is wired via `amdgpu_connector_dvi_helper_funcs`
    (`drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1267`) and used for
    both DVI and HDMI connector init
    (`drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1849`,
    `drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1905`).

- Scope and risk:
  - Single file, localized change in mode validation; no architectural
    churn.
  - Aligns legacy path with DC code’s practice of checking max HDMI
    pixel clock (per commit message).
  - Potential behavior change is deliberate and corrective: prevents
    out-of-spec modes on older ASICs and enables valid high-TMDS modes
    (e.g., 4K60) on HDMI 2.0 ASICs. Low regression risk, as it enforces
    true hardware limits.

- Stable criteria:
  - Important bugfix for display correctness/stability (rejects invalid
    modes; enables valid ones previously blocked).
  - Small, self-contained patch confined to amdgpu legacy display
    connector validation.
  - No API changes, no broad subsystem impact, and behavior matches
    established DC logic.
  - Commit message clearly describes a fix; v2 explicitly addresses
    DVI-D and DVI/HDMI adapter corner cases.

Given the clear correctness improvement, limited scope, and alignment
with hardware capabilities, this is a strong candidate for stable
backporting.

 .../gpu/drm/amd/amdgpu/amdgpu_connectors.c    | 57 ++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 5e375e9c4f5de..a381de8648e54 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1195,29 +1195,60 @@ static void amdgpu_connector_dvi_force(struct drm_connector *connector)
 		amdgpu_connector->use_digital = true;
 }
 
+/**
+ * Returns the maximum supported HDMI (TMDS) pixel clock in KHz.
+ */
+static int amdgpu_max_hdmi_pixel_clock(const struct amdgpu_device *adev)
+{
+	if (adev->asic_type >= CHIP_POLARIS10)
+		return 600000;
+	else if (adev->asic_type >= CHIP_TONGA)
+		return 300000;
+	else
+		return 297000;
+}
+
+/**
+ * Validates the given display mode on DVI and HDMI connectors,
+ * including analog signals on DVI-I.
+ */
 static enum drm_mode_status amdgpu_connector_dvi_mode_valid(struct drm_connector *connector,
 					    const struct drm_display_mode *mode)
 {
 	struct drm_device *dev = connector->dev;
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	struct amdgpu_connector *amdgpu_connector = to_amdgpu_connector(connector);
+	const int max_hdmi_pixel_clock = amdgpu_max_hdmi_pixel_clock(adev);
+	const int max_dvi_single_link_pixel_clock = 165000;
+	int max_digital_pixel_clock_khz;
 
 	/* XXX check mode bandwidth */
 
-	if (amdgpu_connector->use_digital && (mode->clock > 165000)) {
-		if ((amdgpu_connector->connector_object_id == CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_I) ||
-		    (amdgpu_connector->connector_object_id == CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_D) ||
-		    (amdgpu_connector->connector_object_id == CONNECTOR_OBJECT_ID_HDMI_TYPE_B)) {
-			return MODE_OK;
-		} else if (connector->display_info.is_hdmi) {
-			/* HDMI 1.3+ supports max clock of 340 Mhz */
-			if (mode->clock > 340000)
-				return MODE_CLOCK_HIGH;
-			else
-				return MODE_OK;
-		} else {
-			return MODE_CLOCK_HIGH;
+	if (amdgpu_connector->use_digital) {
+		switch (amdgpu_connector->connector_object_id) {
+		case CONNECTOR_OBJECT_ID_HDMI_TYPE_A:
+			max_digital_pixel_clock_khz = max_hdmi_pixel_clock;
+			break;
+		case CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_I:
+		case CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_D:
+			max_digital_pixel_clock_khz = max_dvi_single_link_pixel_clock;
+			break;
+		case CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_I:
+		case CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_D:
+		case CONNECTOR_OBJECT_ID_HDMI_TYPE_B:
+			max_digital_pixel_clock_khz = max_dvi_single_link_pixel_clock * 2;
+			break;
 		}
+
+		/* When the display EDID claims that it's an HDMI display,
+		 * we use the HDMI encoder mode of the display HW,
+		 * so we should verify against the max HDMI clock here.
+		 */
+		if (connector->display_info.is_hdmi)
+			max_digital_pixel_clock_khz = max_hdmi_pixel_clock;
+
+		if (mode->clock > max_digital_pixel_clock_khz)
+			return MODE_CLOCK_HIGH;
 	}
 
 	/* check against the max pixel clock */
-- 
2.51.0

