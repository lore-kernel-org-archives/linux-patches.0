Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031944;
	b=i8vr/XiU26ze1Deq2e1bcE0HSST7LxbmkDjZB90/j/TiEH32i0nYTI+VDbODyjtQN1Yv
	 3hWeEg06ZoeUiNi73v3aREiQzpyIbYDUENgCoewbZDjGb8PmoSE4fX1lhLaGe0CfrDAwd
	 knEryWIOZOtsxNxqP/x57572zFA7XMV1dPzQ2tjrhWNhkS+7uOa6sy2Q42F8Px+rFQSBw
	 w+o05+Wsgr7CMaDtG7webIlKoGtmSjHsTTY7tqQVHdh8UoQmjzPcU5WXnFXYzZ4Pw2IIH
	 7rsIxUfOi2hTLTKcOlRHerL1WUd024jjECLgedTXlcEMvaMUYsrj+saBeCXLA5YlVHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Au6l5CRzyMk6fDXjr4BcRdUPIG/gxQlRbZ8kFyfBEiI=;
	b=R4DjzjIqrk5DMvIzIP1wZRvXAFmlEmLlVDjYoa9ToyRghak4/nSTwHFNdI+D82Vqh4AF
	 GwvPFby8hMaN4i8r30+0jnSK9obnSJG+FC2/1rV9LqOd5cmKWwSFX9XI6Awilf+7badMj
	 7Gqjz88ULDRaVy4mNwcv2X694o5odCUAGt2CT30nV9Mf1T0brHkFYJxNCiPd1U6bzxMKu
	 RDGdNs9IZJ0jMyFV7rIiPwrZrgBDW9vNE/EN9o4vodgF7xHMp6FwzHdSULj/82X6IB7JM
	 ff+pB65ZqH4iI54urtlDp6it3EC7TXyqY5DQG1YIOJfQpsOpRz0FVMy2PiS5Cup/g5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k29yFzUY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB1606A335;
	Wed, 18 Nov 2026 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k29yFzUY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B421F000C4;
	Wed, 18 Nov 2026 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031944;
	bh=Au6l5CRzyMk6fDXjr4BcRdUPIG/gxQlRbZ8kFyfBEiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k29yFzUYsDUj33siS0qGpNs2oLSz3V9SlzI5JWW1E6nWvEX2EGnnZQAb3+DaZcCdz
	 JIoBtdH6uBGgPKx/syY5+uu9L+likNiE9xibOMXqv7SKkNp0OeH0ZXDKumRVLEiSkF
	 3k1T3b9K74R6EIDrZ25C2Mp7jRgKYOB0XPWkHqo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1195/1756] ASoC: codecs: wm8990: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 15:55:22 +0100
Message-ID: <20261118150057.435447812@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 5bd6d05197affaf5a2d7fae0e06e7373fd839b7c ]

The right input PGA boost (R12MNBST, R34MNBST) and routing (R12MNB,
R34MNB) bits are in Input Mixer4 (R42), not in Input Mixer3 (R41),
where these controls write the left channel bits.

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/818cf8d7ae81fa46c67cd5b4d01291a63f44c9a1.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 573bd3d487ba5..d44d671bd1ded 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -97,8 +97,8 @@ static const struct snd_kcontrol_new wm8990_snd_controls[] = {
 SOC_SINGLE("LIN12 PGA Boost", WM8990_INPUT_MIXER3, WM8990_L12MNBST_BIT, 1, 0),
 SOC_SINGLE("LIN34 PGA Boost", WM8990_INPUT_MIXER3, WM8990_L34MNBST_BIT, 1, 0),
 /* INMIXR */
-SOC_SINGLE("RIN12 PGA Boost", WM8990_INPUT_MIXER3, WM8990_R12MNBST_BIT, 1, 0),
-SOC_SINGLE("RIN34 PGA Boost", WM8990_INPUT_MIXER3, WM8990_R34MNBST_BIT, 1, 0),
+SOC_SINGLE("RIN12 PGA Boost", WM8990_INPUT_MIXER4, WM8990_R12MNBST_BIT, 1, 0),
+SOC_SINGLE("RIN34 PGA Boost", WM8990_INPUT_MIXER4, WM8990_R34MNBST_BIT, 1, 0),
 
 /* LOMIX */
 SOC_SINGLE_TLV("LOMIX LIN3 Bypass Volume", WM8990_OUTPUT_MIXER3,
@@ -377,9 +377,9 @@ SOC_DAPM_SINGLE_TLV("Record Right Volume", WM8990_INPUT_MIXER4,
 	WM8990_RDBVOL_SHIFT, WM8990_RDBVOL_MASK, 0, in_mix_tlv),
 SOC_DAPM_SINGLE_TLV("RIN2 Volume", WM8990_INPUT_MIXER6, WM8990_RI2BVOL_SHIFT,
 	7, 0, in_mix_tlv),
-SOC_DAPM_SINGLE("RINPGA12 Switch", WM8990_INPUT_MIXER3, WM8990_L12MNB_BIT,
+SOC_DAPM_SINGLE("RINPGA12 Switch", WM8990_INPUT_MIXER4, WM8990_R12MNB_BIT,
 	1, 0),
-SOC_DAPM_SINGLE("RINPGA34 Switch", WM8990_INPUT_MIXER3, WM8990_L34MNB_BIT,
+SOC_DAPM_SINGLE("RINPGA34 Switch", WM8990_INPUT_MIXER4, WM8990_R34MNB_BIT,
 	1, 0),
 };
 
-- 
2.53.0



