Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58A23BD03;
	Sat, 12 Sep 2026 12:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215170; cv=none; b=i1b1oF6QXscCgGpyMFed3I80WXlc1BY1OUUljHR1NwxzQPeLL9uuOXt7kPngwtAI0DktL2dXOwv5eVD8lhrelSLp4iFbJ1lfUuSYj/8y2udvFx7mWqlRfs9vcAaWzbyAjJks9czN9hVoWqLbt4juMhsnLNzNvsFa8/O5XK0bLKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215170; c=relaxed/simple;
	bh=4f0SZEpVwvjXBUtEksI0W0K1qqUsfRXKdf61cIJsxoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ot4AoyC5sRUu0bVlJwwrixNzmdRyFSuK+PyBg+VeJ2jKQs8jKrxqYmgblzqIMaCxZ6hyvmg8jYGMgpN9BDMSyhWkXpuDO5y3nQUkO1fkWKtS4hbRxdVdtcwQS32uYg8+MYYd7/i1fOg84bYy/PfaglSZQ26I/gWrc/rAscbPcqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIKDymK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIKDymK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB57A1F000FF;
	Sat, 12 Sep 2026 12:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215169;
	bh=oDEFTRAmvzd+pGRFsAP4AMk66Jna3JKSsTpg4RAJyVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIKDymK9Qpudt3Qiz45IHrzqKN3DHYwZpHYNDs6Fd3pODY7Tr9ZAnKlxA+mggRJ9A
	 GVOfmyK94YINj4FaDQMgz8aEAuuGg0SoDIX6OURl+PQv9MsCK85MsZpvLbFtXs19+L
	 YPSLvEA6VGsXwKkuEfygZ9Ww0WenWTjRCCKROa+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0477/1376] platform/x86: lg-laptop: Convert ACPI driver to a platform one
Date: Sat, 12 Sep 2026 08:48:23 +0200
Message-ID: <20260912065618.166268200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2d9cb20610f75ca48c1cac064aede90196787507 ]

In all cases in which a struct acpi_driver is used for binding a driver
to an ACPI device object, a corresponding platform device is created by
the ACPI core and that device is regarded as a proper representation of
underlying hardware.  Accordingly, a struct platform_driver should be
used by driver code to bind to that device.  There are multiple reasons
why drivers should not bind directly to ACPI device objects [1].

Overall, it is better to bind drivers to platform devices than to their
ACPI companions, so convert the LG Gram ACPI features and hotkeys driver
from an ACPI driver to a platform one.

While this is not expected to alter functionality, it changes sysfs
layout and so it will be visible to user space.

Link: https://lore.kernel.org/all/2396510.ElGaqSPkdT@rafael.j.wysocki/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1868365.VLH7GnMWUR@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 3e91964aa74a ("platform/x86: lg-laptop: Fix LED resource handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 45 +++++++++-----------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 6a45e6270941a..a68c4867e696b 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -748,8 +748,9 @@ static void lg_laptop_remove_address_space_handler(void *data)
 					  &lg_laptop_address_space_handler);
 }
 
-static int acpi_add(struct acpi_device *device)
+static int acpi_probe(struct platform_device *pdev)
 {
+	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 	struct platform_device_info pdev_info = {
 		.fwnode = acpi_fwnode_handle(device),
 		.name = PLATFORM_NAME,
@@ -765,11 +766,11 @@ static int acpi_add(struct acpi_device *device)
 
 	status = acpi_install_address_space_handler(device->handle, LG_ADDRESS_SPACE_ID,
 						    &lg_laptop_address_space_handler,
-						    NULL, &device->dev);
+						    NULL, &pdev->dev);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	ret = devm_add_action_or_reset(&device->dev, lg_laptop_remove_address_space_handler,
+	ret = devm_add_action_or_reset(&pdev->dev, lg_laptop_remove_address_space_handler,
 				       device);
 	if (ret < 0)
 		return ret;
@@ -854,7 +855,7 @@ static int acpi_add(struct acpi_device *device)
 	return ret;
 }
 
-static void acpi_remove(struct acpi_device *device)
+static void acpi_remove(struct platform_device *pdev)
 {
 	sysfs_remove_group(&pf_device->dev.kobj, &dev_attribute_group);
 
@@ -874,33 +875,13 @@ static const struct acpi_device_id device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, device_ids);
 
-static struct acpi_driver acpi_driver = {
-	.name = "LG Gram Laptop Support",
-	.class = "lg-laptop",
-	.ids = device_ids,
-	.ops = {
-		.add = acpi_add,
-		.remove = acpi_remove,
-		},
+static struct platform_driver acpi_driver = {
+	.probe = acpi_probe,
+	.remove = acpi_remove,
+	.driver = {
+		.name = "LG Gram Laptop Support",
+		.acpi_match_table = device_ids,
+	},
 };
 
-static int __init acpi_init(void)
-{
-	int result;
-
-	result = acpi_bus_register_driver(&acpi_driver);
-	if (result < 0) {
-		pr_debug("Error registering driver\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void __exit acpi_exit(void)
-{
-	acpi_bus_unregister_driver(&acpi_driver);
-}
-
-module_init(acpi_init);
-module_exit(acpi_exit);
+module_platform_driver(acpi_driver);
-- 
2.53.0



