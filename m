Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027353;
	b=AbSBsbcLtEHsXMUTFFBYLbeM7vobigkzZV/c70tJSFS87z/NoTwYDV0vdbaRMXrDKVND
	 I31oNwxt2NEMudTOVIDmgIrTTlE518zQ+fYbadODPxuVw6B5OW0D2Tw4EwGIHhjSCHvrF
	 4punBBnpQsvALrvPi8K+C1kIZkhkOEKCGIexkR4gr4wJ9ZjwQ7LmxA7NRvuSp2EsJiaZc
	 6t1jXhw6WqmLP0z8qbqFqTxm3A2mwfNRRkqyrBYqy0pTLw57kmr0DdGhOU8UfUim50C/X
	 4vhRT8VB3NsEBNfF3kGRUBq5z7fpZkU1KgkE2KyYD/QxmhNUkmy+DWkFQ9YKFtW7r0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p83g6yge75conaPutgI38HHfS6c7K0eeN6BdvllCEfY=;
	b=qVPl8SXo75dsA5D1awE4LnJnRGrC+AscwExtVvWT0NpTMXUvgy2R6OjdsFxpYtk3Y/Ve
	 1d1T29yzYhGKItjMu+wXwOirHHjMAlfUp590TCaZf1tNZxeFdVKP7F6dnjo+OY3BnfyWi
	 ZzZa9tuJ9PYk3cqsQEWc91WVVbCf/2Ne4klKab8AYLldti+H877wgLo10WzXxxH6fWTPu
	 D1hJeicxK9v41ZkA4yTGA5iw/dCWAfkO4/3cjBRih8chpnqFK+yaPGVYlzXm4S8OAwG4H
	 6OF12/zznUiQup3+azdT7n8oTvYORdGLH2RTQKUzYTvYW+WmJFBjRupL1VEHMRSY3JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CelKQS47;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6F0606A337;
	Wed, 18 Nov 2026 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CelKQS47
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA61F000C5;
	Wed, 18 Nov 2026 18:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027352;
	bh=p83g6yge75conaPutgI38HHfS6c7K0eeN6BdvllCEfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CelKQS47S0Y9Bl5c6y807eJFZWDmIPkacK/XxIZOkfKpPaa6I/rsYccVK4xvydvB1
	 vsmSjbm99JBc90fHVHDJU3ViczsD1B/M0Hv4Az3Lx249hoEJS0nx5SGlE5euMdLh1s
	 jJL0R4Wi96QtYDnDvUM52dajLuPd9wBWD8vXiXpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1759/2151] ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control
Date: Wed, 18 Nov 2026 15:58:14 +0100
Message-ID: <20261118150225.922433018@linuxfoundation.org>
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

[ Upstream commit f28c09b7e62fb5ead65bdfab93012a86d64b6540 ]

The TAS2505 HP volume is bits 6:0 of page 1 register 22, not of
register 16, which holds the HP driver mute (bit 6) and gain
(bits 5:0).

Fixes: 2169d6a0f072 ("ASoC: tlv320aic32x4: Fix TAS2505 volume controls")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/e50b88689e8efd353ee597a6692ab4db30aa63e7.1792135145.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4.c | 2 +-
 sound/soc/codecs/tlv320aic32x4.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 5f0335cbca74c..d733a41d96556 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1074,7 +1074,7 @@ static const struct snd_kcontrol_new aic32x4_tas2505_snd_controls[] = {
 	SOC_ENUM("DAC Playback PowerTune Switch", l_ptm_enum),
 
 	SOC_SINGLE_TLV("HP Driver Gain Volume",
-		       AIC32X4_HPLGAIN, 0, 0x74, 1, tlv_tas_driver_gain),
+		       TAS2505_HPVOL, 0, 0x74, 1, tlv_tas_driver_gain),
 	SOC_SINGLE("HP DAC Playback Switch", AIC32X4_HPLGAIN, 6, 1, 1),
 
 	SOC_SINGLE_TLV("Speaker Driver Playback Volume",
diff --git a/sound/soc/codecs/tlv320aic32x4.h b/sound/soc/codecs/tlv320aic32x4.h
index 3bc6ae355ea81..9652920773077 100644
--- a/sound/soc/codecs/tlv320aic32x4.h
+++ b/sound/soc/codecs/tlv320aic32x4.h
@@ -94,6 +94,7 @@ int aic32x4_register_clocks(struct device *dev, const char *mclk_name);
 #define	AIC32X4_LOLGAIN		AIC32X4_REG(1, 18)
 #define	AIC32X4_LORGAIN		AIC32X4_REG(1, 19)
 #define AIC32X4_HEADSTART	AIC32X4_REG(1, 20)
+#define TAS2505_HPVOL		AIC32X4_REG(1, 22)
 #define TAS2505_SPK		AIC32X4_REG(1, 45)
 #define TAS2505_SPKVOL1		AIC32X4_REG(1, 46)
 #define TAS2505_SPKVOL2		AIC32X4_REG(1, 48)
-- 
2.53.0



