Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0601A569B
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F901C433D2;
	Thu, 15 Dec 2022 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127983;
	bh=xApacaaiV8UL0u+br9ApSOYSXQZmwwuKKkSLgb+ZMvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkHVdlZUC0Bs4mctlyuR2v47h8ajJb8wIpKcpp/wDjuMDD7O8SWC0QOlIi0ioOUfE
	 WpIjYjsgZ5DZUgP8/iBbGjBzSxdKr4KfkXeO6L/bttkKtflTIC2yVIEUamZXCXxOYW
	 wmiQCBMMA3Rn25A8GxXOsy3X2yJCkJ2XmdRgWhQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 14/16] ASoC: cs42l51: Correct PGA Volume minimum value
Date: Thu, 15 Dec 2022 19:10:58 +0100
Message-Id: <20221215172908.799804316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 3d1bb6cc1a654c8693a85b1d262e610196edec8b ]

The table in the datasheet actually shows the volume values in the wrong
order, with the two -3dB values being reversed. This appears to have
caused the lower of the two values to be used in the driver when the
higher should have been, correct this mixup.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221125162348.1288005-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 51721edd8f53..e88d9ff95cdf 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -143,7 +143,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x19, 30, pga_tlv),
+			0, 0x1A, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
-- 
2.35.1



