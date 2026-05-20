Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505ED3F4DDB;
	Wed, 20 May 2026 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300014; cv=none; b=oz3UYiU6X07x+bjdBm7WldS7yJni05LJHdl2Ib2mlb4tPLBGgYV5ZVE7NuOlLZzx/UmUepOeN+bfUfnhU2WjNuwJtqaUz+ho61tGfD3+0qsPCzlW27oWrNgiVsGg2HXOoM2sS1it+SlQcJy5mkcztV1ZFVyCgcXZtSdqtJnQC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300014; c=relaxed/simple;
	bh=CH1wc/myQIyBKiTH+dgAGacBzTIEMikQsYrENv/FOhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNbXbz9mZzYIhQDP1s+aEduMUj9SzVZLfAPaZWFEJxc+UUgaE4A8g7tItL8KcH18Dbmn5OpPVgtt3xftTkVOfW6rUnG7PW/SNCw7yVv9IpWiBAxEJihAdIBhaQpombDVs9c6LiKGY3ceft2upvAh8nLBC4HCNmDNuqjrzrsFUZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm4oRde7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm4oRde7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41421F000E9;
	Wed, 20 May 2026 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300013;
	bh=EduMAv1dTlRx4YWXO/dGW0v9S9/iPKi66yUaOS4pQi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm4oRde7S6SY89jezsgQGhv1fLPTSKwJ0ashOe0km1dh905PQ+GgDw0fb1fgZGTqk
	 N0ZP1lRMY0o5ETb03VnHWQhC9HoAnzc6UzYXOl/N8fPPuqz5WbBlO+0c3sEsPRgx42
	 ghPVc3uZpgpRadgx73l+YWL1g7z2xxaUxwB09bxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/666] ACPI: x86: cmos_rtc: Clean up address space handler driver
Date: Wed, 20 May 2026 18:13:46 +0200
Message-ID: <20260520162111.562344583@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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



