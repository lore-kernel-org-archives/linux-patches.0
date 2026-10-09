Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682133D34A2;
	Fri,  9 Oct 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556466; cv=none; b=DE78jx1858I5ajQO/6LY41HJKuMaHwOB4UghM/oWMvlLZPMzThdsHhcxln8mmwFyXLMNIWscF8bTVE1TAA3OfP33vnLQ+QNcP312r+4d6A9THA5W+4rRwSx8YPdeGbZhzRtMawq23fYm9mXiWDp4zCb2z8wkTtaRBfmhs+LxBUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556466; c=relaxed/simple;
	bh=ZpOxz6t7sfVztKplPQ8hr5Io3iHVTv7FyiTp3itTNTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt86yA68W56K3E0/BVwUskymIXVvJxUmEtkb9c1uVCFIk/K9U4m0WNAz2pgn+x2Rop6g25dvWNaFApTrSaY32LXc05BpkyJA1D3K9y2aIDdzuyuJ4WogLOuRZIfwfAXFxfmtIURdyDgRMzU1BIQh8eBdI6KQh8ckM5MhjYFSAlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PomNnIZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PomNnIZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73351F000FF;
	Fri,  9 Oct 2026 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556465;
	bh=JePRzUtn5YDYhYvm0BJetpGrShEGrYzGs6Ui4EXrGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PomNnIZzVupx1baT1g7V+ObbMEnTp8c/v5MnU0IYO7XDlIu22/hJQTymRRxLBw4yV
	 oyiPoxDxgltkYUlt1OwPqfa3AhTkYTLRdKjSwDafbBRZVMvROEIfLIRhr6fK91Pzv3
	 F/s54S/nSlFv//JFnypNwIQx/pndja89Nh8xPE3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 7.2 180/428] drm/i915/vrr: Disable DC balance by default
Date: Fri,  9 Oct 2026 16:08:37 +0200
Message-ID: <20261009140950.100933892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

commit c034e8a46e4cb703018fe7e10fe5a3a974d6a7c3 upstream.

Disable VRR DC balance by default due to timing issues observed on some
panel/TCON combinations.

Keep the module parameter to enable DC balance during debugging and to
isolate DC balance effects from underlying VRR/display timing issues.

--v2:
- Make enable_dc_balance a bool and keep it disabled by default; fix the
  parameter type/value mismatch and correct the description (Chaitanya
  Kumar Borah, Jani Nikula)
- Explain in the commit message why the feature is gated and why a
  module parameter is used (Jani Nikula)

--v3:
- Commit message update (Jani Nikula)

Fixes: 555819270707 ("drm/i915/vrr: Enable DC Balance")
Cc: <stable@vger.kernel.org> # v7.0+
Signed-off-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260917074322.2606738-1-mitulkumar.ajitkumar.golani@intel.com
(cherry picked from commit d1ef78f0581e856c4238c751e9ae2884ce58c275)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_params.c |    4 ++++
 drivers/gpu/drm/i915/display/intel_display_params.h |    1 +
 drivers/gpu/drm/i915/display/intel_vrr.c            |    4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display_params.c
+++ b/drivers/gpu/drm/i915/display/intel_display_params.c
@@ -120,6 +120,10 @@ intel_display_param_named_unsafe(enable_
 	"(0=disabled, 1=enable up to PSR1, 2=enable up to PSR2) "
 	"Default: -1 (use per-chip default)");
 
+intel_display_param_named_unsafe(enable_dc_balance, bool, 0400,
+	"Enable VRR DC balance (0=disabled, 1=enabled). "
+	"Default: 0 (disabled)");
+
 intel_display_param_named_unsafe(enable_panel_replay, int, 0400,
 	"Enable Panel Replay (0=disabled, 1=enabled). Default: -1 (use per-chip default)");
 
--- a/drivers/gpu/drm/i915/display/intel_display_params.h
+++ b/drivers/gpu/drm/i915/display/intel_display_params.h
@@ -46,6 +46,7 @@ struct drm_printer;
 	param(bool, enable_dp_mst, true, 0600) \
 	param(int, enable_fbc, -1, 0600) \
 	param(int, enable_psr, -1, 0600) \
+	param(bool, enable_dc_balance, false, 0600) \
 	param(int, enable_panel_replay, -1, 0600) \
 	param(bool, psr_safest_params, false, 0400) \
 	param(bool, enable_psr2_sel_fetch, true, 0400) \
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -383,10 +383,12 @@ static bool intel_vrr_dc_balance_possibl
 static void
 intel_vrr_dc_balance_compute_config(struct intel_crtc_state *crtc_state)
 {
+	struct intel_display *display = to_intel_display(crtc_state);
 	int guardband_usec, adjustment_usec;
 	struct drm_display_mode *adjusted_mode = &crtc_state->hw.adjusted_mode;
 
-	if (!intel_vrr_dc_balance_possible(crtc_state) || !crtc_state->vrr.enable)
+	if (!intel_vrr_dc_balance_possible(crtc_state) ||
+	    !crtc_state->vrr.enable || !display->params.enable_dc_balance)
 		return;
 
 	crtc_state->vrr.dc_balance.vmax = crtc_state->vrr.vmax;


