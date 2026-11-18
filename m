Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049776;
	b=TZpYt1ZZsDldNtAHcAprzpu5xsFHBCtFGVHHf9Rbl0+diykU+aMmVvtvW7TJf921NvJD
	 wtOMeC9fVBv/I8MPZnglYYCpakKIxWg4BvauysRip0Kw04NIhv2MWhGTUOKbkvEPVaT8l
	 jaMuw+5IMSZ47dJF2fZi9pwb7N03r/hDlBOucbR0Nv/65qLj++7Ywxi6+PpVhuic1EVgS
	 5H/7pKXjS+kmQRbgYf/46isbZ+IX+3Mp53T/zNOvadGf+cNUIsTtww53oUAXOIe/6i8SK
	 7NlT1iro+bncueQTr1GrTIGy3Txhs6i4iz05iTrry41fIwSukV7S359YbfEJI/MMQGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GOQisW2wXEYzl5ECFJvMQIMUKfY5oP+JkJfbexNAA9Q=;
	b=CxaeCoP25Y23Ho/lpw9jAJC60c6nWeGSnvQ2/i5fxdZNR17p5NFcbwk+KSURLG0Fk7+1
	 UOW/xdc177i3V3Gpdd2v7EnoKNpMND+sfZuovodbAH+i13Vf79g2jMDYyJ5u+Xx5+Uuzo
	 YHdHhb/Qvuf5qJxT3m67jG3Vmxzry27Dpq1rBm+kilkg3DCyiW9V9DB/U5kCPMxlbqvfD
	 J6HVFPnd0tBbrrGcT47Y+Bgo0M0DMtH1ir+JsOjAkNVgw7pHn81CzHmXbeRmOMO8Z+3Nt
	 896Bfy2qEDmthg6K2drRsERzsXSgnIVpTAu9L8JhE0Nv7u/PdvUceDTnnW56VV2uy9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wYbgLDB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857A606A31C;
	Thu, 19 Nov 2026 00:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wYbgLDB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DD21F000C4;
	Thu, 19 Nov 2026 00:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049776;
	bh=GOQisW2wXEYzl5ECFJvMQIMUKfY5oP+JkJfbexNAA9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYbgLDB8TbE7unl6Sd3wuwIivVmQkBNg0/xV6lSSeeODiVTqUK6YRSDjFvAsMKXIQ
	 eeyX4uTghjzF2DPE59CDvc+YOHPCx/Gdbaqk7h+l6RYd2ko2bAJYyZ8fQMhueLhBOs
	 zqqUlbRKNyDDcoyrCGoU6wLH+8+gcwpFJDd9WhQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2472/2857] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:58:26 +0100
Message-ID: <20261118150330.569985291@linuxfoundation.org>
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
index 751aa67308337..b86466fa030ed 100644
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



