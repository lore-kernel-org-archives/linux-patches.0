Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029283;
	b=nSPu9qsSVrOrqjrsXavQp/9sz3nrwYPhNQlkRcdlb692OC2i0xaH/gqWWF0mZGoOtuRt
	 w9G/aBvWGx30foHu8pW/T7n/gtkN6ksq1QFAaJvh1+Y8nm9asRl9BlpSY2sjMvQLTvDhH
	 MeI5gnUs5XVJTnB/2vxCNoJDKy5ytymoLv5lVKXsasm48L28RJh/5jIePSSFHt7MUIOYy
	 zNjrCBJISYIKQZFVx2797iBnz01grLGTApZaHenlmKAmdVgx8IEPQW0kpVvabYcxT4vDW
	 lZ4ubYYQh6tF/tpxwrRp575NSHBMsGCuI35TYUBfphM3FjW2lP/QI+QsR4ZBHzRKWaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OxUx/+dnbitWEE2cFe7yohzOcQHW1dvsL7utf0eEjUI=;
	b=QDe621zcOPp/XxiWa9cOV+IG3GZrwa7GIAbh7qb1vtOFjocuDVqzDxpjd1WwkDE7WdzX
	 cIbkMHYnW+UuCfqQFPg8ymPpMXtjzPWkrnz48WdULBGXLaEeBvc0BuWYJPaFRi15UkuHE
	 BLqFiqWtN3UaIQcMtx3LA7qFLHN+hvXlmqbm83B0mr4o44QnGdE48eFxciWBV8i6sIRhw
	 r+MHHqJoJs5jme6ot5aWY8lT2IjXaJMJY9FZfRRw2EvAMIOAJxN6xh7h54Q4SmMIjDHnR
	 df9hF/ZYgjEH5e7c8h1+KqFm72tEm4mQslGoRAny/sxsnC21b6SnK2+B58eURbRBuMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qR3N411i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14F606A31C;
	Wed, 18 Nov 2026 19:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qR3N411i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4CD1F000C4;
	Wed, 18 Nov 2026 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029283;
	bh=OxUx/+dnbitWEE2cFe7yohzOcQHW1dvsL7utf0eEjUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qR3N411iFqAmNrlVup58m5FcBlopaq4EIUf3YpoRcfluDjIKzhwtfZuHaxkHSzNo7
	 U4pohsB6QhuhzzED2nklRktfUx5dEyfqc98vRq1fo3abEM62xt7Ba4QuyMdmTalAUD
	 HDjK5+KoOr3RfnqZE1B/Dnbfszzjg+T55BRdrd5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0295/1756] PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wake_irq()
Date: Wed, 18 Nov 2026 15:40:22 +0100
Message-ID: <20261118150020.111605753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit fd8318a32573d73eb20637a0c80689de0dc98169 ]

Add device-managed variant of dev_pm_set_wake_irq which automatically
clear the wake irq on device destruction to simplify error handling
and resource management in drivers.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20250103-wake_irq-v2-1-e3aeff5e9966@nxp.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: ece9baab2a6e ("power: supply: bq24190_charger: use the wake irq API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeirq.c | 26 ++++++++++++++++++++++++++
 include/linux/pm_wakeirq.h   |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/base/power/wakeirq.c b/drivers/base/power/wakeirq.c
index ddbe9cc91d23d..c0809d18fc540 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -106,6 +106,32 @@ void dev_pm_clear_wake_irq(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dev_pm_clear_wake_irq);
 
+static void devm_pm_clear_wake_irq(void *dev)
+{
+	dev_pm_clear_wake_irq(dev);
+}
+
+/**
+ * devm_pm_set_wake_irq - device-managed variant of dev_pm_set_wake_irq
+ * @dev: Device entry
+ * @irq: Device IO interrupt
+ *
+ *
+ * Attach a device IO interrupt as a wake IRQ, same with dev_pm_set_wake_irq,
+ * but the device will be auto clear wake capability on driver detach.
+ */
+int devm_pm_set_wake_irq(struct device *dev, int irq)
+{
+	int ret;
+
+	ret = dev_pm_set_wake_irq(dev, irq);
+	if (ret)
+		return ret;
+
+	return devm_add_action_or_reset(dev, devm_pm_clear_wake_irq, dev);
+}
+EXPORT_SYMBOL_GPL(devm_pm_set_wake_irq);
+
 /**
  * handle_threaded_wake_irq - Handler for dedicated wake-up interrupts
  * @irq: Device specific dedicated wake-up interrupt
diff --git a/include/linux/pm_wakeirq.h b/include/linux/pm_wakeirq.h
index d9642c6cf8521..25b63ed51b765 100644
--- a/include/linux/pm_wakeirq.h
+++ b/include/linux/pm_wakeirq.h
@@ -10,6 +10,7 @@ extern int dev_pm_set_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq_reverse(struct device *dev, int irq);
 extern void dev_pm_clear_wake_irq(struct device *dev);
+extern int devm_pm_set_wake_irq(struct device *dev, int irq);
 
 #else	/* !CONFIG_PM */
 
@@ -32,5 +33,10 @@ static inline void dev_pm_clear_wake_irq(struct device *dev)
 {
 }
 
+static inline int devm_pm_set_wake_irq(struct device *dev, int irq)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_PM */
 #endif	/* _LINUX_PM_WAKEIRQ_H */
-- 
2.53.0



