Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048015;
	b=dP6ShjUSWPYQwWzWZeSIZF8HkxKRB0nAioTwZ78+3zpJLGGTvTjOs64QW93/ZPJ9BoLj
	 227SA4KeEoyzVhiG50A2nJuSshD3HEaEfDKtGFMkPmGKnrH/3mInzZF+zvrjU1jmGP1KG
	 yVhW85ImRbF/NG5fB0NimEkplhfRMvOWL8E2qfder2hI2qW2IBtY5syhnERV80utky/s5
	 tMSg+NexPPwJsVERaKJlMnGrGJ/0+8TwzO8DZQAQGYtesKvVrMu0qzfHa1Pd91j9sDZ0b
	 uDT/0FpbGIRisVg5+oiBoHRWjd3sjMHzY9anCZG8LGo0hrZtd+dqt/474fS4OXCnZNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rOaKKrkEwb7A/GATUcfKrpbbso7HXqZu6bnm+hSahG0=;
	b=SSzXIK8r9lEXfeo37uiknOZUWOBH1MP4Uhrgp6i2CIpFVaEi3pJUXnjgKSdFHgTHghTD
	 zdKMEbDarlye/1DadctZ7h98PqblYGsnh6MiQzxe/5cmddIcq0Q1rgF8dm/Xvjl+bLhVR
	 NLl+2OaW7xEOfTeUXHTrAR78BhR4270Q/RGDuS2jVRWHVI6ta0T+p/GeqW2GT+I+EOdD8
	 1ZzU55F1jDm+p8TuL2LnYOjYV/fT25GrtTgb3zcFShVa2/K0E9gJmnswEf5GyuIep6GgN
	 AafJzeHfHkGKYgbYYPfXsTQ6p2/khtd7i3U94IfjZyzPlEyrrj0SA+T0IEnzWPauXRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vZl7aJYm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEBC606A31C;
	Thu, 19 Nov 2026 00:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vZl7aJYm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB251F000C6;
	Thu, 19 Nov 2026 00:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048015;
	bh=rOaKKrkEwb7A/GATUcfKrpbbso7HXqZu6bnm+hSahG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZl7aJYmYFDQ2kum8vvdjmvlor+cOPX4xsjRoZ+xUtovVua+tO0xb9DbW7dpT6b6I
	 DzYWQ3YEKrf1h40badPdP+NAaYg8RJkRnFZNEsEzX6XHyNYwNaUKCu4d/dhUIggxgw
	 m7Fkx+yNsUHVO+9IwotN7VpWdyFdDhooOriImRzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1843/2857] PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wake_irq()
Date: Wed, 18 Nov 2026 15:47:57 +0100
Message-ID: <20261118150307.608466082@linuxfoundation.org>
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



