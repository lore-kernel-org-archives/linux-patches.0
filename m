Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050127;
	b=jHtdTlNI6Gg+oZGfagSxgRFWlnlkn1DY3tHnCe6gifWm4mvgAuRkz+wRh0urCG3iX+qK
	 yJlsQkt5mG4PZOJUeNZJVPJCj5DB1237uaK11gyy92HqfDjfaZLLT6m0V0UBEyxvrawvy
	 QLu6gPN/laXZjwtwODfpRi54bp/SVRXr1epawLcmLIZHhPmzzDC/LektKg+cV0680a+uf
	 sV6981vMUb2AaqcO8yx3US6CrNXTkXvaOZlCs3jq11Us6m2+Tk6+lS0llMpObqRGvK7nU
	 GdpnkwJDAISVJxoIJBlTNoApMKQXqSw58ksM+DnMrsu/aTHl1fxnbDdpqPVIp/zMPdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mex8rPjsdB5TeQ2UFWdxcIqS/CkABmoWiOG3rrtG3Lc=;
	b=SEnvAemWs3LfrQOH5TXpXJGZLjP3npiOUuW2S92Wch/q6aVMnrbV0H3JELFhX5NEwCI3
	 DhxSrWTIqfo6cdlmqBJQZAn/uEP0P82XnsNo+XxWmJ+4mDavTXXvPxS/ixtfxi2HrqoQx
	 cLa2Dj5MAtQKdp0EWHxr4CRnt6lRU35wxlrpHIHw4ePUhY1TEOHtXyOmHcH926lcBkQPg
	 o3JEUk2ZcrisbJfDtv076sT1Adj30JGD/wYaX8YSnSoeZI0I4NPqeusqnT5ppNJcFY5KO
	 Q2U0kyZl8RYoWcNBbnR6dhgGyAMubYhaRtNDkEtJF/OYisYUGF/y+Sw3xMhK+TFRJhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpswRKUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D51606A320;
	Thu, 19 Nov 2026 01:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpswRKUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3C11F000C4;
	Thu, 19 Nov 2026 01:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050127;
	bh=Mex8rPjsdB5TeQ2UFWdxcIqS/CkABmoWiOG3rrtG3Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpswRKUyPw0ApVqhZAAdYomoHsXhOXNuE25ToPLUb15TX3jPpS2mFsQHpnCU+s0Ke
	 Vb7tkt2Te2h2hU5sF+aAPftbzYRU9lkcESDvlb65FzjDvYkkH6KAmkJnbC7T61UbVV
	 mgUM+N8pD7XJumr+z3BrN/eRbYbxR3dPVKtD6Urc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2580/2857] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:00:14 +0100
Message-ID: <20261118150334.391957152@linuxfoundation.org>
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
index 29af9595dac19..8d2b1395822a7 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -465,8 +465,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
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



