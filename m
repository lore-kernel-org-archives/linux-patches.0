Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048893;
	b=pRU5YKqOEOWa5n9rlyy7WVfjfJMvLs45ZwH98aGEZy8pYUgOH0/txEZV/XnvZz6cOMG4
	 6oevnMRG2y0amZfNHGdNrIlK7YidHs34cFFRBTiWOdHa7YlKP4S+1XLiOdojP/ozWCqqN
	 eY7oclskpJSvH0fHDsj92pxGAiczfCRnCTYvu5dE9phtLd4bf/spU0Le/4AloSBBW8NCf
	 QxCahgK4DHtx88HDlvwjvGS/pDa1YkY/v58tH1Y+dTfG7Hgv9qpYutXQ9AfnNPyUV20KL
	 leeU4B+I1Xv5s3UvdWfq9Rgv9i9IxTi9Y6yTtkVANcXxh/xZ/TuJlrP/j7FM04ZaJxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V8N6BlbiBH3eCFL3fWhn/s44KJF2XGaNgEpyOg9HmYo=;
	b=lX0vmG3Y9PSa11V3vikFp/yVLQZECo5jcFLx5raprhn8btFlv0WFvnPYIpNtVfiI15zo
	 mXqSBXSzN8P+BOUHHea38jJfQiWro0kMz7QjmA4ANEG+2ZQStYjZUPjXstC633YnBc3aB
	 lx/jPGo7uQHuXeX793lout1i94uh2aU1NmvepB0i4QGrpThsyGGSVeHbxyvHtBvguZ7up
	 zyzTX64cZjq0UIyB2kodxARI4criJ0I5NOFxtPBeswNEma5MMorMCYaTERcOpakzNESa4
	 TSiyqqrB2qAfGCch0KXYoZP+oI5BnHrnMQcvYWs6xu2LZCVB0zXiW5/ejs+dv8Gg9Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOXZ91vO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50C606A320;
	Thu, 19 Nov 2026 00:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOXZ91vO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3123E1F000C4;
	Thu, 19 Nov 2026 00:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048893;
	bh=V8N6BlbiBH3eCFL3fWhn/s44KJF2XGaNgEpyOg9HmYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOXZ91vOFk8R5hFeMnIT3YB7daZoXH9QZD20KekVlYjpIHq9LqOZlaMMC81QXgLos
	 nGBrJaft2gSpWHDZSkXyW20y2d7Y/3vWsnYDegbbpVxk/Bl6rZo9WfbR+mxnJ/ZRoj
	 rjJsWDFpMsHY4LlBJs3nIVe/2q4lOCqLS7C74VaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2156/2857] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150319.024643585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1f1555aa02d23..9b51f8885eaeb 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c
@@ -706,15 +706,6 @@ const struct mdp5_cfg_hw msm8x76_config = {
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



