Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426743AC0D2;
	Mon, 23 Mar 2026 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274029; cv=none; b=iwj3RU7TW0WRK8hOKk4n0KNMHtmRoA42pAUjd3sslc6/kiMWPMwLC8tw43KjJUKNyAEtqLl9C9EbZgbknDN0a24tJ03nzpFmcBo5OoDPawZ3qkpf+AnEBW5lMiS/g+DZoqprQ043e8O22P+7dBtMHQjiv5+AfQPE0WdBDZ8Yik0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274029; c=relaxed/simple;
	bh=gpJx6Xj4MV94iZjSW6H6nlzSsMuBW5vMZZhTgpkBqTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9f+MnMNwtd9F7bVJwuiuupl8P1eKPFbvKo+h5/H9tOGqXlTo7Fi8/mjzuhmXwTZEElefmIbPfPJmSiW+lpn6afCM3z04G6jM4kXy3erldla9Rjr/KnJDSwPLjKp/0NT3yAzVxLyD7M3B4+6/gWda/+58zTBuHIDLOFrIbIK70U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmpdyir6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmpdyir6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B741AC2BC9E;
	Mon, 23 Mar 2026 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274029;
	bh=gpJx6Xj4MV94iZjSW6H6nlzSsMuBW5vMZZhTgpkBqTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmpdyir6epKjNzgOjE/jn5Ma0u7OhVcnLH5mSL/E3jk3682X8KyWgcY3lwBAPJwdq
	 Q6eu7FcbtRz3S8ps6ZtP91OogahB5UMQdcmhDtgEXVZHwzv9ENWFDxJGnrOiIbYJRq
	 x8lgJoShQZEOXy2ThUspNc2k+4RkdT2+ALQDwHPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.19 087/220] drm/i915/psr: Compute PSR entry_setup_frames into intel_crtc_state
Date: Mon, 23 Mar 2026 14:44:24 +0100
Message-ID: <20260323134507.344271539@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 7caac659a837af9fd4cad85be851982b88859484 upstream.

PSR entry_setup_frames is currently computed directly into struct
intel_dp:intel_psr:entry_setup_frames. This causes a problem if mode change
gets rejected after PSR compute config: Psr_entry_setup_frames computed for
this rejected state is in intel_dp:intel_psr:entry_setup_frame. Fix this by
computing it into intel_crtc_state and copy the value into
intel_dp:intel_psr:entry_setup_frames on PSR enable.

Fixes: 2b981d57e480 ("drm/i915/display: Support PSR entry VSC packet to be transmitted one frame earlier")
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260312083710.1593781-3-jouni.hogander@intel.com
(cherry picked from commit 8c229b4aa00262c13787982e998c61c0783285e0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h |    1 +
 drivers/gpu/drm/i915/display/intel_psr.c           |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1160,6 +1160,7 @@ struct intel_crtc_state {
 	u32 dc3co_exitline;
 	u16 su_y_granularity;
 	u8 active_non_psr_pipes;
+	u8 entry_setup_frames;
 	const char *no_psr_reason;
 
 	/*
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1711,7 +1711,7 @@ static bool _psr_compute_config(struct i
 	entry_setup_frames = intel_psr_entry_setup_frames(intel_dp, adjusted_mode);
 
 	if (entry_setup_frames >= 0) {
-		intel_dp->psr.entry_setup_frames = entry_setup_frames;
+		crtc_state->entry_setup_frames = entry_setup_frames;
 	} else {
 		crtc_state->no_psr_reason = "PSR setup timing not met";
 		drm_dbg_kms(display->drm,
@@ -1792,7 +1792,7 @@ static bool intel_psr_needs_wa_180378188
 {
 	struct intel_display *display = to_intel_display(intel_dp);
 
-	return (DISPLAY_VER(display) == 20 && intel_dp->psr.entry_setup_frames > 0 &&
+	return (DISPLAY_VER(display) == 20 && crtc_state->entry_setup_frames > 0 &&
 		!crtc_state->has_sel_update);
 }
 
@@ -2167,6 +2167,7 @@ static void intel_psr_enable_locked(stru
 	intel_dp->psr.pkg_c_latency_used = crtc_state->pkg_c_latency_used;
 	intel_dp->psr.io_wake_lines = crtc_state->alpm_state.io_wake_lines;
 	intel_dp->psr.fast_wake_lines = crtc_state->alpm_state.fast_wake_lines;
+	intel_dp->psr.entry_setup_frames = crtc_state->entry_setup_frames;
 
 	if (!psr_interrupt_error_check(intel_dp))
 		return;


