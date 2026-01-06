Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FEA346E57;
	Tue,  6 Jan 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721420; cv=none; b=HYS09PwU8ExXuqFB+yi9ks67GupQrEOtpFpZfdIFBZmgWao2AmmtH5G53tF1PG4uGeEIgXFvvLzokziPcTJSvoAxMuVJs/YvJuy/KTjB2I7/Z6mM2WCCZ2lSp4Jaj3oD0wxFMzNlZxHr7G99EX3IoaFPeXctf/C06+ssxzXMlC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721420; c=relaxed/simple;
	bh=j4IVjUKPavKuifwiMpQ96sJ1yubQQF8i7Dxjt2BAENI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSQKbjtzaGSE/ax+eG/BGKYXruhcVZTbIHZbHH4CEXn1zzEaVChH7K2sPfeSVZR8GMctx6373zxirovQmSmaA7Ncjq2EJF7zLQTgvk8V+FWXs/UPQDa2Slzoy1wZO2E0ZhmkkD7q8dtIlb8GjjQzZZze0WouvGzOLUSShVY0064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOJO6bDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOJO6bDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA882C16AAE;
	Tue,  6 Jan 2026 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721420;
	bh=j4IVjUKPavKuifwiMpQ96sJ1yubQQF8i7Dxjt2BAENI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOJO6bDJjMot6f7dZ4X56pU08/gzoZh7bx+3BRnnaXVJY5w/2K1v2WynhoNyV6hWu
	 H3DfJ+QlynpP83FU+rHalboJMU/7dmZ+4m23wVXnHxSFZwdEvPAHqb/hOmOyE+seeF
	 zmzy5Sy0PDMM2YUYlaRVnLGOPmdX1PW3PPCGAXhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/567] serial: core: Restore sysfs fwnode information
Date: Tue,  6 Jan 2026 18:04:41 +0100
Message-ID: <20260106170509.826051068@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 24ec03cc55126b7b3adf102f4b3d9f716532b329 ]

The change that restores sysfs fwnode information does it only for OF cases.
Update the fix to cover all possible types of fwnodes.

Fixes: d36f0e9a0002 ("serial: core: restore of_node information in sysfs")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251127163650.2942075-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_base_bus.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/serial_base_bus.c
+++ b/drivers/tty/serial/serial_base_bus.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/property.h>
 #include <linux/serial_core.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -60,6 +60,7 @@ void serial_base_driver_unregister(struc
 	driver_unregister(driver);
 }
 
+/* On failure the caller must put device @dev with put_device() */
 static int serial_base_device_init(struct uart_port *port,
 				   struct device *dev,
 				   struct device *parent_dev,
@@ -73,7 +74,8 @@ static int serial_base_device_init(struc
 	dev->parent = parent_dev;
 	dev->bus = &serial_base_bus_type;
 	dev->release = release;
-	device_set_of_node_from_dev(dev, parent_dev);
+
+	device_set_node(dev, fwnode_handle_get(dev_fwnode(parent_dev)));
 
 	if (!serial_base_initialized) {
 		dev_dbg(port->dev, "uart_add_one_port() called before arch_initcall()?\n");
@@ -94,7 +96,7 @@ static void serial_base_ctrl_release(str
 {
 	struct serial_ctrl_device *ctrl_dev = to_serial_base_ctrl_device(dev);
 
-	of_node_put(dev->of_node);
+	fwnode_handle_put(dev_fwnode(dev));
 	kfree(ctrl_dev);
 }
 
@@ -142,7 +144,7 @@ static void serial_base_port_release(str
 {
 	struct serial_port_device *port_dev = to_serial_base_port_device(dev);
 
-	of_node_put(dev->of_node);
+	fwnode_handle_put(dev_fwnode(dev));
 	kfree(port_dev);
 }
 


