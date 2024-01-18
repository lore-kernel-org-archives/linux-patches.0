Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4281774B;
	Thu, 18 Jan 2024 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575394; cv=none; b=knxcjPZIy0d/JKV6UOU1zmxLW5TzejW6oMNjX1ogAqXxN2YNXragBjwOVa3Pk0I6oIT27SGPNvUV1HjMgx5MPqKXIN+vJWFG3p5nhNkHlSmAXawZj1GqZwR4YPxRmxynLS0fvX4o8Tr5QnPS8jXHsvM29erYOIiNcCwqEH+BGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575394; c=relaxed/simple;
	bh=S063pxOHt0JxA2NI1eBeWXVleD1EJJLGJ/lEpOIEwAE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=AxUm7wYorq+rLPsaCTMia9qTgiHJplKDJ9jciFDKcP7BhhShS6bN8ffynvTwY+WptVmre/ROCMSTBzYebS2ItBOdFiX37Zl8hLyGJmpEWFi71XytVwgHRxfiYxOZnkdB3Bd0C7a4GfAkhcIXwayJWMvy2kpqG1ebJDnKQ63R82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML4sPu2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML4sPu2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E30C433C7;
	Thu, 18 Jan 2024 10:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575393;
	bh=S063pxOHt0JxA2NI1eBeWXVleD1EJJLGJ/lEpOIEwAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML4sPu2rgLe/ImoUVxwvDo69sVKSR1sobJ2REZn3SnRWZ3JbLRWtECBb0+YyUD0PJ
	 c1kaUBjktaNGOsU8m3q7O9zWAIl8FJY/szmduOfdgO+cR4W1hmptBmq0eNf8S5Mw0D
	 zHKFPQVJR01u35BWQR7K7R0N4LLyL1vGV5M/T3K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/150] pinctrl: cy8c95x0: Fix typo
Date: Thu, 18 Jan 2024 11:48:58 +0100
Message-ID: <20240118104325.421288288@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 47b1fa48116238208c1b1198dba10f56fc1b6eb2 ]

Fix typo to make pinctrl-cy8c95x compile again.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20231219125120.4028862-1-patrick.rudolph@9elements.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 58ca6fac7849..993b30ebc684 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -821,7 +821,7 @@ static int cy8c95x0_setup_gpiochip(struct cy8c95x0_pinctrl *chip)
 	gc->get_direction = cy8c95x0_gpio_get_direction;
 	gc->get_multiple = cy8c95x0_gpio_get_multiple;
 	gc->set_multiple = cy8c95x0_gpio_set_multiple;
-	gc->set_config = gpiochip_generic_config,
+	gc->set_config = gpiochip_generic_config;
 	gc->can_sleep = true;
 	gc->add_pin_ranges = cy8c95x0_add_pin_ranges;
 
-- 
2.43.0



