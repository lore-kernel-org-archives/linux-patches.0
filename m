Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9F3DD502;
	Thu, 17 Sep 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666059; cv=none; b=Wo1Z0TxbK2Z1SxDF+WTRMsS0xzsmoklH/mPfCgqdrIzUycKhe8k0m94fhKpEt3lGuX+hEa8DMQ8cykM4TKS5s/pNM5cIvJ3qJSMwcTr7reCWem5lV8Ts6qZVY+7sNvELsj4f09mXP8z4dDSIVqbCXP7efgMb8XI4s5ibMDFQnrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666059; c=relaxed/simple;
	bh=LKHFfsc6MWXZx73/nJ0oN3KlkGTOL7M1frcoAR3Xp70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyqK52CoAr6Gq0k4+V4STU84/9mfcfFoDrKFvazwEJibg1HReB9pBjE6NV/rQJJUFQvffnpsY9KdpAixcRu+YbLVaAXuHMDcPeasuHNNmYVCpiLEyLfyAaU6gEaAy1H6cH3N3P4oJE3taRWAA3d5gG7FJhHXBfwcJ9Wxr73YPCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxwuiVW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxwuiVW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E00E1F000FF;
	Thu, 17 Sep 2026 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666057;
	bh=bPfTzbythTfK9tQwklJ3cdcXaJ6r7HHAkWjk4hvIfWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxwuiVW31NK518w+85fhf07iACvJhOBUW1MX1FzXo1d1yXU0isjPqlsd2PDx+2yfZ
	 0pbFKrohRME0ZSRCgbNP/Glr1E6OL0OyixT0KN9hqc28LCeXiIF+KSGQ9HEXJS8NeJ
	 yrzMc2D9MztESrIWk0Zn8pb/5KhSOsO4LOYIIZNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0911/1250] devlink: Add port-level resource registration infrastructure
Date: Thu, 17 Sep 2026 16:11:46 +0100
Message-ID: <20260917151616.689348139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 6f38acfed5edb398201d9ff127919745cbb331a1 ]

The current devlink resource infrastructure supports only device-level
resources. Some hardware resources are associated with specific ports
rather than the entire device, and today we have no way to show resource
per-port.

Add support for registering resources at the port level.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260407194107.148063-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7f26a5e8040b ("net/mlx5e: Move representor vnic reporter to eswitch devlink port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/devlink.h  |  8 ++++++++
 net/devlink/port.c     |  2 ++
 net/devlink/resource.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index bfc1ba754d0d7..f24e1332bcb24 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -129,6 +129,7 @@ struct devlink_rate {
 struct devlink_port {
 	struct list_head list;
 	struct list_head region_list;
+	struct list_head resource_list;
 	struct devlink *devlink;
 	const struct devlink_port_ops *ops;
 	unsigned int index;
@@ -1834,6 +1835,13 @@ void devlink_resources_unregister(struct devlink *devlink);
 int devl_resource_size_get(struct devlink *devlink,
 			   u64 resource_id,
 			   u64 *p_resource_size);
+int
+devl_port_resource_register(struct devlink_port *devlink_port,
+			    const char *resource_name,
+			    u64 resource_size, u64 resource_id,
+			    u64 parent_resource_id,
+			    const struct devlink_resource_size_params *params);
+void devl_port_resources_unregister(struct devlink_port *devlink_port);
 int devl_dpipe_table_resource_set(struct devlink *devlink,
 				  const char *table_name, u64 resource_id,
 				  u64 resource_units);
diff --git a/net/devlink/port.c b/net/devlink/port.c
index 93d8a25bb920c..21c72f1af9259 100644
--- a/net/devlink/port.c
+++ b/net/devlink/port.c
@@ -1024,6 +1024,7 @@ void devlink_port_init(struct devlink *devlink,
 		return;
 	devlink_port->devlink = devlink;
 	INIT_LIST_HEAD(&devlink_port->region_list);
+	INIT_LIST_HEAD(&devlink_port->resource_list);
 	devlink_port->initialized = true;
 }
 EXPORT_SYMBOL_GPL(devlink_port_init);
@@ -1041,6 +1042,7 @@ EXPORT_SYMBOL_GPL(devlink_port_init);
 void devlink_port_fini(struct devlink_port *devlink_port)
 {
 	WARN_ON(!list_empty(&devlink_port->region_list));
+	WARN_ON(!list_empty(&devlink_port->resource_list));
 }
 EXPORT_SYMBOL_GPL(devlink_port_fini);
 
diff --git a/net/devlink/resource.c b/net/devlink/resource.c
index 499678e8d686e..dc9a55e443c21 100644
--- a/net/devlink/resource.c
+++ b/net/devlink/resource.c
@@ -532,3 +532,46 @@ void devl_resource_occ_get_unregister(struct devlink *devlink,
 	resource->occ_get_priv = NULL;
 }
 EXPORT_SYMBOL_GPL(devl_resource_occ_get_unregister);
+
+/**
+ * devl_port_resource_register - devlink port resource register
+ *
+ * @devlink_port: devlink port
+ * @resource_name: resource's name
+ * @resource_size: resource's size
+ * @resource_id: resource's id
+ * @parent_resource_id: resource's parent id
+ * @params: size parameters
+ *
+ * Generic resources should reuse the same names across drivers.
+ * Please see the generic resources list at:
+ * Documentation/networking/devlink/devlink-resource.rst
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int
+devl_port_resource_register(struct devlink_port *devlink_port,
+			    const char *resource_name,
+			    u64 resource_size, u64 resource_id,
+			    u64 parent_resource_id,
+			    const struct devlink_resource_size_params *params)
+{
+	return __devl_resource_register(devlink_port->devlink,
+					&devlink_port->resource_list,
+					resource_name, resource_size,
+					resource_id, parent_resource_id,
+					params);
+}
+EXPORT_SYMBOL_GPL(devl_port_resource_register);
+
+/**
+ * devl_port_resources_unregister - unregister all devlink port resources
+ *
+ * @devlink_port: devlink port
+ */
+void devl_port_resources_unregister(struct devlink_port *devlink_port)
+{
+	__devl_resources_unregister(devlink_port->devlink,
+				    &devlink_port->resource_list);
+}
+EXPORT_SYMBOL_GPL(devl_port_resources_unregister);
-- 
2.53.0



