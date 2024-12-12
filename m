Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386412210E1;
	Thu, 12 Dec 2024 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022249; cv=none; b=gEZhZbwQTUwTVe4dtEUB9by6kbnUSaEWYUSDP+T0SWIgYjK0TFhngEwnKybYI4MpLsKErGhE1AZP3LdBAmgNPQDGot5o8zkqWjhIBTo2oFCQ9E8KC329fi/zLUre5KnNGex1uov9/lNFlucyFGYSQIhdWrmbqfjbd4JsybIPLB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022249; c=relaxed/simple;
	bh=+jexRusRw4Uk5r0lr9B55GCaFBZvPp1l3jfZvAi6QCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeJ4M431d2XgVBuDifZOqnPXRJzp0CCSOfZkxq6w3e0gp2J68miyrH6ZxK1heRFEE21aGGlGIqGh9wT1cx+sNOBF+OVpl5lNzR1pSZESkZuVpsOxDg/GDguuxdnA/6b4fE6Zx2pqP9y7pKZpiJM8L+JDGsFjpP2g9HltnwsX+pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7IahncE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7IahncE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CA4C4CECE;
	Thu, 12 Dec 2024 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022249;
	bh=+jexRusRw4Uk5r0lr9B55GCaFBZvPp1l3jfZvAi6QCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7IahncER2xDW8PZHyuApA4tkt7DJetg9+jZMtCdg3nvH4AcMHsAUqQZbY5oTnGXE
	 jGfxdlO1sgEi1CSP1efByVKArhl6HwUeKaSDBlG7E5f1rPzRxGQnG2VyLJ+SQNCRIK
	 vmpaPblbfQIvj0fbw+n6VdmJagl8nJdTthS8AJNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/565] ASoC: fsl_micfil: Drop unnecessary register read
Date: Thu, 12 Dec 2024 15:55:53 +0100
Message-ID: <20241212144317.723640966@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index acc820da46ebf..36e422f6d4622 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -118,8 +118,6 @@ static inline int get_pdm_clk(struct fsl_micfil *micfil,
 	regmap_read(micfil->regmap, REG_MICFIL_CTRL2, &ctrl2_reg);
 	osr = 16 - ((ctrl2_reg & MICFIL_CTRL2_CICOSR_MASK)
 		    >> MICFIL_CTRL2_CICOSR_SHIFT);
-
-	regmap_read(micfil->regmap, REG_MICFIL_CTRL2, &ctrl2_reg);
 	qsel = ctrl2_reg & MICFIL_CTRL2_QSEL_MASK;
 
 	switch (qsel) {
-- 
2.43.0



