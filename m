Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031025;
	b=hmTAEMYQNHPCpCo6bSncp49Qwn9ejW1bEE4yh/Zx30/6ZH7vl/li3tUgpHYyPVHoEMpd
	 jGCvWVXatLfK2zFNC4WLEJThT78IE7tzeuBMM4XUSXU60Aruz2tjaJbxmuMu+QD88x0aM
	 mDkEMwEAW7QNiDEoXj8FnsklUC5Sl8X8V0Goc9e9K4iVesQWn+ZBsMlzOP9KtzAvuAkY7
	 R7mMzBPdZ6Ed823CXoDEOU+AwkU7UUo53YqBZ3NNrqUphFkBVvlbYKSsyzXnxbtyZ8STg
	 MT1Z2xLI1jCf2kBwNm8H6xjMTu3Uy0xHLlTWdr4xUJTmfJP2ZthbDgQqZd5MQztxUVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XKvwbLGWfP5RtD8eO8KZL6pGWcVT2WWXC+JH8LQWwR8=;
	b=hxwXVOpS/c/cB/kXbepm6AEFkRkv+7WSOwfxYDv3Tzwfm0U/sB/0eGcHmtIiylM2tDfm
	 OLaeAZaH4gxMNU2plnBbbaxO0H/yi+9iqUIYcPhyPvh2HOfZ1poLZ25DLaPbMtVGIRezz
	 l0ewm2H9G0g7KU17KBMONcPyAiKaQQNqqkQYrEhdSYdPLuHddxih0CI17RwtriTcEiDbg
	 LPpWV4p9TukJMddIBAKUCd9TLCIdgKIr9a2D+Q407GzkaOxg/crKCoELcAhKuSHm26mde
	 k9LhAakNiowM5AEXv22cVIy7fInx5l1biuxc4NguGpEAgL29X+g4UKZKDmEQDZ2fAwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RaGnKYI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F5606A320;
	Wed, 18 Nov 2026 19:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RaGnKYI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0C61F000C4;
	Wed, 18 Nov 2026 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031025;
	bh=XKvwbLGWfP5RtD8eO8KZL6pGWcVT2WWXC+JH8LQWwR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RaGnKYI1+MSTgeycz7/nMWIzMvGe1PrffB5FGBfsdHbINTWqSdzsrSLOp0BcSDNnn
	 BBtkLwp7S9Bu/0x+n/K4QxfdaLzTixCcYAgRJ1bKCm9ohsheFIKMpEED63VbazdtkZ
	 sizFue6i9BK4ZABhW3cCKsONSLnEBTGxi/p0c+f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0911/1756] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Wed, 18 Nov 2026 15:50:38 +0100
Message-ID: <20261118150046.232842173@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit d83fe67339f2032d8facf0fe8a047a4c5d15394f ]

Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
get_fdt() which is memory owned by FW.

Only the allocated fdt should be freed on the error unwind path. Use a
dedicated variable for the allocation's size so that the free does not get
confused.

Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/fdt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 6a337f1f8787b..b7a2d7aa61b4e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	u32 desc_ver;
 	efi_status_t status;
 	struct exit_boot_struct priv;
+	unsigned long fdt_size_allocated = 0;
 	unsigned long fdt_addr = 0;
 	unsigned long fdt_size = 0;
 
@@ -251,12 +252,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		if (strstr(cmdline_ptr, "dtb="))
 			efi_err("Ignoring DTB from command line.\n");
 	} else {
-		status = efi_load_dtb(image, &fdt_addr, &fdt_size);
+		status = efi_load_dtb(image, &fdt_addr, &fdt_size_allocated);
 
 		if (status != EFI_SUCCESS && status != EFI_NOT_READY) {
 			efi_err("Failed to load device tree!\n");
 			goto fail;
 		}
+		fdt_size = fdt_size_allocated;
 	}
 
 	if (fdt_addr) {
@@ -334,7 +336,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	efi_free(MAX_FDT_SIZE, *new_fdt_addr);
 
 fail:
-	efi_free(fdt_size, fdt_addr);
+	efi_free(fdt_size_allocated, fdt_addr);
 	if (!efi_novamap)
 		efi_bs_call(free_pool, priv.runtime_map);
 
-- 
2.53.0



