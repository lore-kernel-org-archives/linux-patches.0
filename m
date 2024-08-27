Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B67B1C6887;
	Tue, 27 Aug 2024 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770906; cv=none; b=TXLFW142WnQBtPwWMcqF2Bkuq1zyL+lTgwvwDi43PArubWf2Qkq6nUfPmy/0BiCeTWORMzN+8Dfht1DneNHRJediGb6CxzTcwCJnH+b3NLTiWSIHNH3RS+/qYAocWudbx3MEaoQ6ycq8YTgJbhAuYc9fvekIbPAI+nPNOIkVEHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770906; c=relaxed/simple;
	bh=djn+d+KGpj1u9XiJRR/k6hkIp+Ti34EV2qwAUCvAQ0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=culE680zLbPDoF5klfvTF9qCeByw3abag5PiJASzzNLdzsH5sPhFw/Ld4hyZ9l0sxNMz3dbCjLnnV2M8g8Etvi4R3PkVmUmVOx6jrmglFe+17mJ8ltL/69gVFn6swBDUTYV2Ag4Mgz64KH6Ec0/2SIdRmLzoq8neWTSpKM0WK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZbTZMk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZbTZMk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E72C4AF1C;
	Tue, 27 Aug 2024 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770905;
	bh=djn+d+KGpj1u9XiJRR/k6hkIp+Ti34EV2qwAUCvAQ0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZbTZMk6ugbOLmGIWXlwdr4E61zJs7YgxCY20f5/BcyWswiR2Iw+FK1LBxIgiLnak
	 75OcLWbBn/QbH4sDe4CEKSIycQ/OAXahCT3rZNWXfKFKMLMQCyFQZgie7r/0/kXnLs
	 sSfzFOxk5dv4dA/WaG7tx+97+KxDDCUhTF0bzR4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.10 004/273] Revert "ACPI: EC: Evaluate orphan _REG under EC device"
Date: Tue, 27 Aug 2024 16:35:28 +0200
Message-ID: <20240827143833.545263242@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 779bac9994452f6a894524f70c00cfb0cd4b6364 upstream.

This reverts commit 0e6b6dedf168 ("Revert "ACPI: EC: Evaluate orphan
_REG under EC device") because the problem addressed by it will be
addressed differently in what follows.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/3236716.5fSG56mABF@rjwysocki.net
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
@@ -814,7 +818,7 @@ acpi_ev_reg_run(acpi_handle obj_handle,
  *
  ******************************************************************************/
 
-void
+static void
 acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
 				  acpi_adr_space_type space_id)
 {
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -306,57 +306,3 @@ acpi_execute_reg_methods(acpi_handle dev
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
@@ -1507,9 +1507,6 @@ static int ec_install_handlers(struct ac
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
 		acpi_execute_reg_methods(scope_handle, ACPI_ADR_SPACE_EC);
-		if (scope_handle != ec->handle)
-			acpi_execute_orphan_reg_method(ec->handle, ACPI_ADR_SPACE_EC);
-
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -663,10 +663,6 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
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


