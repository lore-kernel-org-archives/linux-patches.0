Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA21C68A9
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495913; cv=none; b=LTe1XUZlcyM8q39Ysl8GFHZUMXzGF30H/YfAjI6NxzrjWo4sj+BIBkPQGTS9/FfFgGtsM58jYNDxRKEPGJ+ZpFdAfNDMXNcZ+LgmiJMITxqwc55VGcZWTAx3ddB4gr6CKQtllZqUZrluS5SBbUl+ICc9W6ect47yOfuShNzxJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495913; c=relaxed/simple;
	bh=khsp430wCZF85FG8u7FCOLvv9K3w859TzG0TQy2mIZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwnGvbSK+736fmBiuqhaGka+lKkloE/1zMd5+XnOkpAZtUP+riU+ZP38bVIaTvoMUxpUTKLqZAG4wbn6fbkW4bmTRewBFg/Wm1lkIyL37PoKtu9utNnbN4g2xS1/ZEoS6w1VWdic6s2e92Ttc3YqSzCXhqshZtGc4DjQ50LqEYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+8q0LY2; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+8q0LY2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495911; x=1746031911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=khsp430wCZF85FG8u7FCOLvv9K3w859TzG0TQy2mIZU=;
  b=f+8q0LY2l0ZWPty3t1lu9i3TxJWCNVUsAGgXxoqv1XGfHDjoxLUdF1rf
   +VYvh4iWazpru15pgmBJpxNQJIXpLJHyEOGQEtH8ut1PK6uYMIOph2Nkt
   xWFY2ZPd5WsUqYjEvECM7PNfb4CIZqj2eVS/9vYrfAa42UknRjlvdjE02
   b7p/mk9yEHqUIciV/txK4nnqTeUX09/0On4dEsL6TNJHos6LXndIEKGx8
   wM3VwqaooD2YHUPy+10YSr9UUkrTjddYTA8IIPvPq5T9VX4VxlongZDoV
   cRGR4o82a7qVoi/T6reHe6J5V7z0R7kESw21zZ2Vkt54QmEKQY+s6sWu5
   w==;
X-CSE-ConnectionGUID: naS5g91XSga1rElgoPNGEw==
X-CSE-MsgGUID: Ry3//0ImSUK1nnuhmB+wDw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075775"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075775"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: P4HwCxYzRRapEAtbo956Bg==
X-CSE-MsgGUID: Vcd2XcoyTGCYYTYyx5xRuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515528"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 45/47] ACPI: x86: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:58 -0700
Message-ID: <20240430165100.73491-45-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/x86/utils.c | 42 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 90c3d2eab9e9..2d8203f7bd98 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -45,37 +45,37 @@ struct override_status_id {
 	unsigned long long status;
 };
 
-#define ENTRY(status, hid, uid, path, cpu_model, dmi...) {		\
+#define ENTRY(status, hid, uid, path, cpu_vfm, dmi...) {		\
 	{ { hid, }, {} },						\
-	{ X86_MATCH_INTEL_FAM6_MODEL(cpu_model, NULL), {} },		\
+	{ X86_MATCH_VFM(cpu_vfm, NULL), {} },				\
 	{ { .matches = dmi }, {} },					\
 	uid,								\
 	path,								\
 	status,								\
 }
 
-#define PRESENT_ENTRY_HID(hid, uid, cpu_model, dmi...) \
-	ENTRY(ACPI_STA_DEFAULT, hid, uid, NULL, cpu_model, dmi)
+#define PRESENT_ENTRY_HID(hid, uid, cpu_vfm, dmi...) \
+	ENTRY(ACPI_STA_DEFAULT, hid, uid, NULL, cpu_vfm, dmi)
 
-#define NOT_PRESENT_ENTRY_HID(hid, uid, cpu_model, dmi...) \
-	ENTRY(0, hid, uid, NULL, cpu_model, dmi)
+#define NOT_PRESENT_ENTRY_HID(hid, uid, cpu_vfm, dmi...) \
+	ENTRY(0, hid, uid, NULL, cpu_vfm, dmi)
 
-#define PRESENT_ENTRY_PATH(path, cpu_model, dmi...) \
-	ENTRY(ACPI_STA_DEFAULT, "", NULL, path, cpu_model, dmi)
+#define PRESENT_ENTRY_PATH(path, cpu_vfm, dmi...) \
+	ENTRY(ACPI_STA_DEFAULT, "", NULL, path, cpu_vfm, dmi)
 
-#define NOT_PRESENT_ENTRY_PATH(path, cpu_model, dmi...) \
-	ENTRY(0, "", NULL, path, cpu_model, dmi)
+#define NOT_PRESENT_ENTRY_PATH(path, cpu_vfm, dmi...) \
+	ENTRY(0, "", NULL, path, cpu_vfm, dmi)
 
 static const struct override_status_id override_status_ids[] = {
 	/*
 	 * Bay / Cherry Trail PWM directly poked by GPU driver in win10,
 	 * but Linux uses a separate PWM driver, harmless if not used.
 	 */
-	PRESENT_ENTRY_HID("80860F09", "1", ATOM_SILVERMONT, {}),
-	PRESENT_ENTRY_HID("80862288", "1", ATOM_AIRMONT, {}),
+	PRESENT_ENTRY_HID("80860F09", "1", INTEL_ATOM_SILVERMONT, {}),
+	PRESENT_ENTRY_HID("80862288", "1", INTEL_ATOM_AIRMONT, {}),
 
 	/* The Xiaomi Mi Pad 2 uses PWM2 for touchkeys backlight control */
-	PRESENT_ENTRY_HID("80862289", "2", ATOM_AIRMONT, {
+	PRESENT_ENTRY_HID("80862289", "2", INTEL_ATOM_AIRMONT, {
 		DMI_MATCH(DMI_SYS_VENDOR, "Xiaomi Inc"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Mipad2"),
 	      }),
@@ -84,18 +84,18 @@ static const struct override_status_id override_status_ids[] = {
 	 * The INT0002 device is necessary to clear wakeup interrupt sources
 	 * on Cherry Trail devices, without it we get nobody cared IRQ msgs.
 	 */
-	PRESENT_ENTRY_HID("INT0002", "1", ATOM_AIRMONT, {}),
+	PRESENT_ENTRY_HID("INT0002", "1", INTEL_ATOM_AIRMONT, {}),
 	/*
 	 * On the Dell Venue 11 Pro 7130 and 7139, the DSDT hides
 	 * the touchscreen ACPI device until a certain time
 	 * after _SB.PCI0.GFX0.LCD.LCD1._ON gets called has passed
 	 * *and* _STA has been called at least 3 times since.
 	 */
-	PRESENT_ENTRY_HID("SYNA7500", "1", HASWELL_L, {
+	PRESENT_ENTRY_HID("SYNA7500", "1", INTEL_HASWELL_L, {
 		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Venue 11 Pro 7130"),
 	      }),
-	PRESENT_ENTRY_HID("SYNA7500", "1", HASWELL_L, {
+	PRESENT_ENTRY_HID("SYNA7500", "1", INTEL_HASWELL_L, {
 		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Venue 11 Pro 7139"),
 	      }),
@@ -112,19 +112,19 @@ static const struct override_status_id override_status_ids[] = {
 	 * was copy-pasted from the GPD win, so it has a disabled KIOX000A
 	 * node which we should not enable, thus we also check the BIOS date.
 	 */
-	PRESENT_ENTRY_HID("KIOX000A", "1", ATOM_AIRMONT, {
+	PRESENT_ENTRY_HID("KIOX000A", "1", INTEL_ATOM_AIRMONT, {
 		DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
 		DMI_MATCH(DMI_BOARD_NAME, "Default string"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
 		DMI_MATCH(DMI_BIOS_DATE, "02/21/2017")
 	      }),
-	PRESENT_ENTRY_HID("KIOX000A", "1", ATOM_AIRMONT, {
+	PRESENT_ENTRY_HID("KIOX000A", "1", INTEL_ATOM_AIRMONT, {
 		DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
 		DMI_MATCH(DMI_BOARD_NAME, "Default string"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
 		DMI_MATCH(DMI_BIOS_DATE, "03/20/2017")
 	      }),
-	PRESENT_ENTRY_HID("KIOX000A", "1", ATOM_AIRMONT, {
+	PRESENT_ENTRY_HID("KIOX000A", "1", INTEL_ATOM_AIRMONT, {
 		DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
 		DMI_MATCH(DMI_BOARD_NAME, "Default string"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
@@ -137,7 +137,7 @@ static const struct override_status_id override_status_ids[] = {
 	 * method sets a GPIO causing the PCI wifi card to turn off.
 	 * See above remark about uniqueness of the DMI match.
 	 */
-	NOT_PRESENT_ENTRY_PATH("\\_SB_.PCI0.SDHB.BRC1", ATOM_AIRMONT, {
+	NOT_PRESENT_ENTRY_PATH("\\_SB_.PCI0.SDHB.BRC1", INTEL_ATOM_AIRMONT, {
 		DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
 		DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
 		DMI_EXACT_MATCH(DMI_BOARD_SERIAL, "Default string"),
@@ -149,7 +149,7 @@ static const struct override_status_id override_status_ids[] = {
 	 * as both ACCL0001 and MAGN0001. As we can only ever register an
 	 * i2c client for one of them, ignore MAGN0001.
 	 */
-	NOT_PRESENT_ENTRY_HID("MAGN0001", "1", ATOM_SILVERMONT, {
+	NOT_PRESENT_ENTRY_HID("MAGN0001", "1", INTEL_ATOM_SILVERMONT, {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		DMI_MATCH(DMI_PRODUCT_FAMILY, "YOGATablet2"),
 	      }),
-- 
2.44.0

