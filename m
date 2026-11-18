Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055600;
	b=4ll5OewPE4nhvV9XAnOoVGYCB2N/OLMPFbTjVOZmjO47kjHJCXWkkkQ86PZCJpLWGuRW
	 vh6K0bpEM3K8r/2YCv0KbGpNTXixCJn9bj5BXekj/+icNE3PwfjgpZ9C8/4bUnDbqCvLj
	 JtYnpe7LVvR0sDr57qtyc1SdyX/WSyO0vXRIxX2FoNK7dBOhzcLwX3rKylQFpcoqCqOpw
	 a0cGrqUOPB+NV/QJse4cie6VqmzGd3g7SjxBBI0PEbI/JjgBCevfMDh6ZzGHMqPCAxE+c
	 y0UQV2ps53y/9UyYJVLv0wIP4JwyfiBIxzMtTZXA2vJBQoGvwL8r6k1fPeQZWEwt9RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1CxuId4diS3J/YEPlm2X9jekqaUcbv9J6QmcA8hMNAY=;
	b=3UWxCJCap1b+idQ+kmb8n52/hrgtbNMm0mUzxpukUEni1CvPeyl8cj5fl28e0ri/IsFp
	 cFlNhSTnZqGczb3kOYXdlWPEVO2HpcBo3IpICuk08onzVL0EP0RelkV94R3fWqWRntBOE
	 IRp00fJ/yp/soOU+M/o7ayL/KuVB0zKxPWB8o8op3rGd9qgTuwUORNnJ7uCHaOkAD0x/v
	 SEVKxKrInePT1HkpyZOIaMw/Tppk+PKpILmx/iITdOQr+E1yiU+ar/5jwyRapp8qt0amQ
	 aWaYSEu278yPTb0b1rzQBuvMT4W48mx+QGWf2JOZSOiuxDcvwQTGkvr+ULmVLTEM3Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzVyaqLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361560A260B;
	Thu, 19 Nov 2026 02:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzVyaqLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB081F000C4;
	Thu, 19 Nov 2026 02:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055600;
	bh=1CxuId4diS3J/YEPlm2X9jekqaUcbv9J6QmcA8hMNAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzVyaqLfGqn9CpBIsoq2JgQmkgs8Fh4bEmX3agCItd3iTNTUO4FsZhTyTtGdPiIKw
	 OlCFMF3lC4JZhclK2u9nK7EYJRDP9DI2U4N8HQs6r0NNdSXjWVV8GQGW+lGc3iQ5s4
	 N8nyoUo5GVlBHgqu/ErW33KACeL7a79RaQiIFE2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1690/2214] drm/msm/mdp5: drop cursor pipe for msm8x76
Date: Wed, 18 Nov 2026 15:56:06 +0100
Message-ID: <20261118150119.432521933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9741544ffc35f..57fa353bd7d6b 100644
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



