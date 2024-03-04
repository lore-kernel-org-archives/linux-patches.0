Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626379F2;
	Mon,  4 Mar 2024 21:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589057; cv=none; b=Nh+uMpVxLbUJRBiHU3Os6//IsjcRoTTeV/s7EKD0A2LcbzuDlCV1SZ93eBdeJ3ISys0+g94RrFW4UZx8LOuUnpGKMR5jWCGv5blb4nNwGtaPVEiaNid/BSwCl3uJIIOyQRH+lzh9LzobaaEujZzVRLU4+sP3DMUFqy3OUTFZo/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589057; c=relaxed/simple;
	bh=QRzo8M9o0AF7DOCo78y0QnU2g9IKqTz/At0DTEXQVVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+9VCTvAiYIlgY9R+syKIbBwEgFSH62pvj71OJf49Yl+6yXR3hcp5HGd0YlFBL/YcO7Nxq1/Lx0hQ1wGwCQAPEF6WuHOvB6C/5L4lc/nGVKJar2BTbmsjo/ZZQqBOltw4nW5rr3vO8PrVblwJqB1pwu0PBFEffH5Zw6+c9l01v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJZk6NOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJZk6NOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C32C433C7;
	Mon,  4 Mar 2024 21:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589057;
	bh=QRzo8M9o0AF7DOCo78y0QnU2g9IKqTz/At0DTEXQVVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJZk6NObv+KNMWtoRiR8wIfABOVAfpozV88/miwNfX+GNuPIpUT2r1iR53jM3ISnx
	 narwrwCIQBO0le8wyy260ee+Y1kvhbl110yKpi1pqglCC50q3SlX8s8gvzgAN86S0Y
	 xR+4Z4Z4s4k1qJ4inCeuzNoIAb1OEyIOK74Z1+9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Evgeniy Baskov <baskov@ispras.ru>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 185/215] efi/libstub: Add memory attribute protocol definitions
Date: Mon,  4 Mar 2024 21:24:08 +0000
Message-ID: <20240304211602.825483765@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb+git@google.com>

From: Evgeniy Baskov <baskov@ispras.ru>

[ Commit 79729f26b074a5d2722c27fa76cc45ef721e65cd upstream ]

EFI_MEMORY_ATTRIBUTE_PROTOCOL servers as a better alternative to
DXE services for setting memory attributes in EFI Boot Services
environment. This protocol is better since it is a part of UEFI
specification itself and not UEFI PI specification like DXE
services.

Add EFI_MEMORY_ATTRIBUTE_PROTOCOL definitions.
Support mixed mode properly for its calls.

Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Evgeniy Baskov <baskov@ispras.ru>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/efi.h             |    7 +++++++
 drivers/firmware/efi/libstub/efistub.h |   20 ++++++++++++++++++++
 include/linux/efi.h                    |    1 +
 3 files changed, 28 insertions(+)

--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -325,6 +325,13 @@ static inline u32 efi64_convert_status(e
 #define __efi64_argmap_set_memory_space_attributes(phys, size, flags) \
 	(__efi64_split(phys), __efi64_split(size), __efi64_split(flags))
 
+/* Memory Attribute Protocol */
+#define __efi64_argmap_set_memory_attributes(protocol, phys, size, flags) \
+	((protocol), __efi64_split(phys), __efi64_split(size), __efi64_split(flags))
+
+#define __efi64_argmap_clear_memory_attributes(protocol, phys, size, flags) \
+	((protocol), __efi64_split(phys), __efi64_split(size), __efi64_split(flags))
+
 /*
  * The macros below handle the plumbing for the argument mapping. To add a
  * mapping for a specific EFI method, simply define a macro
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -419,6 +419,26 @@ union efi_dxe_services_table {
 	} mixed_mode;
 };
 
+typedef union efi_memory_attribute_protocol efi_memory_attribute_protocol_t;
+
+union efi_memory_attribute_protocol {
+	struct {
+		efi_status_t (__efiapi *get_memory_attributes)(
+			efi_memory_attribute_protocol_t *, efi_physical_addr_t, u64, u64 *);
+
+		efi_status_t (__efiapi *set_memory_attributes)(
+			efi_memory_attribute_protocol_t *, efi_physical_addr_t, u64, u64);
+
+		efi_status_t (__efiapi *clear_memory_attributes)(
+			efi_memory_attribute_protocol_t *, efi_physical_addr_t, u64, u64);
+	};
+	struct {
+		u32 get_memory_attributes;
+		u32 set_memory_attributes;
+		u32 clear_memory_attributes;
+	} mixed_mode;
+};
+
 typedef union efi_uga_draw_protocol efi_uga_draw_protocol_t;
 
 union efi_uga_draw_protocol {
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -390,6 +390,7 @@ void efi_native_runtime_setup(void);
 #define EFI_RT_PROPERTIES_TABLE_GUID		EFI_GUID(0xeb66918a, 0x7eef, 0x402a,  0x84, 0x2e, 0x93, 0x1d, 0x21, 0xc3, 0x8a, 0xe9)
 #define EFI_DXE_SERVICES_TABLE_GUID		EFI_GUID(0x05ad34ba, 0x6f02, 0x4214,  0x95, 0x2e, 0x4d, 0xa0, 0x39, 0x8e, 0x2b, 0xb9)
 #define EFI_SMBIOS_PROTOCOL_GUID		EFI_GUID(0x03583ff6, 0xcb36, 0x4940,  0x94, 0x7e, 0xb9, 0xb3, 0x9f, 0x4a, 0xfa, 0xf7)
+#define EFI_MEMORY_ATTRIBUTE_PROTOCOL_GUID	EFI_GUID(0xf4560cf6, 0x40ec, 0x4b4a,  0xa1, 0x92, 0xbf, 0x1d, 0x57, 0xd0, 0xb1, 0x89)
 
 #define EFI_IMAGE_SECURITY_DATABASE_GUID	EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596,  0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
 #define EFI_SHIM_LOCK_GUID			EFI_GUID(0x605dab50, 0xe046, 0x4300,  0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)


