Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023311;
	b=ewMi54rBTvLMyohnOGyfD/Bf38Egs5rX3K7KldBmxvk7ZsOWhWHnYgWssjAPHeAJwQ9a
	 xP3eeEj1YGnP0Bo+Z0jPH36lowllxdSHkSTNhti8xEIzlOVprKtZbRqau6MgbUNbuuCvS
	 cUWGp1LbcSATLlS9Pv5c0YoZ5w/LcA7dD/gLUHHWQIq7xk7GsUfTsuXF8tdB2Am28tmpR
	 hJ6l0f1ggA9yasfMby/5G2PClwIiU7bZbA70W0De4xCXUhVIMSgdCS2mWXyKrr9W/T7x/
	 eWqerI2LPdnqWzLLrfeL/Ksz2161/TxmcuN29HBWFs2eYlfb92tDZqWBp7pzm0x+YTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0uN1BwOPtVOV/Aeu2UQ5uatRcbrfPjfWIAmBh3aQBWM=;
	b=jz5wDZZa8jpk4HFKozxdodr6gKGrNWN6EGs4+Kd1CIq7vrpPNs/FDJeP6BeXtnCunZQ1
	 n3wDmV4bpN2X4C/HTYevTqtEtU2P+LTu+tr6JM+63iiBCXwMxx7tKrtwoF4QQvlV1/bwq
	 9i8LXCvnfcOiQ5JA8gA7Jepacn5e+0A9jCjP5hy1jm4Qi2OPWEGx/Za818B3wAjXtfMDd
	 wfnnNqZ0Qw2J7aLren2uAvEF6Ssfg/5Lfu0mu4JHv2Dle5/wdyS7yqHH2R0vbhVFC10BG
	 tR2IA8gMkIPWUdgncl/xBQg367lWzyTsw+V7HISM5sEtHPJqA/QhIyMt6PRrhw3/tHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FhS633nz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89354606A330;
	Wed, 18 Nov 2026 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FhS633nz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4921F000C4;
	Wed, 18 Nov 2026 17:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023311;
	bh=0uN1BwOPtVOV/Aeu2UQ5uatRcbrfPjfWIAmBh3aQBWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhS633nz99EP5flr7SO6fSiRCEycXAmqSo0NA3s8ILkzSs9ItN8MKCkD+m8f8F42H
	 TsGEN1czUdzIUdHnJjUK+p9iD7rjyNl7sjXeu/gDUM/egaDuOp0RyqnHSnPsJu9Uok
	 B6cKVlYvJyKFyrTjNE4jr9n7JfJCaFEZsQfy1Wu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Brue <ryanbrue.dev@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0323/2151] power: supply: bq24190_charger: use the wake irq API
Date: Wed, 18 Nov 2026 15:34:18 +0100
Message-ID: <20261118150133.722239721@linuxfoundation.org>
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
index ed0ceae8d90b1..459367a342ed9 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -10,6 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/power_supply.h>
 #include <linux/power/bq24190_charger.h>
 #include <linux/regulator/driver.h>
@@ -2175,7 +2176,13 @@ static int bq24190_probe(struct i2c_client *client)
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
 
 	pm_runtime_put_autosuspend(dev);
 
-- 
2.53.0



