Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2491CAA6F;
	Wed, 19 Feb 2025 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956101; cv=none; b=K+nG6EuZ667C2nasjqyElEL1lS1tfLd5erzkOEYOlQ8RqOavs6sh1eCltvbSXyhxRhx1o+LKPyYqOVl42rYV1F3/kIkW+Z1gZIVWqkRQ64fzYmLPMWCmcy/A93rWKQr/KHD0/SM3Gd7TdNoXWAuUgd7BnYqEMCmFSJywfa74+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956101; c=relaxed/simple;
	bh=JxFjuKo9nAITV5/n403liSbDwrvVSBbngaKjPeIHjvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oPZ5As2gkuZkEjVoHhctmyFg8RjnBEjM9mkmoqTJJOGM7hgelepo8/jA3F5+GRLEEgf9+xvRO35PNMekjb9UVPLHnX1qkZHjVtOTDc/Vt7Pq6JjBxnHQfgFAMtqeV49nW+ZNq/3X09dtL5xd5+g97c5uaHdHnf6Z+3sRkrniUSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaYVnfox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaYVnfox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897C3C4CED1;
	Wed, 19 Feb 2025 09:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956100;
	bh=JxFjuKo9nAITV5/n403liSbDwrvVSBbngaKjPeIHjvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaYVnfoxT0YgiBxA/lWKxtNN7QclfzgYKiZr877IUO4aa+NBrvRtUfKSTYkNu6qOb
	 rvf11uHFZHw6Wi2dnJCbPaHR0BVWyaVUPW3Mzb9F2daOwTHj0PddD4O0HybBv57s+o
	 LmMphB1i1ZWDXcFk8HOChi2NV8WSoTRDNHof2WwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/578] pwm: stm32-lp: Add check for clk_enable()
Date: Wed, 19 Feb 2025 09:21:08 +0100
Message-ID: <20250219082655.404649392@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit cce16e7f6216227964cda25f5f23634bce2c500f ]

Add check for the return value of clk_enable() to catch the potential
error.
We used APP-Miner to find it.

Fixes: e70a540b4e02 ("pwm: Add STM32 LPTimer PWM driver")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241206215318.3402860-1-zmw12306@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32-lp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 31a185c6b8da4..7f477082db1d7 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -169,8 +169,12 @@ static int stm32_pwm_lp_get_state(struct pwm_chip *chip,
 	regmap_read(priv->regmap, STM32_LPTIM_CR, &val);
 	state->enabled = !!FIELD_GET(STM32_LPTIM_ENABLE, val);
 	/* Keep PWM counter clock refcount in sync with PWM initial state */
-	if (state->enabled)
-		clk_enable(priv->clk);
+	if (state->enabled) {
+		int ret = clk_enable(priv->clk);
+
+		if (ret)
+			return ret;
+	}
 
 	regmap_read(priv->regmap, STM32_LPTIM_CFGR, &val);
 	presc = FIELD_GET(STM32_LPTIM_PRESC, val);
-- 
2.39.5



