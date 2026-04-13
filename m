Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8468B24DCF6;
	Mon, 13 Apr 2026 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097085; cv=none; b=KKEx8mVhnJw+FwPIHXud18HQC9yyT5aiVVwF8/jTofg1vL75ajCd5Sl8qw0MbgASe+Umi8pI6G6xmmE2YHmjLkIKXPUWEs/6As2C9bFNfLyRjexpNOv2oYB4rXJz8/yn/xthhHb0fE8C9Ynjs2KnSrtgGYAurjdEss52cSp/Xjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097085; c=relaxed/simple;
	bh=c91MCAdaUy2T4v0bCUgl/XYdAhMKoKrvNMPo2dQ8isE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw+NJSexW+aQqGkyh1Cm6MEn3uhB6aVQChOgoQqD9EoSrV8czLrQhD+gM7Aml0e4DQcNSvDQnHI2igegBG7AHEh6rzCodhoVJ7oVyqd/T5Aa3CfXvKGV76rpbnKqimOyIofbgr/0oL1hULvAwLMTXrAxGxargg7M+ei3zCGbhfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp9IUvHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp9IUvHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12839C2BCAF;
	Mon, 13 Apr 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097085;
	bh=c91MCAdaUy2T4v0bCUgl/XYdAhMKoKrvNMPo2dQ8isE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zp9IUvHvxln4IFhNnrrc8mUPXgYnGppQ5xNhFQWp8aifle2i8R91vti/S+J5QG2kw
	 q45GixC2gtqVbWzk65ESqe0qaxt5ju5ubeyqdkdyI7SR9Zdd/tZ0kBtU/l1yHFemQa
	 sNwOzck0K2mqU2tbiEcabHN1dSeOGwxTOSmXQMfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/55] Revert "ACPI: EC: Evaluate orphan _REG under EC device"
Date: Mon, 13 Apr 2026 18:00:58 +0200
Message-ID: <20260413155725.732020581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 779bac9994452f6a894524f70c00cfb0cd4b6364 ]

This reverts commit 0e6b6dedf168 ("Revert "ACPI: EC: Evaluate orphan
_REG under EC device") because the problem addressed by it will be
addressed differently in what follows.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/3236716.5fSG56mABF@rjwysocki.net
Stable-dep-of: 71bf41b8e913 ("ACPI: EC: Evaluate _REG outside the EC scope more carefully")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/acevents.h |    4 ---
 drivers/acpi/acpica/evregion.c |    6 +++-
 drivers/acpi/acpica/evxfregn.c |   54 -----------------------------------------
 drivers/acpi/ec.c              |    3 --
 include/acpi/acpixf.h          |    4 ---
 5 files changed, 5 insertions(+), 66 deletions(-)

--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -191,10 +191,6 @@ void
 acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
 			    acpi_adr_space_type space_id, u32 function);
 
-void
-acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *node,
-				  acpi_adr_space_type space_id);
-
 acpi_status
 acpi_ev_execute_reg_method(union acpi_operand_object *region_obj, u32 function);
 
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -20,6 +20,10 @@ extern u8 acpi_gbl_default_address_space
 
 /* Local prototypes */
 
+static void
+acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
+				  acpi_adr_space_type space_id);
+
 static acpi_status
 acpi_ev_reg_run(acpi_handle obj_handle,
 		u32 level, void *context, void **return_value);
@@ -807,7 +811,7 @@ acpi_ev_reg_run(acpi_handle obj_handle,
  *
  ******************************************************************************/
 
-void
+static void
 acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
 				  acpi_adr_space_type space_id)
 {
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -304,57 +304,3 @@ acpi_execute_reg_methods(acpi_handle dev
 }
 
 ACPI_EXPORT_SYMBOL(acpi_execute_reg_methods)
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_execute_orphan_reg_method
- *
- * PARAMETERS:  device          - Handle for the device
- *              space_id        - The address space ID
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Execute an "orphan" _REG method that appears under an ACPI
- *              device. This is a _REG method that has no corresponding region
- *              within the device's scope.
- *
- ******************************************************************************/
-acpi_status
-acpi_execute_orphan_reg_method(acpi_handle device, acpi_adr_space_type space_id)
-{
-	struct acpi_namespace_node *node;
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_execute_orphan_reg_method);
-
-	/* Parameter validation */
-
-	if (!device) {
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
-	}
-
-	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Convert and validate the device handle */
-
-	node = acpi_ns_validate_handle(device);
-	if (node) {
-
-		/*
-		 * If an "orphan" _REG method is present in the device's scope
-		 * for the given address space ID, run it.
-		 */
-
-		acpi_ev_execute_orphan_reg_method(node, space_id);
-	} else {
-		status = AE_BAD_PARAMETER;
-	}
-
-	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_execute_orphan_reg_method)
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1532,9 +1532,6 @@ static int ec_install_handlers(struct ac
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
 		acpi_execute_reg_methods(scope_handle, ACPI_ADR_SPACE_EC);
-		if (scope_handle != ec->handle)
-			acpi_execute_orphan_reg_method(ec->handle, ACPI_ADR_SPACE_EC);
-
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -669,10 +669,6 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 						     acpi_adr_space_type
 						     space_id))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			    acpi_execute_orphan_reg_method(acpi_handle device,
-							   acpi_adr_space_type
-							   space_id))
-ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_remove_address_space_handler(acpi_handle
 							      device,
 							      acpi_adr_space_type


