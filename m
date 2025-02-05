Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E007E142E86;
	Wed,  5 Feb 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763556; cv=none; b=mPsL/K61oiOxVBXdx0frSUGATpDOcigINS8t3Z+t3/8X0YI8rM3dfeFnF5FtwIWnrPMlzBxVp9uKIA6mIWJjpa5HI+EqCxmWgxsSKN8p/hjW0O6gqVXGLBPY2c/1nN/S1kQN97Z7meCHY4YtnIBme09s7Ngy+weU8hRhykdRmgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763556; c=relaxed/simple;
	bh=dXdkHQMmAZrZa2H1n92ROnuBUgN4oMzh3Jl2Gs2AHn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2PNf/tTbui3glGVn2aOhaX/7zdw4H5sggGL20pgDmhOE0UjHRriM8sKCyx7NmkuLKu/C/hqUjgqgI/E3aIY9oh1aRSWZBQVXxe8Onog38Me7en2tiflTHZD9jgQkQFWnGubJlFpelJekJOomvlk8kDoT+P3k6WdnywSayjQVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tz0YS58A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tz0YS58A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC82C4CED1;
	Wed,  5 Feb 2025 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763555;
	bh=dXdkHQMmAZrZa2H1n92ROnuBUgN4oMzh3Jl2Gs2AHn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tz0YS58ATm7K24ZuPGixKzZLojYmF/aSGF02dAhiWVQdQ5KtKCfggqCdYHMsJDTYu
	 H71ZpD1evi4WzdEwsBNvpLNzElC+NvUDHZjD1gYuFZ9MWNWyVjhXCff7vAdSHHg80w
	 aLk+SxXgzjex78c8jQqNq8Vap91aW0IB90Aw8WTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/393] pwm: stm32-lp: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:40:00 +0100
Message-ID: <20250205134423.394536637@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb3a045a73343..7799258638dfa 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -168,8 +168,12 @@ static int stm32_pwm_lp_get_state(struct pwm_chip *chip,
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



