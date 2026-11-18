Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020163;
	b=MICmabHeIhocOp1i70x6skDMkFLoQ+6ti1Y7Rfq3rXLf54EW9aDbKmPHTIt49zJM38iM
	 BzMuseIQSFxsHe/XbYZxynmI03Ct0C6v4lKkLdW+k1FaCx/EilU4zQ1ZO7x4Z2UaC6Hcv
	 bUsmRpV8p6E2FOEI5/K8/VSvpaOBRCdqIAzc66i/iin+pfG3eSslIFiwRYiViDPQiHuAA
	 aWbCKAsyg5UFUsqN4ZMA0v1ChUGLhKErfgyGXKtIuRHo+vNM/25kz9IxYVaaDfB+uFkIE
	 v6k08xxNCyFQ7f97ldEFmSealdzfvzsCTkmfyfNT6NiFk6j2dfDfbVP0gz26E5YGTvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/6bvIC/WY9gDXZHt1KGDhoM7sAAtVnEfN7T6funud0=;
	b=JQ+xcL/lYuVCK/9MNAcivsdf326QRZ1w3mAAmiJ1fIZIzATY4DADdjzCdLmAHbb7D9bo
	 I2M5YNb7U9dj2Bso5zlyqbpSl0X+jnsd4lXQs51k7FZcT6KaGfXMrjTcCmRaRgTwLnz+C
	 zWlAIxDmb1x/ea8raVt/5ZNRpZZNrhgqrR1bZF+j7g/sVjfYd1cDeiT26L/eCtTempDJS
	 zm/hj1kENlwOjYnuvd4qbNrYKEKzMRdpKGDIVYZCzvkrTfI1zfjiSauHcgML1ww/iqspO
	 yN38SlyhsStdvKxddKdvQGcWGSJr5k84zCkWb8SGA11fc6tmHMiE9fv3yi2qxe7K2tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPp6HdBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88968606A336;
	Wed, 18 Nov 2026 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPp6HdBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACFF1F000C4;
	Wed, 18 Nov 2026 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020163;
	bh=M/6bvIC/WY9gDXZHt1KGDhoM7sAAtVnEfN7T6funud0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPp6HdBt//KjxvnLWZ4pJH9FS20n1yTUvGYlsqPFZLHKo8VFrBPpLOUI8+MPCUJuP
	 Xq7f+WTOpK8oqhdZ2jjU4+RA2vROfzXL2iNV2Q74HqcaIZxxu+7gnKnER05Z5Ps8C9
	 vDbfu4xj4UYKa7taXAlOi4UmCDyjGT2502Cr3n5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1854/2651] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150353.774214930@linuxfoundation.org>
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

[ Upstream commit 291d81d628f3453026b029507a26b856056e4fdc ]

The noise gate hold time (NG_HLD) is at bits 6:5 of each WM8958 DAC
noise gate register, not at bits 3:1, which hold the threshold
(NG_THR).

Fixes: 1ddc07d0f13a ("ASoC: Add WM8958 noise gate support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/8acff0f7314eef9eb3d290ca7855a87052d7e706.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 58cfdd60d8ab1..3214cf2a4c916 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -701,17 +701,17 @@ static const char *wm8958_ng_text[] = {
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac1_ng_hold,
 			    WM8958_AIF1_DAC1_NOISE_GATE,
-			    WM8958_AIF1DAC1_NG_THR_SHIFT,
+			    WM8958_AIF1DAC1_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac2_ng_hold,
 			    WM8958_AIF1_DAC2_NOISE_GATE,
-			    WM8958_AIF1DAC2_NG_THR_SHIFT,
+			    WM8958_AIF1DAC2_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif2dac_ng_hold,
 			    WM8958_AIF2_DAC_NOISE_GATE,
-			    WM8958_AIF2DAC_NG_THR_SHIFT,
+			    WM8958_AIF2DAC_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static const struct snd_kcontrol_new wm8958_snd_controls[] = {
-- 
2.53.0



