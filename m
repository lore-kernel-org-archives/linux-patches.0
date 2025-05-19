Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5480C22D7B7;
	Mon, 19 May 2025 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689751; cv=none; b=CNvDAigU+DXJ7ycgn+0rZGXtc2tRnbqb8Z8jbhT2I9Jok7DX6Cc3ffNyW3peHMtCu5Rjj60G+AT7QyLfGZgDtI8NUUjsZ9wnofiIcid4lUZmRqbi0AUrhXrxZoFw8i21F7ZmXMTUrJgnVoar6XltN/ONshX1QnoiTYIAq7nYFDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689751; c=relaxed/simple;
	bh=Zf2gwxCYTg+DtU01ZLV6g7dD1mikSVVY6rNah8Q+YuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QvO8GsJHroXr5sNXekoN1/wlllCSwfDlQ2SvYtwqvTn3tnWMYCs09I7aHrbXKs+XdWh36XNW5GAQLyZn8/kaebXZPdHTqJCp5cYkIZ53MUQ0ji70mfOayvFw8bOMbLURVE0G15VTvS4l90jxIaejJ+wI5hHHk5VxSIJYL6wrnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKXqQpQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKXqQpQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E70C4CEED;
	Mon, 19 May 2025 21:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689751;
	bh=Zf2gwxCYTg+DtU01ZLV6g7dD1mikSVVY6rNah8Q+YuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKXqQpQk7zLm6evvKRh5KbByfN1kmEc39+FVR/Rbdy3BHEg5f01Re8OiAROtdabyO
	 kSfJPBdvUDXXPKkCoF3+PGXp3wV2VwCDVsotYJXGUW8EWB1+5qhvwrbm3Gxx2NA5MB
	 6Ic5YfxtwZhPesWr1q5fugTFFQqdzII7+aMyUpBLaqfNQjz84MFyfvsdlkzAdO8spO
	 nvq9WyKNpVh4GaeZRBMDJb3rzCS5xotmEHN1QUb0N2Kyq8LfaQcPYYJpeE/XXrzdLg
	 3fAqBpMk8tbsOJsi2hUyb2UPxAhcbHH8EsgDFjmAgAhfj4b2/1jCImxyeHOS2l8fOl
	 TcrtqDNj+f4gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aradhya Bhatia <aradhya.bhatia@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@linux.ie,
	daniel@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 14/18] drm/xe/xe2hpg: Add Wa_22021007897
Date: Mon, 19 May 2025 17:22:03 -0400
Message-Id: <20250519212208.1986028-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212208.1986028-1-sashal@kernel.org>
References: <20250519212208.1986028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.29
Content-Transfer-Encoding: 8bit

From: Aradhya Bhatia <aradhya.bhatia@intel.com>

[ Upstream commit b1f704107cf27906a9cea542b626b96019104663 ]

Add Wa_22021007897 for the Xe2_HPG (graphics version: 20.01) IP. It is
a permanent workaround, and applicable on all the steppings.

Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@intel.com>
Link: https://lore.kernel.org/r/20250512065004.2576-1-aradhya.bhatia@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit e5c13e2c505b73a8667ef9a0fd5cbd4227e483e6)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_wa.c           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 5404de2aea545..c160b015d178a 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -157,6 +157,7 @@
 #define XEHPG_SC_INSTDONE_EXTRA2		XE_REG_MCR(0x7108)
 
 #define COMMON_SLICE_CHICKEN4			XE_REG(0x7300, XE_REG_OPTION_MASKED)
+#define   SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE	REG_BIT(12)
 #define   DISABLE_TDC_LOAD_BALANCING_CALC	REG_BIT(6)
 
 #define COMMON_SLICE_CHICKEN3				XE_REG(0x7304, XE_REG_OPTION_MASKED)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 0a1905f8d380a..aea6034a81079 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -783,6 +783,10 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(CHICKEN_RASTER_1, DIS_CLIP_NEGATIVE_BOUNDING_BOX))
 	},
+	{ XE_RTP_NAME("22021007897"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE))
+	},
 
 	/* Xe3_LPG */
 	{ XE_RTP_NAME("14021490052"),
-- 
2.39.5

