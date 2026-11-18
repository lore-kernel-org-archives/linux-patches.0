Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054976;
	b=RSpVg+X75qltw741IR61I2yyTaAhEakANTfxZNpq4cCaagYbJUUPAAYWRTlQ+ydNX0Bu
	 uc+t3e9BrMW1ckvo21WfItYIKbQWJZremzYIOrPTQWjfosDZtm56B+9mRIu4jdMfjKYuI
	 V+7ikZB1STENUDNIcOHYYzhp5pyu4G34GLuRjtO708YiLb3nW/7UnfNj2eGKgtsR/U11z
	 oX3zDdB7WEHMFW1bZ0FV3kP/cvT8dkwD4Rjl/fPYW5vX3+4WdGO1j0eklstY7gRQg92Bl
	 cX5g/qTL1uOo5Eu7aAIvBtqVEWwNMt54SICBn5tvviFXKqNqheRMIDuZ/x+8ZPajlog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w0Zmm0bcOUzAvyvMLqj1v7RfZIzWEOe+ynkchKnmcLs=;
	b=WriwhKX6w2g3pHoqDlYrA3px0Djl8mUcmOrMy8P6dt0tNgkBra+713ROQPVKS7XCB6jE
	 Prnfka7k4Bd6Wp8hV+GOdJX+/MoMSss4lp8ikMzVYdVg+DfCuR4qBt/s0VsLuDuB4Qgi0
	 PsaHrjykimw/Eq7TfKV0+dBuKv8zrtaqf2BVFpLI5Eekg98SSw8e6qMWnp7zIkCmWCJyK
	 ZYINWGfJF8kKKhuHzA+1uQrppVgrWx6Wfjy+dsGy0JldaGvv++/d8C1NrNDtJyICEXEWT
	 mc+jTNaujXvPntVLiLvLHEE+X7sB2d/qgFarZxyDMJZANRERd8YoGmQ8bVDIYq4yaaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddlm8fd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F931606A320;
	Thu, 19 Nov 2026 02:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddlm8fd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2053C1F000C4;
	Thu, 19 Nov 2026 02:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054975;
	bh=w0Zmm0bcOUzAvyvMLqj1v7RfZIzWEOe+ynkchKnmcLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddlm8fd9LjEOiMwIvOspH7BwnFSUDoouP3Ta4ffmB2PW5H0yqa+HVfsqa56C70w4q
	 L9LEAY1bmNg7ZhoWuj0wtN2pGEjkmItGvFehSsYNqHSu2Uu/hmDM1PzAPo3z/MrBPD
	 pqzvSLvSZCTFTxJVCClECMiMF3Vu3cepKo2cs9U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1426/2214] PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wake_irq()
Date: Wed, 18 Nov 2026 15:51:42 +0100
Message-ID: <20261118150108.240520489@linuxfoundation.org>
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
index 08368afe52038..14dc5c9b6d846 100644
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
index ec8e84bf323ae..3472265e34ae5 100644
--- a/include/linux/pm_wakeirq.h
+++ b/include/linux/pm_wakeirq.h
@@ -20,6 +20,7 @@ extern int dev_pm_set_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq(struct device *dev, int irq);
 extern int dev_pm_set_dedicated_wake_irq_reverse(struct device *dev, int irq);
 extern void dev_pm_clear_wake_irq(struct device *dev);
+extern int devm_pm_set_wake_irq(struct device *dev, int irq);
 
 #else	/* !CONFIG_PM */
 
@@ -42,5 +43,10 @@ static inline void dev_pm_clear_wake_irq(struct device *dev)
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



