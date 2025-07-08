Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494552DD5EF;
	Tue,  8 Jul 2025 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992323; cv=none; b=OmzK/hf8EVyP3m98iGvoSMjvNogudrZha49rodtx20rMdPOcqLB1TRSjKZMzikXbQEUp9Qxb+n2NodU3jOOANKCtQhdYeOjiNxFsALwS960to3UtnndGB3dRWua8+YLNxIlqZ+15pFCDCK8uYslPVCgHru7cyN3jX5XWjdA0zQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992323; c=relaxed/simple;
	bh=XDPYUVVVDhLrXFMGwzNBWwc23qX0yu2zEo0qsGumxxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSiT8WNGsxABjE3sYolBbsLQOJenZWsx+VSYs9gWhXCRG91ISgbprctxqyknKLSv1+gYGNMhWEiLeC9gmrHBDp4VHLQu8/TtQNCVt8a6d4/Cz1znBM7sQs3axQTfXj01x6UFGPT8hIQk0fASVGh/efdhp16Xi57+kI8K6dRxizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZmmbFvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZmmbFvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82304C4CEED;
	Tue,  8 Jul 2025 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992322;
	bh=XDPYUVVVDhLrXFMGwzNBWwc23qX0yu2zEo0qsGumxxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZmmbFvtowW84UdSOXiFBOXRrSBtTRpsS4b1joWzqQOS6dgEJqzaUG9K8jq66LaW4
	 +kjHxQa45EOZbdKd8iwpgUCGvQyo09gCOhxJ2nB5m8wW+kDH/4gAlihHE3EcmDkYFb
	 dfZROIRWHl4EZTyVP955MQGTx77pu4apQm9V/yp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Armin Wolf <W_Armin@gmx.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/132] platform/x86: firmware_attributes_class: Simplify API
Date: Tue,  8 Jul 2025 18:22:36 +0200
Message-ID: <20250708162231.990694143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d03cfde56f5cf9ec50b4cf099a42bf056fc80ddd ]

The module core already guarantees that a module can only be unloaded
after all other modules using its symbols have been unloaded.
As it's already the responsibility of the drivers using
firmware_attributes_class to clean up their devices before unloading,
the lifetime of the firmware_attributes_class can be bound to the
lifetime of the module.
This enables the direct usage of firmware_attributes_class from the
drivers, without having to go through the lifecycle functions,
leading to simplifications for both the subsystem and its users.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250104-firmware-attributes-simplify-v1-2-949f9709e405@weissschuh.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 5ff1fbb30597 ("platform/x86: think-lmi: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/firmware_attributes_class.c  | 40 +++++++------------
 .../platform/x86/firmware_attributes_class.h  |  1 +
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/platform/x86/firmware_attributes_class.c b/drivers/platform/x86/firmware_attributes_class.c
index 4801f9f44aaa6..e214efc97311e 100644
--- a/drivers/platform/x86/firmware_attributes_class.c
+++ b/drivers/platform/x86/firmware_attributes_class.c
@@ -2,47 +2,35 @@
 
 /* Firmware attributes class helper module */
 
-#include <linux/mutex.h>
 #include <linux/module.h>
 #include "firmware_attributes_class.h"
 
-static DEFINE_MUTEX(fw_attr_lock);
-static int fw_attr_inuse;
-
-static const struct class firmware_attributes_class = {
+const struct class firmware_attributes_class = {
 	.name = "firmware-attributes",
 };
+EXPORT_SYMBOL_GPL(firmware_attributes_class);
+
+static __init int fw_attributes_class_init(void)
+{
+	return class_register(&firmware_attributes_class);
+}
+module_init(fw_attributes_class_init);
+
+static __exit void fw_attributes_class_exit(void)
+{
+	class_unregister(&firmware_attributes_class);
+}
+module_exit(fw_attributes_class_exit);
 
 int fw_attributes_class_get(const struct class **fw_attr_class)
 {
-	int err;
-
-	mutex_lock(&fw_attr_lock);
-	if (!fw_attr_inuse) { /*first time class is being used*/
-		err = class_register(&firmware_attributes_class);
-		if (err) {
-			mutex_unlock(&fw_attr_lock);
-			return err;
-		}
-	}
-	fw_attr_inuse++;
 	*fw_attr_class = &firmware_attributes_class;
-	mutex_unlock(&fw_attr_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fw_attributes_class_get);
 
 int fw_attributes_class_put(void)
 {
-	mutex_lock(&fw_attr_lock);
-	if (!fw_attr_inuse) {
-		mutex_unlock(&fw_attr_lock);
-		return -EINVAL;
-	}
-	fw_attr_inuse--;
-	if (!fw_attr_inuse) /* No more consumers */
-		class_unregister(&firmware_attributes_class);
-	mutex_unlock(&fw_attr_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fw_attributes_class_put);
diff --git a/drivers/platform/x86/firmware_attributes_class.h b/drivers/platform/x86/firmware_attributes_class.h
index 8e0f47cfdf92e..ef6c3764a8349 100644
--- a/drivers/platform/x86/firmware_attributes_class.h
+++ b/drivers/platform/x86/firmware_attributes_class.h
@@ -7,6 +7,7 @@
 
 #include <linux/device/class.h>
 
+extern const struct class firmware_attributes_class;
 int fw_attributes_class_get(const struct class **fw_attr_class);
 int fw_attributes_class_put(void);
 
-- 
2.39.5



