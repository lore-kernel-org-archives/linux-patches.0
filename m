Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619830;
	b=hdyHh2HwNGgJbU71G+ENR/2aOJxBvqQJPk2Xdz9kgsonmkgfF5ZFHYlgv8tr9G+Rrli8
	 wT+YbNHUq7f5yucyDP8u+w37/SBf8bt2Rks6we6/YXj8uwVWeRTn6MkjJiWSyn3NhC17m
	 k/RToH7NgoA+PgqVRb/j+x2gk4bY/WJjLXVphxrW1b8PSsEQvuAv5mE0JvYJ60Qh5tfpg
	 JaIKx5jmIOCOOt4kfsOnEoNygp3a7Y4VFaLzEE69r77k9SBQOhcxQSCEQclHjvgR25eR6
	 rt8TloB7YVehVAnO8lGY3YMME3+5PalY7xOd5Css575lxVxbM2U9HjEzTMn9CDMNtkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GdlJzTtBAq1PzkYH7MxZAWU8Esjt2X1Eu+1EQnTpHR0=;
	b=oEBs+9M4RbcgQbT2zly/LEZz98dXLdgZznPFnH/mfIulGty3f0RAEyBtGUVLbGvNjq4n
	 v7glNqzv/T80lmDrqIUUwQ2TJ8wkbpeSc8aC6khkpnnxZ3aWt4lqyAsq6iFqwqmO1mKPF
	 AHIZWJKHkIRWeZD4HVK4xr3Vp9KqymYdRGLgt10yUwzFQW2yR7X4Pk8zjUMZfU48E/Bjv
	 Vxvdlf1aViGAn/+kgF+6qDrafPwxoiEZ1dXI8+ReFEOO+okR0SWjCQsZA3m992xzOq/RA
	 5KrLhX0pAsgGcGEp72VCCW8UkkGuazIT2Lj7WUnV+ObN7wkG7AywwjnKOeHb/J7cG1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0z5KCQv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27178606A330;
	Wed, 25 Nov 2026 15:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0z5KCQv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8AD1F000C4;
	Wed, 25 Nov 2026 15:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619829;
	bh=GdlJzTtBAq1PzkYH7MxZAWU8Esjt2X1Eu+1EQnTpHR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0z5KCQvzT/SFIuFJklw9Qr+dZlQBjvRk+zh1Cu3L8rAt0OaQ/2A/19Bd1Z1MJpG0
	 j6KzMxT6PJzPbMBG2TfnXUOWgN2W9Q3rMotx8Oc1IfyK6wIQ4jnzsoI56CulVdQI5U
	 ubpA8wkjIWoJOxI1eDK876V8ZrRPKmqp8e+q26vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0721/1005] software node: only let the owner release a managed node
Date: Wed, 25 Nov 2026 15:34:19 +0100
Message-ID: <20261125143838.647740346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1145,7 +1146,7 @@ int device_create_managed_software_node(
 	if (IS_ERR(fwnode))
 		return PTR_ERR(fwnode);
 
-	to_swnode(fwnode)->managed = true;
+	to_swnode(fwnode)->owner = dev;
 	set_secondary_fwnode(dev, fwnode);
 
 	if (device_is_registered(dev))
@@ -1208,7 +1209,7 @@ void software_node_notify_remove(struct
 
 	swnode_put(swnode);
 
-	if (swnode->managed) {
+	if (swnode->owner == dev) {
 		set_secondary_fwnode(dev, NULL);
 		swnode_put(swnode);
 	}


