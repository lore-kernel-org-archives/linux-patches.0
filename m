Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059777;
	b=I8X96RprnmxionLPR0S8PXAEEqYqCLnCYMgh5FE2PW+2XNM66FVwZdQmjYjxu7FAIgUv
	 WIVVLyFn8meaQUTac6qfsehsjBoL9mlycJLX0P+fZRZkNyFyEiGJlcgk3cwsrXd3+hd4c
	 AStxJC7Vnt7397DVSFVumXjTYYunZKipWRLGOHY4ytGg81zdU3BEEaHn0a2ijxfD4C5aC
	 E3Db2kjK647M2jXH7TzS3xg53sGIfxEWFekLGweWsUju4tPHbz8wvzQJ3uhnCW7sqYlYB
	 Zx95AqTxv47yDT4bKbY3LA8XbvDY7rFKb2i0KgRT9UG9qKqKIHL0mvyMAmTM1itfMFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QkethY9kMxHhc1j9O1do7h53jtTOKylTicom0Xgbr44=;
	b=JYPO4NeW0m5Ep1fVMet1SqESGz5UZwYX6zH/Ez+t/g5J9EokZmNbaSq+2PUntyNzf5Sa
	 1pc9S9oUlwaqCi1VdBAUVQ7jfjeIERdcIfvSKQeb70BnLcc4jYkkidbXyQ4675kjMeG6h
	 QuUMLEqrtH31uHYCWV/ukDz2BUPbjUG9ZXIMw3jZY0MyBMWpNaulqtpJPj7I+WEJTtO7g
	 jYvbKQRhuFjJpA6YiMolIEAJxjEVip8Rzr1kv1ygzu/9jP5/ls3FUvphNO5Ott69bU+ry
	 8E3dK/cV6S4OM3+ewhHc8joM5mt7rne2HKlNzrBOWBz5uX8wbnLbZX7tlnfWVq8Detw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBm2DnbT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA7606A325;
	Thu, 19 Nov 2026 03:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PBm2DnbT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B4E1F000C4;
	Thu, 19 Nov 2026 03:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059777;
	bh=QkethY9kMxHhc1j9O1do7h53jtTOKylTicom0Xgbr44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBm2DnbTVB5q6TrRs3iJoncRV/L6x+l41ZLKM4hdFmgReeb4HKkwr7gOB5m4uoyCx
	 Aod/seW+a8AxehtWwKh2WrGXtvqCJ29qrhIMqdR0COSJGQvMB1QpcorNOAwpIRmiHx
	 OzEYX2c8UTZX18LrxSqMlZyaDS1Djpi8y7mF4aHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0962/1848] mfd: tps65217: Use devres for IRQ domain and wake teardown
Date: Wed, 18 Nov 2026 15:50:00 +0100
Message-ID: <20261118145957.251537474@linuxfoundation.org>
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

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit cffd44d2d89524e2dda6adc7b0dd59363be1c8e6 ]

Removing the parent device used to tear the IRQ domain down in
tps65217_remove() before the MFD children are unbound: the i2c core
only releases the parent's devres after the remove callback returns,
whereas devm_mfd_add_devices() registered its own devres action which
unbinds the children. Children that requested interrupts from the
domain (e.g. tps65217-charger) therefore call free_irq() on virtual
IRQs whose descriptors have already been disposed. With
CONFIG_SPARSE_IRQ free_irq() then returns early without stopping the
threaded handler, leaking the irqaction, the IRQ kthread and a module
reference.

Register the domain teardown as a devres action right after the domain
is created instead. Devres actions are released in reverse order of
registration, so the MFD children release their IRQs first, then the
parent interrupt is freed and its thread stopped, and only then is the
domain torn down. The same ordering covers probe failure, which no
longer needs manual cleanup, and the remove callback can be dropped
entirely.

Balance the enable_irq_wake() in tps65217_irq_init() by registering
disable_irq_wake() as a devres action as well. Only do so when
enabling actually succeeded, since the parent chip may not support
setting wake-up.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Link: https://patch.msgid.link/20261002113624.178588-4-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
[ sashal: moved the loop variable declaration outside the for statement for compatibility with older C syntax ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 60 ++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index ca81623a74389..43dbcdb7f35cc 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -155,6 +155,32 @@ static const struct irq_domain_ops tps65217_irq_domain_ops = {
 	.map = tps65217_irq_map,
 };
 
+static void tps65217_irq_cleanup(void *data)
+{
+	struct tps65217 *tps = data;
+	unsigned int virq;
+	int i;
+
+	if (!tps->irq_domain)
+		return;
+
+	for (i = 0; i < TPS65217_NUM_IRQ; i++) {
+		virq = irq_find_mapping(tps->irq_domain, i);
+		if (virq)
+			irq_dispose_mapping(virq);
+	}
+
+	irq_domain_remove(tps->irq_domain);
+	tps->irq_domain = NULL;
+}
+
+static void tps65217_irq_wake_disable(void *data)
+{
+	unsigned long irq = (unsigned long)data;
+
+	disable_irq_wake(irq);
+}
+
 static int tps65217_irq_init(struct tps65217 *tps, int irq)
 {
 	int ret;
@@ -178,6 +204,10 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 		return -ENOMEM;
 	}
 
+	ret = devm_add_action_or_reset(tps->dev, tps65217_irq_cleanup, tps);
+	if (ret)
+		return ret;
+
 	ret = devm_request_threaded_irq(tps->dev, irq, NULL,
 					tps65217_irq_thread, IRQF_ONESHOT,
 					"tps65217-irq", tps);
@@ -187,7 +217,16 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 		return ret;
 	}
 
-	enable_irq_wake(irq);
+	ret = enable_irq_wake(irq);
+	if (ret) {
+		dev_warn(tps->dev, "failed to enable IRQ wake: %d\n", ret);
+		return 0;
+	}
+
+	ret = devm_add_action_or_reset(tps->dev, tps65217_irq_wake_disable,
+				       (void *)(unsigned long)irq);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -388,24 +427,6 @@ static int tps65217_probe(struct i2c_client *client)
 	return 0;
 }
 
-static int tps65217_remove(struct i2c_client *client)
-{
-	struct tps65217 *tps = i2c_get_clientdata(client);
-	unsigned int virq;
-	int i;
-
-	for (i = 0; i < TPS65217_NUM_IRQ; i++) {
-		virq = irq_find_mapping(tps->irq_domain, i);
-		if (virq)
-			irq_dispose_mapping(virq);
-	}
-
-	irq_domain_remove(tps->irq_domain);
-	tps->irq_domain = NULL;
-
-	return 0;
-}
-
 static const struct i2c_device_id tps65217_id_table[] = {
 	{"tps65217", TPS65217},
 	{ /* sentinel */ }
@@ -419,7 +440,6 @@ static struct i2c_driver tps65217_driver = {
 	},
 	.id_table	= tps65217_id_table,
 	.probe_new	= tps65217_probe,
-	.remove		= tps65217_remove,
 };
 
 static int __init tps65217_init(void)
-- 
2.53.0



