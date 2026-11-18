Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026700;
	b=3j4mj7vtOVCY19GTeQ3d5KizEhE75IYmkVC6xboatQ5ECAkqg56JZI4Y/sXQWVQxg9ps
	 0e63coF9iMZadaMSiHal34s8M7ZnjtU59hI9kzgHFAMrZ7iLEFrvdid9e/10m2OypNGc/
	 BrJ9p113koiOSZwaPIC8HF0YdxEJyFO628A/ZSOtvtcMsTjsnGBgHgi7TigRI6ggRVXIN
	 yLg5G/2g2Quhh3UrDvVXDLWMHoAJEXyx7oiQd1+O0F8OUVsPW4kpMiNNKx7MV34qW0grV
	 gRXQZT/6VBXvMPJLhxJLAAOUS1I2dIimxSB2gOcVD2oMcxR/Plw0vJMdheHJQIQxL1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mISeJYiybF7lvfZzd0ppmhYoIsrniFUcCNlERHexYU8=;
	b=xlY/CUbn3/6M3nzexXWIP0uj60c6lP+TVJ2o5yM5eRquvNYbLHAOGijUztUaC+BBmfpW
	 cGIQ9JvtUvE9iswlJZ06VbbF9TyUFHheBeCL+ye63XDIomIltssvNjqvG0+G0qrRIi0ct
	 6XhR5GJbY+CjJXZDaZsVvJgczSIY9fvqFJ7xZgbge1lH8nAM7/MKT5WpGtK9BDn4weVs/
	 Cp6VcN1+QNC5A3x6fRUCLfQFVsP5e0t4zAjNB+JT96ttqjuOvOER5ggJeCUNzFcI4YgMW
	 TrvPE0UaLNfOZasdEZstatw4lErStKiZ0NP/sBIrbPRnu78lgiJEl184I17CJlpiZXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcC2xFSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880F0606A32C;
	Wed, 18 Nov 2026 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcC2xFSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC6E1F000C4;
	Wed, 18 Nov 2026 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026700;
	bh=mISeJYiybF7lvfZzd0ppmhYoIsrniFUcCNlERHexYU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcC2xFSwLXph/31HVDpH2jJ3OVYRuIIGYdwBBjiMXdag073+w4GUeYwNwzl5UD7BW
	 2H5S/Q8HABFx4m/4nPeavWeZY0SdZOfbX6wEPPBBsmr7LfF7J8Q79pR1SKeWJ9RQHv
	 EiOAkIcdaKfTCi1q8n4IuQ1kPET+Achk8ANxorkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1511/2151] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 15:54:06 +0100
Message-ID: <20261118150216.897863247@linuxfoundation.org>
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

[ Upstream commit 22bfcedd3febd6acc63ecf8bfd9638210e4b9a5e ]

The Right Output Mixer Right Input Volume (MIXINR_MIXOUTR_VOL) is at
bits 2:0 of Output Mixer6, not at bits 8:6, which hold the IN2LN volume
(IN2LN_MIXOUTR_VOL).

Fixes: 942c435ba79f ("ASoC: Add WM8993 CODEC driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/1ea1d115cea5b183dd51bba5cd9e38157b3482ee.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_hubs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 196ddb224e6dc..1428164cfa8b9 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -427,7 +427,7 @@ SOC_SINGLE_TLV("Right Output Mixer IN2RP Volume",
 SOC_SINGLE_TLV("Right Output Mixer Left Input Volume",
 	       WM8993_OUTPUT_MIXER6, 3, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer Right Input Volume",
-	       WM8993_OUTPUT_MIXER6, 6, 7, 1, outmix_tlv),
+	       WM8993_OUTPUT_MIXER6, 0, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer DAC Volume",
 	       WM8993_OUTPUT_MIXER6, 9, 7, 1, outmix_tlv),
 
-- 
2.53.0



