Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625760;
	b=rQ/eJra41m++t+5/VpZln3S89+ptpRc2dH8RwxvKGh165K9J/+NxIh/uMyHpzm8wxlUO
	 czfVNxBp2TjEBwkvO+Xfqm2PGzEw1Bqrsjvx93cSEWbHyA39YxGSw+pyx0ObAmzmg4xsd
	 JFrwoUDJLca6pI1AVw0ukysrBqQuuoqGA5RmwOp9LdjAO1DZjEeqp3GWq8+IRM6bBGuLl
	 3ne2rGYtXKTbzKEWlOlA4bbN3Ywa4H2qIFJ93t+JCevJ4RkweiXAzT4AjkTHyUI+kLfGV
	 2y03/ETqnGQiS23zaK0VQk1d+lp3VmOd1HPxHz3JZ47HB/9/RB2OrHVGTszhCzfYjMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6L5POoj5pECP/yQdw2ydJGGl93+116+NXDEClfqGeug=;
	b=CQImpzLtHBvJjCNWOUUt4e1lkcUZZVh1Q2/qwnCYIow96AiPc1HgHWAK+RzSSX2GdXYK
	 B2z4BYP5UjC8zyW7S3ZIVHLmVvzMAo6LWUwH6InyJpeUlkZkQ5RG5V0VYpyNazCsVjQ/o
	 7XnmYkPrTV5UKmVDkRk+hJi8PoN1blyKTXSi5pY1BcFzWyQJPRUpxaIvNVuL9OcsPV/mO
	 zEiqupnCN68NHT4F4uKdmlHSxFHCgBBmOcioQQZJVRhHPRtQj2iNIZF7AJrCWfPZO/L3y
	 n1UknF78i9ocFtdIh8JhKU5DCMhsMs3Qr2mVW+XGNcG+dbSxWOwjBgWleB7gl5pqZ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0UHxmMx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE99606A327;
	Wed, 25 Nov 2026 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0UHxmMx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42F81F000C0;
	Wed, 25 Nov 2026 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625759;
	bh=6L5POoj5pECP/yQdw2ydJGGl93+116+NXDEClfqGeug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0UHxmMxer6jUsJLBUfTAF0g226XW8uoIlutJs+Yozku+YI5f1w0BgGsLex1+88I1
	 AewwlvzwL2xMM+ofsnz578PoT7l6fQS7ISkZxMa/RK3RfgNlMlE3Rn7WLSKLaGPDD+
	 uP/2nkXQn/5pg3VnGtSEnzIVTsgpMw5Xx0TMd3+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 624/816] software node: only let the owner release a managed node
Date: Wed, 25 Nov 2026 15:36:12 +0100
Message-ID: <20261125143903.627819788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit f8623ce596492d2e96ca57eeec992938d3d79f00 upstream.

device_create_managed_software_node() creates a node whose lifetime is
tied to the device it was created for. software_node_notify_remove() is
called for every device that has the node as its fwnode (primary OR
secondary) and, if the node is managed, unconditionally detaches it from
that device and drops the creation reference.

This breaks when the node is shared with another device. Example: the
i2c-designware copies the parent's fwnode to the adapter's struct device.
When the adapter is deleted, it releases the reference that belongs to
the owner and the latter ends up with a dangling pointer.

Record the device's "manager" and only perform the actual release when
notify is called for that "owner" device.

Note that it was never the intention that managed software nodes would
be shared, but descendants reusing ancestor firmware nodes is not
uncommon and such use is hard to predict when allocating software nodes.

Reported-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Closes: https://lore.kernel.org/all/20261009164241.923756-2-balasubramani.vivekanandan@intel.com/
Fixes: 151f6ff78cdf ("software node: Provide replacement for device_add_properties()")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Fixes: 0f485f88656a ("drm/xe/i2c: use device_create_managed_software_node()")
Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Tested-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261102-swnode-only-owner-release-v1-1-ee4c9022a629@oss.qualcomm.com
[ johan: drop temporary variable; skip clearing owner field;
         mention reuse not intended in commit message ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -29,6 +29,8 @@ struct swnode {
 	struct fwnode_handle fwnode;
 	const struct software_node *node;
 	int id;
+	/* Device the managed node's lifetime is tied to. */
+	struct device *owner;
 
 	/* hierarchy */
 	struct ida child_ids;
@@ -37,7 +39,6 @@ struct swnode {
 	struct swnode *parent;
 
 	unsigned int allocated:1;
-	unsigned int managed:1;
 };
 
 static DEFINE_IDA(swnode_root_ids);
@@ -1060,7 +1061,7 @@ int device_create_managed_software_node(
 	if (IS_ERR(fwnode))
 		return PTR_ERR(fwnode);
 
-	to_swnode(fwnode)->managed = true;
+	to_swnode(fwnode)->owner = dev;
 	set_secondary_fwnode(dev, fwnode);
 
 	if (device_is_registered(dev))
@@ -1104,7 +1105,7 @@ void software_node_notify_remove(struct
 	sysfs_remove_link(&dev->kobj, "software_node");
 	kobject_put(&swnode->kobj);
 
-	if (swnode->managed) {
+	if (swnode->owner == dev) {
 		set_secondary_fwnode(dev, NULL);
 		kobject_put(&swnode->kobj);
 	}


