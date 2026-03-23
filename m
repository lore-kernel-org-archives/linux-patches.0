Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB463AF65F;
	Mon, 23 Mar 2026 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277109; cv=none; b=bFVWV/eqwG8IgGKc1x16FU5xQL90+5TSkhK42Oq5UNcYdaT37QA6XraCmvpPAYCVgdxqAkLxhhKtXTkbeov/YlZN/gnTkV5QIYmo3z7oHRTJLIM8ltpidfOShu85gx+FUY5zSdpB+R+Im9I15w9erEmuV+yXDkTR8CY+fdnKvpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277109; c=relaxed/simple;
	bh=TXOH0dNYuwk/B/QA2TGD66RV66vsnNq1C9pNZEu/zLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2Ev9iVP5qMETSsAxunjpojwRc56UxwByqlTzQW0zm4+gFQK7kP0YZSU3SOJ+Tu45JhpaXPyuqPkU5fe8E51AuoZFt/ccs1j7mmb27LroMtEb8uMyqZRMJuDAYxEorfZ2XnM+vfKVigNKuzhFObkabbSNj2toPa3LlhchZUv3gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K93kwhyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K93kwhyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E890CC4CEF7;
	Mon, 23 Mar 2026 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277109;
	bh=TXOH0dNYuwk/B/QA2TGD66RV66vsnNq1C9pNZEu/zLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K93kwhyBWp1uHJry8PHBt7gohbPse0C/vAbZ55DngxiNsorMFz3j/XapG0AKzUrFv
	 o7PO9IoyQCcAowp0+NUQoUOQMMC5swIh6agkV82Ia5nzU4GFu4jOvf0I9SjJdtrqv0
	 njCMInw3QEEPLekie6p7Fg71kMd0YvsgSLqQI/bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.12 323/460] drm/i915/dsc: Add helper for writing DSC Selective Update ET parameters
Date: Mon, 23 Mar 2026 14:45:19 +0100
Message-ID: <20260323134534.443113763@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit bb5f1cd10101c2567bff4d0e760b74aee7c42f44 upstream.

There are slice row per frame and pic height configuration in DSC Selective
Update Parameter Set 1 register. Add helper for configuring these.

v2:
  - Add WARN_ON_ONCE if vdsc instances per pipe > 2
  - instead of checking vdsc instances per pipe being > 1 check == 2

Bspec: 71709
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260304113011.626542-4-jouni.hogander@intel.com
(cherry picked from commit c8698d61aeb3f70fe33761ee9d3d0e131b5bc2eb)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
[tursulin: fixup forward declaration conflict]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vdsc.c |   23 +++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_vdsc.h |    3 +++
 2 files changed, 26 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
@@ -723,6 +723,29 @@ void intel_dsc_dp_pps_write(struct intel
 				  sizeof(dp_dsc_pps_sdp));
 }
 
+void intel_dsc_su_et_parameters_configure(struct intel_dsb *dsb, struct intel_encoder *encoder,
+					  const struct intel_crtc_state *crtc_state, int su_lines)
+{
+	struct intel_display *display = to_intel_display(crtc_state);
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	const struct drm_dsc_config *vdsc_cfg = &crtc_state->dsc.config;
+	enum pipe pipe = crtc->pipe;
+	int vdsc_instances_per_pipe = intel_dsc_get_vdsc_per_pipe(crtc_state);
+	int slice_row_per_frame = su_lines / vdsc_cfg->slice_height;
+	u32 val;
+
+	drm_WARN_ON_ONCE(display->drm, su_lines % vdsc_cfg->slice_height);
+	drm_WARN_ON_ONCE(display->drm, vdsc_instances_per_pipe > 2);
+
+	val = DSC_SUPS0_SU_SLICE_ROW_PER_FRAME(slice_row_per_frame);
+	val |= DSC_SUPS0_SU_PIC_HEIGHT(su_lines);
+
+	intel_de_write_dsb(display, dsb, LNL_DSC0_SU_PARAMETER_SET_0(pipe), val);
+
+	if (vdsc_instances_per_pipe == 2)
+		intel_de_write_dsb(display, dsb, LNL_DSC1_SU_PARAMETER_SET_0(pipe), val);
+}
+
 static i915_reg_t dss_ctl1_reg(struct intel_crtc *crtc, enum transcoder cpu_transcoder)
 {
 	return is_pipe_dsc(crtc, cpu_transcoder) ?
--- a/drivers/gpu/drm/i915/display/intel_vdsc.h
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.h
@@ -13,6 +13,7 @@ struct drm_printer;
 enum transcoder;
 struct intel_crtc;
 struct intel_crtc_state;
+struct intel_dsb;
 struct intel_encoder;
 
 bool intel_dsc_source_support(const struct intel_crtc_state *crtc_state);
@@ -29,6 +30,8 @@ void intel_dsc_dsi_pps_write(struct inte
 			     const struct intel_crtc_state *crtc_state);
 void intel_dsc_dp_pps_write(struct intel_encoder *encoder,
 			    const struct intel_crtc_state *crtc_state);
+void intel_dsc_su_et_parameters_configure(struct intel_dsb *dsb, struct intel_encoder *encoder,
+					  const struct intel_crtc_state *crtc_state, int su_lines);
 void intel_vdsc_state_dump(struct drm_printer *p, int indent,
 			   const struct intel_crtc_state *crtc_state);
 


