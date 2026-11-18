Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024077;
	b=CyiGaavsA9krzKwtNLw1/Zkii1TwMPZU4I3pt9c54iXkgXbvTF+r0QeXEBbOfzEe1RyF
	 iwYuAuXwHVhlIAkIsHQ1wlfXKj30Ga3P44KoDx1ONPJlg2MCKjeIwMs0E6oMFdxzUyH/5
	 lc/WNyl/OIk2QtYKFmDMFt3oEpQng8qkVfi4Frl7X2gqkSUojLPFzWwFM3jFbNhsQX0+V
	 YkDjVBXwBplqKJlBS7B4ohUjbY6FUYw4WCEb8f3LSVhAMz4xOgDAXSDH3kaWSAaiYt9n8
	 WyzWE5LylGqhWMGy8Kr0bbCoEHrri3H31bQC4DTe9s3DTtmxqtspBfXbTVuZBwJM5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUo9DK+j0CDSFSbOpaauHfSop0FNp/fecoaFGJGv+rY=;
	b=EoAnfao3RyBjlO1MA6kqjzKNFVwMYtNXJk6lyIL56NPXdGxXudB3INDZMIcK8UPNbkjS
	 lvUeH6HE/juN2mTA4cAdej/KLY1xYplF0J+NgABkXpUWpoBU9VnxNqccyUjQ5JqKdESjh
	 U4f20wtgiPKjnGI1zICaFhkxvJzzGDrnhqbAOqkRvuc4BjVq0OC0e5/reLS3DPsJ6pbuE
	 kiFrUUFjfITA7FQrUYjA9myjlUZisvXlDRMeVve5peQ55vz8h9NP5aBhC0K5sh4uAP+2q
	 ImTG5HtUjl1VRBl8syoFLCGq0mzjS/y5RL1A+7qCxjD0RlfFF8zzfJGvPnW6nuySOTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNhB7d9F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E8606A31C;
	Wed, 18 Nov 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNhB7d9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F3D1F000C4;
	Wed, 18 Nov 2026 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024076;
	bh=SUo9DK+j0CDSFSbOpaauHfSop0FNp/fecoaFGJGv+rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNhB7d9FXG8lqWnvHD6ZuUvFb+/Dv0al44p/qXbOEm63TndAbBhcqJh/0RNJpLYNn
	 VckgCiC0/GRi5yIyNz4VyFwMAPuoh3hs0iFychi3ZhVr8YiyySRPGoL8ghafZbJCEv
	 fAu3cAyVqUhB1W6rbkkH2vt6bHBzvdGoQDWzZeaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0596/2151] leds: st1202: Take a reference on the LED firmware node
Date: Wed, 18 Nov 2026 15:38:51 +0100
Message-ID: <20261118150143.660981807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit 5882de94edf7a53812a76a882a95e1e86d7105d9 ]

st1202_dt_init() stores each LED's firmware node while walking the
device tree with for_each_available_child_of_node_scoped(), which drops
its reference to the node at the end of every iteration. The LED class
stores the pointer with device_set_node() and does not take a reference
of its own, so nothing keeps the node alive for as long as the LED
device uses it. That has been the case since the driver was added, when
the LED class devices were registered inside that same loop.

Commit c72e455b89f2 ("leds: leds-st1202: Fix NULL pointer access on race
condition") moved the registration into a separate loop in
st1202_probe(), which also leaves the stored pointer unreferenced
between the two loops.

With CONFIG_OF_DYNAMIC the node can be freed while it is still in use,
leaving led->fwnode and the LED device's firmware node dangling.

Take a reference when the node is stored and release it through a devm
action. The action is registered before the LED class devices are, so it
runs after they have been unregistered.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB849710C564F23C21BDA3EA41C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 25e548b023364..46228ecb52cac 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -13,6 +13,7 @@
 #include <linux/i2c.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -400,6 +401,11 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 	return 0;
 }
 
+static void st1202_fwnode_put(void *data)
+{
+	fwnode_handle_put(data);
+}
+
 static int st1202_dt_init(struct st1202_chip *chip)
 {
 	struct device *dev = &chip->client->dev;
@@ -419,7 +425,11 @@ static int st1202_dt_init(struct st1202_chip *chip)
 
 		led = &chip->leds[reg];
 		led->is_active = true;
-		led->fwnode = of_fwnode_handle(child);
+		led->fwnode = fwnode_handle_get(of_fwnode_handle(child));
+
+		err = devm_add_action_or_reset(dev, st1202_fwnode_put, led->fwnode);
+		if (err)
+			return err;
 
 		led->led_cdev.max_brightness = U8_MAX;
 		led->led_cdev.brightness_set_blocking = st1202_led_set;
-- 
2.53.0



