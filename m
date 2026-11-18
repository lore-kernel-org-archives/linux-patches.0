Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061173;
	b=OxdMSf+kS8+5UIm9pau0vjLln1tu3qQm38+Cz0Te88zO3GjcY9uoer1wfTW1XHD21mEc
	 GXF+TzoUDDMDGiInHSB5+YA26XYG2qGqjrm1tdMfoLQR/SE1sE+6pwh2dTYCKyLQh6yb4
	 fBhtb1QDkLXEDgYw73wpr3LWn3k8bk0+5EutXTafUMjDVA2LEqlks6HKsEoG4YAUHbZPs
	 cVeH7TRGvmYSWsTf93n1Rr9jxwGAgbUl2SSkKBRXUzdJk96nAWKtmywdGDT4+hCGL64gk
	 Koc4HRc5JHh1bxX9QPTmitBM32e8nsomDTZut+f50euBUyTSacZF6N8A5yRclmkI3CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VTQj/eEwLiSV7L2mtTHT7+zwqva3welEiZjXlKHYXLU=;
	b=RGlLd1LtIpkpSfZRSNW2iPwTekbKjpZi+Aj0NuNNxezBa5sQaDAFpnA4wqGaHuSMGYVA
	 ErErpH+J1GE0Fuii0YmOSexxJgX5/M4KR3YvJjhcccJGflPVNsX3r6R2LBqsVlh8zfrhS
	 IxjLhyRBsN60r1FyExLHavuzdDCGm1kNk1+V10ije2mPWOAOMFo3AOFxKmM6e6zC/HT8J
	 xEaejgoFswcA+VQn3sesdQrtFHF3kF63Ioi6/ps6Qfuq7n4a6ipFj00pJAdf51UjJELDJ
	 RTffMo22e5IHrbPtdPyZtdTnjWYupUP5OBtfuCCadC5tQJrI8fKizI6JyXUyEBfB2Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsefkEwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE719606A320;
	Thu, 19 Nov 2026 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsefkEwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45CE1F000C4;
	Thu, 19 Nov 2026 04:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061173;
	bh=VTQj/eEwLiSV7L2mtTHT7+zwqva3welEiZjXlKHYXLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsefkEwanAlLFBhIatpRxbASiPaM+qujKDzpz+BlZoZ1/bcdbsK0T81QdYGlGt6ff
	 y8KvGv7RJQgTOpra+v5yfGaftQ4y2a/vygWAhWhUYFyVH7+SkP1oTPeGeBPT3kuTHP
	 q0i2VL+GmujWrFyVdbl3pi4eBPYJps2t4d2fAeDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1421/1848] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:57:39 +0100
Message-ID: <20261118150018.960174034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit c33cee4c07f1533ad48ed8e3eef75df57edf44c1 ]

The MSM8976/56 family of platforms doe't have a separate cursor plane.
Instead the cursor is a part of the LM block. Drop the erroneously added
pipe configuration, letting LM to provide a legacy cursor instead.

Fixes: 1860f2a8b8b1 ("drm/msm/mdp5: Add configuration for msm8x76")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/753150/
Link: https://lore.kernel.org/r/20260914-mdp5-fix-cursor-v1-1-9fba3ace6cb9@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
index df10c1ac7591a..46b4c3f54a68c 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
@@ -671,15 +671,6 @@ const struct mdp5_cfg_hw msm8x76_config = {
 			MDP_PIPE_CAP_SW_PIX_EXT	|
 			0,
 	},
-	.pipe_cursor = {
-		.count = 1,
-		.base = { 0x440DC },
-		.caps = MDP_PIPE_CAP_HFLIP	|
-			MDP_PIPE_CAP_VFLIP	|
-			MDP_PIPE_CAP_SW_PIX_EXT	|
-			MDP_PIPE_CAP_CURSOR	|
-			0,
-	},
 	.lm = {
 		.count = 2,
 		.base = { 0x44000, 0x45000 },
-- 
2.53.0



