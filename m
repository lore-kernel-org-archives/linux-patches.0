Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040519;
	b=c64jTrWgm7oNbo6MuYLviOn7kp6al4IIuU2IM3s5MwfJbf5D8pRwaU3jihZkedVqTgbT
	 4fUxYaxlychCrJb1ePOt2EMOGwdlb10NiIQsmngwIsojy1Pd4URhOJAci6vb/LMKFN9Ax
	 tWBfP5Xybq0H9OrsyioOZgXgJbiUPeV2q58lMNyMSHE7J5J2M4Ysb/V0uquAz9Sy5rrx/
	 aeGsxjWjCQ9gJ+DGoXdYSWexnvCtTYTY0U1OxbSusc/rjGHqtle9oVgNXDcuW49h0QnTD
	 gRL/CCgZmA+1/9kliv3UPAzM6QPhp7CINauwhftdIYRxjStK3L+/x309ug1xXNM2/Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azlSmIcVJcCIyz9vv+9xNaTCWzmb1uFnjS3npxwy9SM=;
	b=gJET6HjHJMd263in4YduT/v+NIAT3giuYchHEsSeuUFprpxhzn9CuCxEvjIKnASBInhP
	 ZhLtUeXAts9OZtgkpJhaFEexPTlAlS36+ASGG3AsmFnF6dmlQWj6SM2D5wY1APOTzA3Fo
	 xbP1bYGwlKvxLYSwHosDeJHuNxUQc78of0rEeuwaI1pVdpVHchgjN+sDMacRikSy0xknN
	 Ut7umzigVD1+A0I4KYtO8H4WmhOEY7SEFNVBHVWsV+q40sQBsFyiY/Y0kmvr40DNEWnM1
	 0ssFpkIUL+YWSe5mnw6f16RFV1MPaNRZyMY5qGAX45kMl5KrNLXu1A4kf5PWnT+QBSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4vjdyCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419A8606A320;
	Wed, 18 Nov 2026 22:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4vjdyCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931371F000C5;
	Wed, 18 Nov 2026 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040519;
	bh=azlSmIcVJcCIyz9vv+9xNaTCWzmb1uFnjS3npxwy9SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4vjdyCpbpYgSNZDpd+ND2UVk243DgpTcmXEcMFviGZl1Twtw0BouaokWgrBu/M1F
	 2/mzbgrs0TGYI5If0F4aNZhCZJ2y8g7LDR7SeUCpa2RF+0+0pexRB8oIMJ/xK6ejth
	 1QrySGZl907VlMW0zadm5nki8bCsKAnqFVKIQ/1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2485/3318] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150435.951097263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 694d543413374..aa6ca1440bd1d 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
@@ -787,15 +787,6 @@ static const struct mdp5_cfg_hw msm8x76_config = {
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



