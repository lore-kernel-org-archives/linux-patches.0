Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3BE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BA6C433EF;
	Mon, 30 Jan 2023 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088172;
	bh=Mg2s4iszE+kCEIF9Pcy0R3NPcVM0A1bYGOhjvjwVvKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmIWcoz0IBxxs8RRqhl59QZCBxeWzfPnrA8ICVnolhaHdz8oN76dnF7zh2zh6Dw7e
	 ub8PQ9SdnNcu5dFE30uDVnw7xSkiamJdCIWS1LPLJn2r3ZGhbv5Ic6Wc9JUnHOXn98
	 wAeMx7T7KLOymyb+J/H7g4LGmz6wGetX12VtjWl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/204] ASoC: fsl_micfil: Correct the number of steps on SX controls
Date: Mon, 30 Jan 2023 14:51:05 +0100
Message-Id: <20230130134320.731859925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit cdfa92eb90f5770b26a79824ef213ebdbbd988b1 ]

The parameter "max" of SOC_SINGLE_SX_TLV() means the number of steps
rather than maximum value. This patch corrects the minimum value to -8
and the number of steps to 15.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230104025754.3019235-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index d1cd104f8584..38d4d1b7cfe3 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -88,21 +88,21 @@ static DECLARE_TLV_DB_SCALE(gain_tlv, 0, 100, 0);
 
 static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
 	SOC_SINGLE_SX_TLV("CH0 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH1 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(1), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(1), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH2 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(2), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(2), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH3 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(3), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(3), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH4 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(4), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(4), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH5 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(5), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(5), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH6 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH7 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0x8, 0xF, gain_tlv),
 	SOC_ENUM_EXT("MICFIL Quality Select",
 		     fsl_micfil_quality_enum,
 		     snd_soc_get_enum_double, snd_soc_put_enum_double),
-- 
2.39.0



