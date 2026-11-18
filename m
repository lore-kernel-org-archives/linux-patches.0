Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025988;
	b=Ee/zNkA0iNTeYnlAR/jEaECDlt09TU8gCqkSW72WCmxAnMRURZjvlyRgYiVswCuUWJ0q
	 wrB2JytmkDGyg9Fi5T3lxbqbC6V2lyZEbaWn+fZ+a+FPlloT576PvKPFUVpSM8p4t7qy1
	 n3SVv94vy0u8k3PXC1DerWqh0W1F68pg0AcQNw7f8lp3LnCQcwraX8Z71kp45higPxqir
	 D0jlfX7cA9KGc2nFNZb1CPFMDZOZpGO0PozpSbQk8H2jPQUtO6Rr2RqPorVYkV4vysd9d
	 BsJuOTQhIOIQKq5BY3W8Y+AGOSB+VFgWV6vaq7pDkgeT6a/udPdsQPjQtrCFL88qKjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fOobGz8RfPjmIfldsBTPE4/X1bfEdnpsBYmpQhNyljs=;
	b=E9itnXpFtYHEQ9oj4ZHt7MDrErfRLeOT+FbWCR2YRZxmgNbpbFJgG626aVHAbY6YUFwF
	 6ug6YnmB57q2Mc8i8DYCNKl+R/mnHYxeUJEipXl/GU2da5JB02CJ2+dp0vJEPScccSZwD
	 v1DjYBAIPXMw4tX8FGdLknjtaATWqfISyii6vkiicb4rSpkOiugpMHJbvkGFEfkvMYbx7
	 oJMRFcJb1lwjrC3bzzuTEZAPbzdry9vEayJHZjHWNsJxSm+lrGjzSefMBjZS4D9k8J1Qk
	 yNcMjYuSm3gcLTUCQWdgnCttzVkyWalDGeOGXoz4DicyIkAR3u3n6r0LwZtFOUoHVUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quhiIWjD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B256C606A332;
	Wed, 18 Nov 2026 18:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quhiIWjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9031F000C4;
	Wed, 18 Nov 2026 18:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025988;
	bh=fOobGz8RfPjmIfldsBTPE4/X1bfEdnpsBYmpQhNyljs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quhiIWjD4+M8/RZcrhp7TpNSFTdBGQMzklBetMCcajB+DZdJ+T8xt3HkB1b1yEcW6
	 mPOL82t8j1hwyAuqDwSAQPgdnS4J+D1bcBG8OmQKqNoaG7PMoEJWR1AC+pJAHbNk9b
	 xtBpHjSFvXCgi8YPhCtFALmdvlOfWiR7z2XTixOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1274/2151] ASoC: mediatek: mt8188: Constrain UL8 FE to its back ends capabilities
Date: Wed, 18 Nov 2026 15:50:09 +0100
Message-ID: <20261118150208.536016340@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Kopeć <michal@nozomi.space>

[ Upstream commit 76775717c4adc283d5e7aed469468c8fa1ada4a7 ]

UL8 advertises up to 24 channels, but its only back end, ETDM1_IN,
supports at most 16, and its bit clock is limited to 24.576 MHz.
Without merged constraints, userspace can open UL8 with 48 kHz, 24
channels and 32-bit slots, which then fails in hw_params:

  mtk_dai_etdm_configure bck rate 36864000 not support
  ASoC error (-22): at snd_soc_dai_hw_params() on ETDM1_IN

Set dpcm_merged_chan/rate/format, as the DL front ends already do, so
the FE only offers configurations the back end can accept.

Fixes: 96035d46d4b4 ("ASoC: mediatek: mt8188: add machine driver with mt6359")
Signed-off-by: Michał Kopeć <michal@nozomi.space>
Link: https://patch.msgid.link/20261003194501.832558-4-michal@nozomi.space
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-mt6359.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-mt6359.c b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
index c6e7461e8f764..e61ee390d233f 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -1139,6 +1139,9 @@ static struct snd_soc_dai_link mt8188_mt6359_dai_links[] = {
 		},
 		.dynamic = 1,
 		.capture_only = 1,
+		.dpcm_merged_chan = 1,
+		.dpcm_merged_rate = 1,
+		.dpcm_merged_format = 1,
 		SND_SOC_DAILINK_REG(capture8),
 	},
 	[DAI_LINK_UL9_FE] = {
-- 
2.53.0



