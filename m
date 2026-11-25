Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618016;
	b=LHRxfhOhPtfzkGEFJ8PKW41t2eNdfCDiyM1yTQaT5f08jZc+zjPxggAxgGob7r/K780I
	 cwU3SueC71waCQLmov5qMMYjmU0b1SlPG7455lTiM3Y/DmXBzKNF3xhUWyesD/IfSDkwS
	 tJWSnDvSsFWgzRYQcmBVegXU84eHBS8ip9kASrpuwbHs1iYZATjZiw/yiTZDSafWgV8zL
	 osoyf8adEW1q6o3OdWBfXxivLm2aJDQD+8d90/dUIFn5JHls2kj2FIcAH6xLzRv8dzxne
	 X+00z1ujH+2Q2GL3yHPoaSooNLiqzdefdS4LPokpwmodw+FCPzJKFw6LRpgZvf0egSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSd7OyZFaKckiervx1puOnZ2pljByMeZGikXdKkylEA=;
	b=gz+TIfD29/SsdAXhbvmr/pQVbAONP9klhFj2nbMxNPVr//FIKcLOio1zRk0sZS45KR35
	 pw9Tul6aiNlwkEcd6tw5kqa3Naxb/95vEXkwF2gHWW4+jf29BvZ/mpPeCNPuxrA432gEo
	 TSDXwVTlvVTxzvcLWPW6SZjBUJ1gIfI67rYTeR/Ejbr1tFKX7FqdWIytIaW1Xul1S+vyz
	 3G1QPN0JAbO/73PO19QbxmDEgTsWtB86MoUdgLNTdwwuDSfE9fPB9oL8DyxQbeO8/u1ff
	 SmtRNSOmZsir5MCSDt/akDpgqcIeXx6VrQI+IspFM6ihw5MeWu4IIszUrH9H8SCCjQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hmckqcm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BCC606A326;
	Wed, 25 Nov 2026 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hmckqcm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5973A1F000C4;
	Wed, 25 Nov 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618015;
	bh=pSd7OyZFaKckiervx1puOnZ2pljByMeZGikXdKkylEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hmckqcm2/NG6SVu8q7KpZ4J4a64S0r/F0ZIGVXh2QUYm0Nb4rLHVDO7+hIY6SZjLc
	 4kQVuwibbEolPSk8uV5tMZFOt5ghRMXIZdLBUpreamFllvUqITn5F1PW/Cwt9Hhw3B
	 iOPajQvZB62ZAQPSerXuFELYvs5BDxteYqCDaQv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0119/1005] ASoC: tas2770: Configure transmit clock edge when setting DAI format
Date: Wed, 25 Nov 2026 15:24:17 +0100
Message-ID: <20261125143824.529817862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Calligeros <jcalligeros99@gmail.com>

[ Upstream commit 72da22e9cc380ecda175983d2a17b4494a4b9d15 ]

On reset, TAS2770 is configured to transmit on the falling edge
of the I2S clock. If BCLK is inverted, we are also receiving on the
falling edge. This can cause data leaving the codec to be corrupted.
Transmit should happen on the rising edge of the clock when receiving
on the falling edge, and vice versa.

Fix up tas2770_set_fmt to take into account the BLCK polarity and
always transmit on the correct edge of the clock. This fixes
corrupted VISENSE data on Apple Silicon platforms at sample rates
above 48 kHz.

Fixes: 1a476abc723e ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20261031-tas2770-sdout-clkedge-v2-1-afeeba781cbb@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 9 +++++++++
 sound/soc/codecs/tas2770.h | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 355fcbfd01c79..a77ca55d5cf0c 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -353,6 +353,7 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	struct tas2770_priv *tas2770 =
 			snd_soc_component_get_drvdata(component);
 	u8 tdm_rx_start_slot = 0, invert_fpol = 0, fpol_preinv = 0, asi_cfg_1 = 0;
+	u8 tx_edge;
 	int ret;
 
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
@@ -369,12 +370,14 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		fallthrough;
 	case SND_SOC_DAIFMT_NB_NF:
 		asi_cfg_1 |= TAS2770_TDM_CFG_REG1_RX_RSING;
+		tx_edge = TAS2770_TDM_CFG_REG4_TX_FALING;
 		break;
 	case SND_SOC_DAIFMT_IB_IF:
 		invert_fpol = 1;
 		fallthrough;
 	case SND_SOC_DAIFMT_IB_NF:
 		asi_cfg_1 |= TAS2770_TDM_CFG_REG1_RX_FALING;
+		tx_edge = TAS2770_TDM_CFG_REG4_TX_RISING;
 		break;
 	default:
 		dev_err(tas2770->dev, "ASI format Inverse is not found\n");
@@ -387,6 +390,12 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	if (ret < 0)
 		return ret;
 
+	ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG4,
+					    TAS2770_TDM_CFG_REG4_TX_EDGE,
+					    tx_edge);
+	if (ret < 0)
+		return ret;
+
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
 		tdm_rx_start_slot = 1;
diff --git a/sound/soc/codecs/tas2770.h b/sound/soc/codecs/tas2770.h
index 102040b6bdf8a..666a9631c65d1 100644
--- a/sound/soc/codecs/tas2770.h
+++ b/sound/soc/codecs/tas2770.h
@@ -74,7 +74,9 @@
 #define TAS2770_TDM_CFG_REG4_TX_KEEPER BIT(5)
 #define TAS2770_TDM_CFG_REG4_TX_FILL BIT(4)
 #define TAS2770_TDM_CFG_REG4_TX_OFFSET_MASK GENMASK(3, 1)
-#define TAS2770_TDM_CFG_REG4_TX_EDGE_FALLING BIT(0)
+#define TAS2770_TDM_CFG_REG4_TX_EDGE	BIT(0)
+#define TAS2770_TDM_CFG_REG4_TX_RISING	0x0
+#define TAS2770_TDM_CFG_REG4_TX_FALING	0x1
     /* TDM Configuration Reg5 */
 #define TAS2770_TDM_CFG_REG5  TAS2770_REG(0X0, 0x0F)
 #define TAS2770_TDM_CFG_REG5_VSNS_MASK  BIT(6)
-- 
2.53.0



