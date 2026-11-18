Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018812;
	b=h6XgdvEwPTWrPSKIgqPuKOKhLSayy602wpPQNB0yc7jwqRGsJq7rzc/fSzQhR52bY1ZK
	 VRXz37gpFez9cXTffYVsrhDSz3bafPOLJP1kQ6b3+tU281eOIrvyZqI+9wILW0Lpw/vR9
	 HzFJQdQPdV9CXLOz2Ss3X7ANnBjk2De3fsE+WXWajSzAQ+cDhCuuXJho0Y/QMHb+MWkDT
	 q4urb6pToQSdOXoCEiaLRIceHq1L63UVIBh12Lx3qvKCsxfDfswq7pgx06HOBwfwIGG/B
	 x5hLJS2cLxqSMtHQuvgopG8WppWWGFGnjqYgc0qpASOSJ4vtfARnm9jl+ldyhUJ4bPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/HckA969+2QbD12tEdOlF1PjCGTOTd7mHM4fi5JdlTs=;
	b=TiFDTtLo5FgI7/9Gr9va+STkNBxbvEflCRiOmEZ/91opfTP73c8xsINWf41kYIdSJyEU
	 gmC8WH1JqSbeVtYdZ5q8MFjHaVAjYzP7Rz/jE9QXM+GU7CLFj8cuos9/cgFTs5A7V3anM
	 elkmXqZxylxAOWjVdexxyyxYouzPlwtnLaNNtaNxR8bqaW2GYV9DyG8z8w8XxXytaABy0
	 mF1nucDMbVqpjj8A6LMy2/G8+2T3kPcm+JQcWyl5ugoMnvhG/xhilVf3ffA6u3sepcWUK
	 EdcWp5XKUADqcGEEwx23TZnBdd7sRl2Sk769jWQAtoKPHDZkYa1dSWaY645NcY2NpPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXEPKoDi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9CF60A260A;
	Wed, 18 Nov 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXEPKoDi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF86E1F000C4;
	Wed, 18 Nov 2026 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018812;
	bh=/HckA969+2QbD12tEdOlF1PjCGTOTd7mHM4fi5JdlTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXEPKoDiozN9h02xlfOFdIqecNcefB0VPFSlA/+44yhCsvQo0Opl+tiqcGPDzFX4y
	 iO0RtVTVThNU49AoKVe7x5V5/WnoNaEOXqJcmiS3Rclu2R00q83bKcnHqGTe9WiSO1
	 qd19S+U/2qjTYmFApzFQ8QVtF3+t4KESomAp2518=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1373/2651] efi/riscv: libstub: Dont set image_size in handle_kernel_image()
Date: Wed, 18 Nov 2026 15:43:33 +0100
Message-ID: <20261118150337.461500157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



