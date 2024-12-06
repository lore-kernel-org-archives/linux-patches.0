Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A17149E0E;
	Fri,  6 Dec 2024 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497170; cv=none; b=UPmMJ5/Mbvk0sk/98WHiAkQTDtKIQL7iegz6mEhUgTGPTGEMYany1Mm2HurmRqy/6P6nHFgx98dWwBGKgBq9S7e9dvjSU2ZdjIaUkphUNRdB3YYiCp9PHA0jE5Pbe+Mm9/lygIUBip7MaAr5d+0n5W0p6NcBwIbUgP/COa3K8NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497170; c=relaxed/simple;
	bh=6g8wTonMcGT3gfwz2X0CZ1aZj9u2HVbgiewRIpYU674=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8HpmpY7tPDcm1P95IJwosFzsgyVpm2HolcPB0MUY4A+36WLkhfpWiM9Bi9D5K60x0l0QWIApS8dPhFYrt+uAc0yPALMbL90QxRSsQx4O2neJTXjyLYb4fDpHHPWT/J8BycyvVY+S5PSQwLkzOCrhpkgIgdSuL3YubwrAtSubkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKCtPPjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKCtPPjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4885AC4CEDE;
	Fri,  6 Dec 2024 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497170;
	bh=6g8wTonMcGT3gfwz2X0CZ1aZj9u2HVbgiewRIpYU674=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKCtPPjEQ8hsVMNB1e+H5VJ4dqsEDcDTYnfJ6iBuqRsiAGNcAvGdQGE3iG5/mKOU7
	 5vc3nRZOZl27tQQo/GgQyb+isNeff8nKT0Scq20FWg0ElFD3sMsMs/A2m7bhxLVO7H
	 LbrrqMs8H7HGnDJ3ztkqjmaZKmxON1sKJu6TyLYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/676] ASoC: fsl_micfil: fix regmap_write_bits usage
Date: Fri,  6 Dec 2024 15:30:01 +0100
Message-ID: <20241206143700.457079149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8478a4ac59f9d..f57f0ab8a1add 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -1051,7 +1051,7 @@ static irqreturn_t micfil_isr(int irq, void *devid)
 			regmap_write_bits(micfil->regmap,
 					  REG_MICFIL_STAT,
 					  MICFIL_STAT_CHXF(i),
-					  1);
+					  MICFIL_STAT_CHXF(i));
 	}
 
 	for (i = 0; i < MICFIL_FIFO_NUM; i++) {
@@ -1086,7 +1086,7 @@ static irqreturn_t micfil_err_isr(int irq, void *devid)
 	if (stat_reg & MICFIL_STAT_LOWFREQF) {
 		dev_dbg(&pdev->dev, "isr: ipg_clk_app is too low\n");
 		regmap_write_bits(micfil->regmap, REG_MICFIL_STAT,
-				  MICFIL_STAT_LOWFREQF, 1);
+				  MICFIL_STAT_LOWFREQF, MICFIL_STAT_LOWFREQF);
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



