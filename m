Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153621B9C7;
	Mon,  2 Jun 2025 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872826; cv=none; b=VO4pjdrkZTTx5h8+wiKtJzEq2Xr8SxgmuxWfaN1iIg/O8DvFhqPgw3d6fnn6x7KxNcBA4DuA70zJZB/MO+H1bC8QC8a4gsCx0EVyLvmCb1LvZLSS2owLUlE4K6rWUdMk2yKvUVY6TWq2lMs0ct31XfzxNUiS2MLu1MqnTdr0tDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872826; c=relaxed/simple;
	bh=sNmIBOD/k8igcTQLJ052h5bqLGyuiKwmIgMy3xCMzKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/oSLKxDQ7gvJOqnP7smJBTtk4x1WJN6VVHHUT8I+l1z+Ogz9PgZely9At4zXPcBAVJC0ZrqKPkZk8/U35LtLbXHIiKcC045weGTcgJLkBZMUK9N2uVohMO17C01HJDuwgtdWptXzuGJpLL2hsd13R8TZDBApJAVjBiEg6ZNmMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECkwdKWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECkwdKWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23111C4CEEB;
	Mon,  2 Jun 2025 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872826;
	bh=sNmIBOD/k8igcTQLJ052h5bqLGyuiKwmIgMy3xCMzKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECkwdKWAqstelLNAzvns8nWZoyESe2D8QCBay6rgdk6ck9SuN9Gm+OtkusnyaHFyY
	 kDZ4l+U6sqYcZrciG3z49B8WkAZ3ds8u8BxLF+9ejFCQqjSlDXXTbXv9V9jgSHelHR
	 2dtxmBeoVOHDOIcqjPZaVPc8dqTBEvXX81brxwuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Aradhya Bhatia <aradhya.bhatia@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 65/73] drm/xe/xe2hpg: Add Wa_22021007897
Date: Mon,  2 Jun 2025 15:47:51 +0200
Message-ID: <20250602134244.252580307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index d0ea8a55fd9c2..ab95d3545a72c 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -157,6 +157,7 @@
 #define XEHPG_SC_INSTDONE_EXTRA2		XE_REG_MCR(0x7108)
 
 #define COMMON_SLICE_CHICKEN4			XE_REG(0x7300, XE_REG_OPTION_MASKED)
+#define   SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE	REG_BIT(12)
 #define   DISABLE_TDC_LOAD_BALANCING_CALC	REG_BIT(6)
 
 #define COMMON_SLICE_CHICKEN3				XE_REG(0x7304, XE_REG_OPTION_MASKED)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 65bfb2f894d00..56257430b3642 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -801,6 +801,10 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
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



