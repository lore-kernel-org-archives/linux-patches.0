Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059551;
	b=WshE1KghHJaLcfH4cy/nOUn9weqqO8oEarkIulT3gCTN65EA1b2CN7lVrkPKvEnCxzrT
	 MLZmY/3a373iYOe5SHyo9yBcCZxeuuBBbfB1BA8TMX4veBHLFkqRp3fx0lrTsmdoc2eFU
	 yewBzVrGy9sbLrG3S8pUnmoJ8ytduUtE2Z0GmXQMgb6V5n3rV/stiqRUuUX/n9IcQlN1l
	 NkjUAOYXaSlVi0iX/05qr6guK5XChJPNuLAG694/GchJ/upbIfiGUaUMpLJZ3DEkrqix9
	 8De4zHuLpxfdBTwAaqQp71l9/FSFREqJUhF+4vBgGRndgvB8nKmzpdxTQ+7T5PB9nig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4I6rlYRnoa+5rLCz7pjGu7JmSxKweb3E24HYaT5z7Dg=;
	b=gF0nAlXIBmjtLUuUPt/+9yn7YIBebCbaeFJGdmfHg/2ydEET9O/UGZj1v84hddunWG22
	 9K4jBpKv5EID8BpqPZZ2d+yVjLtp7dmCB8URP/0MLbjU0x+3p/ZjliVQz+igF1xFLZw0O
	 RYRqhBCLJqOFDC0XZqQTbYlQV+y9ncmmmnaffupMrR5DpfyOr20CC4ZbrmzG/M8xjlAxB
	 fwsIfWcw5Tqi0tZ0wfwFeku/K9Wk7O0d0mTw4gcGnVh3TD2CeLsVtDky4tljC4zXNTgNi
	 DMJbOFTjpV7NP9kakofdIRrBKernZ7exeG5cMq8LQnQ/DQfQMFRsABuzuQiCkeq4iTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOdKVZJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AB3606A320;
	Thu, 19 Nov 2026 03:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOdKVZJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4180E1F000C4;
	Thu, 19 Nov 2026 03:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059550;
	bh=4I6rlYRnoa+5rLCz7pjGu7JmSxKweb3E24HYaT5z7Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOdKVZJnpmWj6drsNj3Onso4Zy+11o+IOMbdeTZ7QSuNvWYBvOfQgN/RND/zvkMNy
	 gtZ4NtAyhi/ndpEaCS6DR/eOPJ6z8+pr/8hLNM05CN+fu6SIj/iq2D6qDB1pUhI/CU
	 sWUxdCqygyyelTQ2Q+rVFlY2nBx3bx114xBfCAoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Lopez <jorge.lopez2@hp.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0845/1848] platform/x86: Move existing HP drivers to a new hp subdir
Date: Wed, 18 Nov 2026 15:48:03 +0100
Message-ID: <20261118145951.984010473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit 6e9b8992b122cb12688bd259fc99e67d1be234eb ]

The purpose of this patch is to provide a central location where all
HP related drivers are found. HP drivers will recide under
drivers/platform/x86/hp directory.

Introduce changes to Kconfig file to list all HP driver under "HP X86
Platform Specific Device Drivers" menu option. Additional changes
include update MAINTAINERS file to indicate hp related drivers new
path.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/20221020201033.12790-2-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

HP related drivers are found. HP drivers will reside in the new
subdirectory.

Introduce changes to Kconfig file to list all HP driver under "HP X86
Platform Specific Device Drivers" menu option. Additional changes
include update MAINTAINERS file to indicate hp related drivers new
path.

Keep the existing HP WMI configuration requirements: platform profile
and hardware monitoring support are not present in this driver.

Include the missing-object cleanup branch and invalid-object diagnostic
from the later query implementation so the subsequent buffer bounds
check applies without pulling in the unrelated buffer allocation changes.

Stable-dep-of: 6dea092b261f ("platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                |  4 +-
 drivers/platform/x86/Kconfig               | 41 +--------------
 drivers/platform/x86/Makefile              |  4 +-
 drivers/platform/x86/hp/Kconfig            | 61 ++++++++++++++++++++++
 drivers/platform/x86/hp/Makefile           | 10 ++++
 drivers/platform/x86/{ => hp}/hp-wmi.c     |  7 ++-
 drivers/platform/x86/{ => hp}/hp_accel.c   |  2 +-
 drivers/platform/x86/{ => hp}/tc1100-wmi.c |  0
 8 files changed, 81 insertions(+), 48 deletions(-)
 create mode 100644 drivers/platform/x86/hp/Kconfig
 create mode 100644 drivers/platform/x86/hp/Makefile
 rename drivers/platform/x86/{ => hp}/hp-wmi.c (99%)
 rename drivers/platform/x86/{ => hp}/hp_accel.c (99%)
 rename drivers/platform/x86/{ => hp}/tc1100-wmi.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index beaa5f6294bd2..81bab641d84f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8028,7 +8028,7 @@ F:	drivers/net/wireless/intersil/hostap/
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
 L:	platform-driver-x86@vger.kernel.org
 S:	Orphan
-F:	drivers/platform/x86/tc1100-wmi.c
+F:	drivers/platform/x86/hp/tc1100-wmi.c
 
 HPET:	High Precision Event Timers driver
 M:	Clemens Ladisch <clemens@ladisch.de>
@@ -10159,7 +10159,7 @@ M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
 F:	Documentation/misc-devices/lis3lv02d.rst
 F:	drivers/misc/lis3lv02d/
-F:	drivers/platform/x86/hp_accel.c
+F:	drivers/platform/x86/hp/hp_accel.c
 
 LIST KUNIT TEST
 M:	David Gow <davidgow@google.com>
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index b7bbe97b727eb..7555bb0eb6a0f 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -511,24 +511,7 @@ config GPD_POCKET_FAN
 	  of the CPU temperature. Say Y or M if the kernel may be used on a
 	  GPD pocket.
 
-config HP_ACCEL
-	tristate "HP laptop accelerometer"
-	depends on INPUT && ACPI
-	depends on SERIO_I8042
-	select SENSORS_LIS3LV02D
-	select NEW_LEDS
-	select LEDS_CLASS
-	help
-	  This driver provides support for the "Mobile Data Protection System 3D"
-	  or "3D DriveGuard" feature of HP laptops. On such systems the driver
-	  should load automatically (via ACPI alias).
-
-	  Support for a led indicating disk protection will be provided as
-	  hp::hddprotect. For more information on the feature, refer to
-	  Documentation/misc-devices/lis3lv02d.rst.
-
-	  To compile this driver as a module, choose M here: the module will
-	  be called hp_accel.
+source "drivers/platform/x86/hp/Kconfig"
 
 config WIRELESS_HOTKEY
 	tristate "Wireless hotkey button"
@@ -542,28 +525,6 @@ config WIRELESS_HOTKEY
 	 To compile this driver as a module, choose M here: the module will
 	 be called wireless-hotkey.
 
-config HP_WMI
-	tristate "HP WMI extras"
-	depends on ACPI_WMI
-	depends on INPUT
-	depends on RFKILL || RFKILL = n
-	select INPUT_SPARSEKMAP
-	help
-	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
-	 to read data from WMI such as docking or ambient light sensor state.
-
-	 To compile this driver as a module, choose M here: the module will
-	 be called hp-wmi.
-
-config TC1100_WMI
-	tristate "HP Compaq TC1100 Tablet WMI Extras"
-	depends on !X86_64
-	depends on ACPI
-	depends on ACPI_WMI
-	help
-	  This is a driver for the WMI extensions (wireless and bluetooth power
-	  control) of the HP Compaq TC1100 tablet.
-
 config IBM_RTL
 	tristate "Device driver to enable PRTL support"
 	depends on PCI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 5779c9a061384..4aa356a431668 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -57,9 +57,7 @@ obj-$(CONFIG_FUJITSU_TABLET)	+= fujitsu-tablet.o
 obj-$(CONFIG_GPD_POCKET_FAN)	+= gpd-pocket-fan.o
 
 # Hewlett Packard
-obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
-obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
-obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
+obj-$(CONFIG_X86_PLATFORM_DRIVERS_HP)	+= hp/
 
 # IBM Thinkpad and Lenovo
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
diff --git a/drivers/platform/x86/hp/Kconfig b/drivers/platform/x86/hp/Kconfig
new file mode 100644
index 0000000000000..5f0f55dbf34bd
--- /dev/null
+++ b/drivers/platform/x86/hp/Kconfig
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# X86 Platform Specific Drivers
+#
+menuconfig X86_PLATFORM_DRIVERS_HP
+	bool "HP X86 Platform Specific Device Drivers"
+	depends on X86_PLATFORM_DEVICES
+	help
+	  Say Y here to get to see options for device drivers for various
+	  HP x86 platforms, including vendor-specific laptop extension drivers.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if X86_PLATFORM_DRIVERS_HP
+
+config HP_ACCEL
+	tristate "HP laptop accelerometer"
+	default m
+	depends on INPUT && ACPI
+	depends on SERIO_I8042
+	select SENSORS_LIS3LV02D
+	select NEW_LEDS
+	select LEDS_CLASS
+	help
+	  This driver provides support for the "Mobile Data Protection System 3D"
+	  or "3D DriveGuard" feature of HP laptops. On such systems the driver
+	  should load automatically (via ACPI alias).
+
+	  Support for a led indicating disk protection will be provided as
+	  hp::hddprotect. For more information on the feature, refer to
+	  Documentation/misc-devices/lis3lv02d.rst.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called hp_accel.
+
+config HP_WMI
+	tristate "HP WMI extras"
+	default m
+	depends on ACPI_WMI
+	depends on INPUT
+	depends on RFKILL || RFKILL = n
+	select INPUT_SPARSEKMAP
+	help
+	  Say Y here if you want to support WMI-based hotkeys on HP laptops and
+	  to read data from WMI such as docking or ambient light sensor state.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called hp-wmi.
+
+config TC1100_WMI
+	tristate "HP Compaq TC1100 Tablet WMI Extras"
+	default m
+	depends on !X86_64
+	depends on ACPI
+	depends on ACPI_WMI
+	help
+	  This is a driver for the WMI extensions (wireless and bluetooth power
+	  control) of the HP Compaq TC1100 tablet.
+
+endif # X86_PLATFORM_DRIVERS_HP
diff --git a/drivers/platform/x86/hp/Makefile b/drivers/platform/x86/hp/Makefile
new file mode 100644
index 0000000000000..db1eed4cd7c7d
--- /dev/null
+++ b/drivers/platform/x86/hp/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for linux/drivers/platform/x86/hp
+# HP x86 Platform-Specific Drivers
+#
+
+# Hewlett Packard
+obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
+obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
+obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
similarity index 99%
rename from drivers/platform/x86/hp-wmi.c
rename to drivers/platform/x86/hp/hp-wmi.c
index 370f74fa4a9ab..140a5f797980d 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -241,10 +241,13 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 
 	obj = output.pointer;
 
-	if (!obj)
-		return -EINVAL;
+	if (!obj) {
+		ret = -EINVAL;
+		goto out_free;
+	}
 
 	if (obj->type != ACPI_TYPE_BUFFER) {
+		pr_warn("query 0x%x returned an invalid object 0x%x\n", query, ret);
 		ret = -EINVAL;
 		goto out_free;
 	}
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp/hp_accel.c
similarity index 99%
rename from drivers/platform/x86/hp_accel.c
rename to drivers/platform/x86/hp/hp_accel.c
index 0dfaa1a43b674..823ea56bf778c 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp/hp_accel.c
@@ -26,7 +26,7 @@
 #include <linux/acpi.h>
 #include <linux/i8042.h>
 #include <linux/serio.h>
-#include "../../misc/lis3lv02d/lis3lv02d.h"
+#include "../../../misc/lis3lv02d/lis3lv02d.h"
 
 #define DRIVER_NAME     "hp_accel"
 #define ACPI_MDPS_CLASS "accelerometer"
diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/hp/tc1100-wmi.c
similarity index 100%
rename from drivers/platform/x86/tc1100-wmi.c
rename to drivers/platform/x86/hp/tc1100-wmi.c
-- 
2.53.0



