Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A394461FFE;
	Wed, 20 May 2026 16:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294967; cv=none; b=r7KEsvOuN0yUV2k4aZMS62Wl1VNVC4wj/4AnphO0ESM+ZtJhDcfFxdruVL9V/H5AJYwSYwobD7UctRh0z4x2TQhrBFrVtu6jv0UzC/JzrpA4bTKuiYeo05PVOSN21xwM638KT02eQ6H2r4ueP2OcD5X1IVtjvqiLgasU+pbkIAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294967; c=relaxed/simple;
	bh=84spfCtHkpRNucLRJ3i5IvPbN1i6doc98bcp3n8/hGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8Kp+gLK6R8L1Od+Qbvg8qjNh4dXbsdEwT3VkPWdH+KtimQCDSeaV6WeTRsyX8zFV4JUI6Sbu/4l7Ct9QRRSFEF8A++Tbah+cLa5wvgBfbwsrm34gOeIvLGQO9VGCvVtUpdWK/VEDVvPkKwtNjn6XuK1tcLTcxIxUpuXuExYfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCuctUV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCuctUV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C161F000E9;
	Wed, 20 May 2026 16:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294966;
	bh=I7Cfy/zp9hcIdIm3913xa8hkSfprHl8Q0x/O5uuEG0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCuctUV4DsLtO+2Rcd2O2/a87direWJsT4BoesDi9BGA2Eey7A1DPZK2LhU9t3w3l
	 vN58NDqja5lhdzXzHkBitwUjCkzMRm+SPkQP3KBmpseVXh2tlAI380L1AZ1b0Z399L
	 9i+ViOEJwMHEVsDBI9tx1rsRDQgGyZr4O92OT84Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0239/1146] drm/xe: Consolidate workaround entries for Wa_14019386621
Date: Wed, 20 May 2026 18:08:09 +0200
Message-ID: <20260520162153.652420462@linuxfoundation.org>
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

[ Upstream commit f0d6d356f8ac427d1f3eb8fb783a64ac3efd6fc7 ]

Wa_14019386621 applies to all graphics versions from 20.01 through 20.04
(inclusive).  Consolidate the RTP entries into a single range-based entry.

Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260220-forupstream-wa_cleanup-v2-17-b12005a05af6@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 1046bc7b4168 ("drm/xe/xe2_hpg: Drop invalid workaround Wa_15010599737")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 6f92c0d0d8943..2ee08c068adbc 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -712,6 +712,10 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1255, 2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FD_END_COLLECT))
 	},
+	{ XE_RTP_NAME("14019386621"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2004), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(VF_SCRATCHPAD, XE2_VFG_TED_CREDIT_INTERFACE_DISABLE))
+	},
 
 	/* DG1 */
 
@@ -768,10 +772,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 
 	/* Xe2_LPG */
 
-	{ XE_RTP_NAME("14019386621"),
-	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(VF_SCRATCHPAD, XE2_VFG_TED_CREDIT_INTERFACE_DISABLE))
-	},
 	{ XE_RTP_NAME("14019988906"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FLSH_IGNORES_PSD))
@@ -809,10 +809,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(CHICKEN_RASTER_1, DIS_SF_ROUND_NEAREST_EVEN))
 	},
-	{ XE_RTP_NAME("14019386621"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(VF_SCRATCHPAD, XE2_VFG_TED_CREDIT_INTERFACE_DISABLE))
-	},
 	{ XE_RTP_NAME("14020756599"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(WM_CHICKEN3, HIZ_PLANE_COMPRESSION_DIS))
-- 
2.53.0



