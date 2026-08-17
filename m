Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030543C76A6;
	Mon, 17 Aug 2026 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974352; cv=none; b=GGRpwEWdHul4mL7TjXb1nonFKAQVXHRvd1pgIW0/F3MeVX9olMXH9he9ikp4Mlt3OjPYVyOAuRTKx5mzGDcuMYXzv43uaFhOLEfmBZgVB7viga1DnrPkGkwePgOFii7CwIPU9jyRqagzEeq6yhnJ8iDialyPoGLxKYhKL5mrQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974352; c=relaxed/simple;
	bh=bFi+uDbCwESzm0AQuTLv36+KSH1b5Eoqnu67QcpCqts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdrsXK6ukQuYN7yBs8JGsYHp9i8dnU2izQdphA3b4SfgveDJYBAW+CYe26tSf4xO2wAdJhrwA/34H7LPu6ysmTucSOnE22TIOqXSCIhr8EzPxoP1l0+JrUJPzM0Fl4R/LT+/oYeH2vnhTPDTyFOa+J0TV6BgRfjzv8BM+xXsTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0ed9eLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0ed9eLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C87B1F00A3E;
	Mon, 17 Aug 2026 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974346;
	bh=F+Wc7alCfSl7FYn49PGwO+7SW0cOD0u/e8Z+9cMJsv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0ed9eLcZ9X4juwdbgqT1V9Vt5JF9m40xWbdp+VgWZEYSybvlmLULWDUiWNmnJAes
	 ReIbciDvtY9UcYS6DGAMLv0UZY2q7XMRpwZkXYtuZbOpAHZX38KPo7kYQn3NtYWDb/
	 pKbrefW6UoM+t9nWuAG+7QQ+YHU3eMEYK/rX9NRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.1 175/271] nvmem: layouts: Add fixed-layout driver
Date: Mon, 17 Aug 2026 15:31:40 +0200
Message-ID: <20260817132544.057089771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>

commit b5be879519291f139fa7b365fd0dbc84710e4919 upstream.

Current implementation isn't working well when device tree nodes have a
phandle on a fixed-layout nvmem node. As the fixed layout is handled in
nvmem core, no driver is ever associated with the layout, and the device
consumer driver probe is deferred indefinitely.

Remove the specific handling of fixed-layout and add a layout driver.
This makes the fixed-layout similar to all other layouts, fixing the
whole issue.

Fixes: fc29fd821d9a ("nvmem: core: Rework layouts to become regular devices")
Cc: stable@vger.kernel.org
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223404.629248-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                          |    5 +++
 drivers/nvmem/core.c                 |   24 +-------------
 drivers/nvmem/internals.h            |    2 +
 drivers/nvmem/layouts.c              |   11 ------
 drivers/nvmem/layouts/Makefile       |    1 
 drivers/nvmem/layouts/fixed-layout.c |   58 +++++++++++++++++++++++++++++++++++
 include/linux/nvmem-provider.h       |    6 +++
 7 files changed, 74 insertions(+), 33 deletions(-)
 create mode 100644 drivers/nvmem/layouts/fixed-layout.c

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10031,6 +10031,11 @@ F:	drivers/base/firmware_loader/
 F:	rust/kernel/firmware.rs
 F:	include/linux/firmware.h
 
+FIXED-LAYOUT NVMEM LAYOUT DRIVER
+M:	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
+S:	Maintained
+F:	drivers/nvmem/layouts/fixed-layout.c
+
 FLEXTIMER FTM-QUADDEC DRIVER
 M:	Patrick Havelange <patrick.havelange@essensium.com>
 L:	linux-iio@vger.kernel.org
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -786,7 +786,7 @@ static int nvmem_validate_keepouts(struc
 	return 0;
 }
 
-static int nvmem_add_cells_from_dt(struct nvmem_device *nvmem, struct device_node *np)
+int nvmem_add_cells_from_dt(struct nvmem_device *nvmem, struct device_node *np)
 {
 	struct device *dev = &nvmem->dev;
 	const __be32 *addr;
@@ -834,29 +834,13 @@ static int nvmem_add_cells_from_dt(struc
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nvmem_add_cells_from_dt);
 
 static int nvmem_add_cells_from_legacy_of(struct nvmem_device *nvmem)
 {
 	return nvmem_add_cells_from_dt(nvmem, nvmem->dev.of_node);
 }
 
-static int nvmem_add_cells_from_fixed_layout(struct nvmem_device *nvmem)
-{
-	struct device_node *layout_np;
-	int err = 0;
-
-	layout_np = of_nvmem_layout_get_container(nvmem);
-	if (!layout_np)
-		return 0;
-
-	if (of_device_is_compatible(layout_np, "fixed-layout"))
-		err = nvmem_add_cells_from_dt(nvmem, layout_np);
-
-	of_node_put(layout_np);
-
-	return err;
-}
-
 int nvmem_layout_register(struct nvmem_layout *layout)
 {
 	int ret;
@@ -1005,10 +989,6 @@ struct nvmem_device *nvmem_register(cons
 			goto err_remove_cells;
 	}
 
-	rval = nvmem_add_cells_from_fixed_layout(nvmem);
-	if (rval)
-		goto err_remove_cells;
-
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
 
 	rval = device_add(&nvmem->dev);
--- a/drivers/nvmem/internals.h
+++ b/drivers/nvmem/internals.h
@@ -35,6 +35,8 @@ struct nvmem_device {
 	bool			sysfs_cells_populated;
 };
 
+int nvmem_add_cells_from_dt(struct nvmem_device *nvmem, struct device_node *np);
+
 #if IS_ENABLED(CONFIG_OF)
 int nvmem_layout_bus_register(void);
 void nvmem_layout_bus_unregister(void);
--- a/drivers/nvmem/layouts.c
+++ b/drivers/nvmem/layouts.c
@@ -125,11 +125,6 @@ static int nvmem_layout_create_device(st
 	return 0;
 }
 
-static const struct of_device_id of_nvmem_layout_skip_table[] = {
-	{ .compatible = "fixed-layout", },
-	{}
-};
-
 static int nvmem_layout_bus_populate(struct nvmem_device *nvmem,
 				     struct device_node *layout_dn)
 {
@@ -142,12 +137,6 @@ static int nvmem_layout_bus_populate(str
 		return 0;
 	}
 
-	/* Fixed layouts are parsed manually somewhere else for now */
-	if (of_match_node(of_nvmem_layout_skip_table, layout_dn)) {
-		pr_debug("%s() - skipping %pOF node\n", __func__, layout_dn);
-		return 0;
-	}
-
 	if (of_node_check_flag(layout_dn, OF_POPULATED_BUS)) {
 		pr_debug("%s() - skipping %pOF, already populated\n",
 			 __func__, layout_dn);
--- a/drivers/nvmem/layouts/Makefile
+++ b/drivers/nvmem/layouts/Makefile
@@ -3,6 +3,7 @@
 # Makefile for nvmem layouts.
 #
 
+obj-$(CONFIG_NVMEM_LAYOUTS) += fixed-layout.o
 obj-$(CONFIG_NVMEM_LAYOUT_SL28_VPD) += sl28vpd.o
 obj-$(CONFIG_NVMEM_LAYOUT_ONIE_TLV) += onie-tlv.o
 obj-$(CONFIG_NVMEM_LAYOUT_U_BOOT_ENV) += u-boot-env.o
--- /dev/null
+++ b/drivers/nvmem/layouts/fixed-layout.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2026 Bootlin
+ *
+ * Authors: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
+ */
+
+#include <linux/nvmem-provider.h>
+#include <linux/of.h>
+
+#include "../internals.h"
+
+static int fixed_layout_add_cells(struct nvmem_layout *layout)
+{
+	struct device_node *np;
+	int ret;
+
+	np = of_nvmem_layout_get_container(layout->nvmem);
+	if (!np)
+		return -ENOENT;
+
+	ret = nvmem_add_cells_from_dt(layout->nvmem, np);
+	of_node_put(np);
+
+	return ret;
+}
+
+static int fixed_layout_probe(struct nvmem_layout *layout)
+{
+	layout->add_cells = fixed_layout_add_cells;
+
+	return nvmem_layout_register(layout);
+}
+
+static void fixed_layout_remove(struct nvmem_layout *layout)
+{
+	nvmem_layout_unregister(layout);
+}
+
+static const struct of_device_id fixed_layout_of_match_table[] = {
+	{ .compatible = "fixed-layout", },
+	{},
+};
+
+static struct nvmem_layout_driver fixed_layout_layout = {
+	.driver = {
+		.name = "fixed-layout",
+		.of_match_table = fixed_layout_of_match_table,
+	},
+	.probe = fixed_layout_probe,
+	.remove = fixed_layout_remove,
+};
+module_nvmem_layout_driver(fixed_layout_layout);
+
+MODULE_AUTHOR("Mathieu Dubois-Briand");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(of, fixed_layout_of_match_table);
+MODULE_DESCRIPTION("NVMEM fixed-layout driver");
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -214,6 +214,12 @@ static inline int nvmem_layout_register(
 
 static inline void nvmem_layout_unregister(struct nvmem_layout *layout) {}
 
+static inline int nvmem_add_cells_from_dt(struct nvmem_device *nvmem,
+					  struct device_node *np)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_NVMEM */
 
 #if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)


