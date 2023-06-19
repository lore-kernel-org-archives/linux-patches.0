Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581E5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B68BC433C9;
	Mon, 19 Jun 2023 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171517;
	bh=+Uc/69FxdQG6Cx4lTgPkXnqoeB2Ro0Egv3BZI2vb6mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v18ElXHcb7saOl8x490pCavfwMhHMQoHUCl9aSovz91UqrtpL+KFy/Zom7ylRU881
	 Tvsz0cXFTuo7J0xJRDhzasfwIAWohhH22GB/I8cFXWAux/nqYwhLUrZLWkJlpiOe/9
	 Om5aZ4X8a4VKbroDLof8pHNSmujrzgadcHZyh7pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/166] irqchip/meson-gpio: Mark OF related data as maybe unused
Date: Mon, 19 Jun 2023 12:28:19 +0200
Message-ID: <20230619102155.805889534@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 14130211be5366a91ec07c3284c183b75d8fba17 ]

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/irqchip/irq-meson-gpio.c:153:34: error: ‘meson_irq_gpio_matches’ defined but not used [-Werror=unused-const-variable=]

Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230512164506.212267-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-meson-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-meson-gpio.c b/drivers/irqchip/irq-meson-gpio.c
index 2aaa9aad3e87a..7da18ef952119 100644
--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -150,7 +150,7 @@ static const struct meson_gpio_irq_params s4_params = {
 	INIT_MESON_S4_COMMON_DATA(82)
 };
 
-static const struct of_device_id meson_irq_gpio_matches[] = {
+static const struct of_device_id meson_irq_gpio_matches[] __maybe_unused = {
 	{ .compatible = "amlogic,meson8-gpio-intc", .data = &meson8_params },
 	{ .compatible = "amlogic,meson8b-gpio-intc", .data = &meson8b_params },
 	{ .compatible = "amlogic,meson-gxbb-gpio-intc", .data = &gxbb_params },
-- 
2.39.2



