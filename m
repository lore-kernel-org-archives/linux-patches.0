Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018095;
	b=RDeqfvfH8BhN6aJIwDFCTP741p1R7uR2yijOJfpDFsVYf4C9bdM660Y+yGzGtQ3tZQgG
	 dt8Ga7rQ886Qc1Eh2Lu5BvMaCfF3xDvg5Rz5QaYRE0FEEn0XAAq5oH8F5ha63nTBI8dCM
	 v9TEuGEoCk55NzE4MU9QiJlapJ69TWH+xyu1sv823DyW9ZAiErWyoArVJqZQfjT8KUY0y
	 f/c/aH6rkZzXJ3k13mN3Icg51MB65Lk0s13SYHdnuDI4mr4IlHM3KHjZ1ShgwYrhhNZPy
	 Xd7agOmZb4GsSESGTSiOzHc5p7t0ByF4YNYERfLNTqhOwemHNBbEJhZ13IA+zmCNgwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQzJ2LZwNSDE0pcoIV4K+ucv/QGc0pCqBH7gvzzlurU=;
	b=tohcHoQ+LNV7+59vUWEE56gZP54U9k4Iql3VzlSV2zGbFO+LLfyAXPxXnTV1obULm857
	 7auhfZIXOoh1YHE/REW3ZDWO/JvSeKiVTlkXZxJtVAM7IE3nPmwaV2YynG3/DjoIkPg+T
	 eTuGDWzLs+OOswYQckIG7SvaGYIAlQ7ELsM9iQ35lFtoC9g/9m31KcDTZDaSRjeShVX00
	 cM8CB+Am5gOt+R7ivIL3jAh5SUyZ9xv/T5IriBNviGJEe28z6EeCJu69n2OjTs/sldda0
	 RbcMEEL+enOrxrx1h0J3PTrxh/th5jNyx38eFjdsIinXAC/elYSPLAf330Bep63d2/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dHkgzSkV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05EE60A260B;
	Wed, 18 Nov 2026 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dHkgzSkV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26FD1F000C4;
	Wed, 18 Nov 2026 16:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018095;
	bh=IQzJ2LZwNSDE0pcoIV4K+ucv/QGc0pCqBH7gvzzlurU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHkgzSkVVYUMSsPaqrc9Ws4IX3wXNAchDr7O7RsKnBdvRw08xGYMXd8y7VDmOlLQT
	 6H09/0dHGJKiMMyxrOJlvI77dVWojPuCtY0RSd0SDws1mcxsQqDyv5cHCK74KXHB/i
	 ehTPyZXZ9/UWJuaOaCP1nbPLFXCX/oedR5l+dO68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1094/2651] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:38:54 +0100
Message-ID: <20261118150327.384070240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7c91fc1915f39..389d74ff75163 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
@@ -698,15 +698,6 @@ static const struct mdp5_cfg_hw msm8x76_config = {
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



