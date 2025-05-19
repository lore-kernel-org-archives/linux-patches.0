Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59A622257D;
	Mon, 19 May 2025 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689722; cv=none; b=TnSbIQeXAV7szquGv+UyI+DxH1k8qX2az+gvbpnZ2+bVDIyaJACU7CtuVzPP/FewUVu/1jl3t9JacOMcr0RjqOouC/P5ZXnCRf3KmdJIjCKeSkLLrP6JjHXhYuu7kZnohJj6lWWhs7lNwXTJ2pVDHVQDng1iL38el+ZV/6ZDL6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689722; c=relaxed/simple;
	bh=OL9uX6XWCNIhFu+QC1BZNccZr8I8iotFPDBJYOKGEPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mU5VKHL1KIT1TefC5FnPCb8/FD3FNOyGABqq5c3FZ1IN+TGEysoLPDaoPW/cHEs2HYoxu+Ap1d7eT33oLJaqE78dRXAjhgpuP39BYCrBa9z2uGHht8kTtYVqHWHVs/c3FHRSbzP+GBSzL/mJARCcNn9rd+wVbn5n123yQ5htm4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkZDV/dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkZDV/dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AC4C4CEEB;
	Mon, 19 May 2025 21:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689721;
	bh=OL9uX6XWCNIhFu+QC1BZNccZr8I8iotFPDBJYOKGEPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkZDV/ddErizL3Aqftqbbg+6iGdtptAx3NKWO53BkerNHxMh+ZisNkBZW5VqLie8f
	 9rmdnizjXepZ+RVdFolvnVYs3x1ggCdMOQuycjRSbdkwakSY8yIFLaynzEplrEatfg
	 S7HEmHVRCnraUaSkXPyKV8kkLILuHJ2HAwxmA0QM/y3mV4OUCPVyY32wxKUnsxKi3A
	 b+FJh85ayX3IOgfg7eRFlrm+jYotG/3ey9mwBPZdRFOItcVuUdpZHcezqkIedAs7Lv
	 gKt5+EPEJR6Vm77+mxsha3YcWUTJOUpH818RLnX6dagJZDZ3kYpfCTBtUPcb5hDSD7
	 49PrmkZYScv4g==
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
Subject: [PATCH AUTOSEL 6.14 19/23] drm/xe/xe2hpg: Add Wa_22021007897
Date: Mon, 19 May 2025 17:21:26 -0400
Message-Id: <20250519212131.1985647-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
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

