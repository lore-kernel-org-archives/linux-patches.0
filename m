Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE253ACA5C;
	Mon, 23 Mar 2026 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274537; cv=none; b=sR3Qxm34F+epplZr5ykRu47cC7QBIW7G6qiqH3XyUPfQgpibBcCCH6E2mJcLmFZwZYCqBLVbpoPaJYxU4QFk4LZyajCQhBLOkkpoCGsKDdSMVU/J5ap3uUZCeDKpl/Lh94cp5jUtoMofsuGjIOOd+ZLZzc6eLJpIf5gsHF3DL94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274537; c=relaxed/simple;
	bh=IbFYWcaQUDEMPZUEIgnMA5Xam496KQWLDHSqxyg4Cps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHD2qFDstP4IGDxvmglPSGvsROjpkueLSRxZYxU3iRKTGNNcLKs7TWezMDnfjS7+cN+umonkSRYBqXpMX6uQmuFshD/66RYjQUoPcAGKiX4h1ZhHKUKBg19kiOkfgb2GlHT8jKMxS7nm9MoMeCavsCaJKGMYB5LXqEhGEjUrqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRm/zdoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRm/zdoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F06C4CEF7;
	Mon, 23 Mar 2026 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274536;
	bh=IbFYWcaQUDEMPZUEIgnMA5Xam496KQWLDHSqxyg4Cps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRm/zdoYP7DmFjC9EaS7NKx6VbdRDqqWt8xBJ3DKsC8Yc7JtTupIl/kjy8L4LQU2I
	 ZUqn6Vo0FURCz+adkunLbh4irwgvBqjfeA2crH9gv+tZNaU+c/JaPfB25I5v5u1T5c
	 LmeutwklFAxbmEMMBWS0za8XH2Jlp9iKYHkRcT6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.18 028/212] drm/i915/psr: Write DSC parameters on Selective Update in ET mode
Date: Mon, 23 Mar 2026 14:44:09 +0100
Message-ID: <20260323134504.649329035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 5923a6e0459fdd3edac4ad5abccb24d777d8f1b6 upstream.

There are slice row per frame and pic height parameters in DSC that needs
to be configured on every Selective Update in Early Transport mode. Use
helper provided by DSC code to configure these on Selective Update when in
Early Transport mode. Also fill crtc_state->psr2_su_area with full frame
area on full frame update for DSC calculation.

v2: move psr2_su_area under skip_sel_fetch_set_loop label

Bspec: 68927, 71709
Fixes: 467e4e061c44 ("drm/i915/psr: Enable psr2 early transport as possible")
Cc: <stable@vger.kernel.org> # v6.9+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260304113011.626542-5-jouni.hogander@intel.com
(cherry picked from commit 3140af2fab505a4cd47d516284529bf1585628be)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -50,6 +50,7 @@
 #include "intel_snps_phy.h"
 #include "intel_step.h"
 #include "intel_vblank.h"
+#include "intel_vdsc.h"
 #include "intel_vrr.h"
 #include "skl_universal_plane.h"
 
@@ -2489,6 +2490,12 @@ void intel_psr2_program_trans_man_trk_ct
 
 	intel_de_write_dsb(display, dsb, PIPE_SRCSZ_ERLY_TPT(crtc->pipe),
 			   crtc_state->pipe_srcsz_early_tpt);
+
+	if (!crtc_state->dsc.compression_enable)
+		return;
+
+	intel_dsc_su_et_parameters_configure(dsb, encoder, crtc_state,
+					     drm_rect_height(&crtc_state->psr2_su_area));
 }
 
 static void psr2_man_trk_ctl_calc(struct intel_crtc_state *crtc_state,
@@ -2909,6 +2916,10 @@ int intel_psr2_sel_fetch_update(struct i
 	}
 
 skip_sel_fetch_set_loop:
+	if (full_update)
+		clip_area_update(&crtc_state->psr2_su_area, &crtc_state->pipe_src,
+				 &crtc_state->pipe_src);
+
 	psr2_man_trk_ctl_calc(crtc_state, full_update);
 	crtc_state->pipe_srcsz_early_tpt =
 		psr2_pipe_srcsz_early_tpt_calc(crtc_state, full_update);


