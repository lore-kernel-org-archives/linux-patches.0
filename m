Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020152;
	b=W37aOKtq1dNBO6W7AfbMAGHXi2OG5erlpRosG0C2zXs5RV1o9vXduDUUuaTQtMrF/N9M
	 4jgraIVJn23CyUMneVxPqkc3vh49xlc5vijkzIFJfuJuHro+yChzKSZLCPbgJFQehNomy
	 nenGrBhL3lcTJ2i2Q7TRUo6+H99W9TzZhxguD/AtgZDrOlRdDQQCsmEndM8SyZ/0HSV/X
	 adwrI6IRcJRWEX3zUY26/JGJiquiKPXrKpyh8b8Wn+rQ8r+0LdMW2sm2gr80eFi2cxcDO
	 6dJ+VRzruKyLcFL2rkRO/nSo7FCnR7UZC0reVg87TcaaWyBC8U2yC+ppMqEuHJaCqzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJGFQM4VdexPZ4VxV69gR1nBTQgnrRigy+xuOupUcyI=;
	b=0SjzzZ7V61IBfhIRQRd2OGdkdIbCvNqiwhcB58Q+H/b6MVy2R4cTKADivdEyUhUaapO8
	 PspG2LPlYJVYYuH7R8ZQY7jE4NFs8Xfh1mBSPa68j++r8apZf1RNmKHW1biO81Tn9aVdX
	 N2pGqmul6e4xG9mkwso/ONjHHNltVzrNSZywqjuwHTN9+E3rWPiDDaM2Qezx6henybqxA
	 5u32g08qmtvALqoa3NVJZdro56lrb//C2n/IX1LEvpL+y9Faq8DsyqFSOX9Z5Wd0H0CRE
	 uGswoA4nSYU8cCchZNFoVGVrL8FvO4JT8+IfXf60/lpBHlpUiMy91V10H1t7V7G17kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuN8i6BE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1680260A261B;
	Wed, 18 Nov 2026 16:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuN8i6BE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675361F000CC;
	Wed, 18 Nov 2026 16:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020151;
	bh=pJGFQM4VdexPZ4VxV69gR1nBTQgnrRigy+xuOupUcyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuN8i6BEcyl79Rt1mUgbYvIDjHVUT2WgBhIP2RGqni9Rk1FqJDzSxGK+c58b1Viob
	 67+xzlDRbDvniltkmgMBrcWncz++BvO55J/o0kXhibJe+MqCG6JZk3c/8CuI7ArQTg
	 EwEJRQyLvkAcSzrZK9R8bXkgsBAK0EhdxCJNwWzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1851/2651] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:51:31 +0100
Message-ID: <20261118150353.678687110@linuxfoundation.org>
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

[ Upstream commit fee722db39c2a1f18c944f747271fd1e131910a6 ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/c6e230b0e7d7e3db2136cc751e0b563030dbc16d.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 157b48f02451a..471310257123b 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -184,7 +184,7 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
 		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
 	SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
-		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
+		WM8991_LLBLOVOL_SHIFT, WM8991_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 	/* ROMIX */
 	SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8991_OUTPUT_MIXER4,
-- 
2.53.0



