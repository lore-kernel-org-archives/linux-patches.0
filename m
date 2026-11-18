Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026510;
	b=b2PUILcKN4sLV79ayl2Q/3l7TJTQ7PdMyiUWiPfMoQBPhD15bG2zJBoWHIOPV4WpHzLr
	 U2lPRXO2w1yXJV+6IjeWfDQ0lz3qSrtgG40yzbKrp5Rlvooh37/9MtaUHPCo5kmPOScRl
	 JvXHdsYayPQCx+7F1quHuOeodMVfkA+VE1BoEP06xdZsieQ457jtr8sM3spuxk4oTr+kX
	 ymXcaVkxCW+DylstfNKnyveac55g9et+buY7rxd3xhqvd1Za9fVLN0rvDaz68qrUD514q
	 XjcQy452XfbuZMXAd57R55uDXIUgF6BPpbGZSdBUPacuHACQ/aniF1aWkAVRMWeCoYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wn2Ln1Zbg39srmN6Pkbhwno5O3T4Fxl2qfGyWpzW9qc=;
	b=WKhFqaNkwhKQ5l4I/RacIlRnsgKqnxJYDlMmZyYKj1/f73kuQ3Y6HNAfcfL6I2P9jtjy
	 MvtrUt6y0h3DAs5L+crt1/hpuoOdOgcYtWNGRDiByHYMjl/HDKpEFDYxOwN+GncKUux02
	 8ohzs+fHoMVa2EAg0Zp/gN8v4+S1EviljvA2B8/RPvt3xvhUV/sghkCc5pGazOgtuHRjG
	 aJK27Uz6uZQ0/SHTrPCKkXF8l8G1Y8EEbOwr1iseyvcNrYSJECCtMP1RLXfgbYosn4voz
	 ay6ypNeh4ZjFhgvD+Uw3Wcn+5cKlbkMv7tssQx03JGBoOQlBUbRUQywtyHM6N8OL7NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OgWuSyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEB1606A32A;
	Wed, 18 Nov 2026 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OgWuSyK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997C51F000C5;
	Wed, 18 Nov 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026510;
	bh=Wn2Ln1Zbg39srmN6Pkbhwno5O3T4Fxl2qfGyWpzW9qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OgWuSyK132D5PS0IoC/lhbg9KYqlqZLQbdGxMymEbpE1DErmipEU1chbdOe1o28P
	 xVSUe68pnvulN38J4HB8VrvG9lQHWOk7MtSF07AiBSYbR0i85pISdb356EuUlk4t8s
	 ivlU2KsKvtc2eFyvenMGcfAKiwP/dAZHHgfeQz8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1459/2151] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150215.056779381@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 2e2da92de9bffd2cdbb9a2558fe60de7f1bb09e3 ]

Disable the gclk and reset the MCK configuration when an error occurs
while enabling the MCK generator.

This prevents the gclk from remaining enabled after a failed clock
configuration.

Fixes: 73ad0df57290 ("ASoC: atmel-i2s: Remove unnecessary audio PLL clock (aclk)")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 762199faf872e..f1f8a2d0008ce 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -466,11 +466,21 @@ static int atmel_i2s_switch_mck_generator(struct atmel_i2s_dev *dev,
 	mr |= ATMEL_I2SC_MR_IMCKMODE_I2SMCK;
 	ret = regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, mr);
 	if (ret)
-		return ret;
+		goto err_disable_gclk;
 
 	/* Finally enable the I2S Master Clock generator. */
-	return regmap_write(dev->regmap, ATMEL_I2SC_CR,
-			    ATMEL_I2SC_CR_CKEN);
+	ret = regmap_write(dev->regmap, ATMEL_I2SC_CR, ATMEL_I2SC_CR_CKEN);
+	if (ret)
+		goto err_reset_mr;
+
+	return 0;
+
+err_reset_mr:
+	regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, 0);
+err_disable_gclk:
+	clk_disable_unprepare(dev->gclk);
+
+	return ret;
 }
 
 static int atmel_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
-- 
2.53.0



