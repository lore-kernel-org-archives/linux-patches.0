Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B6B33A02F;
	Tue, 11 Nov 2025 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823421; cv=none; b=ZLC5pgkO2s1r2zRmTy0EZCykmsqypVa/toPb8LmUW7+v5w8NvlCsmnHBPAWTuk5BiN1udocX/bjz65emn3o3Dj3XyKgyjsexykqF2YRAxquhs2mPl5AcikLBuhuNgHBJIY4nLwrykSF6SNraWghV1Ooh4ipVqJcc67dej/vmvWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823421; c=relaxed/simple;
	bh=Irk2++lEsdsyDQVT5e9MF2aajX2nO9Nf3EIrTsH1j0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3v8Ii/TZuqOIomugFbhskv6tLRvLnutO4vgRwgWuFAHbuKyd/NVaD5kTLcWnzsy/fllHbiNZsl3D4AIkP7ChIzOVTBy1S3Zh5esfWv9Ba30HwzsyTLKqi92cWUYnNL4ztaThsDzmMscHsEssDvsmh/Pn1C+6yybjuX065LoLfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzlseRLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzlseRLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F239AC4CEF5;
	Tue, 11 Nov 2025 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823421;
	bh=Irk2++lEsdsyDQVT5e9MF2aajX2nO9Nf3EIrTsH1j0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzlseRLXfl1fj/TqzEgTRG6GxyK2QF9pQlRcwYfYCMuZwQKrDnB0iSo04TI1YKEXl
	 Ft4tsYc92lOTdpRhpD9PMEkCYSX0//t+7e1q9/gKXVouNOuQbJ8uWPjp2XdIKdQMbf
	 w0FsFnAdkB1q6E+BUQuw4sQDIQwiTxO/7iqGuazU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shimrra Shai <shimrrashai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 297/849] ASoC: es8323: enable DAPM power widgets for playback DAC and output
Date: Tue, 11 Nov 2025 09:37:47 +0900
Message-ID: <20251111004543.590163255@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shimrra Shai <shimrrashai@gmail.com>

[ Upstream commit 258384d8ce365dddd6c5c15204de8ccd53a7ab0a ]

Enable DAPM widgets for power and volume control of playback.

Signed-off-by: Shimrra Shai <shimrrashai@gmail.com>
Link: https://patch.msgid.link/20250814014919.87170-1-shimrrashai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8323.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index a9822998199fb..70d348ff3b437 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -211,8 +211,8 @@ static const struct snd_soc_dapm_widget es8323_dapm_widgets[] = {
 
 	SND_SOC_DAPM_ADC("Right ADC", "Right Capture", SND_SOC_NOPM, 4, 1),
 	SND_SOC_DAPM_ADC("Left ADC", "Left Capture", SND_SOC_NOPM, 5, 1),
-	SND_SOC_DAPM_DAC("Right DAC", "Right Playback", SND_SOC_NOPM, 6, 1),
-	SND_SOC_DAPM_DAC("Left DAC", "Left Playback", SND_SOC_NOPM, 7, 1),
+	SND_SOC_DAPM_DAC("Right DAC", "Right Playback", ES8323_DACPOWER, 6, 1),
+	SND_SOC_DAPM_DAC("Left DAC", "Left Playback", ES8323_DACPOWER, 7, 1),
 
 	SND_SOC_DAPM_MIXER("Left Mixer", SND_SOC_NOPM, 0, 0,
 			   &es8323_left_mixer_controls[0],
@@ -223,10 +223,10 @@ static const struct snd_soc_dapm_widget es8323_dapm_widgets[] = {
 
 	SND_SOC_DAPM_PGA("Right ADC Power", SND_SOC_NOPM, 6, 1, NULL, 0),
 	SND_SOC_DAPM_PGA("Left ADC Power", SND_SOC_NOPM, 7, 1, NULL, 0),
-	SND_SOC_DAPM_PGA("Right Out 2", SND_SOC_NOPM, 2, 0, NULL, 0),
-	SND_SOC_DAPM_PGA("Left Out 2", SND_SOC_NOPM, 3, 0, NULL, 0),
-	SND_SOC_DAPM_PGA("Right Out 1", SND_SOC_NOPM, 4, 0, NULL, 0),
-	SND_SOC_DAPM_PGA("Left Out 1", SND_SOC_NOPM, 5, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Right Out 2", ES8323_DACPOWER, 2, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Left Out 2", ES8323_DACPOWER, 3, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Right Out 1", ES8323_DACPOWER, 4, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Left Out 1", ES8323_DACPOWER, 5, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("LAMP", ES8323_ADCCONTROL1, 4, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("RAMP", ES8323_ADCCONTROL1, 0, 0, NULL, 0),
 
-- 
2.51.0



