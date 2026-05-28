Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B427C3164B7;
	Thu, 28 May 2026 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998971; cv=none; b=cKIvMYxR/FcPVU1WP0kEZ+NJWMkKIdlFTBxdFcLPerTx3FIV5qplgkKRP/+p5szs8+WozxjmUSvA/B1mxCqdlv1Gfnvh4C/Tj0f87QO/XnpRNMRB3LL1EnFaNVYKSsIekdGgZZgqv6743hVgi2adh7x80F8uvzCGz/jbKsXXfZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998971; c=relaxed/simple;
	bh=gNEH8lP9jnj9cVULMpXpoxf1MUAY70Q5ZuFLaE+zUVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YusYybSbUf9zM8PRgm03mJSJ1LKO0xgTg+2jFPxdKqyCGL8HVIgpxuK4aY6rtdZZ6KLCeLm7dAVU6ClAF1ysLFq85rOB1gYo8pfmPn+rQorLYV6p6T/3S9obM4mTugy0Duon944Kv8StVggw+w9hMVULSJ6Yoji7uxafDPeWp5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p51lI88N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p51lI88N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01BC1F000E9;
	Thu, 28 May 2026 20:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998970;
	bh=neOxN2tUnYaKj51SKDSIs1Z0KiUF/22LO3tqOlWKmI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p51lI88NjZdjby5qCJxK9NpxmNQm38BI6i0cb78S/JuMJRUx9VpSvRBb6ZQyW8ZvT
	 A6b3BOTlDcoO9mmiBGAxRJU/Y2YPAkKtHWapYjVQvaR8o3mHFpfYLwb0y/iofa1yvE
	 RK5+HFN56kipgGBepAJ8qG1xs9N8s6dUvk0foNac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 363/461] drm/xe: Consolidate workaround entries for Wa_18033852989
Date: Thu, 28 May 2026 21:48:12 +0200
Message-ID: <20260528194657.943189738@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

[ Upstream commit fe681e7b44d78fd77d79de21eca58c3b6bdcda0e ]

Wa_18033852989 applies to all graphics versions from 20.01 through 20.04
(inclusive).  Consolidate the RTP entries into a single range-based entry.

Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260220-forupstream-wa_cleanup-v2-19-b12005a05af6@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: a4660bd94973 ("drm/xe: Define and use MCR version of COMMON_SLICE_CHICKEN1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index c436d0ad51e77..6e3c44bc69daf 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -720,6 +720,10 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(XEHP_PSS_CHICKEN, FLSH_IGNORES_PSD))
 	},
+	{ XE_RTP_NAME("18033852989"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2004), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN1, DISABLE_BOTTOM_CLIP_RECTANGLE_TEST))
+	},
 
 	/* DG1 */
 
@@ -776,10 +780,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 
 	/* Xe2_LPG */
 
-	{ XE_RTP_NAME("18033852989"),
-	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN1, DISABLE_BOTTOM_CLIP_RECTANGLE_TEST))
-	},
 	{ XE_RTP_NAME("14021567978"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, XE_RTP_END_VERSION_UNDEFINED),
 		       ENGINE_CLASS(RENDER)),
@@ -827,10 +827,6 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE))
 	},
-	{ XE_RTP_NAME("18033852989"),
-	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN1, DISABLE_BOTTOM_CLIP_RECTANGLE_TEST))
-	},
 
 	/* Xe3_LPG */
 	{ XE_RTP_NAME("14021490052"),
-- 
2.53.0



