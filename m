Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774167;
	b=2tiWTliApSItGklJb0rW4FGD3gexDC8nerYpz8//qF5q/AoYhS6flXHPkP685dBItk17
	 IycNCqH4VfgkC5z1us6qqRAuD/vNKp6nasRaCE26A9L5hpymtDF7K2SGfr/rxDceBYOHh
	 dhQ5KlYVL+IpC/tfOg3aIHqeiXVybA3buv3bblsHdDRRB4bCsNKL91iWfRwVNaChp8qYr
	 GmlF/cDZ6IYlS8PKkB0o1Lu4BE5i9QHV1yU5REZY9bhnMTSUCrFeCg1cVLLiH2ujlbZsg
	 jrwe5++bdPsm/Xfea+l4TtQ/liY7f0ELZy4hRbKJ9+wJBKWNoKeQGwcrmwbxY6osICg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/Jyvpof+0YuSYYRBcWFJAQtq4d9yKkT/LJoSHXLCrY=;
	b=XGnt++Ne5+nERT5D0B5BxSrL6XKCEQvZDk+J454wWKOGEQJf59hihe/YtPeWs+YZO/Q3
	 9xM05EY1XvAejCxYi3stEUsPrxpS2+yXT4jF94Tlfdht9n7M6Lxn0f+4w4CohbnyecAz8
	 x5jLl++t/0iHMt/3HVEAGseVtuBlAj4nHMRynXrjoBkhCj0kSY4PkcmgGgJl3fMJ96sP2
	 qcKIXRpyGfgln4VjCPaJ+39r77fix9UHXa0T84TYrRySMAqEjAmchUZu2ZbugT29ragFA
	 Rz+t0z/shMVeoVoxB0Nw/xrPa+yWPB1ZTrfnwFdYbsHtTZzwRqILyFZHpsxRkU0YxAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IhD8uca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D835F606A325;
	Fri, 23 Oct 2026 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IhD8uca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260F51F01825;
	Fri, 23 Oct 2026 16:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774166;
	bh=0/Jyvpof+0YuSYYRBcWFJAQtq4d9yKkT/LJoSHXLCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IhD8uca9dOdY5I0K2HhzobVah5pu8ppEYR3TMOQ9Vc1XNDzifyrBZsUX6zIhVikb
	 FcLDAiolUYrAhM7q6QhqM1Pfz2DBuglZdKB9VINIeEYZKVK06AJWEkcTdN1VKpKbUE
	 YupbpOzrZMIaqAV8BkutEEfyV0NZbmNGhjUB6Tzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/193] ACPI: tiny-power-button: Convert the driver to a platform one
Date: Fri, 23 Oct 2026 18:37:01 +0200
Message-ID: <20261023163717.615931321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit f4203ec64e1155c07c5d95bddc62201af8598c67 ]

While binding drivers directly to struct acpi_device objects allows
basic functionality to be provided, at least in the majority of cases,
there are some problems with it, related to general consistency, sysfs
layout, power management operation ordering, and code cleanliness.

Overall, it is better to bind drivers to platform devices than to their
ACPI companions, so convert the ACPI tiny-power-button driver to a
platform one.

While this is not expected to alter functionality, it changes sysfs
layout and so it will be visible to user space.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ rjw: White space fixup ]
Link: https://patch.msgid.link/5629403.Sb9uPGUboI@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/tiny-power-button.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/tiny-power-button.c b/drivers/acpi/tiny-power-button.c
index 6353be6fec698..531e65b01bcbe 100644
--- a/drivers/acpi/tiny-power-button.c
+++ b/drivers/acpi/tiny-power-button.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/sched/signal.h>
-#include <linux/acpi.h>
 #include <acpi/button.h>
 
 MODULE_AUTHOR("Josh Triplett");
@@ -35,8 +36,9 @@ static u32 acpi_tiny_power_button_event(void *not_used)
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-static int acpi_tiny_power_button_add(struct acpi_device *device)
+static int acpi_tiny_power_button_probe(struct platform_device *pdev)
 {
+	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 	acpi_status status;
 
 	if (device->device_type == ACPI_BUS_TYPE_POWER_BUTTON) {
@@ -55,8 +57,10 @@ static int acpi_tiny_power_button_add(struct acpi_device *device)
 	return 0;
 }
 
-static void acpi_tiny_power_button_remove(struct acpi_device *device)
+static void acpi_tiny_power_button_remove(struct platform_device *pdev)
 {
+	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+
 	if (device->device_type == ACPI_BUS_TYPE_POWER_BUTTON) {
 		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
 						acpi_tiny_power_button_event);
@@ -67,14 +71,13 @@ static void acpi_tiny_power_button_remove(struct acpi_device *device)
 	acpi_os_wait_events_complete();
 }
 
-static struct acpi_driver acpi_tiny_power_button_driver = {
-	.name = "tiny-power-button",
-	.class = "tiny-power-button",
-	.ids = tiny_power_button_device_ids,
-	.ops = {
-		.add = acpi_tiny_power_button_add,
-		.remove = acpi_tiny_power_button_remove,
+static struct platform_driver acpi_tiny_power_button_driver = {
+	.probe = acpi_tiny_power_button_probe,
+	.remove = acpi_tiny_power_button_remove,
+	.driver = {
+		.name = "acpi-tiny-power-button",
+		.acpi_match_table = tiny_power_button_device_ids,
 	},
 };
 
-module_acpi_driver(acpi_tiny_power_button_driver);
+module_platform_driver(acpi_tiny_power_button_driver);
-- 
2.53.0



