Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016740;
	b=PSCZjTjL1gklIGfQlyZ0lrvDFRFEI5udPLAz+QV6SR30bJ+xQtOIXvYy2Jh0j31HSiOH
	 m0p6fWiWWHguU5Y7x+GeET17Wh4XcIfkx/310nqWuetxAiUQ5RrouhP2J1MoaUY0qS+y9
	 p+8QbkDyYX+38I1lbWfcYEODs+saj0Q0jEexBwVUPFou3CJP2lkXjcSbyvuACci77Al0E
	 bBQAMSd9J3siOasDEPrNNDXI8qB/3onvDIlUZefRDew/RBjWG78RD2SGZGkONdzTa3RvF
	 AjGEmU/ix/l4ES1jlQinzoMe/XLPGvQYi0Q0SmB644wOLa0pOpcHKC2N/65wps/XhSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1+7VGhsFKhdFHQy5am+UACJS8AUpABTdEQ9Cq6Jx6Y=;
	b=qQYNbn/Su3elCrICbjfatzrCmUoDKxWYpuoViqLz4lbd0XP1pbR1gOdKPEr/mxOEfTBp
	 RWc8VrF8orEmCtAAA6SRffi/J0dG+T1uJyzS6p8nb5rZ0UioMxwf2zlnqHubl3zerAp1w
	 863DGpeMhAcERbLrlAgHXmIgxne3h6p8YI/xEBCUYXo6/Pm7s7CS0XCLqi45eU9DVXh/C
	 Atoef+UdM9Cs6rav9QtYYdHvS3OD3gVk52htq2znw8Pc8PhY0qrgm278ix3Dj5gxT/F4L
	 z6M1FJSSzXVgzVVp7ciC+5mGJj/K6W5/AnP3hDpK1CxWhPgCGaKMjgLDOwzFTq+qsoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbWwCBzs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B86606A320;
	Wed, 18 Nov 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbWwCBzs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129801F000C4;
	Wed, 18 Nov 2026 15:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016740;
	bh=t1+7VGhsFKhdFHQy5am+UACJS8AUpABTdEQ9Cq6Jx6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbWwCBzssdfiZ45YKuB4qY+dSwALXlqd1PxYoXWGnY7bLp+hJAk6szsyzmhTgTxfE
	 VRWG8cd5PHLgKa7XxTk/raV1xRz8hVT83RegwtVqIITtsRd4NoZd9OFtjyQEwAGi3z
	 qzyQrR1viT6igiJTb9IzmNhG+IOqp7SO6BnsAav8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0635/2651] leds: lp8860: Fix device_node leak in lp8860_probe()
Date: Wed, 18 Nov 2026 15:31:15 +0100
Message-ID: <20261118150310.544233217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miles Krause <mileskrause5200@gmail.com>

[ Upstream commit f9879086c4eb4b3b0f4baa80139a5720b99b229e ]

lp8860_probe() looks up the driver's single LED child node with
of_get_next_available_child() and hands it to the LED core as
init_data.fwnode, but never drops the reference that lookup returned:

	child_node = of_get_next_available_child(np, NULL);
	if (!child_node)
		return -EINVAL;
	...
	init_data.fwnode = of_fwnode_handle(child_node);

of_get_next_available_child() returns the node with its refcount
incremented, and the LED core does not take a reference of its own:
led_classdev_register_ext() only reads properties out of
init_data.fwnode and then stores the bare pointer with
device_set_node().  The reference therefore stays owned by the driver
for as long as it holds the node.

Nothing in lp8860_probe() ever releases it, so it is leaked on every
error return taken after the lookup - the enable GPIO, the vled
regulator, devm_mutex_init(), the regmap allocation, the optional
EEPROM programming and the LED class registration - and on a fully
successful probe alike.  A device that binds and unbinds repeatedly
leaks one device_node reference per bind.

Sibling drivers already get this right: leds-lm3692x.c, from the same
TI LED family, calls fwnode_handle_put(init_data.fwnode) once after
devm_led_classdev_register_ext() to cover both outcomes, while
leds-ktd2692.c and leds-aat1290.c take the node with __free(device_node).

Use __free(device_node) here too.  Unlike a single of_node_put() at the
end of probe it also covers the intermediate error returns, and it keeps
the node alive for the whole function, which the LED core still needs
when it reads the child's properties during registration.

Fixes: 99ca0ea57309 ("leds: lp8860: Use generic support for composing LED names")
Signed-off-by: Miles Krause <mileskrause5200@gmail.com>
Link: https://patch.msgid.link/20260910-leds-lp8860-of-node-leak-v1-1-d333cff4345b@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp8860.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp8860.c b/drivers/leds/leds-lp8860.c
index 69f064781f699..f6e4227de903a 100644
--- a/drivers/leds/leds-lp8860.c
+++ b/drivers/leds/leds-lp8860.c
@@ -7,6 +7,7 @@
  * Author: Dan Murphy <dmurphy@ti.com>
  */
 
+#include <linux/cleanup.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/leds.h>
@@ -274,7 +275,6 @@ static int lp8860_probe(struct i2c_client *client)
 	int ret;
 	struct lp8860_led *led;
 	struct device_node *np = dev_of_node(&client->dev);
-	struct device_node *child_node;
 	struct led_init_data init_data = {};
 	struct gpio_desc *enable_gpio;
 
@@ -282,7 +282,8 @@ static int lp8860_probe(struct i2c_client *client)
 	if (!led)
 		return -ENOMEM;
 
-	child_node = of_get_next_available_child(np, NULL);
+	struct device_node *child_node __free(device_node) =
+		of_get_next_available_child(np, NULL);
 	if (!child_node)
 		return -EINVAL;
 
-- 
2.53.0



