Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6BB334373;
	Thu, 27 Nov 2025 15:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255967; cv=none; b=sVtKrDze+g7t7fDrZ9rDgnVLjl/HpPK88kDww0TkuxrOwTa3y0y78kcAL49jb09bPg/UaTARyrJSE26NUSXHr1tDG0lMtXkpmA7DTnzqYA1LO03n89Bue1ZbY+2buXFp+d964X332ihE51yBFEc6q2Wk6YdHUNyK8DIfCSpa4g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255967; c=relaxed/simple;
	bh=Ux7LHs/lT5p/VPSbejZDeIx3C0o//kM77eUIrbocgls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXqtZNC18iay/vHIs2VVzuN1rRCuVIDEYJYwQLLfBpOAuwDeU4egCZtcOj35rsmHW/f2xRuXwO+CPkQG9kULgW/9hVAJ0lnO04ANO00CPGyIiKJia2oRtkQjKLv4iPRMMoJRoMcvc5O+DW846F1ng0xr9JaA10x3Fmc30USR44A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoDVulXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoDVulXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E55C4CEF8;
	Thu, 27 Nov 2025 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255966;
	bh=Ux7LHs/lT5p/VPSbejZDeIx3C0o//kM77eUIrbocgls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoDVulXR+Ugs0EVCIHbj8V3+DVRHL40UyEvWg2H3c8YUPCKTAqq/+ieL2RPmCDnWu
	 eY/YCj5eWP/4l2ohQiEXFq4ltsWSv7q2WlE1m8Mr+iqQhtYhpjtEqSBYNCCqECvyZe
	 jwyBAwTDCqQP1fP1LiJWY7tThMY3HjMRYvKuiEIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ovidiu (Ovi) Bunea" <ovidiu.bunea@amd.com>,
	Yihan Zhu <yihan.zhu@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 169/175] drm/amd/display: Insert dccg log for easy debug
Date: Thu, 27 Nov 2025 15:47:02 +0100
Message-ID: <20251127144049.128531555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 35bcc9168f3ce6416cbf3f776758be0937f84cb3 ]

[why]
Log for sequence tracking

Reviewed-by: Ovidiu (Ovi) Bunea <ovidiu.bunea@amd.com>
Reviewed-by: Yihan Zhu <yihan.zhu@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: cfa0904a35fd ("drm/amd/display: Prevent Gating DTBCLK before It Is Properly Latched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c |   24 ++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
@@ -39,6 +39,7 @@
 
 #define CTX \
 	dccg_dcn->base.ctx
+#include "logger_types.h"
 #define DC_LOGGER \
 	dccg->ctx->logger
 
@@ -1136,7 +1137,7 @@ static void dcn35_set_dppclk_enable(stru
 	default:
 		break;
 	}
-	//DC_LOG_DEBUG("%s: dpp_inst(%d) DPPCLK_EN = %d\n", __func__, dpp_inst, enable);
+	DC_LOG_DEBUG("%s: dpp_inst(%d) DPPCLK_EN = %d\n", __func__, dpp_inst, enable);
 
 }
 
@@ -1406,6 +1407,10 @@ static void dccg35_set_dtbclk_dto(
 		 * PIPEx_DTO_SRC_SEL should not be programmed during DTBCLK update since OTG may still be on, and the
 		 * programming is handled in program_pix_clk() regardless, so it can be removed from here.
 		 */
+		DC_LOG_DEBUG("%s: OTG%d DTBCLK DTO enabled: pixclk_khz=%d, ref_dtbclk_khz=%d, req_dtbclk_khz=%d, phase=%d, modulo=%d\n",
+				__func__, params->otg_inst, params->pixclk_khz,
+				params->ref_dtbclk_khz, req_dtbclk_khz, phase, modulo);
+
 	} else {
 		switch (params->otg_inst) {
 		case 0:
@@ -1431,6 +1436,8 @@ static void dccg35_set_dtbclk_dto(
 
 		REG_WRITE(DTBCLK_DTO_MODULO[params->otg_inst], 0);
 		REG_WRITE(DTBCLK_DTO_PHASE[params->otg_inst], 0);
+
+		DC_LOG_DEBUG("%s: OTG%d DTBCLK DTO disabled\n", __func__, params->otg_inst);
 	}
 }
 
@@ -1475,6 +1482,8 @@ static void dccg35_set_dpstreamclk(
 		BREAK_TO_DEBUGGER();
 		return;
 	}
+	DC_LOG_DEBUG("%s: dp_hpo_inst(%d) DPSTREAMCLK_EN = %d, DPSTREAMCLK_SRC_SEL = %d\n",
+			__func__, dp_hpo_inst, (src == REFCLK) ? 0 : 1, otg_inst);
 }
 
 
@@ -1514,6 +1523,8 @@ static void dccg35_set_dpstreamclk_root_
 		BREAK_TO_DEBUGGER();
 		return;
 	}
+	DC_LOG_DEBUG("%s: dp_hpo_inst(%d) DPSTREAMCLK_ROOT_GATE_DISABLE = %d\n",
+			__func__, dp_hpo_inst, enable ? 1 : 0);
 }
 
 
@@ -1553,7 +1564,7 @@ static void dccg35_set_physymclk_root_cl
 		BREAK_TO_DEBUGGER();
 		return;
 	}
-	//DC_LOG_DEBUG("%s: dpp_inst(%d) PHYESYMCLK_ROOT_GATE_DISABLE:\n", __func__, phy_inst, enable ? 0 : 1);
+	DC_LOG_DEBUG("%s: dpp_inst(%d) PHYESYMCLK_ROOT_GATE_DISABLE: %d\n", __func__, phy_inst, enable ? 0 : 1);
 
 }
 
@@ -1626,6 +1637,8 @@ static void dccg35_set_physymclk(
 		BREAK_TO_DEBUGGER();
 		return;
 	}
+	DC_LOG_DEBUG("%s: phy_inst(%d) PHYxSYMCLK_EN = %d, PHYxSYMCLK_SRC_SEL = %d\n",
+			__func__, phy_inst, force_enable ? 1 : 0, clk_src);
 }
 
 static void dccg35_set_valid_pixel_rate(
@@ -1673,6 +1686,7 @@ static void dccg35_dpp_root_clock_contro
 	}
 
 	dccg->dpp_clock_gated[dpp_inst] = !clock_on;
+	DC_LOG_DEBUG("%s: dpp_inst(%d) clock_on = %d\n", __func__, dpp_inst, clock_on);
 }
 
 static void dccg35_disable_symclk32_se(
@@ -1731,6 +1745,7 @@ static void dccg35_disable_symclk32_se(
 		BREAK_TO_DEBUGGER();
 		return;
 	}
+
 }
 
 static void dccg35_init_cb(struct dccg *dccg)
@@ -1738,7 +1753,6 @@ static void dccg35_init_cb(struct dccg *
 	(void)dccg;
 	/* Any RCG should be done when driver enter low power mode*/
 }
-
 void dccg35_init(struct dccg *dccg)
 {
 	int otg_inst;
@@ -1753,6 +1767,8 @@ void dccg35_init(struct dccg *dccg)
 		for (otg_inst = 0; otg_inst < 2; otg_inst++) {
 			dccg31_disable_symclk32_le(dccg, otg_inst);
 			dccg31_set_symclk32_le_root_clock_gating(dccg, otg_inst, false);
+			DC_LOG_DEBUG("%s: OTG%d SYMCLK32_LE disabled and root clock gating disabled\n",
+					__func__, otg_inst);
 		}
 
 //	if (dccg->ctx->dc->debug.root_clock_optimization.bits.symclk32_se)
@@ -1765,6 +1781,8 @@ void dccg35_init(struct dccg *dccg)
 			dccg35_set_dpstreamclk(dccg, REFCLK, otg_inst,
 						otg_inst);
 			dccg35_set_dpstreamclk_root_clock_gating(dccg, otg_inst, false);
+			DC_LOG_DEBUG("%s: OTG%d DPSTREAMCLK disabled and root clock gating disabled\n",
+					__func__, otg_inst);
 		}
 
 /*


