Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB13332EBD;
	Wed, 20 May 2026 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297408; cv=none; b=KDmpkb3qOp5ZPKT7uhqE7FBC1x4MN5oa+Vq36xucpL7JsLI7atzk3yBtlm+JzbMWWFybNQKFwbxMYTHkbajBjJloV+/nyMzE2HXZooeZ/jvFnZPyM/eS+039Jk+j7nJABDuRuepiQl4OQVsqLWmK5h55yGDL+3M7Bb841PfOGHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297408; c=relaxed/simple;
	bh=NgM3iB9rZtIZhO7aN4N8vQS/8kjPJqwfIi3oSEpI8J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jpq/PVJUh6ah4D+spdi3BrE/Cm5w5/7wocW4/UXaqKnhCiROOh/W3EgChvfZ449lBEhboUev47N6KKQPSh1kRWrnWsWog29auiIgWjncMr31G46uatVesC2AtLpXfQd373egb+a0MEeVdNK3ef0X+9UudKywX0zK9MZS4UvNxYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKFzaFJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKFzaFJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25791F000E9;
	Wed, 20 May 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297407;
	bh=0e53QNlgg73VVJ3bx/yqum8PqM6piNUmKf3+zCwh3Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKFzaFJMoX3T/PXjo+wabY/5vTSyv6vZURXCIxVO6fkq/M0wsK1Bm7uWjVAE9AS9R
	 FkC1T/H4U2y/SaBlH1B9U6iLq656rz0IBcpgL9kxyU+XMOX1aE8xjy/rhFfiBuxsxp
	 SBuaxoTG0k+788QtSF573uWM1CGCYnEcgugAwM0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/957] ACPI: x86: cmos_rtc: Clean up address space handler driver
Date: Wed, 20 May 2026 18:08:23 +0200
Message-ID: <20260520162134.998563159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit ba0b236736dde4059bdcb8e99beaa50d6e5b6e7e ]

Make multiple changes that do not alter functionality to the CMOS RTC
ACPI address space handler driver, including the following:

 - Drop the unused .detach() callback from cmos_rtc_handler.

 - Rename acpi_cmos_rtc_attach_handler() to acpi_cmos_rtc_attach().

 - Rearrange acpi_cmos_rtc_space_handler() to reduce the number of
   redundant checks and make white space follow the coding style.

 - Adjust an error message in acpi_install_cmos_rtc_space_handler()
   and make the white space follow the coding style.

 - Rearrange acpi_remove_cmos_rtc_space_handler() and adjust an error
   message in it.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5094429.31r3eYUQgx@rafael.j.wysocki
Stable-dep-of: 6cee29ad9d7e ("ACPI: x86: cmos_rtc: Improve coordination with ACPI TAD driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/cmos_rtc.c | 61 +++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/x86/cmos_rtc.c b/drivers/acpi/x86/cmos_rtc.c
index 51643ff6fe5fc..977234da9fc11 100644
--- a/drivers/acpi/x86/cmos_rtc.c
+++ b/drivers/acpi/x86/cmos_rtc.c
@@ -24,31 +24,35 @@ static const struct acpi_device_id acpi_cmos_rtc_ids[] = {
 	{}
 };
 
-static acpi_status
-acpi_cmos_rtc_space_handler(u32 function, acpi_physical_address address,
-		      u32 bits, u64 *value64,
-		      void *handler_context, void *region_context)
+static acpi_status acpi_cmos_rtc_space_handler(u32 function,
+					       acpi_physical_address address,
+					       u32 bits, u64 *value64,
+					       void *handler_context,
+					       void *region_context)
 {
-	int i;
+	unsigned int i, bytes = DIV_ROUND_UP(bits, 8);
 	u8 *value = (u8 *)value64;
 
 	if (address > 0xff || !value64)
 		return AE_BAD_PARAMETER;
 
-	if (function != ACPI_WRITE && function != ACPI_READ)
-		return AE_BAD_PARAMETER;
+	guard(spinlock_irq)(&rtc_lock);
+
+	if (function == ACPI_WRITE) {
+		for (i = 0; i < bytes; i++, address++, value++)
+			CMOS_WRITE(*value, address);
 
-	spin_lock_irq(&rtc_lock);
+		return AE_OK;
+	}
 
-	for (i = 0; i < DIV_ROUND_UP(bits, 8); ++i, ++address, ++value)
-		if (function == ACPI_READ)
+	if (function == ACPI_READ) {
+		for (i = 0; i < bytes; i++, address++, value++)
 			*value = CMOS_READ(address);
-		else
-			CMOS_WRITE(*value, address);
 
-	spin_unlock_irq(&rtc_lock);
+		return AE_OK;
+	}
 
-	return AE_OK;
+	return AE_BAD_PARAMETER;
 }
 
 int acpi_install_cmos_rtc_space_handler(acpi_handle handle)
@@ -56,11 +60,11 @@ int acpi_install_cmos_rtc_space_handler(acpi_handle handle)
 	acpi_status status;
 
 	status = acpi_install_address_space_handler(handle,
-			ACPI_ADR_SPACE_CMOS,
-			&acpi_cmos_rtc_space_handler,
-			NULL, NULL);
+						    ACPI_ADR_SPACE_CMOS,
+						    acpi_cmos_rtc_space_handler,
+						    NULL, NULL);
 	if (ACPI_FAILURE(status)) {
-		pr_err("Error installing CMOS-RTC region handler\n");
+		pr_err("Failed to install CMOS-RTC address space handler\n");
 		return -ENODEV;
 	}
 
@@ -70,26 +74,25 @@ EXPORT_SYMBOL_GPL(acpi_install_cmos_rtc_space_handler);
 
 void acpi_remove_cmos_rtc_space_handler(acpi_handle handle)
 {
-	if (ACPI_FAILURE(acpi_remove_address_space_handler(handle,
-			ACPI_ADR_SPACE_CMOS, &acpi_cmos_rtc_space_handler)))
-		pr_err("Error removing CMOS-RTC region handler\n");
+	acpi_status status;
+
+	status = acpi_remove_address_space_handler(handle,
+						   ACPI_ADR_SPACE_CMOS,
+						   acpi_cmos_rtc_space_handler);
+	if (ACPI_FAILURE(status))
+		pr_err("Failed to remove CMOS-RTC address space handler\n");
 }
 EXPORT_SYMBOL_GPL(acpi_remove_cmos_rtc_space_handler);
 
-static int acpi_cmos_rtc_attach_handler(struct acpi_device *adev, const struct acpi_device_id *id)
+static int acpi_cmos_rtc_attach(struct acpi_device *adev,
+				const struct acpi_device_id *id)
 {
 	return acpi_install_cmos_rtc_space_handler(adev->handle);
 }
 
-static void acpi_cmos_rtc_detach_handler(struct acpi_device *adev)
-{
-	acpi_remove_cmos_rtc_space_handler(adev->handle);
-}
-
 static struct acpi_scan_handler cmos_rtc_handler = {
 	.ids = acpi_cmos_rtc_ids,
-	.attach = acpi_cmos_rtc_attach_handler,
-	.detach = acpi_cmos_rtc_detach_handler,
+	.attach = acpi_cmos_rtc_attach,
 };
 
 void __init acpi_cmos_rtc_init(void)
-- 
2.53.0



