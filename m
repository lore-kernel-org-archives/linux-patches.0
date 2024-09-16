Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7F1158525;
	Mon, 16 Sep 2024 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488236; cv=none; b=eEIGaT9DA1PFaPcR22uSgVWFYcgPRPElAIjPMMuHtDl26pbOiZUyxwEMQVdHWpnMQWNZKFlew847Teyg/EUoZi9ueI62eQpRL7sEvx615q65c8cDGKAfJ5Z4fQepiVTHz0KKOdGUYt+tG3cYMoxQuhfsRP94+GtqQdIOYJ/46uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488236; c=relaxed/simple;
	bh=Xih8Y19YpIX5vJPayhzyGfVs/NWCUR9lzN6G7IONClI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHhuOOPhL25+Nds2DpyrhnofcB8o/aFTFszhwp/XcnUmTbZ72H0HY++P2AALJFpwmw6q7Gado2LsJPu7avwhKBM3QK53CBM/x90C6phAv6eAvy6Yx+O6PTWmlqNvEBJxfov5vipYCzccibBXDCnb9Z4e+CYH/MMLEvGRk+41iJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sp+PUVSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sp+PUVSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27456C4CEC4;
	Mon, 16 Sep 2024 12:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488236;
	bh=Xih8Y19YpIX5vJPayhzyGfVs/NWCUR9lzN6G7IONClI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sp+PUVSABumkJ6iszS55b6+zI5kbHU82vhMGWGkuJWF4vwX/9HJ8Za9c3xpVhXJD1
	 98EInO270pewF7SmM5Zk2PJo5SzVoOaEB56SYjnKAolhRuLp4it+z6OzdVS5Z5ueqk
	 TGifejumweca0sluYE6/f9lUwqpMwFGS/en22FOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ngai-Mint Kwan <ngai-mint.kwan@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 035/121] drm/xe/xe2lpm: Extend Wa_16021639441
Date: Mon, 16 Sep 2024 13:43:29 +0200
Message-ID: <20240916114230.289977338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ngai-Mint Kwan <ngai-mint.kwan@linux.intel.com>

[ Upstream commit 03a2dc84f5c4ef31ac0112b29d51ff103f7c8dd4 ]

Wa_16021639441 applies to Xe2_LPM.

Signed-off-by: Ngai-Mint Kwan <ngai-mint.kwan@linux.intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240701184637.531794-1-ngai-mint.kwan@linux.intel.com
(cherry picked from commit 74e3076800067c6dc0dcff5b75344cec064c20eb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 66dafe980b9c..1f7699d7fffb 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -542,6 +542,16 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_ACTIONS(SET(HALF_SLICE_CHICKEN7, CLEAR_OPTIMIZATION_DISABLE))
 	},
 
+	/* Xe2_LPM */
+
+	{ XE_RTP_NAME("16021639441"),
+	  XE_RTP_RULES(MEDIA_VERSION(2000)),
+	  XE_RTP_ACTIONS(SET(CSFE_CHICKEN1(0),
+			     GHWSP_CSB_REPORT_DIS |
+			     PPHWSP_CSB_AND_TIMESTAMP_REPORT_DIS,
+			     XE_RTP_ACTION_FLAG(ENGINE_BASE)))
+	},
+
 	/* Xe2_HPM */
 
 	{ XE_RTP_NAME("16021639441"),
-- 
2.43.0



