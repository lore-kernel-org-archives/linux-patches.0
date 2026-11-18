Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048006;
	b=eY49fsboUS5scgLk0yc9weZuMIZwWy22iPELrFg4qm/xbPQKAVrkospGz3wr/zyJyKEz
	 EyUV1n5ytdc7DYBqH584fadYv4QQ7EZbyEC4rjWpOaqm+yLqpGajoAL2J7JKOrJw/0WLq
	 o9w8QGWyjrypJAw5aW3bilnJ2b5GpU8uBVOV4mIHwgihro8VG7mKtYUy0rcxXaGNBaH8c
	 LQTa6qGqGuwvt2cTX1+RJ8BrVVWqLbFPIFLL1z9hXRHNf1piA1lGuEhHKKxmJLkNWi4O8
	 ExWzeDWldc3twPnnDrtTGm0g5aYo4TCZa7h0ZWXktiuF+aG4O1pvbRufzm19gtPEMLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czsgZQZJbxq2B8K8QAvaqk70W6/kZkeVfCi6KVc00uo=;
	b=DC8O6dzpaL55iPdesDM+J1F0oiGNoU+QePoDht5Ih6fYR4fmjD5y3/3v5wDyO4KilbSb
	 eO98TKnOj3AQeDIT0eOr7EI2ri2hpcDi+eHp8a52Yceu3Gcifwg1Isw31IarDsLeI4c6K
	 3HclutOqKFBuVHMx8kNS+EWu4os6w0ygb3y2LY74W3Fwoa0Ew28sOq6kBArVcx572d+Zg
	 mXcHG84DagpcuM/herp02lJnR3UILCIDIuRLAAYgeWDdS6EUFIg4P0o5h9WNoDeC5SZ7o
	 v6Z74brYaT+qfo03w+PGkWeR7L6/Rc0hhHcrJPvDyOayCQ9LMoglpnx5bxJ6Do69Hhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cm5FoJUR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AA2606A32A;
	Thu, 19 Nov 2026 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cm5FoJUR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330F21F000C4;
	Thu, 19 Nov 2026 00:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048006;
	bh=czsgZQZJbxq2B8K8QAvaqk70W6/kZkeVfCi6KVc00uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm5FoJURLlCOAaa4pCyB2y1ts8PdqlFUmyC34THjfj77cR2d6utMsEnLW+YJSZRZO
	 Y4xoaPz6M055W2LmzAdxYx4WuxGQLXtZ/s5gmYYNf7GdiO+rmBhAlJ2iSHjsXnifEe
	 21I07uLZYyixEshrXxNThP7Uq1qP+4eWAXmyZbMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1841/2857] PM: sleep: wakeirq: drop unused enable helpers
Date: Wed, 18 Nov 2026 15:47:55 +0100
Message-ID: <20261118150307.538322198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09a677c8007a7..ddbe9cc91d23d 100644
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
index dd42d16945d02..d9642c6cf8521 100644
--- a/include/linux/pm_wakeirq.h
+++ b/include/linux/pm_wakeirq.h
@@ -10,8 +10,6 @@ extern int dev_pm_set_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq_reverse(struct device *dev, int irq);
 extern void dev_pm_clear_wake_irq(struct device *dev);
-extern void dev_pm_enable_wake_irq(struct device *dev);
-extern void dev_pm_disable_wake_irq(struct device *dev);
 
 #else	/* !CONFIG_PM */
 
@@ -34,13 +32,5 @@ static inline void dev_pm_clear_wake_irq(struct device *dev)
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



