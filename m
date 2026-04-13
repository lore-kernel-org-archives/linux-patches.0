Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C145A3203B6;
	Mon, 13 Apr 2026 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099380; cv=none; b=IP36aBDagSdBRsFM4TDGN4sXbQgbnSZHDImcMESR66LCkP0ONrZU7vXq3FfE7ZIaxWummrzl0g8+V+Joe1V615M0r9ctIzm+arZYJ3IuYDohsHyvUv/qYHlWzZNoU6oi5wWeG0vsNPQJeiuVDh0ICb+YWQq+qOimYDsbWv7FdPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099380; c=relaxed/simple;
	bh=wuSCxlnWdpaBQuvfG/Fji7SakW6YQJmfWuar5Xsbry4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB9oqiZSvJWyOcUpYWwQ2g9t1eO6zs0R49bflVlvX6ea8Hny592+jM+3pMrFspkdQ/ItLGnvXW2ocUW5VQBRwV1/bAZkAGnvHKOus53dfyX0ES7vLKoY1umKWnx1ymonZVQv//LrD2nSiwc5xO5dMToYM3tH2dJJckGMJQH+47Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2KFe/qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2KFe/qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BF6C2BCAF;
	Mon, 13 Apr 2026 16:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099380;
	bh=wuSCxlnWdpaBQuvfG/Fji7SakW6YQJmfWuar5Xsbry4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2KFe/qCaIZ2iEcPG0PKnYWvZ6AkRSOFSvvsYq/RT+eo/9xFG9dyNJQHkb1a/vtIf
	 MnEGr91Eaq3IwQLRZ7Z98kUNdvJSyqvH2Cj7NUGE9vb1qoXi7fAi5dC/Tqzfopmb4e
	 wijmmKeMbPe7AqgKD95dmi/UB1KyqYmECkUwomFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/491] ACPICA: include/acpi/acpixf.h: Fix indentation
Date: Mon, 13 Apr 2026 17:58:51 +0200
Message-ID: <20260413155829.752049036@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7a9d74e7e403cb2e60d4d00c05f2f3ab2a33d0c3 ]

A bunch of the functions declared in include/acpi/acpixf.h have their
name aligned a space after the '(' of e.g. the
`ACPI_EXTERNAL_RETURN_STATUS(acpi_status` line above rather then being
directly aligned after the '('.

This breaks applying patches generated from the ACPICA upstream git,
remove the extra space before the function-names and all the arguments
to fix this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acpixf.h | 120 +++++++++++++++++++++---------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index be7de305a6220..f9a86e3329715 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -587,82 +587,82 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_install_initialization_handler
 			    (acpi_init_handler handler, u32 function))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_install_sci_handler(acpi_sci_handler
-							  address,
-							  void *context))
-ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_remove_sci_handler(acpi_sci_handler
-							 address))
+				acpi_install_sci_handler(acpi_sci_handler
+							 address,
+							 void *context))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_install_global_event_handler
-				 (acpi_gbl_event_handler handler,
-				  void *context))
+				acpi_remove_sci_handler(acpi_sci_handler
+							address))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_install_fixed_event_handler(u32
-								  acpi_event,
-								  acpi_event_handler
-								  handler,
-								  void
-								  *context))
+				acpi_install_global_event_handler
+				(acpi_gbl_event_handler handler,
+				 void *context))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_remove_fixed_event_handler(u32 acpi_event,
+				acpi_install_fixed_event_handler(u32
+								 acpi_event,
 								 acpi_event_handler
-								 handler))
-ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_install_gpe_handler(acpi_handle
-							  gpe_device,
-							  u32 gpe_number,
-							  u32 type,
-							  acpi_gpe_handler
-							  address,
-							  void *context))
+								 handler,
+								 void
+								 *context))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_install_gpe_raw_handler(acpi_handle
-							      gpe_device,
-							      u32 gpe_number,
-							      u32 type,
-							      acpi_gpe_handler
-							      address,
-							      void *context))
+				acpi_remove_fixed_event_handler(u32 acpi_event,
+								acpi_event_handler
+								handler))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				 acpi_remove_gpe_handler(acpi_handle gpe_device,
+				acpi_install_gpe_handler(acpi_handle
+							 gpe_device,
 							 u32 gpe_number,
+							 u32 type,
 							 acpi_gpe_handler
-							 address))
-ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			     acpi_install_notify_handler(acpi_handle device,
-							 u32 handler_type,
-							 acpi_notify_handler
-							 handler,
+							 address,
 							 void *context))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_install_gpe_raw_handler(acpi_handle
+							     gpe_device,
+							     u32 gpe_number,
+							     u32 type,
+							     acpi_gpe_handler
+							     address,
+							     void *context))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_remove_gpe_handler(acpi_handle gpe_device,
+							u32 gpe_number,
+							acpi_gpe_handler
+							address))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			     acpi_remove_notify_handler(acpi_handle device,
+			    acpi_install_notify_handler(acpi_handle device,
 							u32 handler_type,
 							acpi_notify_handler
-							handler))
-ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			     acpi_install_address_space_handler(acpi_handle
-								device,
-								acpi_adr_space_type
-								space_id,
-								acpi_adr_space_handler
-								handler,
-								acpi_adr_space_setup
-								setup,
-								void *context))
-ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			     acpi_remove_address_space_handler(acpi_handle
+							handler,
+							void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_remove_notify_handler(acpi_handle device,
+						       u32 handler_type,
+						       acpi_notify_handler
+						       handler))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_install_address_space_handler(acpi_handle
 							       device,
 							       acpi_adr_space_type
 							       space_id,
 							       acpi_adr_space_handler
-							       handler))
-ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			     acpi_install_exception_handler
-			     (acpi_exception_handler handler))
-ACPI_EXTERNAL_RETURN_STATUS(acpi_status
-			     acpi_install_interface_handler
-			     (acpi_interface_handler handler))
+							       handler,
+							       acpi_adr_space_setup
+							       setup,
+							       void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_remove_address_space_handler(acpi_handle
+							      device,
+							      acpi_adr_space_type
+							      space_id,
+							      acpi_adr_space_handler
+							      handler))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_install_exception_handler
+			    (acpi_exception_handler handler))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_install_interface_handler
+			    (acpi_interface_handler handler))
 
 /*
  * Global Lock interfaces
-- 
2.53.0



