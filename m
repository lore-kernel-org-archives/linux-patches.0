Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB79F13C9D9
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245216; cv=none; b=dqR+zYfYLzkS4up97A7KNY/PFnAjH88PX4ejIXhbztZ8NOxXu/jSSoTIfkE1xnrvybNbxspc5iy518v8HHVbsGv9Sd82+nSAAaWft2KEFy/xPwreeXdy3nGnB2/oqz6BKt0CTrM7NZ9APJdMXJ9KZ1noYLO3LCwupGghBUyONPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245216; c=relaxed/simple;
	bh=OekOtMnWgaL3iX/OP7hSuh3keHSFGAGWeh7AoTG5V7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYQrJlhD63GXw/ZMYCPOVSL3TElF/ZGsvfllA5Yd2gzVqlyqRcmuRtJIkuWCvE7x9ExjhCso4w1s+aVY3SJpoog1jmNpcRH5zaXnm+SNBVWA0j9aU7gWj4igmrKHFu3xnSRlgZ3NpgUGETVeDSsMYcJ3FhC9RZkF7ywGB4atTeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=koTJHwFy; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="koTJHwFy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245214; x=1747781214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OekOtMnWgaL3iX/OP7hSuh3keHSFGAGWeh7AoTG5V7c=;
  b=koTJHwFyzOIMXzmQz+GqxQb5+2KHq9sSUokuTRkjF5QuEXDhqgdJhDB6
   /A4wcflky45pOtqjd0msg7UpQ+aoKw6f67SBk2KDzgXnz76dgobeMZuoL
   InndKaG3y4HbCT8gtOVt0EgeZlqnUBV+oJUvExCCB99yC7gNhVu4xjkZI
   aJ0mdl3kqsTQD830Ya5sr3SNie76N0rKmn0/Vh0DQeGecGXLfripr5sHP
   hyIOUidAlAXdgG3TE1p4ko+bJAFyIGRnWyyb3bgrFyaKI899g/kVrJTEV
   D1fNgQYWGzCRdYKgQXD4eSeI3NoXKllOhsP8ypp0DMZ/IhoPR55zVgoSJ
   A==;
X-CSE-ConnectionGUID: qJvdC2lWRQK3YF3bZFEgwg==
X-CSE-MsgGUID: f3GezpBiTMiYL2lVOlynZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199958"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199958"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: y62cgbd4ROO5Q9XeGG+TbQ==
X-CSE-MsgGUID: 4wx58AOFQH6IDm0cvKcTBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593509"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 41/49] ACPI: x86: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:12 -0700
Message-ID: <20240520224620.9480-42-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
 drivers/acpi/x86/utils.c | 44 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 7dca73417e2b..e628d969d613 100644
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
@@ -104,7 +104,7 @@ static const struct override_status_id override_status_ids[] = {
 	 * The Dell XPS 15 9550 has a SMO8110 accelerometer /
 	 * HDD freefall sensor which is wrongly marked as not present.
 	 */
-	PRESENT_ENTRY_HID("SMO8810", "1", SKYLAKE, {
+	PRESENT_ENTRY_HID("SMO8810", "1", INTEL_SKYLAKE, {
 		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 		DMI_MATCH(DMI_PRODUCT_NAME, "XPS 15 9550"),
 	      }),
@@ -121,19 +121,19 @@ static const struct override_status_id override_status_ids[] = {
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
@@ -146,7 +146,7 @@ static const struct override_status_id override_status_ids[] = {
 	 * method sets a GPIO causing the PCI wifi card to turn off.
 	 * See above remark about uniqueness of the DMI match.
 	 */
-	NOT_PRESENT_ENTRY_PATH("\\_SB_.PCI0.SDHB.BRC1", ATOM_AIRMONT, {
+	NOT_PRESENT_ENTRY_PATH("\\_SB_.PCI0.SDHB.BRC1", INTEL_ATOM_AIRMONT, {
 		DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
 		DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
 		DMI_EXACT_MATCH(DMI_BOARD_SERIAL, "Default string"),
@@ -158,7 +158,7 @@ static const struct override_status_id override_status_ids[] = {
 	 * as both ACCL0001 and MAGN0001. As we can only ever register an
 	 * i2c client for one of them, ignore MAGN0001.
 	 */
-	NOT_PRESENT_ENTRY_HID("MAGN0001", "1", ATOM_SILVERMONT, {
+	NOT_PRESENT_ENTRY_HID("MAGN0001", "1", INTEL_ATOM_SILVERMONT, {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		DMI_MATCH(DMI_PRODUCT_FAMILY, "YOGATablet2"),
 	      }),
-- 
2.45.0

