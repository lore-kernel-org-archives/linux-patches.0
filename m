Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ACC33AD9D;
	Wed, 20 May 2026 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294964; cv=none; b=cQCt8NIlEbU1d8eVoMwLLo8/Xp3FFg4WEA0sWiuZzFwt985A9Fg9v/9Swc45kGwoQNsmym/9f9eh5KIjad4QLAY4kZ1kCffCnLfbCIRuKpqSZYPutzKdqpwqRv8xVKU35Wb9mro69Qi1GhICyai30hgSTvOOev08gYWKjU8PviE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294964; c=relaxed/simple;
	bh=6X2ABM5Q+qSPOD+Q0/MqRm8lkScj7k5cOA9uLh+gs+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMdTrZ9cmbfglezxBZOq+hsc0EsyFtMiSVaUmTsqY5xi6T69tt6nqN4sgcnN8crzCVPnpH7cnfZhWPbuwp7JFeBweCOHu9d4Jh6Y1y21BJXN+gPpRSeVSr+ZOlHusDOQDM3tjcPRugquctgWA005AjGvNqDPbVHBE+k+mwApGRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GczXxHko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GczXxHko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7DC1F000E9;
	Wed, 20 May 2026 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294961;
	bh=uiZR4/BedAhcSLDmmxoP7HXNqttNf5chEHMMmQkMF+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GczXxHkocRi7FoCO00s9vgKM6mepKw8TQvjpj9sCNd1+LTYkRAsGyRNR3EaWX2nSE
	 Zlb6ygz7XzHJVk4dzrDdbLRxsrEAtx7KH4o4HrT11lbl4ATjRJdHv9AqlgD7ZYQdBK
	 +AksueROOy/vmhaixBzyB2UGNMbZr3HuOv+si/24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0238/1146] drm/xe: Consolidate workaround entries for Wa_14019877138
Date: Wed, 20 May 2026 18:08:08 +0200
Message-ID: <20260520162153.630754853@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 55b19abb6c44db40fe1ebd01e9c16aa02c4cf663 ]

Wa_14019877138 applies to all graphics versions from 12.55 through 20.04
(inclusive) that have a render engine.  Consolidate the RTP entries into
a single range-based entry.

Note that the DG2 entry for this workaround was missing an
ENGINE_CLASS(RENDER) rule; that mistake is fixed by this consolidation.

Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260220-forupstream-wa_cleanup-v2-16-b12005a05af6@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 1046bc7b4168 ("drm/xe/xe2_hpg: Drop invalid workaround Wa_15010599737")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index d7e309ad9abaf..6f92c0d0d8943 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -708,6 +708,10 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(1200)),
 	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, DISABLE_TDC_LOAD_BALANCING_CALC))
 	},
+	{ XE_RTP_NAME("14019877138"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1255, 2004), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
+	},
 
 	/* DG1 */
 
@@ -744,10 +748,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(PLATFORM(DG2)),
 	  XE_RTP_ACTIONS(SET(CACHE_MODE_1, MSAA_OPTIMIZATION_REDUC_DISABLE))
 	},
-	{ XE_RTP_NAME("14019877138"),
-	  XE_RTP_RULES(PLATFORM(DG2)),
-	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
-	},
 
 	/* PVC */
 
@@ -765,10 +765,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1270, 1274)),
 	  XE_RTP_ACTIONS(SET(CACHE_MODE_1, MSAA_OPTIMIZATION_REDUC_DISABLE))
 	},
-	{ XE_RTP_NAME("14019877138"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1270, 1274), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
-	},
 
 	/* Xe2_LPG */
 
@@ -776,10 +772,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(VF_SCRATCHPAD, XE2_VFG_TED_CREDIT_INTERFACE_DISABLE))
 	},
-	{ XE_RTP_NAME("14019877138"),
-	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
-	},
 	{ XE_RTP_NAME("14019988906"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FLSH_IGNORES_PSD))
@@ -829,10 +821,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FLSH_IGNORES_PSD))
 	},
-	{ XE_RTP_NAME("14019877138"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
-	},
 	{ XE_RTP_NAME("14021490052"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(FF_MODE,
-- 
2.53.0



