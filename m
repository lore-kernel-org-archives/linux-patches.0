Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213940;
	b=1a+A3G1ra0sjnZWQ0+w3pNfn+yeQcW4ppn8Vk5zaHB84PoL9YLeFMTUNZFFMn74aFYoy
	 3lYo5HZcEoN8IXPd6L4hDH2Z62OUiWtuCtD3j3y959JnG00I9FUoKmyS/yspjRXhbkiGX
	 omsxsw338g5cQo8yCpqaHO9qew/BjCWU6vit2u8YbeMndPNyzg5SYOWCwWvXh+KYE6TWc
	 USk4E0lrQxC2+pvmHWi95zAG5S8pDVGB4+jNZF7BUTCmo79WeIubrV2119PCU9ZcZyKZa
	 SNB0IUulm19L0N0JoGx9eKiFYj2apy2ncv/XiyeuXDzA0WXiWK9eHWgMWRqqeR8akLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEdlqpowuU6LAu7zcNG74udsGjBphI3LBNV4RB2vKJk=;
	b=0t/qhbKPnmUZBSdr77H5kCprYKc2QM+EuaFtM3L8Vl3BhsE7sQ1pQvxJJpKj4H8YoC3E
	 sOE+222RUmtsF5q/Ov0kY6UB3uu3+S69piUsVHbVHly7YHXOdxNUimDeIP1fmzLezstqm
	 3WTYlH1tRUD0KSK6v5uwJXJNBmTWwbde240WBD61LPNAj9ATbJRYQNj1XDrhQfUgexS+p
	 fbMiRgjb5B26qtdAa/TW3hPe7aKiQOy4C4WJTBGvTV4Xhmbo2+NkmhaiFa0q1INrr/dDU
	 MwpRf9qWfoU/7TB9UaRwxl58tgHuI+MNuAa9gXse3oVM9QtVPiwBr2W2qvjDcbFIBNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0XO94bO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E789E606A31C;
	Wed, 28 Oct 2026 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0XO94bO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467871F01828;
	Wed, 28 Oct 2026 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213939;
	bh=IEdlqpowuU6LAu7zcNG74udsGjBphI3LBNV4RB2vKJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0XO94bOsWbpR58jZT5qsfJLMZA3Wi6oeSbeiFsTWqEom2eKA7qAmoerig8dGpT0L
	 ukDdh8mmnoODwllpFjnfiV1aEJdpyidRBEn2FyUgCTemqD4as4y3HKPfGamSGOgqTu
	 YTDclyJnq9XlQifaAOTLkBYvElI7cZ0l9WqQB9cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0684/1887] firmware: arm_scmi: Move protocol registration helpers
Date: Wed, 28 Oct 2026 17:46:20 +0100
Message-ID: <20261028170514.978272683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 9115c20ac1ee9e92a3e751e352db818b7f95746a ]

Move protocol registration helpers and logic out of bus.c compilation
unit into driver.c.

No functional change.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-4-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 68 ------------------------------
 drivers/firmware/arm_scmi/common.h |  3 --
 drivers/firmware/arm_scmi/driver.c | 67 +++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 71 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 8c6f99d15f22f..83829c6303c22 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -16,8 +16,6 @@
 #include "common.h"
 
 static DEFINE_IDA(scmi_bus_id);
-static DEFINE_IDR(scmi_protocols);
-static DEFINE_SPINLOCK(protocol_lock);
 
 static const struct scmi_device_id *
 scmi_dev_match_id(struct scmi_device *scmi_dev, struct scmi_driver *scmi_drv)
@@ -79,30 +77,6 @@ struct scmi_device *scmi_child_dev_find(struct device *parent,
 	return to_scmi_dev(dev);
 }
 
-const struct scmi_protocol *scmi_protocol_get(int protocol_id)
-{
-	const struct scmi_protocol *proto;
-
-	proto = idr_find(&scmi_protocols, protocol_id);
-	if (!proto || !try_module_get(proto->owner)) {
-		pr_warn("SCMI Protocol 0x%x not found!\n", protocol_id);
-		return NULL;
-	}
-
-	pr_debug("Found SCMI Protocol 0x%x\n", protocol_id);
-
-	return proto;
-}
-
-void scmi_protocol_put(int protocol_id)
-{
-	const struct scmi_protocol *proto;
-
-	proto = idr_find(&scmi_protocols, protocol_id);
-	if (proto)
-		module_put(proto->owner);
-}
-
 static int scmi_dev_probe(struct device *dev)
 {
 	struct scmi_driver *scmi_drv = to_scmi_driver(dev->driver);
@@ -235,48 +209,6 @@ void scmi_set_handle(struct scmi_device *scmi_dev)
 		scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev);
 }
 
-int scmi_protocol_register(const struct scmi_protocol *proto)
-{
-	int ret;
-
-	if (!proto) {
-		pr_err("invalid protocol\n");
-		return -EINVAL;
-	}
-
-	if (!proto->instance_init) {
-		pr_err("missing init for protocol 0x%x\n", proto->id);
-		return -EINVAL;
-	}
-
-	spin_lock(&protocol_lock);
-	ret = idr_alloc(&scmi_protocols, (void *)proto,
-			proto->id, proto->id + 1, GFP_ATOMIC);
-	spin_unlock(&protocol_lock);
-	if (ret != proto->id) {
-		pr_err("unable to allocate SCMI idr slot for 0x%x - err %d\n",
-		       proto->id, ret);
-		return ret;
-	}
-
-	pr_debug("Registered SCMI Protocol 0x%x\n", proto->id);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(scmi_protocol_register);
-
-void scmi_protocol_unregister(const struct scmi_protocol *proto)
-{
-	spin_lock(&protocol_lock);
-	idr_remove(&scmi_protocols, proto->id);
-	spin_unlock(&protocol_lock);
-
-	pr_debug("Unregistered SCMI Protocol 0x%x\n", proto->id);
-
-	return;
-}
-EXPORT_SYMBOL_GPL(scmi_protocol_unregister);
-
 static int __scmi_devices_unregister(struct device *dev, void *data)
 {
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 3b601e4d99507..2a18578a4d578 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -106,9 +106,6 @@ void scmi_setup_protocol_implemented(const struct scmi_protocol_handle *ph,
 int __init scmi_bus_init(void);
 void __exit scmi_bus_exit(void);
 
-const struct scmi_protocol *scmi_protocol_get(int protocol_id);
-void scmi_protocol_put(int protocol_id);
-
 int scmi_protocol_acquire(const struct scmi_handle *handle, u8 protocol_id);
 void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 018713475d16d..dc55a492461a0 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -51,6 +51,9 @@ enum scmi_error_codes {
 	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
 };
 
+static DEFINE_IDR(scmi_protocols);
+static DEFINE_SPINLOCK(protocol_lock);
+
 /* List of all SCMI devices active in system */
 static LIST_HEAD(scmi_list);
 /* Protection for the entire list */
@@ -194,6 +197,70 @@ static inline int scmi_to_linux_errno(int errno)
 	return -EIO;
 }
 
+static const struct scmi_protocol *scmi_protocol_get(int protocol_id)
+{
+	const struct scmi_protocol *proto;
+
+	proto = idr_find(&scmi_protocols, protocol_id);
+	if (!proto || !try_module_get(proto->owner)) {
+		pr_warn("SCMI Protocol 0x%x not found!\n", protocol_id);
+		return NULL;
+	}
+
+	pr_debug("Found SCMI Protocol 0x%x\n", protocol_id);
+
+	return proto;
+}
+
+static void scmi_protocol_put(int protocol_id)
+{
+	const struct scmi_protocol *proto;
+
+	proto = idr_find(&scmi_protocols, protocol_id);
+	if (proto)
+		module_put(proto->owner);
+}
+
+int scmi_protocol_register(const struct scmi_protocol *proto)
+{
+	int ret;
+
+	if (!proto) {
+		pr_err("invalid protocol\n");
+		return -EINVAL;
+	}
+
+	if (!proto->instance_init) {
+		pr_err("missing init for protocol 0x%x\n", proto->id);
+		return -EINVAL;
+	}
+
+	spin_lock(&protocol_lock);
+	ret = idr_alloc(&scmi_protocols, (void *)proto,
+			proto->id, proto->id + 1, GFP_ATOMIC);
+	spin_unlock(&protocol_lock);
+	if (ret != proto->id) {
+		pr_err("unable to allocate SCMI idr slot for 0x%x - err %d\n",
+		       proto->id, ret);
+		return ret;
+	}
+
+	pr_debug("Registered SCMI Protocol 0x%x\n", proto->id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scmi_protocol_register);
+
+void scmi_protocol_unregister(const struct scmi_protocol *proto)
+{
+	spin_lock(&protocol_lock);
+	idr_remove(&scmi_protocols, proto->id);
+	spin_unlock(&protocol_lock);
+
+	pr_debug("Unregistered SCMI Protocol 0x%x\n", proto->id);
+}
+EXPORT_SYMBOL_GPL(scmi_protocol_unregister);
+
 void scmi_notification_instance_data_set(const struct scmi_handle *handle,
 					 void *priv)
 {
-- 
2.53.0



