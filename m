Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060562;
	b=yifgn5WqXZlj9sjbyj2TbC11jkzgp4hF1mmEmTa745coIQEa8hueXoMVfbv3oDrH5Z9a
	 UaerGgWtP/RKSgYy1WBewBdjllFGkfcwfn72wa00wQe3ObGvTBmynV5ToAT9ZA3HxyUqO
	 ZU8QBS1XP92Kfyaouc4cK6c4xWT2yfvmR10QNKHSXAHxW39BRMHKz+LGWrP+hpGtycK6L
	 EGYah88GLdU6tB2BuPh5jDveLL5WckmTmtkjphLhBdfKWERqAWAVatrmlOJILauomSVRt
	 viSx4RRX0VLT6NK2U8Z/EnX/6somsIcX4kcTGiXN1Fy/ybvej7mwdarAr2kyg6tC6rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CVKrS6D5Hc2A/613zVUt/s0ZetndMPvBd03MeSQrA90=;
	b=kKBrL2rFUIS+gMLzUKyG4Pr1dXpPG9BouBaOnpbLVb0Q/2cg3q/BBtvWDtviWS02ifyb
	 ACznwwR6EYTkqz2atKYJlMRUTYMWaNSRilfelzeMv/16Ohjzk0ZDMq7fl2S8aIJIeDRju
	 9yEFB6CFZ64HoITdNknq0Q2pkDDJdKLcUakMh6TKALNPqKt9UfVCLNmKkYPFbFgeuOlQU
	 cKpe58aEiGK6VZOqxiAjnQYv5QSc2TS2P5i2g3mlVGMGTnhdbWnUlF2iysBn6fudx5wAG
	 zgJwV6mqSPDuyZXA1JVisoIYCA75McOnUYoWgm4QyOVi2vnhqrZGngSBQwEq6JELvEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b29I7eiu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DA1606A320;
	Thu, 19 Nov 2026 03:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b29I7eiu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C67B1F000C4;
	Thu, 19 Nov 2026 03:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060561;
	bh=CVKrS6D5Hc2A/613zVUt/s0ZetndMPvBd03MeSQrA90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b29I7eiuM4E0MTPYj4OWBAYueJC+d/NtRUqu/4/C8vM0SkktRGUDZnQpmx3o+Y5XA
	 47QKA+3W2VfllqlMZYmWc3F+THdF4QPvYM7FQh42LnSNCSuk443EPYym7IYPgTHt7d
	 2QX/+tovow+Al6HawiDPYRIVwjS3XguicxNpgy2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1201/1848] PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wake_irq()
Date: Wed, 18 Nov 2026 15:53:59 +0100
Message-ID: <20261118150010.147361435@linuxfoundation.org>
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
index 7886390eb3b4c..44da551c60abf 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -109,6 +109,32 @@ void dev_pm_clear_wake_irq(struct device *dev)
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



