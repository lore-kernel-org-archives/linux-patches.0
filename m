Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064188;
	b=qHUGeHhrCMW452byHe/+lzAk/G2NdgNBVTknzTN9fdYtyaYon1yPx9lqlZJtnR3Mcb6g
	 hHQSElCIAZxUPsYg/pRmrzhx3CqSEh5b+RkpRiX6qTGckuTNUKIRRRSW4xsPmD1atFLbb
	 i9NHpglyuFwdXP+BakygGXu3I8JxZjeHK1boiW11Ebv2a47L8RxEiUlIttQeTy6GHtxoj
	 +lTF67XKtswIj0BEbysvV/LCZRolj8nOIEjLFWn02dmwvGBiGFHEvgKxL2FPljcfnBjdK
	 cMo0YFOH07sm/WuiaH3ShQDDm5erPraePgp8TYZLf0DzymDtgYMzL2jsMkGqiMi6iRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=G3xokjhhN8VnWA5fmi0qkSXY7niRyiVjeLQA18V28tI=;
	b=dfz9ctri84NNx+RvRPAInIO0XlLylprVJGZD3xvm24oEdv3DzA8UC3PsVwblWbtPM5de
	 vhTJJexpLIs8kgdLvEx7LSUOQdkdq8dG3dhhgwemt2QnRlZSAZhC9Nf/H4uXPM7IkvMik
	 KuYa4mO8WPzdcHAgrH/UAAK9WJ1M7iVUz7o8BNWMrsbj+XAIa4pvvJ6wDTk9MspcT3B3I
	 3zkI7Me+67xIOkj0w91hLKigQR2Bfi7yHhKtEnyNe5nDGW0InX+7YjF5u468G/4QtMmEV
	 UJXuJgpAjLrON2TjLazmX2FMf+3b1LQNQ/zpOEVJOOvCU1cP5TSpTmxz1K1EMSCTLMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwuF4MQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A777A606E8EF;
	Sat,  7 Nov 2026 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwuF4MQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563901F0089F;
	Sat,  7 Nov 2026 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064187;
	bh=G3xokjhhN8VnWA5fmi0qkSXY7niRyiVjeLQA18V28tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwuF4MQcumOE56kODgvwRjqOdSxKiMJ6Zu9aKPiFfyT8IjPSN6GhAmc7AuPmV9aVA
	 yEeu1W/HGvLybqEaLz5FS0Lnh3BnnhuFuky80uGMGOXOgFus3jFsqscnj13jsb/blj
	 +n1fW6Smn34LPBpAXw2/mVzt7/enh4ZvNBQkpaA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0329/1257] iio: adc: ad4080: enable address ascension for chip identification
Date: Sat,  7 Nov 2026 08:43:45 -0500
Message-ID: <20261107134948.507791675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit c051d08d98771132868abf0cb95b6de95ab3060a ]

The two byte bulk read at AD4080_REG_PRODUCT_ID_L expects PRODUCT_ID_L
followed by PRODUCT_ID_H. After a software reset the AD408x defaults to
descending address mode, so the second byte comes from CHIP_TYPE (0x03)
instead. CHIP_TYPE reads 0x07 on all AD408x parts, so an AD4080 reports
0x0750 rather than 0x0050 and every part logs "Unrecognized CHIP_ID".

Set ADDR_ASC along with SDO_ENABLE before the read. This is the only
multi byte transfer in the driver, so no other access is affected.

Fixes: b66cddc8be72 ("iio: adc: ad4080: fix chip identification")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4080.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad4080.c b/drivers/iio/adc/ad4080.c
index 04cd6628ebffb..7b3b338886b47 100644
--- a/drivers/iio/adc/ad4080.c
+++ b/drivers/iio/adc/ad4080.c
@@ -685,7 +685,8 @@ static int ad4080_setup_channel(struct ad4080_state *st, unsigned int ch)
 		return ret;
 
 	ret = regmap_write(st->regmap[ch], AD4080_REG_INTERFACE_CONFIG_A,
-			   AD4080_INTERFACE_CONFIG_A_SDO_ENABLE);
+			   AD4080_INTERFACE_CONFIG_A_SDO_ENABLE |
+			   AD4080_INTERFACE_CONFIG_A_ADDR_ASC);
 	if (ret)
 		return ret;
 
-- 
2.53.0



