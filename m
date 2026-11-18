Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031045;
	b=awbw049+3UoVxsKpHmVsx8kfiuavqFQutw4ZZaIJQRsVrdstR4uJ8V2aaEuK5zVET4nU
	 rJIr/nKCh25kyvuZQhRLzxhHT9BccoO1Jdscc7RQtPmqFLtMg0p4fWzfVYJq2yhN7esxx
	 q0pzEEKB99RhKHYtLHSsk2Op8KwQ/8uZe2ER/JLplWN/N3mNTxBcgCpeLfY7Jq5s4gjbo
	 mGwRdmCYx2vP+hCiTJQwco5a9mCCvWnLGTrRycGRK/VQyB7PHHj/p8gjBoBCkI6/d13bL
	 pfbzd2+uBkfsApyrmd6reYVvWw31aruEqQ+Z8zLlOA6oTFvgF5Qmy1wCQBmr5xEOoaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rj8CtQXsgZa8hmhv9mAjBgum4xZixHWUV+8HsyWLaEc=;
	b=Bii4MaS8pplToglBQCT4jf+49E77frd37ycWW/EIQWwcqX5OhomFwWHVpF8jFdNQTPdB
	 NusDtAlg0clvJ12iyS/SXKtvgrzZRyJdc76sO0LkTmvBRsx/NsagHs+ml8esCH5allJr5
	 DUCCQ8CMbcsqHpNG4wGpF7o2yjE/dtFyAF8j6TXU9jAlQ+w6moz3D9mNhWjy4FlG0CjNA
	 jOJtuCVKheADzuiZbjFA8Y1kJO5eugjjXDVVQS4CjJoSSV4SIM2b+1zB59zygWs8/W0oP
	 MWG0PBp44ksu57ICYjVhQlduj9Et0d2U6Fpst/20UP8T7/4EqulrwaI43KJ4zhamddg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gJW1VepL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96789606A31C;
	Wed, 18 Nov 2026 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gJW1VepL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCEB1F000C4;
	Wed, 18 Nov 2026 19:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031045;
	bh=rj8CtQXsgZa8hmhv9mAjBgum4xZixHWUV+8HsyWLaEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJW1VepLCwPvxifBHMBK58UEsHjBxuYlO6+8Do+TacM0iTZBgK+uJ1fIps0Tq4jsd
	 IqsveZEDI0pvrwlLVKyv8tEiJSlMZn5NtMdDPPxQBjWYuhwsGiH1mvP8KvMJlk7Hpg
	 D+mHBSet4mYVHicy3iC+9WcJCZwZ3rlz8exYgNGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0917/1756] efi/libstub: Simplify PCI I/O handle buffer traversal
Date: Wed, 18 Nov 2026 15:50:44 +0100
Message-ID: <20261118150046.498347718@linuxfoundation.org>
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

[ Upstream commit 90534e689d2e52202c276ade5cf1dfc13d9e116f ]

Use LocateHandleBuffer() and a __free() cleanup helper to simplify the
PCI I/O handle buffer traversal code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: 8ea857a2bb54 ("efi/libstub: Free cmdline_ptr in efi_pe_entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/pci.c      | 33 ++++++-------------------
 drivers/firmware/efi/libstub/x86-stub.c | 29 +++++-----------------
 2 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/firmware/efi/libstub/pci.c b/drivers/firmware/efi/libstub/pci.c
index b0ba372c26c55..1dccf77958d3a 100644
--- a/drivers/firmware/efi/libstub/pci.c
+++ b/drivers/firmware/efi/libstub/pci.c
@@ -16,36 +16,20 @@
 void efi_pci_disable_bridge_busmaster(void)
 {
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
-	unsigned long pci_handle_size = 0;
-	efi_handle_t *pci_handle = NULL;
+	efi_handle_t *pci_handle __free(efi_pool) = NULL;
+	unsigned long pci_handle_num;
 	efi_handle_t handle;
 	efi_status_t status;
 	u16 class, command;
 
-	status = efi_bs_call(locate_handle, EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-			     NULL, &pci_handle_size, NULL);
-
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		if (status != EFI_SUCCESS && status != EFI_NOT_FOUND)
-			efi_err("Failed to locate PCI I/O handles'\n");
-		return;
-	}
-
-	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, pci_handle_size,
-			     (void **)&pci_handle);
+	status = efi_bs_call(locate_handle_buffer, EFI_LOCATE_BY_PROTOCOL,
+			     &pci_proto, NULL, &pci_handle_num, &pci_handle);
 	if (status != EFI_SUCCESS) {
-		efi_err("Failed to allocate memory for 'pci_handle'\n");
+		efi_err("Failed to locate PCI I/O handles\n");
 		return;
 	}
 
-	status = efi_bs_call(locate_handle, EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-			     NULL, &pci_handle_size, pci_handle);
-	if (status != EFI_SUCCESS) {
-		efi_err("Failed to locate PCI I/O handles'\n");
-		goto free_handle;
-	}
-
-	for_each_efi_handle(handle, pci_handle, efi_get_handle_num(pci_handle_size)) {
+	for_each_efi_handle(handle, pci_handle, pci_handle_num) {
 		efi_pci_io_protocol_t *pci;
 		unsigned long segment_nr, bus_nr, device_nr, func_nr;
 
@@ -81,7 +65,7 @@ void efi_pci_disable_bridge_busmaster(void)
 		efi_bs_call(disconnect_controller, handle, NULL, NULL);
 	}
 
-	for_each_efi_handle(handle, pci_handle, efi_get_handle_num(pci_handle_size)) {
+	for_each_efi_handle(handle, pci_handle, pci_handle_num) {
 		efi_pci_io_protocol_t *pci;
 
 		status = efi_bs_call(handle_protocol, handle, &pci_proto,
@@ -107,7 +91,4 @@ void efi_pci_disable_bridge_busmaster(void)
 		if (status != EFI_SUCCESS)
 			efi_err("Failed to disable PCI busmastering\n");
 	}
-
-free_handle:
-	efi_bs_call(free_pool, pci_handle);
 }
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 76e611ffadccb..b11c46215a81f 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -119,37 +119,23 @@ preserve_pci_rom_image(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 static void setup_efi_pci(struct boot_params *params)
 {
 	efi_status_t status;
-	void **pci_handle = NULL;
+	efi_handle_t *pci_handle __free(efi_pool) = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
-	unsigned long size = 0;
 	struct setup_data *data;
+	unsigned long num;
 	efi_handle_t h;
 
-	status = efi_bs_call(locate_handle, EFI_LOCATE_BY_PROTOCOL,
-			     &pci_proto, NULL, &size, pci_handle);
-
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, size,
-				     (void **)&pci_handle);
-
-		if (status != EFI_SUCCESS) {
-			efi_err("Failed to allocate memory for 'pci_handle'\n");
-			return;
-		}
-
-		status = efi_bs_call(locate_handle, EFI_LOCATE_BY_PROTOCOL,
-				     &pci_proto, NULL, &size, pci_handle);
-	}
-
+	status = efi_bs_call(locate_handle_buffer, EFI_LOCATE_BY_PROTOCOL,
+			     &pci_proto, NULL, &num, &pci_handle);
 	if (status != EFI_SUCCESS)
-		goto free_handle;
+		return;
 
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	for_each_efi_handle(h, pci_handle, efi_get_handle_num(size)) {
+	for_each_efi_handle(h, pci_handle, num) {
 		efi_pci_io_protocol_t *pci = NULL;
 		struct pci_setup_rom *rom;
 
@@ -169,9 +155,6 @@ static void setup_efi_pci(struct boot_params *params)
 
 		data = (struct setup_data *)rom;
 	}
-
-free_handle:
-	efi_bs_call(free_pool, pci_handle);
 }
 
 static void retrieve_apple_device_properties(struct boot_params *boot_params)
-- 
2.53.0



