Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027293;
	b=CWAk+GxMFEKi4TspGjs5iECbbxYYMx9cjqpz4DcCmv5tyWnI2jfbLhwRUTb/Io8wkxG0
	 Nhezyih0auzArx/olTHqqkysw4KlXAloRP21f7ToLlnnRA9s4wL/xOktP8e7V1YEZVGcV
	 m+M8cS4a+q7hjtt7SI52TIKzV49CsE2ALvdPzo//qbLn3DGeNWQdOnWlNBLhIVvEX/dcT
	 VxYwMU1zcjPtcn6sOQwVnLw6Eenxb7XnONVQbehLGvSkkLL8FlG6wJzaCzCVLDhVHN1GM
	 33aSneFitfgG0qAzJ9WJ6sLQTJCFyuho0G3qgGcw/wCxvXLDHSxwyW0LeODmNYo/NMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQK6Y+7XSwMOl1a51ix+s8VKwC1LUx9MfQhanD4Eab0=;
	b=VkAYx8dquC57nY2x2MVJgMZlgnC2U6eAM1hHT2qbHg0R/GCqKPAMPQWl2ldyIrfWNrZu
	 O61WycRpJJ7jC9Ahjl4yXzC6nreF1OZ/Oh5OohuZhqBry9sdXlr3dm+BFsEkNIkz3QiBL
	 lRYwwlDOIPVKsgtelhEUJXkSMXPEUmuMBWLAtQ9nw5RPKnk+mH5dCE4oVLP3dsDmn0mAj
	 VvAZHxuZzbRQxCb8f9kXyCRykzhMhPz6lrszsPQjztitXEwEHvAn33UtJ7tUmollb/lyS
	 4783DfWzrzCOvMjgVMp20xgwMos8VpA8Sio85Vq3Kwz4JJ491G4ChyWT3A4Ffz7kO5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJGz47lS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AFE606A31C;
	Wed, 18 Nov 2026 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJGz47lS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5481F000C4;
	Wed, 18 Nov 2026 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027293;
	bh=dQK6Y+7XSwMOl1a51ix+s8VKwC1LUx9MfQhanD4Eab0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJGz47lSQ61IOeyusl7WwgAZa1JFIaz/knrr0kJYOq9mnY04qGUrWNu/r7On6CSdj
	 6vpVrdxita4tpuEb30AEWENhzRnE+JOmWzAceM92uynq1OZSU3+GgC6rgseOBRyGrD
	 aF4vZ9utJwOa8uNIKVTAXDwakF5THykJiGBD9dvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1697/2151] ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level control
Date: Wed, 18 Nov 2026 15:57:12 +0100
Message-ID: <20261118150223.644564108@linuxfoundation.org>
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

[ Upstream commit 0a9efcb663b5a4d468cbb90de29c6dd3794af124 ]

The right channel AGC target level is in RIGHT_CHN_AGC_1, as on the
left, not in RIGHT_CHN_AGC_2, which holds the right noise threshold
and hysteresis.

Fixes: e9a3b57efd28 ("ASoC: codec: tlv320adc3xxx: New codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/09cad9ec9bb382e44cad079a680bdf0f6163567e.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adc3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adc3xxx.c b/sound/soc/codecs/tlv320adc3xxx.c
index 258fbcaf345a8..4f25277f55dcf 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -691,7 +691,7 @@ static const struct snd_kcontrol_new adc3xxx_snd_controls[] = {
 	SOC_DOUBLE_R("AGC Capture Switch", ADC3XXX_LEFT_CHN_AGC_1,
 		     ADC3XXX_RIGHT_CHN_AGC_1, 7, 1, 0),
 	SOC_DOUBLE_R_TLV("AGC Target Level Capture Volume", ADC3XXX_LEFT_CHN_AGC_1,
-		     ADC3XXX_RIGHT_CHN_AGC_2, 4, 0x07, 1, agc_target_tlv),
+		     ADC3XXX_RIGHT_CHN_AGC_1, 4, 0x07, 1, agc_target_tlv),
 	SOC_DOUBLE_R_TLV("AGC Noise Threshold Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
 		     ADC3XXX_RIGHT_CHN_AGC_2, 1, 0x1f, 1, agc_thresh_tlv),
 	SOC_DOUBLE_R_TLV("AGC Hysteresis Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
-- 
2.53.0



