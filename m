Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039479;
	b=Q4mhXIY47pgBiUeTmpPBOrP+49PdPZ9/FxPBy1Er8cEXQVRtI9PGKbdIGwzrdYmLsKID
	 Cke1J89nWJV4HvDdt9Usm8+SuulrsQocFJOU66Izql+a25SpmyXiay0rImluHgjn0ChDJ
	 VSJT+FHIt28hlYAv/zHrmC6bXTSA21v7z1zm6FQ9YvU5ZHV9EzSUu+TxaYSEghja65rO4
	 kpeBkki0Pq6p3zXzrF6rieTYuW+CllFXQxbA/7Ttns08JXxVpVmB9kyFPr4JWme6YUNb5
	 CYl82Vug+mg3aiYOeXdiePve2bjCsP5pwgmWBUcVusxdYax7rcBIAjyJoYFkLwaRn9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OQzrjhI+mIsGJw85sUexPHQvo5PrJ6rjW51sJm5xlkE=;
	b=t+6uIb0S2KEBWaRDsl9L3FLZX2wu3bjwXIVxkAgArT78cfGD/tJNRuZtJ0TvMImb9yHp
	 R1tuxUKEHRoCUlpRmVrZKHnOI724Hu910GGrTSSIWL9deog4x1STOY1Cfo4RIq1FaLAJN
	 12Pbk/QpPYWoICZ38x1j95eGevq/SA/9zxDUZ4oSKcdynKhP9eq4cld37Yo1SzZuOLA4C
	 Ez+qb7twFp8v1J18QLZUmyrQDsgEN3Gw+Mpkn+KoDshg3E+ahwq2IvCL4ZjrKkh4LFACb
	 vHHBTTChELP1ChVzTPVYsfSRArjl5qJZJS0L44Fgt5RUzPfINhM5MkwSrFuoHwwZuXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pe/KR8HC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C86606A31C;
	Wed, 18 Nov 2026 22:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pe/KR8HC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EEC1F000C4;
	Wed, 18 Nov 2026 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039479;
	bh=OQzrjhI+mIsGJw85sUexPHQvo5PrJ6rjW51sJm5xlkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pe/KR8HCcG5hc4NxhhvKfv8eY8vq3qrwtg8MoGjxY9XkZ57YeMrALKBe6o0Xffuwj
	 VDM2hLqQl5pfMkkepzOalfiQtgUImPQrbg5BBkC1Zoi/ZGKpwVr4sYPMC0fcPOUPc0
	 Yp5+oC9lOqZrrcOlEqw+4PXqlxibiYpIHbp0HobA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2115/3318] PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wake_irq()
Date: Wed, 18 Nov 2026 15:45:37 +0100
Message-ID: <20261118150425.515731592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



