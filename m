Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622320;
	b=UtUbHrGtNvyb+rCtiv3I683EU/oe2ppzh6X8PgmIRg+uREqSZsDOIPUQ9CJhMShqCVxx
	 INxUIPacUnbgcVbGnNPtJ/xm0547loQN/hcjbcA7zbkOcZTOx5Ay5KR7NvkJQTatvTEaX
	 josoXmPqZEDolSAEH4CoeRpcgFv7Dx9iEV4ZKiF0P0RyUaioAhj54KsEcxO4Huwrh2iyD
	 pl3kM5D0TArquwm86IBuer+UkQhilL6wvvIHU9+5A+4UbIBJNMFrCOIED5jbyjkS45R/H
	 uIS7Uelaj9sK74zbVTxnOwTmv2OnACfbO85U7hgJl5TDqyJRfwdZAoFIvdJ2ouphySw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0q7I0KV6v9OStnud/3MQV3+JobaJ96kVGLSyDv6by4=;
	b=NULTaxbkI1Hv8EKUIrgBCRS6vxVuJ+Phv2MI+ngwgc0f6r+g+OFrCGOTcOgUsLQNbcrO
	 wT5yqpeg7xxqo+nooENqzNZAoFXm3Hx0L0LzxLwaEs34dk8cWNCGxC0CzibqDdrjx9nb8
	 dyTijc/dd27GJ/tUQAArRM/fk7FZBLVOvow9DNqz0kZO0G/eUsm4qeMnwmLL8Mzn2lW7R
	 6ZoryZZ8e05pCYPYuun9fufiNow9OcB78w231qBI4l5xgLZZvQqOqh7Butj2kiKSE0nSa
	 cglf99N1McgZZcqk15sAwezkIkcH8v539EQUDPSW8gmqzpZJ6Y43762BORIFtf/b/sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCbkY2c2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01910606A69D;
	Wed, 25 Nov 2026 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCbkY2c2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3995E1F000D2;
	Wed, 25 Nov 2026 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622319;
	bh=x0q7I0KV6v9OStnud/3MQV3+JobaJ96kVGLSyDv6by4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCbkY2c2opGxQtA6xFxgwL6vBvov4nZsahastL+v9zAA2kiVvOnfGR9FlIGOMLM9o
	 HB1SbTWP9v02RM3dT2BQF9RwdDFT9mjiwm7+kSgPnaMHG0EBLRyzV+Z8uJuKFsGal1
	 0vszmaA0cCgg89NReiFWlIdEOau3/iecUcPRre88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 455/990] drm/xe/xe3: Add support for graphics IP versions 30.04 & 30.05
Date: Wed, 25 Nov 2026 15:30:22 +0100
Message-ID: <20261125143832.752792465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shekhar Chauhan <shekhar.chauhan@intel.com>

[ Upstream commit 4fde66699f1ced2eeb6e58ff0eaf46e4fc92a7a0 ]

Add graphics IP versions 30.04 & 30.05 and initial workarounds for these
IP versions.

BSpec: 74201
Signed-off-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://lore.kernel.org/r/20251016-xe3p-v3-1-3dd173a3097a@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c        | 2 ++
 drivers/gpu/drm/xe/xe_wa.c         | 6 +++---
 drivers/gpu/drm/xe/xe_wa_oob.rules | 9 +++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 75334fc1ac66a..e907751e9e3a4 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -149,6 +149,8 @@ static const struct xe_ip graphics_ips[] = {
 	{ 3000, "Xe3_LPG", &graphics_xe2 },
 	{ 3001, "Xe3_LPG", &graphics_xe2 },
 	{ 3003, "Xe3_LPG", &graphics_xe2 },
+	{ 3004, "Xe3_LPG", &graphics_xe2 },
+	{ 3005, "Xe3_LPG", &graphics_xe2 },
 };
 
 /* Pre-GMDID Media IPs */
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 51c5985830b17..e4810821d4813 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -675,7 +675,7 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	},
 	{ XE_RTP_NAME("13012615864"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001), OR,
-		       GRAPHICS_VERSION(3003),
+		       GRAPHICS_VERSION_RANGE(3003, 3005),
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
 	},
@@ -686,7 +686,7 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 			     XE_RTP_ACTION_FLAG(ENGINE_BASE)))
 	},
 	{ XE_RTP_NAME("14021402888"),
-	  XE_RTP_RULES(GRAPHICS_VERSION(3003), FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3003, 3005), FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(HALF_SLICE_CHICKEN7, CLEAR_OPTIMIZATION_DISABLE))
 	},
 	{ XE_RTP_NAME("18041344222"),
@@ -912,7 +912,7 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 			     DIS_AUTOSTRIP))
 	},
 	{ XE_RTP_NAME("22021007897"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3003), ENGINE_CLASS(RENDER)),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3005), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE))
 	},
 	{ XE_RTP_NAME("14024681466"),
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 1d32fa1c3b2d7..31b5062585eb3 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -34,14 +34,15 @@
 13011645652	GRAPHICS_VERSION(2004)
 		GRAPHICS_VERSION_RANGE(3000, 3001)
 		GRAPHICS_VERSION(3003)
+		GRAPHICS_VERSION_RANGE(3004, 3005)
 14022293748	GRAPHICS_VERSION_RANGE(2001, 2002)
 		GRAPHICS_VERSION(2004)
-		GRAPHICS_VERSION_RANGE(3000, 3001)
-		GRAPHICS_VERSION(3003)
+		GRAPHICS_VERSION_RANGE(3000, 3005)
 22019794406	GRAPHICS_VERSION_RANGE(2001, 2002)
 		GRAPHICS_VERSION(2004)
 		GRAPHICS_VERSION_RANGE(3000, 3001)
 		GRAPHICS_VERSION(3003)
+		GRAPHICS_VERSION_RANGE(3004, 3005)
 22019338487	MEDIA_VERSION(2000)
 		GRAPHICS_VERSION(2001), FUNC(xe_rtp_match_not_sriov_vf)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0), FUNC(xe_rtp_match_not_sriov_vf)
@@ -63,11 +64,11 @@
 16023105232	GRAPHICS_VERSION_RANGE(2001, 3001)
 		MEDIA_VERSION_RANGE(1301, 3000)
 		MEDIA_VERSION(3002)
-		GRAPHICS_VERSION(3003)
+		GRAPHICS_VERSION_RANGE(3003, 3005)
 16026508708	GRAPHICS_VERSION_RANGE(1200, 3001)
 		MEDIA_VERSION_RANGE(1300, 3000)
 		MEDIA_VERSION(3002)
-		GRAPHICS_VERSION(3003)
+		GRAPHICS_VERSION_RANGE(3003, 3005)
 14020001231	GRAPHICS_VERSION_RANGE(2001,2004), FUNC(xe_rtp_match_psmi_enabled)
 		MEDIA_VERSION(2000), FUNC(xe_rtp_match_psmi_enabled)
 		MEDIA_VERSION(3000), FUNC(xe_rtp_match_psmi_enabled)
-- 
2.53.0



