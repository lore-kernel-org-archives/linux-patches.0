Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056180;
	b=TekDJ742VjRiTEg00nIqFxKVcoMQCW3M+l9xoXfjCbvnELtJ+o/3jvCjUkNiEsiIX2uM
	 98vaXPrUnm6jJ1afXVmbvQovxv5qTFb9K13zCTTo6fgqnhkB2i+ts6fQDUkdMzOPoz/im
	 prFh4gnT/BZTV91fL7oIcqCfjPmT4VWVgQVavBu6ierKZF2zUhXD8pkk50/wvW8++1LEE
	 YpEG6bQHxcuNg6b1zl5vCZSQw/amAbiMbUYlMtJyf7vtknEOCh7nJroLuXYiEiJCidqv8
	 C4sePH+4vlgyj2kw6GeqDrOBtncWj4drvVzk5Xgmh0utmMh/YFrpnkE3oJbii/ocSGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lPzCSvU1uLYziVRNNThWbFcWcbjHs2QG92iR6Abo4i0=;
	b=UApz0F5cgO3o2Hr4Huh1RVa98oPouqzaiSC7WpS2PuzAuzfVaioiigR7mShkYfCDWFAR
	 ppbZIDRYaFRSnMVLKzBgUV08cEO1PjMimt55OfdtB45Ge+7TSAsZroijI9Nsu+WDKLB/b
	 /PetgdIWfMn1hAscMreZcwMKW3uPrH3YB9Cml4u41cy0eKnKy1POlsn53l4REioOq9qIR
	 Wue0m6OXt9HKNc641EWf0boyiCro9wpU9Njl4tAFuxc0962OlKvI0O93gCBffiSm8fkOk
	 QqA8TLHRVcHYCoN318Jzhc7LOhBcG/nZv/AJo0ZK/dmiUK+iOEYSjIvJ23Rva0Qylag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jqt2LWXI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB1D606A325;
	Thu, 19 Nov 2026 02:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jqt2LWXI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2B41F000C4;
	Thu, 19 Nov 2026 02:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056180;
	bh=lPzCSvU1uLYziVRNNThWbFcWcbjHs2QG92iR6Abo4i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jqt2LWXISO+7umfm0ehBs86OYP2cdi747MWM8f06pV+K9jbJOcUixAlOh5hSU6QLZ
	 Hv/5i8987WZiaXsY7iuRXy114oM+btrpfNEIK4nS2csd/+EK3AtGb0p8yZNlTDek+0
	 D86i16p+qUh+5/Hs2FhKecfItcUyFwj7q9ILliHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1895/2214] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150126.985512055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4cb0605f6daa2..cc447fd7bc842 100644
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



