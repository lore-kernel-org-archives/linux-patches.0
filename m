Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060565;
	b=faKoU/vslxIslcoLPxpZ+m5sqqGItCWTUadwiCU9/F1euNZqWX/SSWYlEI7S0CVo/QJ6
	 cRehk9xOTipRq1DRCkGfZePa2E+dgRe38tYYWzMmzMkQ9KgfoHoNJc9w1Zz3AGXlKw7gF
	 ZsZ2ScgJUJxY4dhove5ehabJ84Up44mRNSVveWaNiZE7NlCcQ23Jyl+DL0GZ82+INUXGz
	 p5WdbAzcv3alJNPDOYkln6h/Y/m7q7QTQQJc023f3yz825xkYLJkxArt6rOSDs322We24
	 vlUoDt4E1Ubj6Ob6/hywCp0yNFte++SgQIEGd4/jHDoJoZK4/hVTfBUxIQj9rESNuyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f9dCLG4DWEHoUDXEvwtTOIZMtY5RkhMwUYuEmSjxiyI=;
	b=CJX7A9NXt5HoUSj/BunrrNW/RQQ6EyXC9S6CMUF0YnU9Kt3VBrtwON6QOZ/ArRP30d9+
	 WhQveTadEVwU19Cxd4JhA2O5MZHHbDdLzLMl5Xt2nFPyqYJcL7Klgnii4VWm6gWZQvKVw
	 xjRNt7e8296cfcU4A1B7DMg+Svijw+0o9qOt8ZUO+EGVrfsjCqEzE/wDvsiaYOPZYvl5a
	 kGIGxLDk8LNeRKBRb5fQshbzBBpBUC4J4Z7xtYw/ZivOYYjyHgZqTpZQFCUcqO6DliJX3
	 b8Dik90wdjeyufXQGfkA8CmQSHud1H/pICyuk3ihYdZ5ER0kE1EIZIZlt56uOkDq2Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WjbOXGIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0247A606A320;
	Thu, 19 Nov 2026 03:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WjbOXGIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAF51F000C4;
	Thu, 19 Nov 2026 03:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060564;
	bh=f9dCLG4DWEHoUDXEvwtTOIZMtY5RkhMwUYuEmSjxiyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjbOXGIW3e/dMQnF1pMUXnP7ZzbXbILPLKD0oJf+QzR5io5pjKibsfVX2P2MIZTTc
	 I/o70QRp2zRNQwD3pNAZEvGczwfytQiTQpUqRtn/LFvBgXU+TnVlCeIg5ggh4LIDf4
	 Pw4RDKOmDPlexoCUA4u+amdjVU1kBogYEI2AXPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Brue <ryanbrue.dev@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1202/1848] power: supply: bq24190_charger: use the wake irq API
Date: Wed, 18 Nov 2026 15:54:00 +0100
Message-ID: <20261118150010.248017636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Brue <ryanbrue.dev@gmail.com>

[ Upstream commit ece9baab2a6e79224d3f591893be23b540b1625f ]

bq24190_probe() calls enable_irq_wake() on the charger interrupt and
never calls disable_irq_wake(). That is wrong in three ways.

It is unbalanced. free_irq() does not touch desc->wake_depth -- only
irq_set_irq_wake() does -- so after the driver is unbound the descriptor
is still one wake reference deep and the irqchip is still configured for
wake, forever, for an interrupt nobody owns any more.

It ignores the device's wakeup policy. The chip is made a system wake
source whether or not anyone asked for it, and because
device_init_wakeup() is never called there is no power/wakeup attribute
for userspace to say otherwise. A board that would rather not be woken
by its charger has no way to express that.

And it arms the interrupt for wake permanently, from probe onwards,
rather than for the sleep it is meant to cover.

Use the wake irq API instead: devm_device_init_wakeup() to make the
device wakeup-capable and enabled -- preserving today's behaviour -- and
devm_pm_set_wake_irq() to hand the interrupt to the PM core, which arms
it in dpm_suspend_noirq() (only if device_may_wakeup(), immediately
before suspend_device_irqs()) and disarms it on resume. Both are unwound
by devm, so the reference is balanced on unbind, and userspace gets the
power/wakeup control it should have had.

No intended change in behaviour: charger events still wake the system by
default.

The same conversion was made to another charger driver for the same
reason, in commit 6c5393771c50 ("power: supply: qcom_pmi8998_charger: fix
wakeirq").

Fixes: f385e6e2a153 ("power: bq24190_charger: Use PM runtime autosuspend")
Assisted-by: LLM
Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
Link: https://patch.msgid.link/20260908-rbrue-suez-upstreaming-bq24190_charger-use-wake-irq-api-v1-1-c3f10ae2a34a@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 5769b36851c34..32e5c6dad7535 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -11,6 +11,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/power_supply.h>
 #include <linux/power/bq24190_charger.h>
 #include <linux/regulator/driver.h>
@@ -1821,7 +1822,13 @@ static int bq24190_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto out_charger;
 
-	enable_irq_wake(client->irq);
+	ret = devm_device_init_wakeup(dev);
+	if (ret < 0)
+		goto out_charger;
+
+	ret = devm_pm_set_wake_irq(dev, client->irq);
+	if (ret < 0)
+		goto out_charger;
 
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
-- 
2.53.0



