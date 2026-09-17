Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892494C10DA;
	Thu, 17 Sep 2026 15:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659956; cv=none; b=rKif2r+w5uhaUvDXwkFsO33gYFLVWmcPrY8Hy6BmPOz320bkGYyIi0OE+VXYTovOrPNftZzXK5T0l6rD3kyobKnIbKb07zWW5U4VoiEaEMHOjMAqqQlkoLaidV5XVmAxqxKN8Ml/+bUt9hl78zIF2WVImYV3EKtA3Mp7tRt+CZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659956; c=relaxed/simple;
	bh=JrP+9nnWfsE5b2ReI4ALXubCP8Wy7qguEGqa7mVmCEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDAVnQBJE2c8/R3zq3Iw5tzOfw1zY4tbcYIC5IMsi84o2zc+eK2ultQN2TV7YzK/lVfzLB+icHZGD3jHNc/oTZgVf1MM4Sk6iqgl9Ivcemo9n+i5j/DNB1Fi12LjOy/g3/ch2RVaAQ+UP4atQ9LaJR7mielZUrblbI8JtIBPNb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my/0mKxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my/0mKxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6161F000FF;
	Thu, 17 Sep 2026 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659952;
	bh=XOv3t0fW7W9LQUnVSdnyyrQaQiZzqwg4ahVJ+GJ50rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=my/0mKxkr8lWxyRJF3T0D2B7gAZld2DouaynsmFAn5WiZsEnURPmaeWhKGhyGXj7c
	 ExCDWXxObjpKVpkrEIs9P7409bTct14w1UnU9l1LGT2Xoy9c9UdMZFR5YrLRV2KiVC
	 9yQW0pen/gIH34scLapIyGFTeKpVYCnvQRTEQ8Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 412/733] drm/i915/dp: Gate UHBR SST SDP splitting on sink capability
Date: Thu, 17 Sep 2026 16:12:00 +0100
Message-ID: <20260917151402.041126397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>

[ Upstream commit a894f97318366d12102c15937aa6b63c21aa82b5 ]

SDP splitting for 128b/132b (UHBR) SST audio must only be enabled when
the sink advertises support for it. Previously sdp_split_enable
was set for every UHBR SST stream carrying audio, regardless of sink
capability.

In MST mode SDP splitting is inherently supported, so the sink
capability check (DP_SST_SPLIT_SDP_CAP) is applied only to the SST path.

Fixes: 8853750dbad8 ("drm/i915: Enable SDP split for DP2.0")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260825073204.872441-1-mitulkumar.ajitkumar.golani@intel.com
(cherry picked from commit b37921c9f533ca936c5b5a484c1299680c570a7e)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_display_types.h    |  2 +
 drivers/gpu/drm/i915/display/intel_dp.c       | 44 ++++++++++++++++---
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index c21e0c0ef0b12..96422641ae441 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1947,6 +1947,8 @@ struct intel_dp {
 
 	bool colorimetry_support;
 
+	bool sst_split_sdp_support;
+
 	struct {
 		enum transcoder transcoder;
 		struct mutex lock;
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 5733d2e7ac7f1..ba0b19d1163cf 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3518,12 +3518,22 @@ intel_dp_audio_compute_config(struct intel_encoder *encoder,
 			      struct intel_crtc_state *pipe_config,
 			      struct drm_connector_state *conn_state)
 {
+	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
+
 	pipe_config->has_audio =
 		intel_dp_has_audio(encoder, conn_state) &&
 		intel_audio_compute_config(encoder, pipe_config, conn_state);
 
 	pipe_config->sdp_split_enable = pipe_config->has_audio &&
 					intel_dp_is_uhbr(pipe_config);
+
+	/*
+	 * SDP splitting for UHBR audio requires explicit sink capability in
+	 * SST mode, whereas in MST mode it is inherently supported.
+	 */
+	if (pipe_config->sdp_split_enable &&
+	    !intel_crtc_has_type(pipe_config, INTEL_OUTPUT_DP_MST))
+		pipe_config->sdp_split_enable = intel_dp->sst_split_sdp_support;
 }
 
 void
@@ -4566,16 +4576,25 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
 			    str_enable_disable(tmp));
 }
 
-static bool intel_dp_get_colorimetry_status(struct intel_dp *intel_dp)
+static u8 intel_dp_read_dprx_feature_enum(struct intel_dp *intel_dp)
 {
 	u8 dprx = 0;
 
-	if (drm_dp_dpcd_readb(&intel_dp->aux, DP_DPRX_FEATURE_ENUMERATION_LIST,
-			      &dprx) != 1)
-		return false;
+	drm_dp_dpcd_read_data(&intel_dp->aux, DP_DPRX_FEATURE_ENUMERATION_LIST,
+			      &dprx, sizeof(dprx));
+	return dprx;
+}
+
+static bool intel_dp_get_colorimetry_status(u8 dprx)
+{
 	return dprx & DP_VSC_SDP_EXT_FOR_COLORIMETRY_SUPPORTED;
 }
 
+static bool intel_dp_get_sst_split_sdp_status(u8 dprx)
+{
+	return dprx & DP_SST_SPLIT_SDP_CAP;
+}
+
 static int intel_dp_read_dsc_dpcd(struct drm_dp_aux *aux,
 				  u8 dsc_dpcd[DP_DSC_RECEIVER_CAP_SIZE])
 {
@@ -4875,6 +4894,7 @@ intel_edp_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector
 {
 	struct intel_display *display = to_intel_display(intel_dp);
 	int ret;
+	u8 dprx;
 
 	/* this function is meant to be called only once */
 	drm_WARN_ON(display->drm, intel_dp->dpcd[DP_DPCD_REV] != 0);
@@ -4886,8 +4906,13 @@ intel_edp_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector
 			 drm_dp_is_branch(intel_dp->dpcd));
 	intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
+	dprx = intel_dp_read_dprx_feature_enum(intel_dp);
+
 	intel_dp->colorimetry_support =
-		intel_dp_get_colorimetry_status(intel_dp);
+		intel_dp_get_colorimetry_status(dprx);
+
+	intel_dp->sst_split_sdp_support =
+		intel_dp_get_sst_split_sdp_status(dprx);
 
 	/*
 	 * Read the eDP display control registers.
@@ -4978,13 +5003,20 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 	 * the OUI/ID since we know it won't change.
 	 */
 	if (!intel_dp_is_edp(intel_dp)) {
+		u8 dprx;
+
 		drm_dp_read_desc(&intel_dp->aux, &intel_dp->desc,
 				 drm_dp_is_branch(intel_dp->dpcd));
 
 		intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
+		dprx = intel_dp_read_dprx_feature_enum(intel_dp);
+
 		intel_dp->colorimetry_support =
-			intel_dp_get_colorimetry_status(intel_dp);
+			intel_dp_get_colorimetry_status(dprx);
+
+		intel_dp->sst_split_sdp_support =
+			intel_dp_get_sst_split_sdp_status(dprx);
 
 		intel_dp_update_sink_caps(intel_dp);
 	}
-- 
2.53.0



