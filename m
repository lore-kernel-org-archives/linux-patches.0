Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F9142DFFA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301200; cv=none; b=MvvqLPrOyre8jlAfNFga9S0wnaRiYXZWaRhToNnMhXBSrnYoyq/ex95tOH0/2pHbE1h4VY5fHPRLOjLaj033zFnw9HJcaSEROuvia/cKSNTwMWo45CPwbpSRgSH6eRqf5OQsYiYwqCBjI+ZosqL0fC51+IWeN6mmKIGZNO4tV9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301200; c=relaxed/simple;
	bh=P4+DSjc31sZ+lPxmi+d1cV3XvKHl283IqheB5hvnv0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LteQdsZ6MlX7qDHD16tJM05OE6FxbD58U4ZWnGNBq+B57TFqNX4drntCD4RfZSRWecvuIjIEXCDXApFiKqdfhAfAIhdkAvlUoituOnIl/u6g/pITNEeOs6S5Lj4v6dZPYzt98plO84TblRGt1jXzGIMavj5hS9ZKux2yAZQKD+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKo/lNn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKo/lNn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172B7C2BC87;
	Sat, 28 Feb 2026 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301200;
	bh=P4+DSjc31sZ+lPxmi+d1cV3XvKHl283IqheB5hvnv0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKo/lNn9FXOmxxBpgDV/cYK/a0ampJQ+fAhaarww1eEtQhdwBpDMlMc4K/M26rsk6
	 Kz18/A3qfdtIZzsE5qdn15qy6iL+Sz/STl/FyNBEm3OksaAoxvJ1eA6kKM9DUc2Vb8
	 dY89EIplQTTgpFJLpXc0WDMQPLj1sjwCd3usQ+1EjAeLSfiyx5MgFkwQXfr3qLgRnX
	 1sC+cPOK2wG2OGNpNBrHRUJIrmUHliY8ZDXCZ3zsTo7GmLYQb0Y3lY49Fq9ImYPkMO
	 fy2qVxOr4gIr15dN3+6jtXYUEOgO32TTrM+nc/RjMYWLRMp6gkPnnjFknZF2meYNHp
	 Xbmr++5iyUwUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/752] ASoC: rt721-sdca: Fix issue of fail to detect OMTP jack type
Date: Sat, 28 Feb 2026 12:41:24 -0500
Message-ID: <20260228174750.1542406-373-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 5578da7d957fbaf91f6c39ba2363c2d2e4273183 ]

Add related HP-JD settings to fix issue of fail to detect
OMTP jack type.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/20260210074335.2337830-1-jack.yu@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt721-sdca.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index 5f7b505d54147..53cec09d29085 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -245,12 +245,12 @@ static void rt721_sdca_jack_preset(struct rt721_sdca_priv *rt721)
 	regmap_write(rt721->mbq_regmap, 0x5b10007, 0x2000);
 	regmap_write(rt721->mbq_regmap, 0x5B10017, 0x1b0f);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_CBJ_CTRL,
-		RT721_CBJ_A0_GAT_CTRL1, 0x2a02);
+		RT721_CBJ_A0_GAT_CTRL1, 0x2205);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_CAP_PORT_CTRL,
 		RT721_HP_AMP_2CH_CAL4, 0xa105);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_VENDOR_ANA_CTL,
 		RT721_UAJ_TOP_TCON14, 0x3b33);
-	regmap_write(rt721->mbq_regmap, 0x310400, 0x3023);
+	regmap_write(rt721->mbq_regmap, 0x310400, 0x3043);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_VENDOR_ANA_CTL,
 		RT721_UAJ_TOP_TCON14, 0x3f33);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_VENDOR_ANA_CTL,
-- 
2.51.0

