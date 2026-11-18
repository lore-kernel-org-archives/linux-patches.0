Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041552;
	b=KeCmIDJSCA5p+9qiDbq6t9ZDlao46/PIU+z3NbALjJSF4EZQ71lJT5ixvNgLpNx45v5M
	 b/w6yQKUOlHIofLfj2feSxzBXEu1JNUE0LZwa648ginFoPwmRU0Xvt1dJVxhuPfK3DcMd
	 +r4czQTNbjABXurnstwsmKe5hkcTgo/APMEfp7oYMK8IAZIHqsgfly5qHGvZ8oWgRfPda
	 oh5QARqOGvBP1ULUTH3Ho5uAHTV3rZj9pSXIVx12o5AMcwpYZptIvmcq5/XHZged4sXDS
	 c73oMsOUIKknfLdjzygRFBNDKa38I/W4I1sS59poGRrFE2s0D7/pLFqkGN1z0lCmZKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y8MMRZJQIYWpaJPs4k4dC1Hwygiok6fncXSJo3gxpbs=;
	b=eY368Swbur+OznkFsasMVv1kAu19jrFA68Gy3Mp3ruiOXYuJ7xrp4532lSmHxbDO8eyX
	 a4FpmynTotqU4DR28WONCwSJn5ybg6ahJfASPzk6aSb+R9fzW38fbF+56wsErWlm3xs/T
	 MeHmyyeaAJnsGQyqHnuBYBeeGvJ8fJ+73Jsko4VICCMHteKXZnvf7mJufrcJljaGfM0pB
	 rYQ00tiE1QowI3bNoopQFkx8lyKrI2B5wbCnkXWgRqTAlHD6j/1MymDcz0skOzrLi0qOF
	 Y9st4mwjKp2+PXfsawlAztqCtknUbuB6SQ8hvoAnc022jm/QO9JR2UAcuikynj1JpmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H07ZePJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F3606A32F;
	Wed, 18 Nov 2026 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H07ZePJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A401F000C4;
	Wed, 18 Nov 2026 22:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041551;
	bh=y8MMRZJQIYWpaJPs4k4dC1Hwygiok6fncXSJo3gxpbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H07ZePJwcd6vQQTg8+hA785eet9vmOpLSIWpFr5eqEYv3Cbz2ycr5uEnQYybQ+Tx8
	 LYSXf83CCxMIQlpJ93b6ILzO5dzW0lnBpXWLuDu7qzMsQeCzau9u+Ln/v5gO3PeekC
	 VKAdqFUn2LSzc/iVBfpqJy2iVDAexcaRHnSDDn3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2855/3318] ASoC: codecs: wm8990: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 15:57:57 +0100
Message-ID: <20261118150446.246837040@linuxfoundation.org>
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
index 5a8e765090af4..ee47de27ad6b7 100644
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



