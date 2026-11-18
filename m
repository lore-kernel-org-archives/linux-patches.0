Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020143;
	b=QoZV8cd9RnOFJNZTJdkapmp+3d82AxM2W9nvEnEvNtpDOGTA/sDk09Wb4AdTgjbYV/Ms
	 i6SPqcSxdtfj3Q/u2QZg+UhNZib63T1NmGQhaEPKAN74rqF2ZW4Wsf/liQ95KAwHxcY5c
	 ZBNTExvpxuPxZBtXGU1A7/XH7FW6BPRyz6F/FjL0aZZnrmEJYKy306VsBYV4Yq64RvTzk
	 Gc5W9Cd6X0z9esBQ8p/+Hb1b+0jWnAoOEsfJ6NRVbR0GUTKA8N3D3DUH+ezz72zI6Y3I4
	 a44KQLIr0/ZHub4HTrnBIQoT0qGMsSUjaMQ9okYzyV+eIC/UNwhGvvMB9jA3WXZRT+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=euOX/FS9BBA6TxTtR1I2XvZ/bJJoGhlPcI/m+PrH7W4=;
	b=YDBCpawtW9Wu+JMeR1Gwo+AUPwHD9tLhoUuoG4x4yS2jMD4s5itkmKzm7ActYePlVQPc
	 kLimJVDfI95oinKLSszUFIVkqYlKPQuSXGA7qD/2mUFuW+efxuPVlvNQuQqgbuEt5JJGU
	 3ot84eJmtVOcd2X6dq2nCNSg+eISdF4b2HpvSICAtNm6OWzDlTK06iR3+9d93ZaMABa9y
	 qV61++npKaUF1Y10iFgDGiEelV33epTfszG8MalIVmwzyqnkF62/UhojuPo7wlIXSd+M5
	 pJWOFlazSfYy5Bx9UHlngMgLxPavyhiq7xOdao3y133KehfHFclk2bnbjWRK2NUPVvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RRH5ChSD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A33606A331;
	Wed, 18 Nov 2026 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RRH5ChSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057A11F000C5;
	Wed, 18 Nov 2026 16:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020143;
	bh=euOX/FS9BBA6TxTtR1I2XvZ/bJJoGhlPcI/m+PrH7W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRH5ChSDNs4tnbuMO5BZsntQ4f/nJY6g+gMD96KdjmhVRxVzMavCJO+4Q0nb1HXH1
	 m/8VltF4EC0WharfzZ9Kcy3UKjAVo+B5ckyrQZM5fgGPeaqW5xs7/wos5edox32lZq
	 y/C5/iJx9U6t1fGqwLR2Hyp+n4qNtgdfc6e2T9JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1848/2651] ASoC: codecs: wm8990: Fix definition of right input PGA controls
Date: Wed, 18 Nov 2026 15:51:28 +0100
Message-ID: <20261118150353.582530477@linuxfoundation.org>
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
index 11dfbbbdcd920..a3843094866b2 100644
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



