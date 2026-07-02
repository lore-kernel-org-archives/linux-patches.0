Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5746F36215B;
	Thu,  2 Jul 2026 16:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010198; cv=none; b=vFs0aMDbwD/yj/VOrwKNJOk+MCOq6gjEhfPC5cobMnRNdKcEmwrZSsRUVAxvCrkI0wcU5Dx5Kwb/w1LzneEn1E7kWDts/WvjOGnO8k1TDuAA/lI6Bivaiu9iCYCNG97aNYgSsaN4G/mw80OhFWdF6MqJmzJ2GSC4Ac276YPp9SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010198; c=relaxed/simple;
	bh=A60A2sBi7HHfgEoo9mV3PTh5tUmmAGAk9ESxC/kYCks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDxNg64cXIuSf5//qZ5Uw8WLZaJusuQqPyGs4PGwltNFT6y71JRTXY3GRIN3xkzp+JdPmn2y+nL6BonTy1xpwm/tpE2MBHFK7uUOwcMnxQsf7ZNSykenzDiSYrbR1OUGwLvH5rL0FyFzabRvUqYgN5OGfGs/vF7+/on27YmY3y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpWZCSb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpWZCSb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AAF1F000E9;
	Thu,  2 Jul 2026 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010195;
	bh=CyzrZLuzAY86qV1iIb3aRHMz8KTO9KtqvG1C0JZEuVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpWZCSb9XcID3MK1MujGEh1osDpWOx34MeLwI3LKfDNezGn5Wji5OwJlFxLsrRu9M
	 BK3QSsDRMP9ay+jqyOYra42r53RiXu6PC/p+qk3OQu/Ot++dwai/4cbPcTejykCh4o
	 h6donAfVKmUNmjXQrnHjdHjaFFVhX1qL3QNImVcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/204] gpiolib: Extract gpiochip_choose_fwnode() for wider use
Date: Thu,  2 Jul 2026 18:17:42 +0200
Message-ID: <20260702155118.781677897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 375790f18396b2ba706e031b150c58cd37b45a11 ]

Extract gpiochip_choose_fwnode() for the future use in another function.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Reviewed-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Link: https://lore.kernel.org/r/20250213195621.3133406-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 16fdabe143fc ("gpio: Fix resource leaks on errors in gpiochip_add_data_with_key()")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5c8cd816569634..d48a57b899f79c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -883,6 +883,21 @@ void *gpiochip_get_data(struct gpio_chip *gc)
 }
 EXPORT_SYMBOL_GPL(gpiochip_get_data);
 
+/*
+ * If the calling driver provides the specific firmware node,
+ * use it. Otherwise use the one from the parent device, if any.
+ */
+static struct fwnode_handle *gpiochip_choose_fwnode(struct gpio_chip *gc)
+{
+	if (gc->fwnode)
+		return gc->fwnode;
+
+	if (gc->parent)
+		return dev_fwnode(gc->parent);
+
+	return NULL;
+}
+
 int gpiochip_get_ngpios(struct gpio_chip *gc, struct device *dev)
 {
 	u32 ngpios = gc->ngpio;
@@ -942,14 +957,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	gc->gpiodev = gdev;
 	gpiochip_set_data(gc, data);
 
-	/*
-	 * If the calling driver did not initialize firmware node,
-	 * do it here using the parent device, if any.
-	 */
-	if (gc->fwnode)
-		device_set_node(&gdev->dev, gc->fwnode);
-	else if (gc->parent)
-		device_set_node(&gdev->dev, dev_fwnode(gc->parent));
+	device_set_node(&gdev->dev, gpiochip_choose_fwnode(gc));
 
 	gdev->id = ida_alloc(&gpio_ida, GFP_KERNEL);
 	if (gdev->id < 0) {
-- 
2.53.0



