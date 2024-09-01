Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06213D53B;
	Sun,  1 Sep 2024 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208077; cv=none; b=o72DwnR0DyzUlFS2ByApwv9bzvkAV/E084Tg3l8t8180HffteH/JeCBrKJEVemFMbNxWCncM6YSPPO/rov0JImDbTBbxDSx3CBdprOeIPUc5bynMmNj/kUfHbfgTSr0DU1qH66LjwJKm+V5rkRpjscsj8Qnyz5xlZsHvvkv5DYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208077; c=relaxed/simple;
	bh=PcY/rXvPdSDfCeN2mcCbs5PigRIV5g6O01WF7th56q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUqvNd1rnLSNhXBDgBLgqha6+1Y1RIOpt4mIC+OV9on/d+RyX5sBCiLKt6n6/sXGNbKv/5+2zuaWDNR9vnc70F8oaJzRz2FU0KQULBEiEtcXkYNP4xzh5nIRfjVEfnGWmhl58siXaBEpkJ94tu7fEd3DPgm+RF3Hc1tejbg1zQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puIX40Sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puIX40Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA42C4CEC3;
	Sun,  1 Sep 2024 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208077;
	bh=PcY/rXvPdSDfCeN2mcCbs5PigRIV5g6O01WF7th56q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puIX40Sl2Rw6X/XaWMBalvpBGAJO5blaq41sTzTnqVEM4UABlydk2JPoqf4YC3Uar
	 CTUjluDceg/UCxrRbFs+DAI+n4Y59hLqzx/MAMUS6SaffYhiayzn9E5wv9I0Jc9TeQ
	 O8Qxqtqm5yMsv4aZs9ienup4RdHbWMi7eR7QbWv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/93] pinctrl: starfive: jh7110: Correct the level trigger configuration of iev register
Date: Sun,  1 Sep 2024 18:16:22 +0200
Message-ID: <20240901160808.681262344@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 639766ca10d1e218e257ae7eabe76814bae6ab89 ]

A mistake was made in level trigger register configuration. Correct it.

Fixes: 447976ab62c5 ("pinctrl: starfive: Add StarFive JH7110 sys controller driver")
Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Link: https://lore.kernel.org/20240812070108.100923-1-hal.feng@starfivetech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c b/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c
index b4f7995726894..a3fee55479d20 100644
--- a/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c
+++ b/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c
@@ -805,12 +805,12 @@ static int jh7110_irq_set_type(struct irq_data *d, unsigned int trigger)
 	case IRQ_TYPE_LEVEL_HIGH:
 		irq_type  = 0;    /* 0: level triggered */
 		edge_both = 0;    /* 0: ignored */
-		polarity  = mask; /* 1: high level */
+		polarity  = 0;    /* 0: high level */
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		irq_type  = 0;    /* 0: level triggered */
 		edge_both = 0;    /* 0: ignored */
-		polarity  = 0;    /* 0: low level */
+		polarity  = mask; /* 1: low level */
 		break;
 	default:
 		return -EINVAL;
-- 
2.43.0



