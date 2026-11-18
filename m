Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027177;
	b=a2GyBJ2Y/nwVWFiW0CHWetcZmwpPK2brFVr5381wWk+mbucqfgMOioHINJ+I8tTR8HYV
	 RtOtEop2JpGgYgeWPShTQdvrtVOY1vCNQWIVa6uMmp7mwt4swZ4G4p+n6JXUYN1kCQeBt
	 xaFiU3iS+MdGj+FILtWThtV9FxYnGSdbWSLPRf8yBUghSIHn5UANJigP5qK63onaAE61N
	 +uXPedzMQ+cOwqyArVSo8zk0bUOigTPAWGc+k0s+G540VY+8oKpopRtafp7z3qmhTEFSw
	 W5eXAxrvix2DpOo3TaQhOZkNfSxBvqPz2pK7nFu/qy0cAk3IYv/+PA4YEmnFba9AoQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aYH9T7dJ4BWLXvcyAjAohwliY5bTteGySBGnq8MckbY=;
	b=3ZTXzlmsMMj2TKiaYdkJ/vWhXm8igxCsl+YUv3nAOl8QO1WBpdTq75cnIN/Yl6jdUQ6c
	 /4BZjqXu9vMBAXSI3Fguxa0Uiti6T+XrCg/k0iFwW6AEEfLgVUxXFWvDht+GK4pLL5ePL
	 72Me9J9Sl98jSdhZtdS2xAz/4bEIW0yqb647QEMMNv8D8gwLXAPODh8HSaU9cPlXOcUtV
	 adiY5eiSbdNmgxfIf0NSjnNvpwEUWM5CdCuwi+uygrv2bOo3huQOSwzUBLiBCa+0K3YLJ
	 SH/nGzCYXx/6eZbHS7CYyI69JXIfdC9oG17SDVzSC6TlWSJwYeEeKnEfcg8KatO/T9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h07vcAN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8B1606A31C;
	Wed, 18 Nov 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h07vcAN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5DC1F000C4;
	Wed, 18 Nov 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027177;
	bh=aYH9T7dJ4BWLXvcyAjAohwliY5bTteGySBGnq8MckbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h07vcAN1Dlco+fwso2tlNijz2N1xTG97MZ05i4M0WhD2kC2YyUWezAIwRqbfPMxHV
	 MCfGG7fMplFUtQNaSImGXUcDjRtV9fXOYU73aypQJKA2jwwB+UOFwB3RtUMW0HYB1D
	 dyVuUN1wXEsVWea+nXOOolQr+NIAkOVttWSKZUfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1698/2151] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 15:57:13 +0100
Message-ID: <20261118150223.679399951@linuxfoundation.org>
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
index 32c818ed587aa..1c3e94fffe79e 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -494,8 +494,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
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



