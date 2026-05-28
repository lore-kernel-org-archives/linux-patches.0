Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC232B13B;
	Thu, 28 May 2026 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998974; cv=none; b=PcbnB31jCh+o3AX67/KVLVJQ/O3NORuYem6l3v/IK3dbqLCM/I2rRdovafpZYQCbf3I3u6jlZZjpCzbpAWIOKkd3OiD/ReOU8BrsKfdQis4/REc52FRQdEeBD6Mo/AbsZwAc8uppHNMtURCqeENFO1WFicm9G4Q8rg5MK/Igy4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998974; c=relaxed/simple;
	bh=v7LQEY8s7T2+xC/a63RFkw7WMTSASLqDIEcIEhOrJ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSBZZtz2x+oUMakzarBiLA3U2JkEPshHxcJXJH7k329iAltrdnM+JK/KciXPaj9TKQFRhTnCqZXYI8ja00s6K13hydxP/LQU3SbnrnNg6DO3CPdvLv9kN7V/hw2FGe3aEal2XbljvOJnQ5yz22LA3uO+5BLMsG37jsI2euhv6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c38uKtyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c38uKtyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55101F000E9;
	Thu, 28 May 2026 20:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998973;
	bh=5OjBI2BbedxGxnf7eYJPd/x5BtHx+G/81g2M+MBJmDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c38uKtyy25P5ITp8FeLPcualEaXEQo6D59/GBHNIFy9GzDwMjYht4kTGIczWzgSN/
	 nbV4Q8eoRXOcT3VF1Wmt+ynSOQh9UbbPeB8+IKPxFu31IVcA7Q97DeO9u55E5o2Nyr
	 BPmT6h8mpD77t4/ZNuhx3IIxK/pUaWDugCRwH5Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 364/461] drm/xe: Define and use MCR version of COMMON_SLICE_CHICKEN1
Date: Thu, 28 May 2026 21:48:13 +0200
Message-ID: <20260528194657.974965498@linuxfoundation.org>
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

From: Gustavo Sousa <gustavo.sousa@intel.com>

[ Upstream commit a4660bd949733fd6ea621fdb50fabac2608155e9 ]

The register COMMON_SLICE_CHICKEN1 is a MCR register on Xe2.
Let's make sure to define a MCR version of it and use it for the
relevant IP versions.

Use XEHP_ as prefix for the register name, since it is MCR as of Xe_HP.

Fixes: a5d221924e13 ("drm/xe/xe2_hpg: Add set of workarounds")
Fixes: 9f18b55b6d3f ("drm/xe/xe2: Add workaround 18033852989")
Bspec: 66534, 71185
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260514-rtp-mcr-check-v3-2-30dd47855fee@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
(cherry picked from commit a672725fdbfc3ea430130039d677c7dc98d59df8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_wa.c           | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 9d66f168ab8a7..dd06487c87edc 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -145,6 +145,7 @@
 #define   MSAA_OPTIMIZATION_REDUC_DISABLE	REG_BIT(11)
 
 #define COMMON_SLICE_CHICKEN1			XE_REG(0x7010, XE_REG_OPTION_MASKED)
+#define XEHP_COMMON_SLICE_CHICKEN1		XE_REG_MCR(0x7010, XE_REG_OPTION_MASKED)
 #define   DISABLE_BOTTOM_CLIP_RECTANGLE_TEST	REG_BIT(14)
 
 #define HIZ_CHICKEN					XE_REG(0x7018, XE_REG_OPTION_MASKED)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 6e3c44bc69daf..4ecf96fb40846 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -722,7 +722,7 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	},
 	{ XE_RTP_NAME("18033852989"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2004), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN1, DISABLE_BOTTOM_CLIP_RECTANGLE_TEST))
+	  XE_RTP_ACTIONS(SET(XEHP_COMMON_SLICE_CHICKEN1, DISABLE_BOTTOM_CLIP_RECTANGLE_TEST))
 	},
 
 	/* DG1 */
-- 
2.53.0



