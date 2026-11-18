Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031301;
	b=Vp76T7gLSPImkKB6feTdN1ERZPEKSimunu32nLf/2ZfvqnEkFjkW7yXQMtcY+OfMHmpr
	 xUyLYC64mjqXlFEqNZP9CTt6Tm79okIJeSv5NMBGFjw/gvmL3fqD7EqvCZPaMbhjeQnkw
	 2Ay1AjuimXY4a5tzp2sQqVYgx2R6GU8uXhHiOIom6XEjf5VGQ3Z9I7cdx3HNXDaX4N0ox
	 O4zYQ44UNlFdhqez6Tr8caEctV661/vDdO55JfOsMMHjPJxdnrefLioKLFZbGivffuJfb
	 1sbSNv2CfBfvz85HhnDOyeuc7XKW4I73xRksO1B21E+dc+GDzIdB/8cGxAXzhDztOhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iFbtqLU7FlAsT5ABIV5izpnMOPF41xIVLnUtyv+GjmU=;
	b=UKvgULSzDDX5fvMIbBl22ZzTB55nUfbSgqguy3K3qw4Kxx+nEjtHl0AfmBLRgxNdCURj
	 kAip0TCipvQG8pmEVakGcX23IL73H6/1UOkOfy9z4pGgyMj8twCsjndwod7UoK+oWpDtB
	 66nKItdq/FokP2fxj/0+u4KsGqjkOergibrHHzY/cQVT7p4CbXpT3tsrb457Va4UIVkQT
	 iVXOKvLOdvu9/isDJu3wWey/plEv4duapUZ1pkqKt9LkmRs55tNh3NsUXaoE9n55dGqhO
	 vj93GrQg97DFLb/+eizGIZeyiBxKFosBzt6QfKqWMNuKMHvJECmOOFB2kvYX/CxhlJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssxPDF+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96AE606A32F;
	Wed, 18 Nov 2026 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssxPDF+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15F11F000C4;
	Wed, 18 Nov 2026 19:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031301;
	bh=iFbtqLU7FlAsT5ABIV5izpnMOPF41xIVLnUtyv+GjmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssxPDF+Wzo20MtwxkVNMPQj3xr5hBebn4NHwMPiYzsg+J1tTr5XIUHq84+3RVuhR2
	 ncayE6FRNfahlPzGQH+++38KYhcPCQ+SGBBfywk1LdOvhXJgQm9l3XmlGVNYjSkEJQ
	 A3tWZ1TUDjdONOPx2OIvLyJ4ih3428084FYt8r98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1008/1756] ASoC: mediatek: mt8188: Constrain UL8 FE to its back ends capabilities
Date: Wed, 18 Nov 2026 15:52:15 +0100
Message-ID: <20261118150050.275014861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13e9a32e50c4b..8ff93f0026ca3 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -1089,6 +1089,9 @@ static struct snd_soc_dai_link mt8188_mt6359_dai_links[] = {
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



