Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F228647CA61;
	Thu, 20 Aug 2026 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243347; cv=none; b=ooSTgtCGqyi1eMZYII0Y1Vm3mmfgLzv84OJnOH9bDoRdXAKSZzL0D1n3qCzfM8fDeSTOvskvnbLRBzyERCA+Roo53hWi5FXJc4yfKPukfJxFSX44+omjZIg3+XAntklSYxQEBGtPBURghF/cVAKkLwaG8MyTPkzXD1yo9ptlBu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243347; c=relaxed/simple;
	bh=hrgHStkMR2fjEXNXS2D7a5mBRLTJRn8Y6O7juIglrdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+aFhL2HpfuzCToeH94DrGJ+OXcur3O83THNZfQLyId+h6qaFLspOdLPvRcAmlO/CKU7qLhGUnC1dZfFm6fapBZMsxxiP5qAFJB70Mol8ba08hp2Io6ArZBfiu/9tD3Nbe90DZHwwWdoCDrqxqhfy5SMGuMHjLbS1UPaDPn7voY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGoyqseA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGoyqseA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5955F1F00A3A;
	Thu, 20 Aug 2026 16:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243345;
	bh=0KfLOCzmcHZwK4Y6I6Wzmbs8svCwf6a2ovyGAnU7rm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGoyqseA4OldC9oUMMU3HmFya6G8qKiug2c/qg3K6plk0lW2B1ERSgwCEnQjk1u8u
	 7d+vdYGdGd3/CRT32N7at30ClzLdygjMjGS/GJBlWDj5FmpsOgkED+ZrQxZ+4uUtpD
	 TNsyDwwCwQTENUmBMSy3Ei0EcvwoknQ9OzP7h8Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/272] serial: max310x: replace bare use of unsigned with unsigned int (checkpatch)
Date: Thu, 20 Aug 2026 16:54:06 +0200
Message-ID: <20260820145233.153951532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 79b69eb09cf5b6a77e621b2838b7e0d38113debb ]

Fixes the following checkpatch warnings:

    WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

With this change, the affected functions now match the prototypes in
struct gpio_chip.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-16-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a483b1a91b33 ("serial: max310x: implement gpio_chip::get_direction()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1193,7 +1193,7 @@ static int __maybe_unused max310x_resume
 static SIMPLE_DEV_PM_OPS(max310x_pm_ops, max310x_suspend, max310x_resume);
 
 #ifdef CONFIG_GPIOLIB
-static int max310x_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int max310x_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	unsigned int val;
 	struct max310x_port *s = gpiochip_get_data(chip);
@@ -1204,7 +1204,7 @@ static int max310x_gpio_get(struct gpio_
 	return !!((val >> 4) & (1 << (offset % 4)));
 }
 
-static void max310x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+static void max310x_gpio_set(struct gpio_chip *chip, unsigned int offset, int value)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
 	struct uart_port *port = &s->p[offset / 4].port;
@@ -1213,7 +1213,7 @@ static void max310x_gpio_set(struct gpio
 			    value ? 1 << (offset % 4) : 0);
 }
 
-static int max310x_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static int max310x_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
 	struct uart_port *port = &s->p[offset / 4].port;
@@ -1224,7 +1224,7 @@ static int max310x_gpio_direction_input(
 }
 
 static int max310x_gpio_direction_output(struct gpio_chip *chip,
-					 unsigned offset, int value)
+					 unsigned int offset, int value)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
 	struct uart_port *port = &s->p[offset / 4].port;


