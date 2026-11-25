Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623125;
	b=Lr586KA0oB0muMINZK+hzqXrz4MJL8n4Md3m56wSd7o51WKF3lVe8f3ZOncOyNJAyd91
	 BQAxYWJ0ePnSLyhacDq8h/6ahoyt3xjX8jywcm5ahkj9oIGlViXdV1V2fxfCB4as357B2
	 4fF1PKOqL3W0ekrGLI/A/co2FCisZmWFesYwALPe0Glojj5/Js4bfAqJnicyvbQKMNINg
	 3gqwXPYB48CEVoUwsNDTmPFAxgDn+rC/mWxfw5nh8U1TImn4MnA51uSKxp4oICjnldoas
	 LbGCqiZzRMCGTZzuhwbbh8vyqwBX90QH/Mkk+nbPB2hOBqzXsrs2dZGK+nxX9/ZPStw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cDIBRCcVpfEErDlqth3PWFMvEhGabRvGPUr1UzH8LgM=;
	b=Gby5pp5i1ACTZwou9EY548UuOg10l0y4fsrYObNJQtjkkKEUD6pi5kP1MMnGTTQsnF7z
	 sTthXPt/UuQSH+FgFox5sR3TBGdG7r6XPVqiFQLYAh0h8e/Xhe55lptLECQ63hZPMXVaS
	 c9tcwPtLMiz79ccH3UjgjaYm8kw7CHjbxQVQbiYO3VlKW8+HZPYuqkl623jJPYnlsF8zp
	 /ndj59Qs/1m/jVK1DaB173P894+5SuHEgrmt9HmK1xL84elguQUjcyeP1fP2LFml5Lgpf
	 Vb4LHJ34WC7NG0INdFZtl8OoJjUxk+yUDR50z8WckXAAMACsFtjj7WS7O8ui9BD50rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoTN9ImR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1656606A31E;
	Wed, 25 Nov 2026 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoTN9ImR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFF21F000C4;
	Wed, 25 Nov 2026 16:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623125;
	bh=cDIBRCcVpfEErDlqth3PWFMvEhGabRvGPUr1UzH8LgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoTN9ImRAUgPE/e878XPw8L6cUEFbZH9W89znhExVR5CGIW5JZ0Q0AUo6VUdwdaeB
	 T4jAaCozy8HFtPEc/bn+iJnmOkTFtcdV/RnAswvXHpLVMOTJbwFku780AYZmfAvtjF
	 Ze1vpEv2UVFYGjpsVRMtnKmQwF+TbIavuBWh3PPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 759/990] software node: only let the owner release a managed node
Date: Wed, 25 Nov 2026 15:35:26 +0100
Message-ID: <20261125143839.836508097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1103,7 +1104,7 @@ void software_node_notify_remove(struct
 	sysfs_remove_link(&dev->kobj, "software_node");
 	kobject_put(&swnode->kobj);
 
-	if (swnode->managed) {
+	if (swnode->owner == dev) {
 		set_secondary_fwnode(dev, NULL);
 		kobject_put(&swnode->kobj);
 	}


