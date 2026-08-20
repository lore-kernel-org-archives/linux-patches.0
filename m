Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D2C47D95F;
	Thu, 20 Aug 2026 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244224; cv=none; b=Mq6dJa2JVchMlvl4G6tFab05sVsBebn5UlR/U6Yna5R8ca3JjVgFoMJglH78FPGXjMr7U6dN+wZG0BjqX1yVMKyhQXgGeJoIT2Xp9uZbwytDabzsE7O/l2d6xDUpBCyU0N8uA4KhnZoLdGXyCaGpk2O9FJMmkwjGuR+cSP/1OJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244224; c=relaxed/simple;
	bh=vj0CCPR83/uoK4zYNhe76bF35knsJngpACEaGcEUEpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CluEriR44mTrB9uWgbLvCJIIbSbgh4tTOHXppfFOadJ7XPa6Nx5+KSehMxFhT/gYkwPogpmyi4qif7LzjENEJQxdNOIiLwLryLnxNml0jlPr3ustvnKzXsDLje2JSWGYtyv2YRRHdmGFjQ5QPLbbK4hGWv9GDR8/njc5+ep14g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRSuXIgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRSuXIgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F31F000E9;
	Thu, 20 Aug 2026 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244222;
	bh=P+xKBIpxULQrpX8wx1iMYXa2pBhoqTDU0C8MCuWtZVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRSuXIgnKCiDTRpS2VHNVYA9tYP4x0+4V6ekzR7rRwhGdX9+YMamRUmfNhpqCAc5B
	 i/Tb2eXkTvva3ROOjdLblBjmQ3o18Edc210+/wceuehHduGFZtY9s8MsjUg+RA49xz
	 uoVjK2qoFH9dUzLTmVGLjxnOLUuGVMy3doE0xp9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/235] serial: max310x: replace bare use of unsigned with unsigned int (checkpatch)
Date: Thu, 20 Aug 2026 16:54:53 +0200
Message-ID: <20260820145218.177410811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1215,7 +1215,7 @@ static int __maybe_unused max310x_resume
 static SIMPLE_DEV_PM_OPS(max310x_pm_ops, max310x_suspend, max310x_resume);
 
 #ifdef CONFIG_GPIOLIB
-static int max310x_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int max310x_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	unsigned int val;
 	struct max310x_port *s = gpiochip_get_data(chip);
@@ -1226,7 +1226,7 @@ static int max310x_gpio_get(struct gpio_
 	return !!((val >> 4) & (1 << (offset % 4)));
 }
 
-static void max310x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+static void max310x_gpio_set(struct gpio_chip *chip, unsigned int offset, int value)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
 	struct uart_port *port = &s->p[offset / 4].port;
@@ -1235,7 +1235,7 @@ static void max310x_gpio_set(struct gpio
 			    value ? 1 << (offset % 4) : 0);
 }
 
-static int max310x_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static int max310x_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
 	struct uart_port *port = &s->p[offset / 4].port;
@@ -1246,7 +1246,7 @@ static int max310x_gpio_direction_input(
 }
 
 static int max310x_gpio_direction_output(struct gpio_chip *chip,
-					 unsigned offset, int value)
+					 unsigned int offset, int value)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
 	struct uart_port *port = &s->p[offset / 4].port;


