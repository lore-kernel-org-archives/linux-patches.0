Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3B81E495;
	Tue, 14 May 2024 11:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684848; cv=none; b=fksYHHZbebep9IOrGY0I0FDrEjco+xBbBPjz9NXZkRT7GB+6/BLeR85dPT9b3gFiUq5E8nmU56cG34OJ7LJ1q6C6xRbiFhgeI19hBMZNiX7k8eQNwmSUAL/jUfCQ2O5lIvdgsIpCmjSeHm1AiB9X9loXeavy0RSTjFmAKxg6Rdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684848; c=relaxed/simple;
	bh=w3GVX0rfRKc4kyFTjiT8xFevfP295Hcb9eeNiuOeVzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bejd4HKmEM4amdUnc+KrELvfzoFCwuyRtPFY4hLdf22RAih3PNxcpl0acMCP7twF4/R1ZhZmUWrPi9f510VOl6bo9IMGy1pFs7a35n8etpP3vi6er3sKcaA9TD1shI0vx3qyZH70U+LgNSO/INcG3nHRzoCOSU/642j2uMa94ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXrzbft0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXrzbft0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4F3C2BD10;
	Tue, 14 May 2024 11:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684847;
	bh=w3GVX0rfRKc4kyFTjiT8xFevfP295Hcb9eeNiuOeVzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXrzbft021emYWw2YS6BT2jrUkq5b4MSKXaz/PUUdccYbL8w1sQSSxAkdihtrqxih
	 DRVNdbnE64Df92NwLIZDp8K+29qAfAN1fSxxvWXBV/JLm7050gmSkwh5hyvyLZd8kn
	 bpA0N1hkCxi0b6lHHxRK69ndxaTA1HOo5BWC2iBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/301] ASoC: meson: axg-card: make links nonatomic
Date: Tue, 14 May 2024 12:15:38 +0200
Message-ID: <20240514101034.772445449@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit dcba52ace7d4c12e2c8c273eff55ea03a84c8baf ]

Non atomic operations need to be performed in the trigger callback
of the TDM interfaces. Those are BEs but what matters is the nonatomic
flag of the FE in the DPCM context. Just set nonatomic for everything so,
at least, what is done is clear.

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240426152946.3078805-3-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index f10c0c17863eb..b6f5b4572012d 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -318,6 +318,7 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
+	dai_link->nonatomic = true;
 
 	ret = meson_card_parse_dai(card, np, dai_link->cpus);
 	if (ret)
-- 
2.43.0



