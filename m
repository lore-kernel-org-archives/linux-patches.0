Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229141BEF9D
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891163; cv=none; b=hmw9qN2OthD8CTR+w/ncaGh7HQDlYBnRg8meKAuBI5JRUbg93QArx76FnopBlhhcfLwREouAjfqn4S06RtkY0kI0XrgUUgOm7cP/MA8ESskL0+yF6xipxQ9P/hos7U+cVXPOPGV7Y4x6FLuT7BCUI45j+M7uKoebzEcdNgYUAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891163; c=relaxed/simple;
	bh=DYDnWhpnLtX4Dhv9suXW1x6bNilfnHXbyxsxBya8CKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JiCOmX7tM5pHSCKFEuhEXbasccnKpHiskh/dBgNtbnzCGBK/xs7b6qRtDxcOGAsJlBjvOe2beoNnb2EXxDa9axIMp/ZfeNKgWnwkKPIrgFvaiPtbDKQY/v1wtat6NAmnAimpfSKbBAW75b/0oyhnuBEWGY+1v1ppuTBn1hoD9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=DgJE7SA9; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="DgJE7SA9"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id DE0CF3F190;
	Wed, 11 Dec 2024 04:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733891160;
	bh=xBQgUIUYy4rLZDmSDt+PADaoBv2f76aIMN12SaDrpes=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=DgJE7SA9wsIH+7aO65uA1jhvoxuWjnrN+Q8sN3X88xeVyF/LNlHQ2XLGnZKuuLT5a
	 vcAKJTwF/gslc+3eE4Oq7T6k2XkxqROCqrud3QbPJ8LwwsCF27P3g6BUfT4SHY8IBp
	 5FS43E08/dw51HRxx9Wy13o7sIN1D746s5+xQ1dW5mqcBVe0ktt/rJaUt1VasQfVst
	 FdfbI22YCHVHRvaNg8yokF2HmALB6rG4e/eOSJRjElONs00AAizKEG9U4m4429yGFA
	 4CANgNVi48dhj9F9NHpE7r1osw5DTGlp2k2jx0bQHPZQjEC+9N9XtBFGxHm9sXgh6F
	 0Fl19DzlXyrOg==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stable-kernel][5.15.y][PATCH 3/5] serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
Date: Wed, 11 Dec 2024 12:25:42 +0800
Message-Id: <20241211042545.202482-4-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241211042545.202482-1-hui.wang@canonical.com>
References: <20241211042545.202482-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit f6959c5217bd799bcb770b95d3c09b3244e175c6 upstream.

Remove global struct regmap so that it is more obvious that this
regmap is to be used only in the probe function.

Also add a comment to that effect in probe function.

[Hui: fixed some conflict when backporting to 5.15.y]

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/tty/serial/sc16is7xx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 35001cc7ec90..90b39ddec082 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -323,7 +323,6 @@ struct sc16is7xx_one {
 
 struct sc16is7xx_port {
 	const struct sc16is7xx_devtype	*devtype;
-	struct regmap			*regmap;
 	struct clk			*clk;
 #ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
@@ -1222,6 +1221,10 @@ static int sc16is7xx_probe(struct device *dev,
 	 * This device does not have an identification register that would
 	 * tell us if we are really connected to the correct device.
 	 * The best we can do is to check if communication is at all possible.
+	 *
+	 * Note: regmap[0] is used in the probe function to access registers
+	 * common to all channels/ports, as it is guaranteed to be present on
+	 * all variants.
 	 */
 	ret = regmap_read(regmaps[0], SC16IS7XX_LSR_REG, &val);
 	if (ret < 0)
@@ -1257,7 +1260,6 @@ static int sc16is7xx_probe(struct device *dev,
 			return -EINVAL;
 	}
 
-	s->regmap = regmaps[0];
 	s->devtype = devtype;
 	dev_set_drvdata(dev, s);
 	mutex_init(&s->efr_lock);
@@ -1272,7 +1274,7 @@ static int sc16is7xx_probe(struct device *dev,
 	sched_set_fifo(s->kworker_task);
 
 	/* reset device, purging any pending irq / data */
-	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG,
+	regmap_write(regmaps[0], SC16IS7XX_IOCONTROL_REG,
 		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
-- 
2.34.1

