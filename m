Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061679;
	b=pPqXINb6K8qlUwulxfRt426NRJOF+JZeQ0fUFUEIJstBeXOl7RyQ1Q4rehkyYI2xta46
	 +6FLagx0wleVV6Mtf4ZT/ZkBeeLMRCjFZkkPttPtF5Vpw5+5G81G0HbczIWKOS3n0FiiU
	 2eN0CBfU2h2vonq+ZHQK68s3ZQww3x4wtGwp17/5f5Zq/S0NiW8uFeEUKkIqagz+6yY4V
	 lwTHvrgcUPWXqd0albCmJkWB0B6poqGppSG49na2BLEshw2eV/hi1NhlWTD24A2YboNqu
	 tU61vlBLwj+NIgmTQnr3v4Yr8lTdt1ksIz7dUtrmH+FHXeJrsqSgHLDe5YMlG2GFZpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WmG59j7sg/+JKrjIc38dVwhnvxzXVxZrapxJTIAA2A=;
	b=IW0Dq7Azav4iI30qwubHdsPEfqzwuyV8azbknGVeBXQ5bvtD0QW+266qmyTCEq03BOuM
	 gkp28d7t96cie6dDgv0fQ1kox57uon1b19zDxHgncpdVkoZa90lbqTIPYQ/4bfumymaFi
	 SsutACbkvTJJBqwo/gmb9JqJdRgT1Gb5cFBJXs03bOE2HLiOo3vpVIu5vqAHdYRSpB/yF
	 cOlFivXaNOsRMhdlFvbFZGXha6qZrBrgYv8vyvtYBW83cBkPJJq74eMNPY8R0W2aCblDU
	 wL5NCSdOPkzBNmmTmimU3pgxBfR6LijKymm/KctKXEHRrSaAtLc/d49eoFccSzvBlxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebOnhnCk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476E7606A32A;
	Thu, 19 Nov 2026 04:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebOnhnCk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB561F000C4;
	Thu, 19 Nov 2026 04:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061679;
	bh=9WmG59j7sg/+JKrjIc38dVwhnvxzXVxZrapxJTIAA2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebOnhnCkG83YZFcYIgCgG8aAmfXew5cxouD3T3gUVIznY8lCzD2OtPoZ2o9CUmpHI
	 Y4VaFT1tUXMDyxIgmF3TowqvTScMtwUcMmrffA5MUtolNsay2yXGSUI5RiT2AFJ5rG
	 UHK9mR/HmqzlY2mGLVfNzMRjILR3nfNTSnZQbB9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1637/1848] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150028.100049259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit a747ec6e12cf7a71e42567a479af18b930890d9d ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6d6f8b832705 ("ASoC: WM8985: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/00ae032401aaad740b61d664c861b72d2e5ed520.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8985.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index 3f27482349b2a..46a3887ed0567 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -327,7 +327,7 @@ static const struct snd_kcontrol_new wm8985_common_snd_controls[] = {
 		8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8985_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8985_LEFT_DAC_DIGITAL_VOL,
 		WM8985_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



