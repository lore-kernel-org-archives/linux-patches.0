Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB2D27A462;
	Thu, 15 Jan 2026 17:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498769; cv=none; b=sSe0/eHKMk1tj7/+x0Jq4Z5YADlA4pxaYYrG8Ook7CgP3FFYul+y8bkpNyW63N4So5sFULYcMAMCkdSL6qzzaFX9lTj2HldjT+yARjy5I+48lv+t0S1LJ4Oy/RW8LS/Tg+iIYd4J1kEIEdpMeIt0Vzawu0YSh07FyR/fbj8YWIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498769; c=relaxed/simple;
	bh=C9NWac1JEfykLDBZ7GQ9zYcgzcKDmozA+GMu5EEgUYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjtyPiU8zquZWvf+SQPdeWO5i7K2tBuGPYnZ7Mhr7aNwvnlzo0WL5kEKUBOStC7ht6GwYnyPNm1pdPi+NSs0SI1VouBFOrfYCB3ZP4EelujpPisfchHpPPZ2S5lgtrAVcmFAepXFHJoDgUmcaet/D3KbW+FvXWg2qPmtaeXHihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL2MCaEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL2MCaEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA0DC116D0;
	Thu, 15 Jan 2026 17:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498769;
	bh=C9NWac1JEfykLDBZ7GQ9zYcgzcKDmozA+GMu5EEgUYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL2MCaEWUXlC7u+pJSGGK+rJKbxzaDYSP0CZhcyEUotRl9+M20beSW8E21/qAzQvL
	 RCYr2XRcEfpyl7i2nsKGUYxMuc+VKcvY8fa3REx48QevJNmlDQe7UBUbC/nUfixQdP
	 2QkeUnjiqn9SZ6nGvlzt7WrVWQoeZmnSmaXVarG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 547/554] pinctrl: qcom: lpass-lpi: Remove duplicate assignment of of_gpio_n_cells
Date: Thu, 15 Jan 2026 17:50:13 +0100
Message-ID: <20260115164306.126812013@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a3fc976a2d68cb74ae4234314002e4e398e4c337 ]

The of_gpio_n_cells default is 2 when ->of_xlate() callback is
not defined. No need to assign it explicitly in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230112184923.80442-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: ebc18e9854e5 ("pinctrl: qcom: lpass-lpi: mark the GPIO controller as sleeping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
@@ -644,7 +644,6 @@ static int lpi_pinctrl_probe(struct plat
 	pctrl->chip.base = -1;
 	pctrl->chip.ngpio = data->npins;
 	pctrl->chip.label = dev_name(dev);
-	pctrl->chip.of_gpio_n_cells = 2;
 	pctrl->chip.can_sleep = false;
 
 	mutex_init(&pctrl->lock);


