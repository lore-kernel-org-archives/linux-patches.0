Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056514;
	b=de/xaOxJCkq1MeNnX9k4K6P8k+iggzB5GXF/0HeZ0KWPzsz100TCvI+GN0Maha5WB7/O
	 Zmjt60L2kFBorWhnUM2z/1p14T/Nq7pocqqseusDIQ2JmavebRBRaNT7qPUaOapA6Inm/
	 Tu3/jTLiHz41v+H4wjbsrs5IOwKM56fKkjXKqmRV4aNueHMOIMInZCGRMVujmboj0gxVL
	 01lxvqYbSyYYSUaZasxFy+bCbIY4vCoW1KTJtCgJ2t73H2GV/caRUNnwxgJgQ3/n3VKHa
	 T8yxU5E3UkRceJGcY7IdIIknoqVqeCGz15iAL/D2UuS+xm03DVfUg3DHSmoAG63lKyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l5i3VYALNGN7dhQAAM0cz0I466Eko7LkwxgWXA+Apig=;
	b=KxLFyssTfOZTb/dhWlse7sqwpqhxVbudpWhF1x2p0AAEG2i9lJ+cvr10+llbmj+Xa5m1
	 yzJclY5KkJH9H3XhJreO4LGFQsjaavRxeRmhRvzUhvzZccBt9IDEqVHjlE3pTW8t/vp9u
	 sLnJ6iJzRiYpBqoET+2rgoGkOhLSZPcURH5yI07nIgjCRc47FBTfaWjZ0QLskkvtOdnNN
	 vFL+FPFW4uhKcAvB5zh6PrSwzERA3FXXmoCD/yvDgHTKAY7n5W8gCMh60wf9kzr+usFdd
	 TL7ox+SXt9emsXKc6iMT7pYLGMKCPjJXVloNxm0ivcgdLIXC5v3RNSDnTdVxvWuJvzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8OEoMEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB31C606A320;
	Thu, 19 Nov 2026 02:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8OEoMEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2A31F000C4;
	Thu, 19 Nov 2026 02:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056514;
	bh=l5i3VYALNGN7dhQAAM0cz0I466Eko7LkwxgWXA+Apig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8OEoMEoNQcB4iDkY1F3/JblGfvLkXaDReCA6sNvRxVIqY5uKe23zTIj23iX8s8LD
	 /I+ousVk/E3LUVgSf1spDHzhQGzuSRKSP92PPHZ/jsw9XJDGN1M7RJ873bQXw5TYiT
	 xy4H8igGKHmMoGe4aT5lQ7D6mWzgw0gl0JPrFN5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2015/2214] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150131.343281844@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ea53ab9003d8655cf7e94428de3006e86fbd06a0 ]

Each channel's master volume bypass (CxVBP) is in its own
configuration register, C2CFG and C3CFG, not in C1CFG, which holds the
channel 1 bit.

Fixes: c034abf6e503 ("ASoC: add STA32X codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/8576f091aa0fe172ce43f28dacd6a1bf638258c6.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta32x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 86528b930de89..add3af887515f 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -468,8 +468,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
 SOC_SINGLE("Ch1 EQ Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_EQBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch2 EQ Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_EQBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch1 Master Volume Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
-SOC_SINGLE("Ch2 Master Volume Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
-SOC_SINGLE("Ch3 Master Volume Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
+SOC_SINGLE("Ch2 Master Volume Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
+SOC_SINGLE("Ch3 Master Volume Bypass Switch", STA32X_C3CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
 SOC_ENUM("Ch1 Limiter Select", sta32x_limiter_ch1_enum),
 SOC_ENUM("Ch2 Limiter Select", sta32x_limiter_ch2_enum),
 SOC_ENUM("Ch3 Limiter Select", sta32x_limiter_ch3_enum),
-- 
2.53.0



