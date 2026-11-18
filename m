Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031037;
	b=YiVKZhIH0zLbbMy6STmIT3AQf9Ez4AuScZeAGI+5dAJ92pyA6NFPLDI4MCSfbCH51/0v
	 NNxvh4AzLolqnKoTdOa5tm77M22txPhenSPH7/nZJNapLMia28xVWxugpzqfXihmN1SU+
	 wGN8Z6ui7bA6ztAYfzCncyP8J/SQUlnR7QunxTkA58j+HHm52jE0wcgmZgXltHmibsMEz
	 7hzetNWAHm0DHN97Jk9PH3NG9MUakrnLtPeAvJiLVthWJh6he/y0QF3mZXwdgSMvpIRTR
	 Te/LuM6QRa3Y6+idJ5tdseYiSyvMe3RWodw25WdsL95KpZMpL6a46AlDtKxm5IuWxmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k3K63mzXaLJ97O9/aVBV7SKYOm8tfL6bzsh3SN1W7eM=;
	b=poPKHpZVrMULJo1dAdMRvWyiN3uxISbyX5a9anHzF0VI3j1/CjAF3CKbHTdtiX+GHDd1
	 blPa8vBngH6KcuC4hkXTJc8Qt5DYJ72R+71qqNqwqb2E6OUIPP7A2sAqQwtnn8nY20Sd6
	 NdZu0p7bODZCu+f+zvrkf2Kudm/xai48OB9IzqHxpKRLm+1XB1DFsyyTkkdUEpMXBaIEh
	 +rcm60jomod8wfdusafq59zulpPqzOq9gE8edizOQYp6xTsfBeQ17u+zG7A8QS77IoCQD
	 fVqOO4gaRm3rm45GAnmALOsH2aFfLm7kt2RP2hBNpHMKv6c/ODNm7M1PD/BSC9OOTYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYXcVupv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5E7606A320;
	Wed, 18 Nov 2026 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYXcVupv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792091F000C4;
	Wed, 18 Nov 2026 19:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031037;
	bh=k3K63mzXaLJ97O9/aVBV7SKYOm8tfL6bzsh3SN1W7eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYXcVupvYH6ZEDXczVJMu8qf7upPK/NqyJ7fnN5ZqESKjeoj6bkFg9GuP0dpqDtrf
	 HMILcMrnmA9lzAdtskUQ72a2AiRReFmET4yAL/UnskvYH1WLpFrkBZ/TJaKxUHZR14
	 YY1pDOcU9c29VFzdZra0RmJyyGsVfCl+M6R3c9ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0915/1756] efi/libstub: Use C99-style for loop to traverse handle buffer
Date: Wed, 18 Nov 2026 15:50:42 +0100
Message-ID: <20261118150046.426559098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit c14bca3f7aa94fd8d3f5e621ce5b56535ef2396b ]

Tweak the for_each_efi_handle() macro in order to avoid the need on the
part of the caller to provide a loop counter variable.

Also move efi_get_handle_num() to the callers, so that each occurrence
can be replaced with the actual number returned by the simplified
LocateHandleBuffer API.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: 8ea857a2bb54 ("efi/libstub: Free cmdline_ptr in efi_pe_entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h  | 9 ++++-----
 drivers/firmware/efi/libstub/gop.c      | 3 +--
 drivers/firmware/efi/libstub/pci.c      | 5 ++---
 drivers/firmware/efi/libstub/x86-stub.c | 3 +--
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index a2838e36f3f9f..21986fd151426 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -122,11 +122,10 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 #define efi_get_handle_num(size)					\
 	((size) / (efi_is_native() ? sizeof(efi_handle_t) : sizeof(u32)))
 
-#define for_each_efi_handle(handle, array, size, i)			\
-	for (i = 0;							\
-	     i < efi_get_handle_num(size) &&				\
-		((handle = efi_get_handle_at((array), i)) || true);	\
-	     i++)
+#define for_each_efi_handle(handle, array, num)				\
+	for (int __i = 0; __i < (num) &&				\
+		((handle = efi_get_handle_at((array), __i)) || true);	\
+	     __i++)
 
 static inline
 void efi_set_u64_split(u64 data, u32 *lo, u32 *hi)
diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index ea5da307d542f..8eef63c48288d 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -466,11 +466,10 @@ find_gop(efi_guid_t *proto, unsigned long size, void **handles)
 {
 	efi_graphics_output_protocol_t *first_gop;
 	efi_handle_t h;
-	int i;
 
 	first_gop = NULL;
 
-	for_each_efi_handle(h, handles, size, i) {
+	for_each_efi_handle(h, handles, efi_get_handle_num(size)) {
 		efi_status_t status;
 
 		efi_graphics_output_protocol_t *gop;
diff --git a/drivers/firmware/efi/libstub/pci.c b/drivers/firmware/efi/libstub/pci.c
index 99fb25d2bcf54..b0ba372c26c55 100644
--- a/drivers/firmware/efi/libstub/pci.c
+++ b/drivers/firmware/efi/libstub/pci.c
@@ -21,7 +21,6 @@ void efi_pci_disable_bridge_busmaster(void)
 	efi_handle_t handle;
 	efi_status_t status;
 	u16 class, command;
-	int i;
 
 	status = efi_bs_call(locate_handle, EFI_LOCATE_BY_PROTOCOL, &pci_proto,
 			     NULL, &pci_handle_size, NULL);
@@ -46,7 +45,7 @@ void efi_pci_disable_bridge_busmaster(void)
 		goto free_handle;
 	}
 
-	for_each_efi_handle(handle, pci_handle, pci_handle_size, i) {
+	for_each_efi_handle(handle, pci_handle, efi_get_handle_num(pci_handle_size)) {
 		efi_pci_io_protocol_t *pci;
 		unsigned long segment_nr, bus_nr, device_nr, func_nr;
 
@@ -82,7 +81,7 @@ void efi_pci_disable_bridge_busmaster(void)
 		efi_bs_call(disconnect_controller, handle, NULL, NULL);
 	}
 
-	for_each_efi_handle(handle, pci_handle, pci_handle_size, i) {
+	for_each_efi_handle(handle, pci_handle, efi_get_handle_num(pci_handle_size)) {
 		efi_pci_io_protocol_t *pci;
 
 		status = efi_bs_call(handle_protocol, handle, &pci_proto,
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index f8f9e043c283c..f77d6fd7e1154 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -124,7 +124,6 @@ static void setup_efi_pci(struct boot_params *params)
 	unsigned long size = 0;
 	struct setup_data *data;
 	efi_handle_t h;
-	int i;
 
 	status = efi_bs_call(locate_handle, EFI_LOCATE_BY_PROTOCOL,
 			     &pci_proto, NULL, &size, pci_handle);
@@ -150,7 +149,7 @@ static void setup_efi_pci(struct boot_params *params)
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	for_each_efi_handle(h, pci_handle, size, i) {
+	for_each_efi_handle(h, pci_handle, efi_get_handle_num(size)) {
 		efi_pci_io_protocol_t *pci = NULL;
 		struct pci_setup_rom *rom;
 
-- 
2.53.0



