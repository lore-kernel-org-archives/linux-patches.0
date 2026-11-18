Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041557;
	b=NWHMa6XKTfpwVTtQmhHFATU7vfOZ6RQprucqzcUxP3wWQdN6PMChOciIp+2V22mtPMSn
	 yL4tjkIje5rpv4LG5SGm4lda3zub6k54DzlBkIqfTDmE08WgXKJXX1wYbCn1WPWeZn6kq
	 71v7AkS1SZR6IKxWDQwqopa4HO6kclLiJ0XFuMdKZKa+fMOs1ZpNTVSEA3avDkUTbJqzX
	 6LCTqgeU27U57oR6yToqHmH/h38FsavYEJjtPzTC+Zj5ulv4/iFx8mbgdS+6yZ1pypmun
	 fdAYHi5MvzhbhXYsQ/2KNZ//41uXRRaXfhYTFLenyiXzyM4RqS2oVyEJUq6vSzIxGxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGvcdjAPvPZ1uB50o4VuRrXpar8TSwBJgXGePPitmZU=;
	b=VvtO1eURDCs+SdBP6mubriLvnORv/CioCJHp8h5xkCyHkbGWIJ2GmPVY0256J5PW7Ndy
	 3nR0+drS+j6hCI0V5XEp0LoNaZW5LPCEyXonqCiVup/6sJPhmg5NQYot8Ib95H8PxogfW
	 IdCuj0KcMZw8oSvtf+LC6yYu3KHE05TaE/9uHrt6rczKAjwZTekjgyRuM9UwE0mzsdkZL
	 MDH6e12K0wBqxxQy7VyUlc5llee08zcUf+kAJkJrH1UHvgUfL64bcFZV0SYp/ZSdonUCA
	 cyW6yBX/nqeH1rT7/+HNLlmmV/9SFYbJC4S4CiE5BsLHBuiY5SK+n3/5LPtV6MOd1og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZayaAGPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C837C606B60D;
	Wed, 18 Nov 2026 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZayaAGPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E441F000C5;
	Wed, 18 Nov 2026 22:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041557;
	bh=YGvcdjAPvPZ1uB50o4VuRrXpar8TSwBJgXGePPitmZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZayaAGPUgm5UVgT5usvAj06nAnyyx98LOQ8f4hdOsnUEZUvJW47HR0KuJFV15jb00
	 1umk/T5jTpsFcL9JY2KTl802N4JHKsW9SpVNsDT9HMuHpyMFCF4zf7BDfoEUjzeUXx
	 RrEnKgdqz5asgqahmsu7qNZ5HF90V4huYZTtOjeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2857/3318] ASoC: codecs: wm8991: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150446.304572743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 2dfecdc25d4937a36675c0c36ee0addc99e1e7f9 ]

The right input PGA boost (R12MNBST, R34MNBST) and routing (R12MNB,
R34MNB) bits are in Input Mixer4 (R42), not in Input Mixer3 (R41),
where these controls write the left channel bits.

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/5c0196e45dff1769682d885fc26e613648e05436.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 590318aafaea1..a7f1e810a2b09 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -169,8 +169,8 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE("LIN12 PGA Boost", WM8991_INPUT_MIXER3, WM8991_L12MNBST_BIT, 1, 0),
 	SOC_SINGLE("LIN34 PGA Boost", WM8991_INPUT_MIXER3, WM8991_L34MNBST_BIT, 1, 0),
 	/* INMIXR */
-	SOC_SINGLE("RIN12 PGA Boost", WM8991_INPUT_MIXER3, WM8991_R12MNBST_BIT, 1, 0),
-	SOC_SINGLE("RIN34 PGA Boost", WM8991_INPUT_MIXER3, WM8991_R34MNBST_BIT, 1, 0),
+	SOC_SINGLE("RIN12 PGA Boost", WM8991_INPUT_MIXER4, WM8991_R12MNBST_BIT, 1, 0),
+	SOC_SINGLE("RIN34 PGA Boost", WM8991_INPUT_MIXER4, WM8991_R34MNBST_BIT, 1, 0),
 
 	/* LOMIX */
 	SOC_SINGLE_TLV("LOMIX LIN3 Bypass Volume", WM8991_OUTPUT_MIXER3,
@@ -446,9 +446,9 @@ static const struct snd_kcontrol_new wm8991_dapm_inmixr_controls[] = {
 		WM8991_RDBVOL_SHIFT, WM8991_RDBVOL_MASK, 0, in_mix_tlv),
 	SOC_DAPM_SINGLE_TLV("RIN2 Volume", WM8991_INPUT_MIXER6, WM8991_RI2BVOL_SHIFT,
 		7, 0, in_mix_tlv),
-	SOC_DAPM_SINGLE("RINPGA12 Switch", WM8991_INPUT_MIXER3, WM8991_L12MNB_BIT,
+	SOC_DAPM_SINGLE("RINPGA12 Switch", WM8991_INPUT_MIXER4, WM8991_R12MNB_BIT,
 		1, 0),
-	SOC_DAPM_SINGLE("RINPGA34 Switch", WM8991_INPUT_MIXER3, WM8991_L34MNB_BIT,
+	SOC_DAPM_SINGLE("RINPGA34 Switch", WM8991_INPUT_MIXER4, WM8991_R34MNB_BIT,
 		1, 0),
 };
 
-- 
2.53.0



