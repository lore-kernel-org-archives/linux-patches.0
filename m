Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023988;
	b=lOIDDvJT5GLkg5yS2xb0ThltILxB+PgxcpO0Xras0N/8t4c2SK9JWWA5g+zyg/2mqdyC
	 IZfVSPpVgAJqaYh7Wo/U0FwCWyF8vTU6938MgsRoRi1+Xt2Kjl9tc23zDjdWLZs1ypT5N
	 sFSJprDBG8Wu8YnW05BaCr7kqBs/zJxZ3jx78POqmngzSvh+NuBZcstOLpDFoihudHTAk
	 TCc9FEeZV5G4gzdUon8++6YewsUxEomLeDEZB5ZPVJGZa5BOCMusw7Ysn6GkMxP1V2zfI
	 YpGRHomyyzyIu5JIbJJGB+E2j9T2yjYByiDUSc80/uGnSsSGGfFolH0ubG+FDGoG+LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yw4ho9jWGbxdVqkHGc1E3MmtcXNC9n4ujMNfEd3lNco=;
	b=v1ryfaPcNNStqW8SGvKVkXEmVgZE9h0C8ujUv/aqI8oZnlxD5UkBrD/O3zmdFpNVGK5t
	 HF6c0W17WE0tMOeiiU/7YPtj3I7SBy97SNNFoUtEpPQEuWDvb+BWTlB/8EfjtmesrcpAF
	 hLFfcbiZYsk9KExc5H8r/FPDj1KvP1EZuTrUJZve/+rgX6kqxVtabD03F3u/sjhjj7Gm8
	 +EPzZeXZ1VlqNhAzg1Di7ocXS/uzDJJgaqBrB8nSyQwBAfIACKB53BU+foFIE8Wb0lH3T
	 ZIkehipd9xZnD7n52U9lEDB8t7ttk0/I74p+jQmSPN09E7qiFcoTQhK6pfBgIIMJ/dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhcJ2YhH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6561606A32A;
	Wed, 18 Nov 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhcJ2YhH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B951F000C4;
	Wed, 18 Nov 2026 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023988;
	bh=yw4ho9jWGbxdVqkHGc1E3MmtcXNC9n4ujMNfEd3lNco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhcJ2YhHvzBwLiB99V1aRXUtsxZNXmoqaPlwyYpPTrpgDLFH6hAyuRVAq67ZCe+Z+
	 956OtJ0ZTFa3rKZVzyGnakzQJCYF9TUaKq0gq6ogE8u3PXV5BlfPu5Y6OVE3VqYosl
	 q03yw5WKmVVXCM8ROoHzE6G1qdxfPR60RhRHBAS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0514/2151] cxl/port: Cleanup dport removal with a devres group
Date: Wed, 18 Nov 2026 15:37:29 +0100
Message-ID: <20261118150140.779601501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit afa2bdba1ee28e21f30fe5391b0273b58b32e0d3 ]

In preparation for adding more setup actions like RAS register mapping,
introduce a devres group to collect all the dport creation / registration
actions. This replaces the maintenance tedium of open coding several
devm_release_action() calls in del_dport().

Tested-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20260131000403.2135324-4-dan.j.williams@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 0de71a1ab211 ("cxl/core: Fix dport use-after-free via the einj_inject debugfs file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 71 +++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 9990a038d2360..c7b46eeedb093 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1163,6 +1163,57 @@ static void cxl_dport_unlink(void *data)
 	sysfs_remove_link(&port->dev.kobj, link_name);
 }
 
+static struct device *dport_to_host(struct cxl_dport *dport)
+{
+	struct cxl_port *port = dport->port;
+
+	if (is_cxl_root(port))
+		return port->uport_dev;
+	return &port->dev;
+}
+
+static void free_dport(void *dport)
+{
+	kfree(dport);
+}
+
+/*
+ * Upon return either a group is established with one action (free_dport()), or
+ * no group established and @dport is freed.
+ */
+static void *cxl_dport_open_dr_group_or_free(struct cxl_dport *dport)
+{
+	int rc;
+	struct device *host = dport_to_host(dport);
+	void *group = devres_open_group(host, dport, GFP_KERNEL);
+
+	if (!group) {
+		kfree(dport);
+		return NULL;
+	}
+
+	rc = devm_add_action_or_reset(host, free_dport, dport);
+	if (rc) {
+		devres_release_group(host, group);
+		return NULL;
+	}
+
+	return group;
+}
+
+static void cxl_dport_close_dr_group(struct cxl_dport *dport, void *group)
+{
+	devres_close_group(dport_to_host(dport), group);
+}
+
+static void del_dport(struct cxl_dport *dport)
+{
+	devres_release_group(dport_to_host(dport), dport);
+}
+
+/* The dport group id is the dport */
+DEFINE_FREE(cxl_dport_release_dr_group, void *, if (_T) del_dport(_T))
+
 static struct cxl_dport *
 __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 		     int port_id, resource_size_t component_reg_phys,
@@ -1188,14 +1239,20 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 	    CXL_TARGET_STRLEN)
 		return ERR_PTR(-EINVAL);
 
-	dport = devm_kzalloc(host, sizeof(*dport), GFP_KERNEL);
+	dport = kzalloc(sizeof(*dport), GFP_KERNEL);
 	if (!dport)
 		return ERR_PTR(-ENOMEM);
 
+	/* Just enough init to manage the devres group */
 	dport->dport_dev = dport_dev;
 	dport->port_id = port_id;
 	dport->port = port;
 
+	void *dport_dr_group __free(cxl_dport_release_dr_group) =
+		cxl_dport_open_dr_group_or_free(dport);
+	if (!dport_dr_group)
+		return ERR_PTR(-ENOMEM);
+
 	if (rcrb == CXL_RESOURCE_NONE) {
 		rc = cxl_dport_setup_regs(&port->dev, dport,
 					  component_reg_phys);
@@ -1248,6 +1305,9 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 
 	cxl_debugfs_create_dport_dir(dport);
 
+	/* keep the group, and mark the end of devm actions */
+	cxl_dport_close_dr_group(dport, no_free_ptr(dport_dr_group));
+
 	return dport;
 }
 
@@ -1474,15 +1534,6 @@ static void delete_switch_port(struct cxl_port *port)
 	devm_release_action(port->dev.parent, unregister_port, port);
 }
 
-static void del_dport(struct cxl_dport *dport)
-{
-	struct cxl_port *port = dport->port;
-
-	devm_release_action(&port->dev, cxl_dport_unlink, dport);
-	devm_release_action(&port->dev, cxl_dport_remove, dport);
-	devm_kfree(&port->dev, dport);
-}
-
 static void del_dports(struct cxl_port *port)
 {
 	struct cxl_dport *dport;
-- 
2.53.0



