Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020747;
	b=Tp5pl9exst3+swjcnpl4ALLH8sq5XUhVASI4g2zRzQborOJzZ86AufJMGcfirFSocgrs
	 4V/cyrXMbZIbbwP851suwYBFsHvT6VVU/fivMgtwASMj1fKRGMKs8pItZHwQyRsNt+E+X
	 c7eXmEmf7zPKhcYVYk5rng30CEa2J5dgXZoOZq9bm82ZPQqPo7+Ur5KTE0RXKL9cMbSfx
	 PE/pWVKdbsIzZpjuRMb516D7YiMLQ654/CqL5zOXssRDp/Xg4gkC+gugTjyXDtM/FxPpN
	 P2kEBchJwS5APESefIAIZb/Xx+kZgwBPahVaSkoQ9N8JLI1G7PRsrWVTen6IwmbtXIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xUmDb05mqQbglYCatEldrHMdYdVdol5qAfN/PhdSwgg=;
	b=Rx/WNmblocRrukI2OfQqc5AKgjhzIPxkT8oB0rdfBWBmLwD8Wuuy19CiaDCTNI+v6QcR
	 ATph34cU/AH2MHw4JoE1naX069Pc1QkaBATa1fkAS8sGHYnsYhrfxLhIeKaQVBgM/r+2a
	 7Nwv1jD8P0Oji2AO/3bkqh5PxanQluW/Pk5pmUflt7ASEE/b7bL1OJQLLBMj1vevntd4C
	 GSnzBrEgaPdhJ7GuiNBGkMENcboP8MeGQDlfijqfKlwCR1XNAPtaZ5iGxqh5XIqDXhgea
	 UwLLNcVLPFm+HR7xOld8Ssi8SdUS2NtFVZLtVSw4qoUuDD+l68ofaRBjylX5PQRn8nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDyGUUW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16B5606A330;
	Wed, 18 Nov 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDyGUUW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329DD1F000C6;
	Wed, 18 Nov 2026 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020747;
	bh=xUmDb05mqQbglYCatEldrHMdYdVdol5qAfN/PhdSwgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDyGUUW7cB0fXM0WJJx+yGf4AM+3xlkw6EXxgBQpd3z18d9Of/ef2vmV4IptPDE1+
	 kKz5hlRyQE8sYYmee7byld39LfDvePbAcMmtS2IFfIO1sTs0KKYqvo8lXKv7XLTkep
	 41WsbZJEsjVTI5X281hdRgH5fHF3IoqQO91PtjT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2063/2651] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 15:55:03 +0100
Message-ID: <20261118150400.329199047@linuxfoundation.org>
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
index 3766db457b673..d23b4d559744f 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -491,8 +491,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
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



