Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866303446AA;
	Tue, 11 Nov 2025 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823191; cv=none; b=qQ8G+Hu2ckVVAhg6GoFnITgfWwiRYLjG3lgpvt7pe9KouzN71S8fV0yXMlx/DsvMTsM13vWoPbVXbVEtDXcyWpyCfJHbl2zPyb3ITCgF4rbAMKDN4WyS7uvC2hBuAffS3XnYRN+Qe74iQEQZ3h5WVIu3gyeNDuZc1q6rK+iRSc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823191; c=relaxed/simple;
	bh=2ZKA2ao+jFzctaqshd2We2yntOTF6vQwxZ7I9sjBA3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4QhMytCuFu05TvbsM7V2Xtv4dyEUyAGWkvMm1cBXS05ZA3Jh1n6WYBf7Zv17SGeKiFRQGsBNP5CVZRuQ72FarDigqCQAt/axcSH0FePhPxVqgVGFedY1AYlRghwA02AY5qGp/h+wTtsdcl73Wd/DgW5nuZd3byOpXrmN01zjdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOe4tWJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOe4tWJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8E7C16AAE;
	Tue, 11 Nov 2025 01:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823191;
	bh=2ZKA2ao+jFzctaqshd2We2yntOTF6vQwxZ7I9sjBA3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOe4tWJOAU9Q6tJmsa+Q+b+aw/D2vJoNq9mx6+ysX8anN+sfefT4TM4QUykaoVh+F
	 DR+OIXSJTqXhYP4NrefzuEaiSFHShN9WyYi99GDVFRoJ1vTN7MYma2UIRUsbF7CIsK
	 vfe4u2PstUgblEC6skk37Sup4pQHqLaxyPUbBDJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 250/849] drm/xe: Extend wa_13012615864 to additional Xe2 and Xe3 platforms
Date: Tue, 11 Nov 2025 09:37:00 +0900
Message-ID: <20251111004542.477081012@linuxfoundation.org>
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

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

[ Upstream commit bcddb12c027434fdf0491c1a05a3fe4fd2263d71 ]

Extend WA 13012615864 to Graphics Versions 20.01,20.02,20.04
and 30.03.

Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://lore.kernel.org/r/20250731220143.72942-2-jonathan.cavitt@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 22a98600fd8f2..535067e7fb0c9 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -538,6 +538,11 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(HALF_SLICE_CHICKEN7, CLEAR_OPTIMIZATION_DISABLE))
 	},
+	{ XE_RTP_NAME("13012615864"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2004),
+		       FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
+	},
 
 	/* Xe2_HPG */
 
@@ -602,6 +607,11 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, STK_ID_RESTRICT))
 	},
+	{ XE_RTP_NAME("13012615864"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002),
+		       FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
+	},
 
 	/* Xe2_LPM */
 
@@ -647,7 +657,8 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_ACTIONS(SET(TDL_CHICKEN, QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE))
 	},
 	{ XE_RTP_NAME("13012615864"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001), OR,
+		       GRAPHICS_VERSION(3003),
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
 	},
-- 
2.51.0



