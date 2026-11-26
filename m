Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705482;
	b=vMUNnX2+8GF+O3k/eKFF6GXXEW8C8ZB+lL47x8LpYEoCr/YXthTVUp/BjKvtu6L0tMgt
	 blUdu7sVwLps66mY7bHD46301K2ey64WG9wGFUlSXwYs2JvSEVD/+tbPTfZvYd2FbfTFb
	 tw9ApJFut1UrwsVM0QIiEgbTOyEeH9idKis9hk1MhWa0hQCsUYoBRpz47PvYP/E5fIXLI
	 x9AhWoKFd7TnxdnoI+bMfy99IPkm6W+M1Kiqn6xk4+LFlN4+8iZ7FGDGhxgd7DFpMmqKq
	 c7SoJGyvcQni0qCkxnt2f5cTjNPBHcKOiSs8t9CKEz+fssxi2StqP/PZG42/ym7Tl8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eJKKrgNpxpAIP4peTMSc12sRQAuFHUPFBzay4tWWtbw=;
	b=PaDKC0m8o0P3PdZF/jk0RfKp29Zt3L3rasl8+7gGlwIomQS8S9IHEXlINs+DZsdOg7GB
	 s8CJRbabOPgqKH9R1bRs/S1LNbSb7G5pMlQZIiDG/R+pN63bIe/tZyUdRqDBFCS6R2CwR
	 6qYv5j9cKU5SFVGH4xcyudKX0pzDSkxNmuG39/UyKZRA08eUDXsxSKtS58/GN8ChpVuy7
	 KS/97xdXz7VF+w8qQobN9L0riRFBOKQi5NAQoKUeXcLQKpxeq+cCCp9KsL2CqdYv7MUx9
	 J5j3bYHUcIvj8rhFK/BjXeamyd08yu9DDyitNMalC5KqRYNybtb78j9UNg88B93AzZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2Q4KDH9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8EA606A31C;
	Thu, 26 Nov 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2Q4KDH9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738AE1F000C0;
	Thu, 26 Nov 2026 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705481;
	bh=eJKKrgNpxpAIP4peTMSc12sRQAuFHUPFBzay4tWWtbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2Q4KDH9iJepFZE6EPNp7tt7afA+rnGLQ6DkjWJ6cuPAip9gP8LNHwHk0Tyn7mELp
	 Xb35D6c0Srp6vbVYnWbwGLLVFrs8KF7vNqKgnI/XGpMRdWCMy3G0Dk+exnXF6tVwL4
	 Za/QONELIilwo4CZodpj8VUBMpw/n27Vp8qc7OmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 211/319] software node: only let the owner release a managed node
Date: Thu, 26 Nov 2026 15:39:39 +0100
Message-ID: <20261126144011.507803691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -18,6 +18,8 @@ struct swnode {
 	struct fwnode_handle fwnode;
 	const struct software_node *node;
 	int id;
+	/* Device the managed node's lifetime is tied to. */
+	struct device *owner;
 
 	/* hierarchy */
 	struct ida child_ids;
@@ -26,7 +28,6 @@ struct swnode {
 	struct swnode *parent;
 
 	unsigned int allocated:1;
-	unsigned int managed:1;
 };
 
 static DEFINE_IDA(swnode_root_ids);
@@ -1116,7 +1117,7 @@ int device_create_managed_software_node(
 	if (IS_ERR(fwnode))
 		return PTR_ERR(fwnode);
 
-	to_swnode(fwnode)->managed = true;
+	to_swnode(fwnode)->owner = dev;
 	set_secondary_fwnode(dev, fwnode);
 
 	if (device_is_registered(dev))
@@ -1160,7 +1161,7 @@ void software_node_notify_remove(struct
 	sysfs_remove_link(&dev->kobj, "software_node");
 	kobject_put(&swnode->kobj);
 
-	if (swnode->managed) {
+	if (swnode->owner == dev) {
 		set_secondary_fwnode(dev, NULL);
 		kobject_put(&swnode->kobj);
 	}


