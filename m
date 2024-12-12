Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D4A222D6A;
	Thu, 12 Dec 2024 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025119; cv=none; b=uTOE20NHuv3AIrgct2jnV/AzlSZDXwPHpQsAZU7avLqr7gz2436uX/9hRdttjxh1EmsV/fY4oL8FjGSDg6KrlmcMeOqQBZB7Cl+XG6/QsTSRtBhZQjmuxMRIHHxYy6mSq8NkazHaSmGOkRYkIDpL66Fs8xw+Z0+lhsS04S2W9ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025119; c=relaxed/simple;
	bh=j2oM5m377zC/bx3ykb4gcmVmkg5vLLb4ksU2ZWktpjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUTM1qHfYK8kJ9BIFRGKnV0OXCaUbhZqhTSXibUTNWhZY4XXaT5+t7xl5btemFAgL9mt+EVwSYMS0xmcyViNDItAWmiUDTa0cXcG6cJRLLMVw9cunVOIbvS4rBJ18R82JpMMXd9vBIVG/j/1QhkLdETludkDtyfWOwitDaQUkAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RogJKBNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RogJKBNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF546C4CECE;
	Thu, 12 Dec 2024 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025119;
	bh=j2oM5m377zC/bx3ykb4gcmVmkg5vLLb4ksU2ZWktpjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RogJKBNOcrSRHAyrJFlK/9zEKJpl9vuk3chQBy6hZSPA7quL2GcEifSeoJ4gC5KXp
	 fP4f4BbyzEV4mNChexTS0R6EqPtKtYITOgJkN3zF9t0tOUGEbo0kZ7Ao8FOq0jeKvH
	 SpnHebE37d3o1GX9VOF49pqcQ6tjy55aVMK2yhOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/321] ASoC: fsl_micfil: Drop unnecessary register read
Date: Thu, 12 Dec 2024 15:59:40 +0100
Message-ID: <20241212144232.442105540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6285ee8f829e5..a69237b7f564a 100644
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



