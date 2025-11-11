Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D002D8DD6;
	Tue, 11 Nov 2025 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823129; cv=none; b=U2coFllRJ+GMkp+ARVgUvl9uJBr8y5TotAtZNuZLtxMKWGbcykSWRiOhFVdZ+D0kBNXYUpGsTWQnchnJM6AZMNqUjNix+VAxZoweLOCD8VX8bsIngozhkLSf0N1uLJx+RFlXgCKDJGSlR8ymYeiHIv6bbQzpERRkg/i1bvJooC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823129; c=relaxed/simple;
	bh=RdIphVcKRTfn9Gy+IwiTWPj+SipUG1qKEY5R1hneqh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0rfw7Bcgz+pMrq+JcSXP0D8aC+XlbteU1K9CvJb03Af0u6Ia9w7Oy2hZ6bZ8zffkPiWjYqi8s01Rb8Q6WxepWnkKhC9hcrm84CyRS2mNTkNkNI/PWy5PGBRn1oIjRIRA2ytgSSdZOW63ObmpvrXvFL/Ic1MGmmcgvXFvXmNgmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xavkc7sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xavkc7sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BA1C113D0;
	Tue, 11 Nov 2025 01:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823129;
	bh=RdIphVcKRTfn9Gy+IwiTWPj+SipUG1qKEY5R1hneqh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xavkc7sh1Ez+rWKlpJz98mHFKiLrW0XKnleBn2jhopoiPBv4VFhQjscEwl/1bKmWJ
	 s3ptBQmwuIIvuzF9L3uAWYVAK/bKy+/4JpXDBGZ1yHP5vsFNSxO84zkDSFeCKdBuTS
	 QxQTOoToKLdPhptTyW1P/TlMdy8WlDztOyI77clE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 236/849] drm/amd/display: Remove check DPIA HPD status for BW Allocation
Date: Tue, 11 Nov 2025 09:36:46 +0900
Message-ID: <20251111004542.148528673@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



