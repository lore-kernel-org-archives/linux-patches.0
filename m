Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A341BFE06;
	Tue, 27 Aug 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770073; cv=none; b=asBJPQva5V+dcrZ8zufWgMzZ7TNb4PCk2RJ2PQB9HTm5xJFbNbM28mF8O4JClhbYGJt9A1M0KH6UnGC0h3HAleOOiGiPa/Jzz8LVl4RlEgMgVXLxr3jT8ptTVMyuVhvCAy4+8AIpXTEBcnbprN9x9ebB53dpYKtryQfPtNNxlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770073; c=relaxed/simple;
	bh=fuClPaG6a2BJitgDy20hlGjS3R4b4chl9DMOp2zj0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/l+DDAVugfqAIjl8xLrjN+mclNSV5oRlmcESuVoU9V25qAaNyu4mdgfKyalzNUDcGXc6vRrNUSbdH2g6IWdHR1easG3ReT49wyRPvM8yyQvgihsVHF5Fg6CGFDW6TUCaZ2i6CamOAfZ9wjKng3m5CuUVgjK3RCdA616CduHEoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4WvaYEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4WvaYEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFF2C61040;
	Tue, 27 Aug 2024 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770073;
	bh=fuClPaG6a2BJitgDy20hlGjS3R4b4chl9DMOp2zj0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4WvaYEoDYXkJLToeV+Cc5vqcG28MSpltVzs/LA8NpnLOPkncZt1aiF5TCLIW9fkg
	 OSib4jk0WrKVIiFddQiaiDD+49UnduyKyDRNUCtvqa8C+H7lHiKhNQ8FEj3hcwiT/k
	 Ss24fuhB/MtEnyyIp0bqmR+iUlOnjhvjuGoklfSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Vlad Karpovich <vkarpovi@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/341] ASoC: cs35l45: Checks index of cs35l45_irqs[]
Date: Tue, 27 Aug 2024 16:35:18 +0200
Message-ID: <20240827143846.718967235@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit 44f37b6ce041c838cb2f49f08998c41f1ab3b08c ]

Checks the index computed by the virq offset before printing the
error condition in cs35l45_spk_safe_err() handler.

Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Signed-off-by: Vlad Karpovich <vkarpovi@opensource.cirrus.com>
Acked-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230831162042.471801-1-vkarpovi@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index 9b9fc2d491089..7e439c778c6b4 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -1067,7 +1067,10 @@ static irqreturn_t cs35l45_spk_safe_err(int irq, void *data)
 
 	i = irq - regmap_irq_get_virq(cs35l45->irq_data, 0);
 
-	dev_err(cs35l45->dev, "%s condition detected!\n", cs35l45_irqs[i].name);
+	if (i < 0 || i >= ARRAY_SIZE(cs35l45_irqs))
+		dev_err(cs35l45->dev, "Unspecified global error condition (%d) detected!\n", irq);
+	else
+		dev_err(cs35l45->dev, "%s condition detected!\n", cs35l45_irqs[i].name);
 
 	return IRQ_HANDLED;
 }
-- 
2.43.0



