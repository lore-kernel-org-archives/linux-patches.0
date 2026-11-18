Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025016;
	b=L9YAOC0UOVm8eoUp8kmO+HnhEIA0+QD8Y2Zg29N+zKibrA6GAYipHCEmhmGrQCDw6uUP
	 OUwPzGEoBanIx3iDOfbHtU+xmTcwuRf2H59rkHAGuGnRrLqRbrsB81lAR838PX4Ut4WON
	 7yZZcERei4CEX5Cpi1H2Nur06pISUoTYCOdCNcvjkqGOV2nQvK0Jb0KEXg7d08CnS1mQF
	 KGh4qarBU8o11tVy53XYHsBAbvOilTPJihlFMWECjQ//imiU29JfTo5n2m/BcDgdEmy+m
	 gneNResp97orSCvXq3hjMhhiMY88cXPfRofy50UcUJSIBkPWsirrdRSzt9ZWm54Hc5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CsS3E4OnCphy8jwznrhrkS0hkOoLraT9w18onFZxC9c=;
	b=NuFlw04R+1dTXM4OmoLZkNOHaE5nndhBpOKwyLxw4HewuJUcX7DU3sau6jyRRvVmkBhr
	 qlZES96CIvUQ+DL3bPih2jYev5Poaim4T+DXYuZwPvHFzmcaQRP/ccnjoNVH9Rj+nUaC+
	 P/9VLgrU8rPhJEoaQfF6XXJ6w47TzWiOx4pwc+sevAwX4BPVtdCOAfKRGEl+EEV20I2hM
	 V+mFCNqJ6YWgJmMXkD2MY47X/ZtX2ZE1aadC1mPyTUr9sTWKyjcfWCFUgy9FxfFsCCB+o
	 Q7E9BLw41Dc1CjaRzMsZQk0Tiu+2LDIQPRFIkVRQvdjx0YreKV6Cg7gKGDYqf1z6QiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKga1lVh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988BB606A32A;
	Wed, 18 Nov 2026 18:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKga1lVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803D1F000C4;
	Wed, 18 Nov 2026 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025016;
	bh=CsS3E4OnCphy8jwznrhrkS0hkOoLraT9w18onFZxC9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKga1lVhtvfvHKhbN49BaPBSK7fFFVT9EPJEsxQs/afJN5EImvwl7bJjni7Y0Irzw
	 SHIMnrv/62i5GW4j+/2nS2dJL/cSN/jYJ65G9atUGWdPZGDtoWSKYxhi/EhTmT3/m1
	 2PzEp+fnpKlYEP4Q3KDaFcohO1QwuKFV8gxwYiS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0915/2151] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:44:10 +0100
Message-ID: <20261118150155.715655097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



