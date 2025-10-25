Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DA430FC23;
	Sat, 25 Oct 2025 16:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409332; cv=none; b=nQmWevlPKm/jxMDsZcId8qSWUhB+7S0VjRKJl3GLpdsPipSRYG9t4/bDwtXXTX1ouQi1WHZBYo5ZtMHioqPW61SR4uTpeB3wZe//U0pVMkhEgi3TFMmUDUqhcSyQDiNvBpUHOaVxI1VlU+g/ptLtDZNuTqzYuaUuO5mXDL6PPAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409332; c=relaxed/simple;
	bh=PlWTbrBPJkE6wKI+zzRdPW/KqPg9rI9eB5GRFoEJqQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EeE6ZYryhn0PHd8P8ago22K4j19XdiLtVSPuxvdlQOmKFVZhKn1cNp2pKNbfwYQxiMPnwTJALpsM+Mzafvi/UtwKbXLWn6ftWFreKeNN+MjqI0e85GBs1GwFoSdUhy9PjK7IRmSg57RRyivPqfhfPBoHSUtjksd4La5J0te4Ig8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWcYtHK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWcYtHK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58AEC4CEFB;
	Sat, 25 Oct 2025 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409332;
	bh=PlWTbrBPJkE6wKI+zzRdPW/KqPg9rI9eB5GRFoEJqQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWcYtHK0H7PrdoMMyCdyycwtVCdRPxN3c50uJwelwTOksRpJyPEwmPgok7WR6p4o9
	 /kUZtnVwZHJKkBP1jJ3EjUtTy/5hdwDlPXQzu+6GQRpTpTu/stxDL4R4kHb6EDiZSM
	 sxukL+wlViHDmQJKsYjEwU4wFt8JUBP0Ywl4C1BjZgTSt2ZLKRZz9h/ZJWZLDUE8zz
	 4YnhXs1N6XvGH3F7iecbfcUHDGNrHrqf0T516T1N91MH+RdCiDg4vJkH/SHe5xgVMH
	 /sx8HxgVAV3qPMqltZhUigingnz3hF5LcsM11LCxLlNs+JTNVLu+UKSfk/uoHq4rjv
	 PNHxjU5BS/M8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cruise Hung <Cruise.Hung@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	wenjing.liu@amd.com,
	george.shen@amd.com,
	Jingwen.Zhu@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Remove check DPIA HPD status for BW Allocation
Date: Sat, 25 Oct 2025 11:58:33 -0400
Message-ID: <20251025160905.3857885-282-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cruise Hung <Cruise.Hung@amd.com>

[ Upstream commit d0e164f72e6a16e64f660023dc7ad25b31b8b08d ]

[Why & How]
Link hpd_status is for embedded DPIA only.
Do not check hpd_status for BW allocation logic.

Reviewed-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The change removes inappropriate reliance on `link->hpd_status` in
    the USB4 DPIA bandwidth allocation path. The commit message states
    “Link hpd_status is for embedded DPIA only,” which means using it
    broadly in bandwidth allocation logic was causing false negatives
    and preventing allocation/deallocation at the wrong times. This can
    manifest as:
    - Failure to request DP tunneling BW when needed (streams present in
      the new state, but embedded HPD seen as LOW).
    - Failure to release BW (when allocation should be zeroed or torn
      down, but was gated by HPD state instead of actual BW demand).
  - This is a functional bug in DP-over-USB4 DPIA bandwidth handling.
    Fixing it improves correctness for users with DP over USB4 setups.

- Why it’s safe and small
  - The scope is limited to AMD DC DP-over-USB4 DPIA BW allocation and
    validation. No architectural changes, no broad subsystem refactors.
  - Changes are straightforward condition adjustments and do not
    introduce new features or APIs.

- Code changes and their effect
  - drivers/gpu/drm/amd/display/dc/link/link_validation.c
    - Old gating skipped all DP/MST streams if `link->hpd_status` was
      false:
      - Previously: `if (!(link && (stream->signal == DP || MST) &&
        link->hpd_status)) continue;`
    - New logic only skips when the endpoint is a DPIA with HPD low,
      otherwise does not gate validation on `hpd_status`:
      - Now: `if (!(link && (stream->signal == DP || MST))) continue;`
        followed by `if ((link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA)
        && (link->hpd_status == false)) continue;`
    - Impact: For non-DPIA DP links, bandwidth validation no longer
      spuriously ignores streams because of the embedded DPIA HPD
      status, matching the commit rationale that `hpd_status` is
      embedded-only and should not block generic DP BW validation.

  - drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
    - Availability check
      - Old: `link_dp_is_bw_alloc_available()` required
        `link->hpd_status` to be true.
      - New: Removes `link->hpd_status` from availability; now
        availability is based on DPCD bits only (USB4 tunneling support,
        DPIA BW alloc, and driver support).
      - Effect: Prevents premature blocking of BW alloc logic simply due
        to embedded HPD state; capability-based gating remains intact.
    - Enabling BW allocation mode
      - Old: `link_dpia_enable_usb4_dp_bw_alloc_mode()` only executed
        when `link->hpd_status` was true.
      - New: Always attempts to enable via
        `DPTX_BW_ALLOCATION_MODE_CONTROL`, checks return. Also refreshes
        NRD caps and updates `reported_link_cap` if available.
      - Effect: Allows enabling the DP-Tx BW alloc mode based on
        capabilities rather than embedded HPD, reducing cases where
        enablement is skipped even though tunneling is supported.
    - Allocation/deallocation flow
      - Old: `dpia_handle_usb4_bandwidth_allocation_for_link()` treated
        “Hot Plug” and “Cold Unplug” based on `link->hpd_status`
        (request BW only if HPD high and `peak_bw > 0`; unplug if HPD
        low).
      - New: Drives allocation by demand: request when `peak_bw > 0`;
        otherwise perform unplug. This ties allocation lifecycle to
        actual required BW instead of HPD signals, avoiding stale
        allocations when HPD is not representative of DP tunneling
        state.
    - Call-site behavior
      - `link_dp_dpia_allocate_usb4_bandwidth_for_stream()` still logs
        HPD but now relies on the updated
        `link_dp_is_bw_alloc_available()` (no HPD gating). Requests
        proceed when capabilities indicate support, not when embedded
        HPD happens to be high.

- Alignment with stable rules
  - Bugfix: Yes; corrects overly strict gating that blocked proper BW
    allocation/deallocation and validation in DP-over-USB4 cases.
  - Small and contained: Yes; condition-only changes in two AMD DC
    files.
  - Side effects: Minimal and beneficial; shifts from HPD-based gating
    to capability and demand-based logic, which is more accurate for DP
    tunneling over USB4.
  - Architectural changes: None.
  - Critical subsystems: Only AMDGPU DC display path; common to stable
    fixes.
  - Stable tags: No explicit Cc stable/Fixes in the message, but the fix
    has clear user impact and low regression risk.

- Risk assessment and compatibility
  - DPCD accesses remain capability-gated (dp tunneling + BW alloc
    bits). If the link is not in a state to handle DPCD writes, the
    writes fail and are logged; logic handles DC_OK checks.
  - For non-DPIA DP links, validation no longer depends on embedded HPD,
    which is exactly what the commit calls out as incorrect. DPIA-
    specific gating remains for cases where it’s meaningful.
  - For stable series with slightly different function names (e.g.,
    older trees may use helpers like `get_bw_alloc_proceed_flag` or
    `link_dp_dpia_set_dptx_usb4_bw_alloc_support`), the same conceptual
    change (stop gating on embedded DPIA HPD for BW allocation) should
    be applied in the corresponding locations.

Conclusion: This is a targeted, low-risk bugfix that improves DP-over-
USB4 DPIA bandwidth allocation and validation behavior and should be
backported to stable trees that contain the affected DPIA BW allocation
logic.

 .../drm/amd/display/dc/link/link_validation.c |  6 +-
 .../dc/link/protocols/link_dp_dpia_bw.c       | 60 +++++++++----------
 2 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_validation.c b/drivers/gpu/drm/amd/display/dc/link/link_validation.c
index aecaf37eee352..acdc162de5353 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_validation.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_validation.c
@@ -408,8 +408,10 @@ enum dc_status link_validate_dp_tunnel_bandwidth(const struct dc *dc, const stru
 		link = stream->link;
 
 		if (!(link && (stream->signal == SIGNAL_TYPE_DISPLAY_PORT
-				|| stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
-				&& link->hpd_status))
+				|| stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)))
+			continue;
+
+		if ((link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA) && (link->hpd_status == false))
 			continue;
 
 		dp_tunnel_settings = get_dp_tunnel_settings(new_ctx, stream);
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
index 819bf2d8ba530..906d85ca89569 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
@@ -48,8 +48,7 @@
  */
 static bool link_dp_is_bw_alloc_available(struct dc_link *link)
 {
-	return (link && link->hpd_status
-		&& link->dpcd_caps.usb4_dp_tun_info.dp_tun_cap.bits.dp_tunneling
+	return (link && link->dpcd_caps.usb4_dp_tun_info.dp_tun_cap.bits.dp_tunneling
 		&& link->dpcd_caps.usb4_dp_tun_info.dp_tun_cap.bits.dpia_bw_alloc
 		&& link->dpcd_caps.usb4_dp_tun_info.driver_bw_cap.bits.driver_bw_alloc_support);
 }
@@ -226,35 +225,35 @@ bool link_dpia_enable_usb4_dp_bw_alloc_mode(struct dc_link *link)
 	bool ret = false;
 	uint8_t val;
 
-	if (link->hpd_status) {
-		val = DPTX_BW_ALLOC_MODE_ENABLE | DPTX_BW_ALLOC_UNMASK_IRQ;
+	val = DPTX_BW_ALLOC_MODE_ENABLE | DPTX_BW_ALLOC_UNMASK_IRQ;
 
-		if (core_link_write_dpcd(link, DPTX_BW_ALLOCATION_MODE_CONTROL, &val, sizeof(uint8_t)) == DC_OK) {
-			DC_LOG_DEBUG("%s:  link[%d] DPTX BW allocation mode enabled", __func__, link->link_index);
+	if (core_link_write_dpcd(link, DPTX_BW_ALLOCATION_MODE_CONTROL, &val, sizeof(uint8_t)) == DC_OK) {
+		DC_LOG_DEBUG("%s:  link[%d] DPTX BW allocation mode enabled", __func__, link->link_index);
 
-			retrieve_usb4_dp_bw_allocation_info(link);
+		retrieve_usb4_dp_bw_allocation_info(link);
 
-			if (link->dpia_bw_alloc_config.nrd_max_link_rate && link->dpia_bw_alloc_config.nrd_max_lane_count) {
-				link->reported_link_cap.link_rate = link->dpia_bw_alloc_config.nrd_max_link_rate;
-				link->reported_link_cap.lane_count = link->dpia_bw_alloc_config.nrd_max_lane_count;
-			}
+		if (
+				link->dpia_bw_alloc_config.nrd_max_link_rate
+				&& link->dpia_bw_alloc_config.nrd_max_lane_count) {
+			link->reported_link_cap.link_rate = link->dpia_bw_alloc_config.nrd_max_link_rate;
+			link->reported_link_cap.lane_count = link->dpia_bw_alloc_config.nrd_max_lane_count;
+		}
 
-			link->dpia_bw_alloc_config.bw_alloc_enabled = true;
-			ret = true;
-
-			if (link->dc->debug.dpia_debug.bits.enable_usb4_bw_zero_alloc_patch) {
-				/*
-				 * During DP tunnel creation, the CM preallocates BW
-				 * and reduces the estimated BW of other DPIAs.
-				 * The CM releases the preallocation only when the allocation is complete.
-				 * Perform a zero allocation to make the CM release the preallocation
-				 * and correctly update the estimated BW for all DPIAs per host router.
-				 */
-				link_dp_dpia_allocate_usb4_bandwidth_for_stream(link, 0);
-			}
-		} else
-			DC_LOG_DEBUG("%s:  link[%d] failed to enable DPTX BW allocation mode", __func__, link->link_index);
-	}
+		link->dpia_bw_alloc_config.bw_alloc_enabled = true;
+		ret = true;
+
+		if (link->dc->debug.dpia_debug.bits.enable_usb4_bw_zero_alloc_patch) {
+			/*
+			 * During DP tunnel creation, the CM preallocates BW
+			 * and reduces the estimated BW of other DPIAs.
+			 * The CM releases the preallocation only when the allocation is complete.
+			 * Perform a zero allocation to make the CM release the preallocation
+			 * and correctly update the estimated BW for all DPIAs per host router.
+			 */
+			link_dp_dpia_allocate_usb4_bandwidth_for_stream(link, 0);
+		}
+	} else
+		DC_LOG_DEBUG("%s:  link[%d] failed to enable DPTX BW allocation mode", __func__, link->link_index);
 
 	return ret;
 }
@@ -297,15 +296,12 @@ void dpia_handle_usb4_bandwidth_allocation_for_link(struct dc_link *link, int pe
 {
 	if (link && link->dpcd_caps.usb4_dp_tun_info.dp_tun_cap.bits.dp_tunneling
 			&& link->dpia_bw_alloc_config.bw_alloc_enabled) {
-		//1. Hot Plug
-		if (link->hpd_status && peak_bw > 0) {
+		if (peak_bw > 0) {
 			// If DP over USB4 then we need to check BW allocation
 			link->dpia_bw_alloc_config.link_max_bw = peak_bw;
 
 			link_dpia_send_bw_alloc_request(link, peak_bw);
-		}
-		//2. Cold Unplug
-		else if (!link->hpd_status)
+		} else
 			dpia_bw_alloc_unplug(link);
 	}
 }
-- 
2.51.0

