Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050515;
	b=1PdU7ma3D0/dToS50JRg2tS1WiVApku5/y6WdFeGY1s3K9dgNlJDpajru8WqaLE/vPAl
	 mJBLfvaZxG77UpoXTZJJFC/r6FPqtcAmCA16BWtxSR7tR4uB/X2+RQXc9PvZx/xusgeJ8
	 TMjmEh4Kldu0BPsIc9CrNN7sY8YYW+rCEny0Lv0jI1eP+bPEIKcUpZyQClxUR8wZ6WRvB
	 3XoImOeTY/0VvFSfUvj0sFtd+hZbZZdigoZgorIqJ5q+5CxaT4aWxWplM67bMG13hmA8z
	 SGSyi05MCFukCdGHXdfz3EyeDANLKZpdV2zrWPhqqTxCw/TWxjDvHGUIl2AZTygttaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sEDaQgAPqYavEaqvEa26QN/lw0QK82/Cx8XJi1QeW9s=;
	b=XPGCqXEbkzJQEkI94vG1Y9LeRg2FlemAGqIPF4uT9VbHa69Zd6nECYUbiQdy+VFl63mu
	 +IjnJaupgBdLeQfrFLdwCzvgPrLSxk+LvUFMEf6eKmVjd1HKcOdIvO9oDBDfQqsAiflDq
	 E4G32yAUX1KYURsBBriJuw2sE5hjyk9fkScycoZwXwuBF2nNI816kFaJBaIyFvG7gQvwc
	 R/bKwRbXBqhyNoOVbradKGiLSxXBmDzUIv/7R18IrdR33VPmqhvyBtW7F+v/VOyJShO8s
	 vNmmHJp7ng2eGmqmM499qB8VWoie6XvEAos5Usu1VMidzwmpNYsoEYJeMAqEYbNHKcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fG7zAhPy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E354606A320;
	Thu, 19 Nov 2026 01:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fG7zAhPy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838AF1F000C4;
	Thu, 19 Nov 2026 01:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050515;
	bh=sEDaQgAPqYavEaqvEa26QN/lw0QK82/Cx8XJi1QeW9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fG7zAhPye6ymtNvxva1DeyXTT5J5o5IRYBnPXxf76w24+iaW6eDUj1tYjKr8xoiM5
	 W1kJC6HV4yI7c8lLeBRqWMqL3aggTfv5bsBL+RrtL8IwQFodOWZUzYPBJZ+pHG2p+R
	 ukGVj3uTRngeGTzYtMrulgPlSVYln2O5fgCPTMJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2735/2857] ASoC: codecs: es*: Modify the registers related to ALC RECOVERY
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150340.097894478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit dd64271fe1b935252cf454a72a558cbdb7be57c5 ]

The register related to "ALC Capture Recovery Level" is ES8326_ALC_RECOVERY,
not ES8326_ALC_LEVEL.

Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Reviewed-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20261026054837.13618-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 555125efd9ad3..83be78b4fd712 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -91,7 +91,7 @@ static const struct snd_kcontrol_new es8326_snd_controls[] = {
 	SOC_SINGLE_TLV("ADC PGA Gain Volume", ES8326_PGAGAIN, 0, 10, 0, adc_analog_pga_tlv),
 	SOC_SINGLE_TLV("ADC Ramp Rate", ES8326_ADC_RAMPRATE, 0, 0x0f, 0, softramp_rate),
 	SOC_SINGLE("ALC Capture Switch", ES8326_ALC_RECOVERY, 3, 1, 0),
-	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_LEVEL,
+	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_RECOVERY,
 			0, 4, 0, drc_recovery_tlv),
 	SOC_ENUM("ALC Capture Winsize", alc_winsize),
 	SOC_SINGLE_TLV("ALC Capture Target Level", ES8326_ALC_LEVEL,
-- 
2.53.0



