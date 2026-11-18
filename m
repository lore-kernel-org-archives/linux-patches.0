Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025726;
	b=kGUdzsw2vRYWg8XPsnPqyfMhx6P6zc/nopKe1aFN2VUanI2EFjxoBObVHxjqy+E0DDGM
	 kasu6hDDUp1widBaH05Wkzw32I4Xnru8hglZ+xdm6mft6XYpLo5w2nKidhfw0CNINbn+w
	 vVHLprTcAYHmgdOPLa3TJdAQwAGAzuKQPR9uJo0rKpzmYhi0bbw9PfQ8wxPbpBPqmmLbq
	 GfUS/AxQgwFtw4CVhBqatrvMqlKOwApXGD0eSG1LT3x2BkDsl6w2B+cKPGuL3BFJVQVHC
	 N0bsp3GBtPwkRaLfwC3oqLXcL/JdsnuG0NJwMSMIQbuRii2pYGYgQDvSZrqyjMPTv4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JeduzL5l5pizxxcLVHIdmemeWrnBUOYh/LXZpmKvstY=;
	b=Naj6uo8uyDYOFI4YAharohKI6h8XXOly+cDw8C/ZliaoAUoHlAaMWfR2w0cuT7OaYMfS
	 FgtbwvNfgDU3LdlSik6MaNTtRhaTwluY/JC8FWn01biojg5y1DixFiBVuVMYfZfZafAz9
	 9JxoNgYzNkMrSmATYk12hCgWGSZRniBjVUMOHzwZDKtZn4He1iAN4fbJFmKKi4o1+8QpA
	 G8ZTidImjuWrybBq0nP5jNVmzVDkx8xyyFxuXw19Y+qSkceMaE6gYXnHGl/KoI81qHoPh
	 QYoAFDYYZUQJaRtuUPVdgfEOYbUccfAqbAZAHUiC3paBcsxXLWO6r/MIvAFeP+nwH4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKqXrPRb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671D9606A32F;
	Wed, 18 Nov 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKqXrPRb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE71A1F000C4;
	Wed, 18 Nov 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025726;
	bh=JeduzL5l5pizxxcLVHIdmemeWrnBUOYh/LXZpmKvstY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKqXrPRbAyrOECVM5T6DvpmDAIwCHrTKBEt7LeA6L4UOgW0GDgWUmaB8bcLegKNE9
	 9DcxCQWStPAz5+MrBcM0PbaMml8o2tGwJuK2O8ejtvwQYgHIg/tYt5Zwnjzul55fM4
	 ZbiHLlWwnv5SzMRKoXe4JYobAu31NyPg3uKjO8F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1154/2151] efi/riscv: libstub: Dont set image_size in handle_kernel_image()
Date: Wed, 18 Nov 2026 15:48:09 +0100
Message-ID: <20261118150204.208938841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit fd4465f49b53c7379d10610f8edb71f77366a5b7 ]

Sashiko points out the image_size should only be set if image_addr was
reassigned to some allocated memory. If image_size is not zero then the
caller will free the image_addr pointer.

efi_kaslr_relocate_kernel() never works like that, if it changes
image_addr to allocated memory the free is done through reserve_size.

Fixes: b7ac4b8ee73d ("riscv: libstub: Implement KASLR by using generic functions")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/riscv-stub.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index e7d9204baee31..725b634c51791 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -37,17 +37,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	kernel_codesize = __init_text_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
-	*image_size = kernel_memsize;
-	*reserve_size = *image_size;
+	*reserve_size = kernel_memsize;
 
 	status = efi_kaslr_relocate_kernel(image_addr,
 					   reserve_addr, reserve_size,
 					   kernel_size, kernel_codesize, kernel_memsize,
 					   efi_kaslr_get_phys_seed(image_handle));
-	if (status != EFI_SUCCESS) {
+	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
-		*image_size = 0;
-	}
 
 	return status;
 }
-- 
2.53.0



