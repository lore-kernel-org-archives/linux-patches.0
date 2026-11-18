Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027947;
	b=TMqNcMATcfIrwz320v01xrjZoeZHH6K+cLymXG0tZ/w3wx88B+rPGrJsmKdUxxTBzbxd
	 Gji3jQwrj4Yd/JKq/XArtF71tGqhBWO9qL4AbXboiNk+KzcAMljNe54o+RMYq8f8w4McL
	 NfY/7koZVGmwYvchZimfEixHYNfiDUHqEXfFdh6byNe/blDLTvKNTmWNBlywA42Sj1U8x
	 IdE1um3RvG4XTjy2d0jmHZjnTOloyneFKYRMIFQV+1kxo6hpMJ05w8QAQoNfE8Lm0GnVq
	 JnvlyxOvGNoiAH/AncD6EmeWQo2ascUrslRsbj4nGgwGmlRLeEbks/BZO+4L9m3DpCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEXKMjCivb/CEKRimnkKXVFhG1uRxyzNa/GIGiuOQbM=;
	b=SwaDX5hUTuCfKJYUa+f6yC2/Ek2bm6lWiKqfGYYTNiL66t3uuwgUDLbQnU/QnnXuWU++
	 JzWRazvduXjdNWffMaHdNvpqeI/pqWMkg/ZJoxhTo1xaSkl+CdZmgvzbnUmHS2wQLIXJt
	 jAzPItt6JczLOejCySFC+d4jJtIN1OeFQ4Uxg5Xu2PLvHq0BJyajqHgZcfN+LrJQxewdn
	 9g755nEGvgmq87MZGhs6bA4G0cLosH77p0gn6CSjGgvBcCwuq6FtmtRByEFYwfDSyX0+d
	 wwbQIxOlanNfk78S9DHRIXQqvq1/X8IPJTmPXpj3sG5d/0K3wDNjfGlcxLqMJsguBGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dk5xoOEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B878F606A31C;
	Wed, 18 Nov 2026 18:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dk5xoOEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7341F000C4;
	Wed, 18 Nov 2026 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027947;
	bh=YEXKMjCivb/CEKRimnkKXVFhG1uRxyzNa/GIGiuOQbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dk5xoOEb+WC0EDLPVkjiVFi+D8t2Z0SJMmc7t8FMl0nnOMbXFZvUp5S5omMOFxM14
	 GXSTDk4hH+qS9KrKe7iQ0uMbNBruTLaci0C2BVN08Qpi9e5wrrmQ7RFfoe9TceQWj9
	 lHVOmAOPHg7FA8Do+zBnAXvcRPlwcpM2ptr5zFDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1971/2151] ASoC: codecs: es*: Modify the maximum value of DMIC_GAIN
Date: Wed, 18 Nov 2026 16:01:46 +0100
Message-ID: <20261118150233.545830769@linuxfoundation.org>
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

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 29b867d8351de378704775d3733bfb589c48ab1f ]

The Kcontrol related to DMIC_GAIN affects bits[3:2].
However, the old code sets ES8375_DMIC_GAIN_MAX to 4, which causes the Kcontrol to
affect bits [4:2],this is incorrect. Therefore, change ES8375_DMIC_GAIN_MAX to 3.

Fixes: de2b3119f9f7 ("ASoC: codecs: add support for ES8375")
Reviewed-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20261026054837.13618-3-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8375.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8375.h b/sound/soc/codecs/es8375.h
index 11e3ceec9b682..70e56813fae7a 100644
--- a/sound/soc/codecs/es8375.h
+++ b/sound/soc/codecs/es8375.h
@@ -91,7 +91,7 @@
 
 // Function values
 #define ES8375_ADC_OSR_GAIN_MAX         0x3F
-#define ES8375_DMIC_GAIN_MAX            0x04
+#define ES8375_DMIC_GAIN_MAX            0x03
 #define ES8375_ADC_AUTOMUTE_ATTN_MAX    0x1F
 #define ES8375_AUTOMUTE_NG_MAX          0x07
 #define ES8375_ADC_VOLUME_MAX           0xFF
-- 
2.53.0



