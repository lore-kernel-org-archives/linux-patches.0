Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030495;
	b=VRJIK2BgIINx5U5xU2fvgLVTzvyc/d2yrY5bwzXM06tfY5wpudOlp02ik41VQNSBMFEO
	 xCtHJkVRnSrPAmK6KEKajWiZNACvq+AWzhlXnRhsDWhbN0GC1SYFybSqPnm/T/Ou8x1T/
	 HVNleUCL/LANhObw3tZR/xT4VNXd/YmFja+CXl4ey7OdjNQw/ngOAH7TNGvqkb+74p40C
	 A1D1Wahbq2RGb75p2OtfFlJ4bC8oH+heQvxdQr/Wcs5CSSgmPeUtfflS8XUfWOvuvrNZi
	 wk55sJK95oh8KNV7yIhZmhrDX/OWl+sAS95peOnGl3ox+UT1TzztVHdC8ahW1HZ07GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhUXZBoh6stkJvR67SKvpA5brbz1cXG9GwVs0OfGJXg=;
	b=vuZYKl1f4pZTZH/34DdTuXhOvpVFOu6wpzwbJcLc9S++N0PJY5c6Hmi60/wFHpS7Zj7s
	 GheahueU5O1riTyI8jmDLWy8E/GEUVKup6FUqU5EIP5+6UogMUpEkQl//bsfiwPAJZlhE
	 eLWsr7PBlL7G7TOh/We/zmvBo7lCdxrVd+atoQolBjCnYIlB+S7lvtTeOQmChyiLyf9Ed
	 4NnqOdXpHZs/R+5Lt3LRUir29wpjyI8rDMXjAf6kfQ5/WzGFwqzsF2tXKie0dNp6WS8wi
	 q0Nld+6uFMQXVHricLFOX18jFLc+TgnoCl93pNV6zUWXDqfgY0VM0Na5pbxRoCCJ9Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoZnxAVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D98606BB51;
	Wed, 18 Nov 2026 19:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoZnxAVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A91F000C4;
	Wed, 18 Nov 2026 19:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030495;
	bh=AhUXZBoh6stkJvR67SKvpA5brbz1cXG9GwVs0OfGJXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoZnxAVOmQ13jK97427hG8ok97hBWlbxlmnEJwRVEFHL9TPho9QeillvWV5hop5Ed
	 ePJJXFKZzHmVlWR2FxuJvia29jsg3sl4yUxmDjf018MoRcERnHeh9pGzqVr2tS6iUT
	 QBC4LxM6rEaE4+DXftfh/PfE7MtHl/0rjsgW65vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0724/1756] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118150038.519905764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index df464f7c05bfa..97e75c1a0a344 100644
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



