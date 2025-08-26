Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6D187554;
	Tue, 26 Aug 2025 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214599; cv=none; b=PZvjJyrQt6AhoRfreHYyH4XClLgvgWsBSA9McAYiUMC6d2x6ZT0EKJxq6L8zDIKOOx1fVPxF5U5p5G/o7ZVj5OJtrFWx6eY6iqcBUM7+DQcWgQKU17P8j/UbMP2qHl9/3m919VZNXh8ND1m8T+FHgd3KGnRbjvqtI8XYqZKJGG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214599; c=relaxed/simple;
	bh=1mg3Kcr+eQ1vYD0MwBtpfSEp+z8LbLtRGxJJJeM179Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz0j3kHkPzxiRo75eqJVmFZ6ATyAQjDwIhqczMpCIId3WwzMonb5q9yaBx0muTY/MUjNtlBcz5SNG9ug3yhZFpybHA07VUVetoqWzhAucpcmfDMQzjgsdTQCb/aPAgQ0UhDrq6Q3QqxhJVXRnyWwEmpQUIFXZwxm+swl1acB/9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoWW9NyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoWW9NyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875A6C4CEF1;
	Tue, 26 Aug 2025 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214598;
	bh=1mg3Kcr+eQ1vYD0MwBtpfSEp+z8LbLtRGxJJJeM179Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoWW9NyNwuFchTNPUacVU0zO86VMlAe0azQcrQu/exK7iB/LX7i6SDSSj+63kyf/N
	 wUDGXj70fsIjhu+av+GZsPGHMcLdJropbz348l+baSb/m1PxdJpSYTfmJyPX+j43ft
	 7lcrR1lJXXQ8QJIBxUr4djxhRyA1QBu/Vufd94b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/482] pinctrl: stm32: Manage irq affinity settings
Date: Tue, 26 Aug 2025 13:07:32 +0200
Message-ID: <20250826110935.710652121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore@foss.st.com>

[ Upstream commit 4c5cc2f65386e22166ce006efe515c667aa075e4 ]

Trying to set the affinity of the interrupts associated to stm32
pinctrl results in a write error.

Fill struct irq_chip::irq_set_affinity to use the default helper
function.

Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-3-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 4a3f5f5b966d..661eb0c1f797 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -417,6 +417,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



