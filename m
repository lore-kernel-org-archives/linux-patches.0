Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E067B7D07D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643314; cv=none; b=GA5+oApwWF1pwzCofrXMNbXyXQlIwKwJHy3Wgtjp8KsSy741TeXaac3KltkhqJqYJXWyIaMUn22YoGdysRqgv7Kgglp/0LuptyAZwXAmYcNXR/gBgSLH3/jqgsxamOFC5zmMpFUmGMcR3bMYRK+tV0mjpIPeSrqKapIgYOppC8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643314; c=relaxed/simple;
	bh=Ns4zJOKmhnvJzXIPZiEm4QRM/poJQeF7gAkGh51mMOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIKeUFaVw3SgjR5ubzrp+/Zuy+3yLnAVPTtqyS6oqk17UYAJpU3No2rWhFEeClLXYMdcmltT65FBJlUzRVgKHs0IVz35pWDmf+WrIEnHLqxjCCu+tiMMhV0+xaD4/m4v8trJ5i0xlNLshPokpu+jPt3FKKY3RdyKtpEoaa7bBfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EW2dlc33; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EW2dlc33"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643311; x=1743179311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ns4zJOKmhnvJzXIPZiEm4QRM/poJQeF7gAkGh51mMOI=;
  b=EW2dlc33RdodTf6nJ/8LANGG78VNU8LDxg0yZ7JtPg7TVEOwS0T06hkj
   8ncjL+EFDCZ2/QjzXKaHIu+L33d7LqQhAiOlit6g4DyQFiU9cStIu10U6
   W8sdKfzHb2TYUqZRG2bD3hyEE81ORnIiS7anPZvOwHpI1atLioFjIexve
   OojyoEKVw+x1goxu4ixeSbrWSgG50QCL5FrKkrwiut+2veDsXl+l5AGPV
   ECjn/gINLZTR9KrQmDvL8ntOF/RRrGg943Htxiaun500P7RlcQUiqhmhy
   OYA1hDOoSkc4YItZodxHeRbKCzJpin2fzetyWFontK70U72VsDHgnrkKi
   Q==;
X-CSE-ConnectionGUID: Ud2fcyC+SRWZvRsnJf7U0g==
X-CSE-MsgGUID: p8wmLUFvQVSgswHkVwPleg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294761"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294761"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726067"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 36/74] x86/cpu/vfm: Update drivers/acpi/x86/utils.c
Date: Thu, 28 Mar 2024 09:27:30 -0700
Message-ID: <20240328162820.242778-36-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
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

