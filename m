Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021719;
	b=cYovwk3TOYkO1EXmut+/N5/oqGTv3r6E/XczXr+WAdt0yE6LGPU8WsdNwVXMq6cq0ewx
	 vUsBusHSm148lffEm6xU0miBZ0RZOkohZaMMUVjN3p1iyd/r0XJXcZR31hDSarOns4ZUt
	 aGt47Ir1AKXSu7JadrJvQ/NXZ0YKKoHT4opohA6QpmSHOQqzQNPSC2To+3ueHmm7Wvics
	 wZhQR/Wn5XXHP6fSUmuiDkyduBP70FAYSnBU97prTXWh1Q/q3KzMtTWzz31Xqq7h4hpeR
	 EMgp9X0s6FbMn0OnL2UsxV0Xnv8OVbvdsXPujaeTpT8BcXVcJUd3Zq9GjAy9xllNiRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fkxufHgZw3X9HJ+PsqYI33J0ILCf8ndsQKilGq5unOo=;
	b=KStJ8sq58gSYb/+O37tdcSqxec5+7s9yTz101KzPmJTNA4guzNnsahCpEjyyhMTyn2Nz
	 A+wHazv33/W740xIdkDLoCRgPtvwpvDY/5ODotmxyGYkVJwsFQ+8MIebMlwxBBwuPKDQv
	 cFyLbbvA/4HmgBl+C9GOwly715fde6X933uNTHatyb038wTpxwzglFsyKj52MNv7EtTWw
	 jrCs+2tb7c1WSifUWZRb2UOD9+tPFBwUQ5tVHgEWE8OQZeOn0Sd2r36m1YUaNw4ysOwdZ
	 qV2vXRk9phRTKqxbCn40mLN4Qn38fMEJ3eKTshDf3/JQXvCjTE0iVEYC4dntm8BerTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSNKfHjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D0C606A332;
	Wed, 18 Nov 2026 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSNKfHjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8211F000CD;
	Wed, 18 Nov 2026 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021719;
	bh=fkxufHgZw3X9HJ+PsqYI33J0ILCf8ndsQKilGq5unOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSNKfHjhSVLbgg3mOnIjHO1aWl5g4ZHdYdQUg7LCZ8Bz2iOPf+BpCMsiQMyU5Rt0G
	 BDLxyT3uSQTQJy/QqydCzCFItCUnrvKG2k066ejUuhZc+QNBI2PUQCeupFD0M70TnD
	 Nu8XLNmgXFmYWqcBvwr1ViSSkIhHOwvym4OgUpOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2366/2651] regulator: irq: freeze deferred hardware access during suspend
Date: Wed, 18 Nov 2026 16:00:06 +0100
Message-ID: <20261118150410.711203657@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 8a6d73e316f95e398a1de1d1f58314b6d3e7f641 ]

The regulator IRQ helper delays status checks and recovery callbacks on
non-freezable workqueues. Those callbacks may access regulator hardware
after the backing bus has been suspended.

Use system_freezable_wq for normal-priority callbacks. Allocate a
freezable high-priority workqueue when requested so the high_prio
contract is preserved while hardware access is frozen across suspend.

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Fixes: 7111c6d1b31b ("regulator: IRQ based event/error notification helpers")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20261016100522.2582557-3-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/irq_helpers.c | 38 +++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index 5b3cfac286676..cdbd170d2b150 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -15,6 +15,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/regulator/driver.h>
 
 #include "internal.h"
@@ -27,6 +28,7 @@ struct regulator_irq {
 	int irq;
 	int retry_cnt;
 	struct delayed_work isr_work;
+	struct workqueue_struct *wq;
 };
 
 /*
@@ -145,12 +147,7 @@ static void regulator_notifier_isr_work(struct work_struct *work)
 	return;
 
 reschedule:
-	if (!d->high_prio)
-		mod_delayed_work(system_dfl_wq, &h->isr_work,
-				 msecs_to_jiffies(tmo));
-	else
-		mod_delayed_work(system_highpri_wq, &h->isr_work,
-				 msecs_to_jiffies(tmo));
+	mod_delayed_work(h->wq, &h->isr_work, msecs_to_jiffies(tmo));
 }
 
 static irqreturn_t regulator_notifier_isr(int irq, void *data)
@@ -248,13 +245,8 @@ static irqreturn_t regulator_notifier_isr(int irq, void *data)
 	}
 
 	if (d->irq_off_ms) {
-		if (!d->high_prio)
-			schedule_delayed_work(&h->isr_work,
-					      msecs_to_jiffies(d->irq_off_ms));
-		else
-			mod_delayed_work(system_highpri_wq,
-					 &h->isr_work,
-					 msecs_to_jiffies(d->irq_off_ms));
+		mod_delayed_work(h->wq, &h->isr_work,
+				 msecs_to_jiffies(d->irq_off_ms));
 	}
 
 	return IRQ_HANDLED;
@@ -363,13 +355,25 @@ void *regulator_irq_helper(struct device *dev,
 
 	init_rdev_errors(h);
 
-	if (h->desc.irq_off_ms)
+	if (h->desc.irq_off_ms) {
+		if (h->desc.high_prio) {
+			h->wq = alloc_workqueue("regulator_irq_highpri",
+						WQ_FREEZABLE | WQ_HIGHPRI, 0);
+			if (!h->wq)
+				return ERR_PTR(-ENOMEM);
+		} else {
+			h->wq = system_freezable_wq;
+		}
+
 		INIT_DELAYED_WORK(&h->isr_work, regulator_notifier_isr_work);
+	}
 
 	ret = request_threaded_irq(h->irq, NULL, regulator_notifier_isr,
 				   IRQF_ONESHOT | irq_flags, h->desc.name, h);
 	if (ret) {
 		dev_err(dev, "Failed to request IRQ %d\n", irq);
+		if (h->desc.irq_off_ms && h->desc.high_prio)
+			destroy_workqueue(h->wq);
 
 		return ERR_PTR(ret);
 	}
@@ -393,8 +397,11 @@ void regulator_irq_helper_cancel(void **handle)
 		struct regulator_irq *h = *handle;
 
 		free_irq(h->irq, h);
-		if (h->desc.irq_off_ms)
+		if (h->desc.irq_off_ms) {
 			cancel_delayed_work_sync(&h->isr_work);
+			if (h->desc.high_prio)
+				destroy_workqueue(h->wq);
+		}
 
 		h = NULL;
 	}
@@ -441,4 +448,3 @@ int regulator_irq_map_event_simple(int irq, struct regulator_irq_data *rid,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(regulator_irq_map_event_simple);
-
-- 
2.53.0



