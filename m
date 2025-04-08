Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07FB268FC9;
	Tue,  8 Apr 2025 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111400; cv=none; b=kZ5nG8Fxuk3685j2K+JARr2O10W09BNBFom2oL9/9nmItrfwI6YP0cMAKLHz5FkWzVBUgt6LGWaeDhnrsS1JPuDmUB18mPaEUmXuj4gR91sR7h7lBVqZU1SkUnpRxUxhrmAyneYYc2LxQMilhYHaQ9r0giejJZ2eQmgkKiXkl1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111400; c=relaxed/simple;
	bh=IAXoEa+8iQrnaIDkb4VKxjYU98mTP0Ts2xnuOZ3t640=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY8SAUh5V0m3DRKo+16vfblfJaGOoflUHW3iKvvbSR4/EkphWPl9rBcPdftULM9kcRLmCIVovqnMNWw/GqYbnzK6juvgyvaci6x1Cbm54A3Q4dc5LRxgURHOw5JpG5MR5Y2bYThA/9Ad1Q41KjwVB4db5hm/tNZAsyMIwKDD/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adiHF+09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adiHF+09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409D9C4CEE5;
	Tue,  8 Apr 2025 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111400;
	bh=IAXoEa+8iQrnaIDkb4VKxjYU98mTP0Ts2xnuOZ3t640=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adiHF+098XHGH7j8wdnWRQuz3LYdkl5U4WbRf4nlGy60Gs4YS0DtsU/fVI3YwOzsQ
	 Hobjpk/78wxlLJRjulTwWZxwTV6UdiDqyNvvP6iuIi+Bc3+/zONQCpS3Vx8AaTxwu2
	 kOqAfBYloQbibUM8tKbskz1kyJ+EtFUFX2m0fnj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 418/731] clk: stm32f4: fix an uninitialized variable
Date: Tue,  8 Apr 2025 12:45:15 +0200
Message-ID: <20250408104923.996355192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 9c981c868f5f335e1b51e766b5d36799de163d43 ]

The variable s, used by pr_debug() to print the mnemonic of the modulation
depth in use, was not initialized. Fix the output by addressing the correct
mnemonic.

Fixes: 65b3516dbe50 ("clk: stm32f4: support spread spectrum clock generation")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/77355eb9-19b3-46e5-a003-c21c0fae5bcd@stanley.mountain
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://lore.kernel.org/r/20250124111711.1051436-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-stm32f4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-stm32f4.c b/drivers/clk/clk-stm32f4.c
index f476883bc93ba..85e23961ec341 100644
--- a/drivers/clk/clk-stm32f4.c
+++ b/drivers/clk/clk-stm32f4.c
@@ -888,7 +888,6 @@ static int __init stm32f4_pll_ssc_parse_dt(struct device_node *np,
 					   struct stm32f4_pll_ssc *conf)
 {
 	int ret;
-	const char *s;
 
 	if (!conf)
 		return -EINVAL;
@@ -916,7 +915,8 @@ static int __init stm32f4_pll_ssc_parse_dt(struct device_node *np,
 	conf->mod_type = ret;
 
 	pr_debug("%pOF: SSCG settings: mod_freq: %d, mod_depth: %d mod_method: %s [%d]\n",
-		 np, conf->mod_freq, conf->mod_depth, s, conf->mod_type);
+		 np, conf->mod_freq, conf->mod_depth,
+		 stm32f4_ssc_mod_methods[ret], conf->mod_type);
 
 	return 0;
 }
-- 
2.39.5



