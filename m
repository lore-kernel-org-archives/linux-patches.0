Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054968;
	b=ydSc1XU276547KlMlcrprJ6RqcLIy2nYJ/8yhLW1nzHRozQuybIv8fz3914U7N9y5R23
	 JBSLCLDcJ5P78X4STFiA87mD76wrf0XGYxmLaBIYHwFeSZKj+tUTGiFsmNR0H5LYvtbyo
	 eQxIz3BxJ4hBqmX+J1MPJNW5ITQaAB4O7etVhKNtStlZiuWYk06cig4VcJ6yrhQFF6vD2
	 IVQKMxdDBNv8X5Ww1CLKKFuJRBL8Z3cDl1t7Z+d6XBKB+VoQnSjV/vMGEhaDkyLpUpC11
	 KJKyOAjZcjjZey+hyGUFnDbNf7jyZ2tvtZK/oJ9Brm+2vmM1bcYOrS9YjZtOX3PkVGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TkwQxaNDtLIwuzYYG5WtJgrwkDy+znGE4I2cx8t50zg=;
	b=XDNRXMmxSSqy3Sejlpa5yED4wijzUkTaI529kFzd7pL73dZ/7FWmjHrBtP289VQsydax
	 hzIib4qgfsKWywwE3Cj0WdG6C6NuOjkOjykEfutZNTFwaKoeZdCenWh5vKy0Bd0PFmCSM
	 N8ofwTw4BkEefY4Yr3FBxTqq1Cy64HaAXzrQNK/t3F6G5yUwiPpNCeQ/PWzLRn/WZiPiK
	 q25JN2/YY5N9mP7CnzGOkep7Y76l+NFdqeIZjD++Bck6zvHqHcr22EIJxTeAFM5u8IfdL
	 gytpN9j8igTSdiXoDrhIklDrH4/7dN9VJiLYvWvDsfB9Five7idIFQhgal76UXk9gGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8+Qqa6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1D9606A31C;
	Thu, 19 Nov 2026 02:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8+Qqa6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE211F000C4;
	Thu, 19 Nov 2026 02:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054968;
	bh=TkwQxaNDtLIwuzYYG5WtJgrwkDy+znGE4I2cx8t50zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8+Qqa6ueGW/DnzycKIaahkA7iqpcnXHUJ8mw1hG1A2AKgxTfK3yb0qRnbW10uI4t
	 OF84Un9DBgOAiCxj1mCyDvJ0ic3XYEzIw9PIQyc1YpMZQgGJKXkL/UkBlbmi8Fzr2l
	 BSSWazlo5htsuQ8DdJgfhuzeTqKgj7INiaFHt3Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1424/2214] PM: sleep: wakeirq: drop unused enable helpers
Date: Wed, 18 Nov 2026 15:51:40 +0100
Message-ID: <20261118150108.166302631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit e7b915219baa4b2bf30afe1dbaca7a24ff627ad2 ]

Drop the wake-irq enable and disable helpers which have not been used
since commit bed570307ed7 ("PM / wakeirq: Fix dedicated wakeirq for
drivers not using autosuspend").

Note that these functions are essentially just leftovers from the first
iteration of the wake-irq implementation where device drivers were
supposed to call these functions themselves instead of PM core (as
is also indicated by the bogus kernel doc comments).

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: ece9baab2a6e ("power: supply: bq24190_charger: use the wake irq API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeirq.c | 49 ------------------------------------
 include/linux/pm_wakeirq.h   | 10 --------
 2 files changed, 59 deletions(-)

diff --git a/drivers/base/power/wakeirq.c b/drivers/base/power/wakeirq.c
index 0328ee03c1bfc..08368afe52038 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -197,7 +197,6 @@ static int __dev_pm_set_dedicated_wake_irq(struct device *dev, int irq, unsigned
 	return err;
 }
 
-
 /**
  * dev_pm_set_dedicated_wake_irq - Request a dedicated wake-up interrupt
  * @dev: Device entry
@@ -209,11 +208,6 @@ static int __dev_pm_set_dedicated_wake_irq(struct device *dev, int irq, unsigned
  * Sets up a threaded interrupt handler for a device that has
  * a dedicated wake-up interrupt in addition to the device IO
  * interrupt.
- *
- * The interrupt starts disabled, and needs to be managed for
- * the device by the bus code or the device driver using
- * dev_pm_enable_wake_irq*() and dev_pm_disable_wake_irq*()
- * functions.
  */
 int dev_pm_set_dedicated_wake_irq(struct device *dev, int irq)
 {
@@ -235,11 +229,6 @@ EXPORT_SYMBOL_GPL(dev_pm_set_dedicated_wake_irq);
  * the status of WAKE_IRQ_DEDICATED_REVERSE to tell rpm_suspend()
  * to enable dedicated wake-up interrupt after running the runtime suspend
  * callback for @dev.
- *
- * The interrupt starts disabled, and needs to be managed for
- * the device by the bus code or the device driver using
- * dev_pm_enable_wake_irq*() and dev_pm_disable_wake_irq*()
- * functions.
  */
 int dev_pm_set_dedicated_wake_irq_reverse(struct device *dev, int irq)
 {
@@ -247,44 +236,6 @@ int dev_pm_set_dedicated_wake_irq_reverse(struct device *dev, int irq)
 }
 EXPORT_SYMBOL_GPL(dev_pm_set_dedicated_wake_irq_reverse);
 
-/**
- * dev_pm_enable_wake_irq - Enable device wake-up interrupt
- * @dev: Device
- *
- * Optionally called from the bus code or the device driver for
- * runtime_resume() to override the PM runtime core managed wake-up
- * interrupt handling to enable the wake-up interrupt.
- *
- * Note that for runtime_suspend()) the wake-up interrupts
- * should be unconditionally enabled unlike for suspend()
- * that is conditional.
- */
-void dev_pm_enable_wake_irq(struct device *dev)
-{
-	struct wake_irq *wirq = dev->power.wakeirq;
-
-	if (wirq && (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED))
-		enable_irq(wirq->irq);
-}
-EXPORT_SYMBOL_GPL(dev_pm_enable_wake_irq);
-
-/**
- * dev_pm_disable_wake_irq - Disable device wake-up interrupt
- * @dev: Device
- *
- * Optionally called from the bus code or the device driver for
- * runtime_suspend() to override the PM runtime core managed wake-up
- * interrupt handling to disable the wake-up interrupt.
- */
-void dev_pm_disable_wake_irq(struct device *dev)
-{
-	struct wake_irq *wirq = dev->power.wakeirq;
-
-	if (wirq && (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED))
-		disable_irq_nosync(wirq->irq);
-}
-EXPORT_SYMBOL_GPL(dev_pm_disable_wake_irq);
-
 /**
  * dev_pm_enable_wake_irq_check - Checks and enables wake-up interrupt
  * @dev: Device
diff --git a/include/linux/pm_wakeirq.h b/include/linux/pm_wakeirq.h
index e63a63aa47a37..ec8e84bf323ae 100644
--- a/include/linux/pm_wakeirq.h
+++ b/include/linux/pm_wakeirq.h
@@ -20,8 +20,6 @@ extern int dev_pm_set_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq_reverse(struct device *dev, int irq);
 extern void dev_pm_clear_wake_irq(struct device *dev);
-extern void dev_pm_enable_wake_irq(struct device *dev);
-extern void dev_pm_disable_wake_irq(struct device *dev);
 
 #else	/* !CONFIG_PM */
 
@@ -44,13 +42,5 @@ static inline void dev_pm_clear_wake_irq(struct device *dev)
 {
 }
 
-static inline void dev_pm_enable_wake_irq(struct device *dev)
-{
-}
-
-static inline void dev_pm_disable_wake_irq(struct device *dev)
-{
-}
-
 #endif	/* CONFIG_PM */
 #endif	/* _LINUX_PM_WAKEIRQ_H */
-- 
2.53.0



