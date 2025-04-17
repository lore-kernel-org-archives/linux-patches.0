Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC9E257AC3;
	Thu, 17 Apr 2025 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914292; cv=none; b=qqfqRHRV2vPk9tKSx7m9Gqhv9Ip/5JNm4yel9/DxlANcSAg3QIp6n3XGYcq/Qsmv4AEIB93yWPJ23KUL4X3Ol43ovSWc2EC69GwHYubyn4YjjUUKe7m6qUVGPtL5zTRa3xT5WzseTUrkfFrh5o9ICKfbVCVXhSRY6YoH1BIGE+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914292; c=relaxed/simple;
	bh=nVZsMctnSlNnPRS9/4IUrz+xwj6nFJ5Zkpl68LSBewQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k7Xo26Xmsh24u1VNRSEuOC7r8EUyfouxMA3ucbrRG854gVdP1efH1fvg+zYZJPOyKKEhmOiZIdyMzDZJQ49SF+zr7lbPrV6DHzxnQV6Jr8E83HzrtBPFotB0uDa2g2L0i5SePoUYiHms1LCtjq7SqHacEMj/xeSl+89L0jVyZr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SY1YqEyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SY1YqEyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEECC4CEEA;
	Thu, 17 Apr 2025 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914291;
	bh=nVZsMctnSlNnPRS9/4IUrz+xwj6nFJ5Zkpl68LSBewQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SY1YqEyP0/SvcAHlR3k6yUjwvNORRlTTwGw+duXOIMNcxDDtUawJSG70nu1754AvG
	 H7gO3fv9VVJxzBLhqSQXuj0ZUae4h9ZxUdHdv2PK+7K6JFuo6QaJPtnzyXJgEQbiqQ
	 XFCMLQvMuyNswoRGNS2rm996VX4SIa7k1WwYyYXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 168/414] pwm: fsl-ftm: Handle clk_get_rate() returning 0
Date: Thu, 17 Apr 2025 19:48:46 +0200
Message-ID: <20250417175118.195581405@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 928446a5302eee30ebb32075c0db5dda5a138fb7 ]

Considering that the driver doesn't enable the used clocks (and also
that clk_get_rate() returns 0 if CONFIG_HAVE_CLK is unset) better check
the return value of clk_get_rate() for being non-zero before dividing by
it.

Fixes: 3479bbd1e1f8 ("pwm: fsl-ftm: More relaxed permissions for updating period")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b68351a51017035651bc62ad3146afcb706874f0.1743501688.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-fsl-ftm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 2510c10ca4730..c45a5fca4cbbd 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -118,6 +118,9 @@ static unsigned int fsl_pwm_ticks_to_ns(struct fsl_pwm_chip *fpc,
 	unsigned long long exval;
 
 	rate = clk_get_rate(fpc->clk[fpc->period.clk_select]);
+	if (rate >> fpc->period.clk_ps == 0)
+		return 0;
+
 	exval = ticks;
 	exval *= 1000000000UL;
 	do_div(exval, rate >> fpc->period.clk_ps);
@@ -190,6 +193,9 @@ static unsigned int fsl_pwm_calculate_duty(struct fsl_pwm_chip *fpc,
 	unsigned int period = fpc->period.mod_period + 1;
 	unsigned int period_ns = fsl_pwm_ticks_to_ns(fpc, period);
 
+	if (!period_ns)
+		return 0;
+
 	duty = (unsigned long long)duty_ns * period;
 	do_div(duty, period_ns);
 
-- 
2.39.5



