Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060794;
	b=XGRxrGg4VOaEGwnZsKQ4SgeWhfGU5PnJqaffoLDaIzrtKnCwkfLwE1dOx/3xdHmgh9jo
	 GjCUWgqC6r1Zv8LbOLgOhH6uM+SlapAhDr2fHK29QRB9oJqgyJaiXLRce4LVWE0WO/iJp
	 tA7yXGin0tb0NBGXZHapQhXuS3n27uJ53jHT/lZtb9BOD2cqgzQoAEE1PABOAWj+AvLC+
	 AdY6dqCNeOZ6+pTQhyLuCh/6/W3uxEK/OdFKyVegEipHz5auaXevgr7Nz8g7AnlpZO2qT
	 ETfqcXLxrnjfJbYdmPnMalq10Xjbur7M8xV010VN7TzTg2iqUPu1PjUwV3Q/tPfS0qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukeqwe0usV36hle2i94lWWapwWyaaOtesO/p5+nd5GM=;
	b=vho8foekxdSUcnYZSHdq+P9ZBAtuL+4L21Hx4jaX6IU8ysegFWR4HhNC4KbMj7Nyylvy
	 FLQV6eBuXK9uAagIQjXJClb9+Tizuc0DeSeXnzS1XSv7as6+T2tL30yNfi8KPsxm8dHUj
	 LdIfIQRCCAkVKb+s/+3vDmTj08QDmIexhMDpy34JuGXqZPk2N5k7babZS0nt+X6lk0Boc
	 T7jTWfgk055mWWPj7IdYd8lgxj92gjew6uprSf0JzaoBNbUgiGVmEV27F9YZK3mMx0Saj
	 D3XZjHjv79YwZlCMPwZPlt7AxSRvLKCldLdXHUF6htpZQZeNx7PNSmE7U5fS23t2ESg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kqn5eUlt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5059606A326;
	Thu, 19 Nov 2026 03:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kqn5eUlt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1669B1F000C4;
	Thu, 19 Nov 2026 03:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060794;
	bh=ukeqwe0usV36hle2i94lWWapwWyaaOtesO/p5+nd5GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kqn5eUlt3qLAooVxpB2k/6CqRvyayFiwF9PVD0VgY+lR3KBrAk0u4++nbXNDYd2xl
	 W0k7zMSy8UMRAorL0guAM9ywjpeD7+CAfTxvxCNHq/7lJ2z2/lY/UxSOUWCG2t67Qp
	 Vr7M/75v3G8FxhOPMxUj0lqUpmLOqRV6u1/rQ1ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felipe Balbi <balbi@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1325/1848] software node: Introduce device_add_software_node()
Date: Wed, 18 Nov 2026 15:56:03 +0100
Message-ID: <20261118150015.214544640@linuxfoundation.org>
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

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit e68d0119e3284334de5650a1ac42ef4e179f895e ]

This helper will register a software node and then assign
it to device at the same time. The function will also make
sure that the device can't have more than one software node.

Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210115094914.88401-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c    | 71 +++++++++++++++++++++++++++++++++++-----
 include/linux/property.h |  3 ++
 2 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index e11e715320199..dc59a25e207c1 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -48,6 +48,19 @@ EXPORT_SYMBOL_GPL(is_software_node);
 				     struct swnode, fwnode) : NULL;	\
 	})
 
+static inline struct swnode *dev_to_swnode(struct device *dev)
+{
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+
+	if (!fwnode)
+		return NULL;
+
+	if (!is_software_node(fwnode))
+		fwnode = fwnode->secondary;
+
+	return to_swnode(fwnode);
+}
+
 static struct swnode *
 software_node_to_swnode(const struct software_node *node)
 {
@@ -853,22 +866,62 @@ void fwnode_remove_software_node(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(fwnode_remove_software_node);
 
+/**
+ * device_add_software_node - Assign software node to a device
+ * @dev: The device the software node is meant for.
+ * @swnode: The software node.
+ *
+ * This function will register @swnode and make it the secondary firmware node
+ * pointer of @dev. If @dev has no primary node, then @swnode will become the primary
+ * node.
+ */
+int device_add_software_node(struct device *dev, const struct software_node *swnode)
+{
+	int ret;
+
+	/* Only one software node per device. */
+	if (dev_to_swnode(dev))
+		return -EBUSY;
+
+	ret = software_node_register(swnode);
+	if (ret)
+		return ret;
+
+	set_secondary_fwnode(dev, software_node_fwnode(swnode));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(device_add_software_node);
+
+/**
+ * device_remove_software_node - Remove device's software node
+ * @dev: The device with the software node.
+ *
+ * This function will unregister the software node of @dev.
+ */
+void device_remove_software_node(struct device *dev)
+{
+	struct swnode *swnode;
+
+	swnode = dev_to_swnode(dev);
+	if (!swnode)
+		return;
+
+	software_node_notify(dev, KOBJ_REMOVE);
+	set_secondary_fwnode(dev, NULL);
+	kobject_put(&swnode->kobj);
+}
+EXPORT_SYMBOL_GPL(device_remove_software_node);
+
 int software_node_notify(struct device *dev, unsigned long action)
 {
-	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	struct swnode *swnode;
 	int ret;
 
-	if (!fwnode)
-		return 0;
-
-	if (!is_software_node(fwnode))
-		fwnode = fwnode->secondary;
-	if (!is_software_node(fwnode))
+	swnode = dev_to_swnode(dev);
+	if (!swnode)
 		return 0;
 
-	swnode = to_swnode(fwnode);
-
 	switch (action) {
 	case KOBJ_ADD:
 		ret = sysfs_create_link(&dev->kobj, &swnode->kobj,
diff --git a/include/linux/property.h b/include/linux/property.h
index b6135176cfdc5..9e94de6a83478 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -492,4 +492,7 @@ fwnode_create_software_node(const struct property_entry *properties,
 			    const struct fwnode_handle *parent);
 void fwnode_remove_software_node(struct fwnode_handle *fwnode);
 
+int device_add_software_node(struct device *dev, const struct software_node *swnode);
+void device_remove_software_node(struct device *dev);
+
 #endif /* _LINUX_PROPERTY_H_ */
-- 
2.53.0



