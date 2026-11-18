Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019268;
	b=wEFHV4vVtOuAD84vU5BxbmW2nf6myOk8wjH9b1JX/qtEc3lIBxFxyaW9VnBscaiAXttL
	 EBFtRghg8LYQiU2lkWgDgA/5zTDnEbdXnhSNljBTrIfl75gsiBTR6Jdityt+qM8my8LR1
	 zMY45zRbNmTmin9HtqlAY5Cgu4Q9bjJdBMjSlon2oGSqXSgZMmntbb/X0L51VsVYsAUns
	 vHo2poaE8SklxwX2PXnZd/CoIJ4q2WH/3mRmyUBeiJ1vPzJ+WtYbFAoSxWwdIF6TmSM5I
	 7962PNin42/Ymre9VzUoE8l9SorjQKykBHMpwP6kwvESzPlca9xZydphpeX8+GnHnxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3T60/v5GJntHB3HJARuxRxxc2JFFmBwFmMuFmeQSKSQ=;
	b=KkK3xCV6W1OL0MXBCZeAfXv1r+Q2fLQG91dmb3surytGLF385afmSRm0GibCQ4GJKak4
	 UPUI43moyI6HdbhSnQe6AKuyU3TRdAGDyHIGCUInrRrm+6TIJ12Xylj5R5VZTnkeZPlDw
	 HUOqSgx4q2yRtDMu7JgXU4cw3f9kZeNpdEbcRAXzziTUybvRQxkuA73chCD/RZ4WtPTGT
	 cp3v0KJ0KfoCfgG2sHNDrnUsEzyCb9PI0wKjWXf3FoQ+awtzw4q4gkor4/FDNu9Hv502A
	 LUEX+En+H/RAEGvEESzmuqU70zVEnK3SCMp9llf2C8Mp7K3JCAG5CMxZSVFM5SowDqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9ML84Ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2966F60A2602;
	Wed, 18 Nov 2026 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9ML84Ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73241F000C4;
	Wed, 18 Nov 2026 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019267;
	bh=3T60/v5GJntHB3HJARuxRxxc2JFFmBwFmMuFmeQSKSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9ML84KsRsE6jqb1L1hxgRrYYv1827aB7jCWbQCXyNFegi73t+v7uajkQ/mXNeDRe
	 vYn5yGaxeAstKFdpzxNlw2K+bxtcAZEwUyHZsfeU7VwJtekQH0g711e146QPasAXF7
	 ZaJm+o5/D+QYTgvwJHT8l6fdbpOvT6F7/twqtQkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1536/2651] ASoC: mediatek: mt8188: Constrain UL8 FE to its back ends capabilities
Date: Wed, 18 Nov 2026 15:46:16 +0100
Message-ID: <20261118150343.273053561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 75c90d1d165f7..f07aeb6371083 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -1142,6 +1142,9 @@ static struct snd_soc_dai_link mt8188_mt6359_dai_links[] = {
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



