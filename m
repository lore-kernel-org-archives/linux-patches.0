Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568492B9B7;
	Tue,  5 Aug 2025 13:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399397; cv=none; b=H622ccwng19unZc+2svM5S+1AfjY8QpLXlaAo4SU7m9ysbMCc7VjwyvcdpRoyFLi9VLYa3MBsanuNWK1sVj6RtJhiVaYhC26dcvZ1nHhLh5WgfQuK9OFfWOiBMxFTL4vZSZByVu65zSKvdt3w4ZScjliee+weDLqeQsXyzmpkxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399397; c=relaxed/simple;
	bh=Qyw2Seyv99FKHqkQGzgzhkf96Afcfp/hz1VcHx8L4aU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RoTKgQjsHJPiTtejqXkuc4Imijc6kZ1iYpKW6hR5KpqyS7eOSBTbwx0s184JIwHbLroC/9AW2/Qkak4OMvdL0xo5wIO/FzzzzXI5aVrWfW9SR7c2+feTw+1o8WnmoH0+oXQOkGe6v7G3I3e4KUWgn2iLoKhlguxC/0LJS8aX0MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oa90mp6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oa90mp6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396ACC4CEF0;
	Tue,  5 Aug 2025 13:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399396;
	bh=Qyw2Seyv99FKHqkQGzgzhkf96Afcfp/hz1VcHx8L4aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oa90mp6nH2jmdGDeDx1W6U4hN+VoFrpFYw8lSlcVrLD7Kstvd5GNfHl2W+ARRl/Ga
	 55iTAvlm8ApdzRQ+/YVnX8SVLD5+zeItIpXqmnm9PHBhyo6w6VD0e7isyWKeAhvnmL
	 b9mkh/z15OXSaT1aXtGJXO4bEYanDb6m5SHhIQ8r0gRg6EW8HjdXG1s7WY+JBf5oPv
	 gKkXplf0G9px9l1bT0u/WECjJcj3mJnKuUtAt1UuMeUdulH0Tt1NBglRnjfG5DcT0n
	 /ZHhp79srmnIb7ZleUdNF+3WYWlbreS9Kv58xWxnJCOq30ArtYOqmiSiEW9hIEC/QS
	 DBUCEBVdOEDxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16-5.4] pinctrl: stm32: Manage irq affinity settings
Date: Tue,  5 Aug 2025 09:08:40 -0400
Message-Id: <20250805130945.471732-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug**: The commit message explicitly states "Trying to
   set the affinity of the interrupts associated to stm32 pinctrl
   results in a write error." This is a functional bug that affects
   users trying to configure IRQ affinity on STM32 platforms.

2. **Small and contained fix**: The change is minimal - just adding a
   single line:
  ```c
  .irq_set_affinity = IS_ENABLED(CONFIG_SMP) ?
  irq_chip_set_affinity_parent : NULL,
  ```
  This is a one-line fix that adds the missing callback to the irq_chip
  structure.

3. **Follows established patterns**: My analysis shows that other
   GPIO/pinctrl drivers already implement this callback in the same way:
   - `drivers/pinctrl/renesas/pinctrl-rzg2l.c`
   - `drivers/gpio/gpio-thunderx.c`
   - `drivers/gpio/gpio-msc313.c`

   The STM32 driver was missing this standard callback that other
similar drivers have.

4. **No architectural changes**: This is purely a bug fix that enables
   existing kernel functionality (IRQ affinity setting) to work
   properly. It doesn't introduce new features or change any
   architecture.

5. **Minimal regression risk**: The fix uses the standard
   `irq_chip_set_affinity_parent` helper function that's already well-
   tested in the kernel. The conditional compilation with
   `IS_ENABLED(CONFIG_SMP)` ensures it's only enabled on SMP systems
   where it's relevant.

6. **Related to known issues**: My search found related commits like
   `3e17683ff4a8` ("irqchip/stm32-exti: Fix irq_set_affinity return
   value") showing that the STM32 platform has had IRQ affinity issues
   that needed fixing.

7. **Clear user impact**: Without this fix, users cannot set IRQ
   affinity for GPIO interrupts on STM32 platforms, which can impact
   system performance optimization and interrupt load balancing on
   multi-core STM32 systems.

The commit meets all the stable tree criteria: it fixes an important
bug, is small and self-contained, has minimal risk, and doesn't
introduce new functionality. This is exactly the type of fix that should
be backported to ensure stable kernels have proper functionality.

 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index ba49d48c3a1d..e6ad63df82b7 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -411,6 +411,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5

