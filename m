Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062225;
	b=E8LsZ9HQ5lQ/IUNHM5OMfGvh4oUNeb17N96m1kc0sqFTBI+iqGws/Jm1S63WLj1gwD+F
	 4uMgBzYt17K19Eegd0sx74HPDw+Sy9XFJsShtQU62lNp1f6aUqc0si95E3uPqrlw2N1en
	 a6Pr5V9F/gLwEnIQA1HL47bfjQl58Gn0zFh9t8j2+g1EwNncLRfALlSXrYKv0oDeX/Xvd
	 6S2KCpu0IGVtMQrmnDt7FaSndILsOfrNI1thPvcNl5G7Y/GiUvqZ7R+Aqwolh9yhFKYIX
	 GjB1fMq4j218xBbsO3oCtI5VZ0QwDpWvhKSFOM5RO5MyA+MbB09NHmZX+Vaiu/XZqpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yv1k9FEbP5UzEg9XHceLqzYR3zDSlyTu95mtNRICBK0=;
	b=IUpK3hRa8+vdN2g/dyz/Rg97ueJD49G9ocWVIGunNMz8jf61UPD4uUHiGvhbOzxwID4D
	 4YO06GT3SXvm5j5GcchBFQOWOHWOZD+EsWcUVrDASDKuT09BdMqI+B4wS//kVjrINvDUJ
	 f8BjAgIEi+JJ1ndRh/XgkMn3Q8huwnGBTyays+kqeNBLGbLeUPRdOwpoYZWf/fp6LNDrX
	 NmJ4wBjKkbB2AkMKWFOQC8mwugv+1+kHklcyrW1hn989zDQQSrsFjW4wKUvoc+euegS43
	 6FPbR9NMaO061C2A7LlQb/HxzSCeKJuHUn7PcDiiUbjPnK3+K4HzC95ua5DoGcpBzYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1D1JPDRC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB5E606A32C;
	Thu, 19 Nov 2026 04:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1D1JPDRC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461D31F000C4;
	Thu, 19 Nov 2026 04:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062224;
	bh=Yv1k9FEbP5UzEg9XHceLqzYR3zDSlyTu95mtNRICBK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D1JPDRCLTCP7YGFhB4yPjQdiui48ApwTBqrR3mALuv5eqC2cIpk5gCsqCQlviJLG
	 JDOTZj8AbGfNhWew9EOrrZsJa48DodPbEMGzzdrEZpjzF87prQ9EwV5qD5RV0cHWqL
	 vTA02JysJED2DQipa8GrfckfSE5HnqE0SyLx2Zds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 1835/1848] software node: Fix device_add_software_node()
Date: Wed, 18 Nov 2026 16:04:33 +0100
Message-ID: <20261118150036.435413041@linuxfoundation.org>
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

commit 2a92c90f2ecca4475d6050f2f938a1755a8954cc upstream.

The function device_add_software_node() was meant to
register the node supplied to it, but only if that node
wasn't already registered. Right now the function attempts
to always register the node. That will cause a failure with
nodes that are already registered.

Fixing that by incrementing the reference count of the nodes
that have already been registered, and only registering the
new nodes. Also, clarifying the behaviour in the function
documentation.

Fixes: e68d0119e328 ("software node: Introduce device_add_software_node()")
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c    |   26 +++++++++++++++++---------
 include/linux/property.h |    2 +-
 2 files changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -869,25 +869,33 @@ EXPORT_SYMBOL_GPL(fwnode_remove_software
 /**
  * device_add_software_node - Assign software node to a device
  * @dev: The device the software node is meant for.
- * @swnode: The software node.
+ * @node: The software node.
  *
- * This function will register @swnode and make it the secondary firmware node
- * pointer of @dev. If @dev has no primary node, then @swnode will become the primary
- * node.
+ * This function will make @node the secondary firmware node pointer of @dev. If
+ * @dev has no primary node, then @node will become the primary node. The
+ * function will register @node automatically if it wasn't already registered.
  */
-int device_add_software_node(struct device *dev, const struct software_node *swnode)
+int device_add_software_node(struct device *dev, const struct software_node *node)
 {
+	struct swnode *swnode;
 	int ret;
 
 	/* Only one software node per device. */
 	if (dev_to_swnode(dev))
 		return -EBUSY;
 
-	ret = software_node_register(swnode);
-	if (ret)
-		return ret;
+	swnode = software_node_to_swnode(node);
+	if (swnode) {
+		kobject_get(&swnode->kobj);
+	} else {
+		ret = software_node_register(node);
+		if (ret)
+			return ret;
 
-	set_secondary_fwnode(dev, software_node_fwnode(swnode));
+		swnode = software_node_to_swnode(node);
+	}
+
+	set_secondary_fwnode(dev, &swnode->fwnode);
 
 	return 0;
 }
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -492,7 +492,7 @@ fwnode_create_software_node(const struct
 			    const struct fwnode_handle *parent);
 void fwnode_remove_software_node(struct fwnode_handle *fwnode);
 
-int device_add_software_node(struct device *dev, const struct software_node *swnode);
+int device_add_software_node(struct device *dev, const struct software_node *node);
 void device_remove_software_node(struct device *dev);
 
 #endif /* _LINUX_PROPERTY_H_ */


