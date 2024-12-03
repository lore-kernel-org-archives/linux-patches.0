Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5841C1F8AC9;
	Tue,  3 Dec 2024 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240706; cv=none; b=eAmPkIMxSLm1hkPIfuMUfCIHs1V76qazFK0i4xJmUCyaAqwMIlwahIi4CTL+Mg8T29JXiFvGFRLMPwGSMb23KHSc48NdyAprUMizDhM39NdDTg0RuGaUPk3lyNRigl3GRhc0vjZsgZRUsLEeAVvOiEj/jyZ22Jf5Qlvzgyp3h7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240706; c=relaxed/simple;
	bh=UwJLjNRnt+I6rsyNDMMVhVF3jy2Efyv3hpHlLUpLrmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssjQgzepyLB0HaR3mMP/2UNmxkK/Tp9jrbk+F8yO82o6ERvNYAY/n4yu9Ihkx4Oyir1AmEfSgILdv5T0NX/0Q+NUynWFKag2nA8R9YRxtVva2CkiWjrLuY9MzobKOHxo4yx+l25acKEgRNiVC1H8hGXstZBp3BvKZyerClxyD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA3jUVVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA3jUVVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A35C4CECF;
	Tue,  3 Dec 2024 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240706;
	bh=UwJLjNRnt+I6rsyNDMMVhVF3jy2Efyv3hpHlLUpLrmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SA3jUVVIGyLTSjSE5fZGKfMw7mwDPxl+7m9u4b6AkHTmmSAkNZbGcvYar4u3wsXh5
	 XGJDpc7qvRh5rhbczT/zatcL9ONSg5b2lVVnycUN+/fjLdYjEBMQvA8gfxHekI7fSf
	 vgi+DE/2ltTUcD+A3p7m6BsPVzrrJ46oJ94cYvTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/826] ASoC: fsl_micfil: fix regmap_write_bits usage
Date: Tue,  3 Dec 2024 15:39:00 +0100
Message-ID: <20241203144752.053113829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 06df673d20230afb0e383e39235a4fa8b9a62464 ]

The last parameter 1 means BIT(0), which should be the
correct BIT(X).

Fixes: 47a70e6fc9a8 ("ASoC: Add MICFIL SoC Digital Audio Interface driver.")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/1727424031-19551-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 0c71a73476dfa..67c2d4cb0dea2 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -1061,7 +1061,7 @@ static irqreturn_t micfil_isr(int irq, void *devid)
 			regmap_write_bits(micfil->regmap,
 					  REG_MICFIL_STAT,
 					  MICFIL_STAT_CHXF(i),
-					  1);
+					  MICFIL_STAT_CHXF(i));
 	}
 
 	for (i = 0; i < MICFIL_FIFO_NUM; i++) {
@@ -1096,7 +1096,7 @@ static irqreturn_t micfil_err_isr(int irq, void *devid)
 	if (stat_reg & MICFIL_STAT_LOWFREQF) {
 		dev_dbg(&pdev->dev, "isr: ipg_clk_app is too low\n");
 		regmap_write_bits(micfil->regmap, REG_MICFIL_STAT,
-				  MICFIL_STAT_LOWFREQF, 1);
+				  MICFIL_STAT_LOWFREQF, MICFIL_STAT_LOWFREQF);
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



