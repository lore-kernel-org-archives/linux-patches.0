Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE121AF0BB;
	Tue, 21 Jul 2026 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662232; cv=none; b=Bd0TFuCx9k17ShuEtEVhIs1V/mnkY55mpfbg1pMA8w4eYbZCzjT8HEiZS5p3xD6BxjrigwuhMzFf+JE5vsebZ7v+M6tLCxwRFuwBaScN6gfmPS4Qg2i2wZqbnhuBk+bwYfCHyJeTt/8QOVA3DrbIdbQaZsg3EVuYgO+JOjBNl7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662232; c=relaxed/simple;
	bh=UX76qzcOj3La5CPFy2ypyUlAV01NIJt3hz4MttGKYM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM34DJyN7swneRUcUurdsv6gJmCsJrZeBAo7yymRbbqUY7FRFim7DBOUqyrIWe+LxMCvCJELGSDsfeN2arUHSApBOVpdAw48ymKOsiLLH7aFGSrYAgUpfFxZmtOs0EtUO1aDK+IoFoD3qF8Hkkk3c6YvnYZqJ+0nWeDzcWMqMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwpIgFeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwpIgFeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131D31F000E9;
	Tue, 21 Jul 2026 19:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662230;
	bh=1uml04gNOr9s3Y10SOLKxMNr+MiOmISqmKnJ4M0Fvt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwpIgFeJfY3hTLStxo5fuaoXDMgX8LPuuIdGXV0wDil/AsZjmqrjVxUEGdadP1Idw
	 +xhOTRp/VuYIn/Fo/0eYKkChuCTXX0xUWDsPUdAlgaYF7xGW4fVDTvJfKtQdDe9XpU
	 h/rcc5ZDPhCgsmAQ5Lz/PIAsxwON1bcQFWgQycms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0364/1276] dpll: Allow associating dpll pin with a firmware node
Date: Tue, 21 Jul 2026 17:13:27 +0200
Message-ID: <20260721152454.253558564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit d0f4771e2befbe8de3a16a564c6bbd1d5502cec3 ]

Extend the DPLL core to support associating a DPLL pin with a firmware
node. This association is required to allow other subsystems (such as
network drivers) to locate and request specific DPLL pins defined in
the Device Tree or ACPI.

* Add a .fwnode field to the struct dpll_pin
* Introduce dpll_pin_fwnode_set() helper to allow the provider driver
  to associate a pin with a fwnode after the pin has been allocated
* Introduce fwnode_dpll_pin_find() helper to allow consumers to search
  for a registered DPLL pin using its associated fwnode handle
* Ensure the fwnode reference is properly released in dpll_pin_put()

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260203174002.705176-2-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 32239d600236 ("dpll: fix stale iteration in dpll_pin_on_pin_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 49 ++++++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_core.h |  2 ++
 include/linux/dpll.h     | 11 +++++++++
 3 files changed, 62 insertions(+)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 8879a72351561b..f04ed7195cadd6 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -10,6 +10,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -595,12 +596,60 @@ void dpll_pin_put(struct dpll_pin *pin)
 		xa_destroy(&pin->parent_refs);
 		xa_destroy(&pin->ref_sync_pins);
 		dpll_pin_prop_free(&pin->prop);
+		fwnode_handle_put(pin->fwnode);
 		kfree_rcu(pin, rcu);
 	}
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_pin_put);
 
+/**
+ * dpll_pin_fwnode_set - set dpll pin firmware node reference
+ * @pin: pointer to a dpll pin
+ * @fwnode: firmware node handle
+ *
+ * Set firmware node handle for the given dpll pin.
+ */
+void dpll_pin_fwnode_set(struct dpll_pin *pin, struct fwnode_handle *fwnode)
+{
+	mutex_lock(&dpll_lock);
+	fwnode_handle_put(pin->fwnode); /* Drop fwnode previously set */
+	pin->fwnode = fwnode_handle_get(fwnode);
+	mutex_unlock(&dpll_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_fwnode_set);
+
+/**
+ * fwnode_dpll_pin_find - find dpll pin by firmware node reference
+ * @fwnode: reference to firmware node
+ *
+ * Get existing object of a pin that is associated with given firmware node
+ * reference.
+ *
+ * Context: Acquires a lock (dpll_lock)
+ * Return:
+ * * valid dpll_pin pointer on success
+ * * NULL when no such pin exists
+ */
+struct dpll_pin *fwnode_dpll_pin_find(struct fwnode_handle *fwnode)
+{
+	struct dpll_pin *pin, *ret = NULL;
+	unsigned long index;
+
+	mutex_lock(&dpll_lock);
+	xa_for_each(&dpll_pin_xa, index, pin) {
+		if (pin->fwnode == fwnode) {
+			ret = pin;
+			refcount_inc(&ret->refcount);
+			break;
+		}
+	}
+	mutex_unlock(&dpll_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fwnode_dpll_pin_find);
+
 static int
 __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 		    const struct dpll_pin_ops *ops, void *priv, void *cookie)
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
index 93c68e78b3515c..2b71824f10adbc 100644
--- a/drivers/dpll/dpll_core.h
+++ b/drivers/dpll/dpll_core.h
@@ -42,6 +42,7 @@ struct dpll_device {
  * @pin_idx:		index of a pin given by dev driver
  * @clock_id:		clock_id of creator
  * @module:		module of creator
+ * @fwnode:		optional reference to firmware node
  * @dpll_refs:		hold referencees to dplls pin was registered with
  * @parent_refs:	hold references to parent pins pin was registered with
  * @ref_sync_pins:	hold references to pins for Reference SYNC feature
@@ -55,6 +56,7 @@ struct dpll_pin {
 	u32 pin_idx;
 	u64 clock_id;
 	struct module *module;
+	struct fwnode_handle *fwnode;
 	struct xarray dpll_refs;
 	struct xarray parent_refs;
 	struct xarray ref_sync_pins;
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 673bae6cdd5817..003c003a1b4c5c 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -16,6 +16,7 @@
 struct dpll_device;
 struct dpll_pin;
 struct dpll_pin_esync;
+struct fwnode_handle;
 
 struct dpll_device_ops {
 	int (*mode_get)(const struct dpll_device *dpll, void *dpll_priv,
@@ -154,6 +155,8 @@ void dpll_netdev_pin_clear(struct net_device *dev);
 size_t dpll_netdev_pin_handle_size(const struct net_device *dev);
 int dpll_netdev_add_pin_handle(struct sk_buff *msg,
 			       const struct net_device *dev);
+
+struct dpll_pin *fwnode_dpll_pin_find(struct fwnode_handle *fwnode);
 #else
 static inline void
 dpll_netdev_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin) { }
@@ -169,6 +172,12 @@ dpll_netdev_add_pin_handle(struct sk_buff *msg, const struct net_device *dev)
 {
 	return 0;
 }
+
+static inline struct dpll_pin *
+fwnode_dpll_pin_find(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
 #endif
 
 struct dpll_device *
@@ -194,6 +203,8 @@ void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 
 void dpll_pin_put(struct dpll_pin *pin);
 
+void dpll_pin_fwnode_set(struct dpll_pin *pin, struct fwnode_handle *fwnode);
+
 int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 			     const struct dpll_pin_ops *ops, void *priv);
 
-- 
2.53.0



