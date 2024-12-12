Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD4813CA93;
	Thu, 12 Dec 2024 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023870; cv=none; b=IBCreIN0St+kDXGkdheDhVRSoTsySR/BMPIc7kIN1SVpnJicIOK92tIymwir1tlh+TVPHNPrAS/Z2O9XZbD7nXSPhLj3v8NCEwg4IG12nPKB4BmQbzk1rSE4rjODFY0gsW5qvv1rMFZ1Jn1c9yAKT8YsIOI30y3ACr77eNlqnqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023870; c=relaxed/simple;
	bh=H05phxrYUPh37zz0aRiidvCiUokFaC2yeMhLPChGQ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTQDiAg1kt67ig2y5BU1NZohpXCbRl5LD8hSX/XEgYil0rmsCrJ+aF1wvheF0jeVI4IfMs+c/TSEjhUpGexfWDGNTbwQ1cmjUei/Y167DJz3E6ElewXmRs/UhxSQmDvxeE11Y49qCiJShWazLvqg0VLwyLJ9PtjXgYBONgIhe6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVmNU2Dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVmNU2Dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ED0C4CECE;
	Thu, 12 Dec 2024 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023869;
	bh=H05phxrYUPh37zz0aRiidvCiUokFaC2yeMhLPChGQ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVmNU2Dl9vFt9TSm1D0uiZlPPmGjBWu002eiv58rAOHTHt3UNBcFZZRjjP89RDCru
	 lXeMQg8cJgu+TE8dtVFBnUWCITS1Wd0nvn09forwNS4HLrVX8Ua8xwWSY2J/ibBfTA
	 zSLyO07UvcfbgRaa9g3W0KZnKFrQmx8QX1/Z7CvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/459] ASoC: fsl_micfil: Drop unnecessary register read
Date: Thu, 12 Dec 2024 15:57:27 +0100
Message-ID: <20241212144257.820269762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit c808e277bcdfce37aed80a443be305ac1aec1623 ]

in get_pdm_clk() REG_MICFIL_CTRL2 is read twice. Drop second read.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20220414162249.3934543-2-s.hauer@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 06df673d2023 ("ASoC: fsl_micfil: fix regmap_write_bits usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 826829e3ff7a2..fe6d6c87a1c42 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -117,8 +117,6 @@ static inline int get_pdm_clk(struct fsl_micfil *micfil,
 	regmap_read(micfil->regmap, REG_MICFIL_CTRL2, &ctrl2_reg);
 	osr = 16 - ((ctrl2_reg & MICFIL_CTRL2_CICOSR_MASK)
 		    >> MICFIL_CTRL2_CICOSR_SHIFT);
-
-	regmap_read(micfil->regmap, REG_MICFIL_CTRL2, &ctrl2_reg);
 	qsel = ctrl2_reg & MICFIL_CTRL2_QSEL_MASK;
 
 	switch (qsel) {
-- 
2.43.0



