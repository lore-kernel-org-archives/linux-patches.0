Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08034AB1A;
	Tue, 26 Aug 2025 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216413; cv=none; b=VezpPzMtBi+XPZ11gZMIt7F0JhDRfMhwKoCZpPDRU2ogGHuzzq8l3AuZLgggW2OVoavk/L8MU9iaLHduXG/FE5OYv4bOo2ns/LRYB8yYbVrqfOsaOMjO299zLJgojIhY3btDJ6d7BJ2RUcmuAgMV/nlLYwwZzs6zq5R85vkWA6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216413; c=relaxed/simple;
	bh=AThf7cOXpP1RPyvf8P7T7Z1d4Xeao3vhROfzpC0cZ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5a33e3AbWhtsUMeRgMKwoRkzbKdoN3uOe0zdtFqTkXb5rgkkwlAh5tgqvYvTPGLR8aSSeFWbwhecFbDDBLiOxVt4vTnDvm5CnIvMnH5nuklNvA86R7ds0mRNC1yl+ZklKK0diOfebOLqGISrcSHSh0HWcDCD6RZ10SX6Ah4caM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0jWEkt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0jWEkt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B89CC4CEF1;
	Tue, 26 Aug 2025 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216412;
	bh=AThf7cOXpP1RPyvf8P7T7Z1d4Xeao3vhROfzpC0cZ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0jWEkt5xUvQYI8LjVu8oUKol5orIc/BOdoeNHqQGl0ISfXC65AY+2y3km89ZOPv8
	 5w6lhlGX+ZZFaosCAkql9SKF67ozoGGvN14H8V1qfDR7YwrIvRNxmAxE7uA4kBfNuI
	 IFZ7MOITgmrQpnHeUnPhgtS5FBaFKeqDJ3iJFT5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/644] pinctrl: stm32: Manage irq affinity settings
Date: Tue, 26 Aug 2025 13:08:14 +0200
Message-ID: <20250826110956.438581574@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abb12a5c3c32..821ec5a97551 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -412,6 +412,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



