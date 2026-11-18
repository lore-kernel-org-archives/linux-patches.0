Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041047;
	b=nD8hFbHn/PqG6clbTiLdpXUAB8+z54+I3L03fWpRcYfqnSQWSgwVz8sf5r3PG6d3RZ2L
	 rO3mEv8L5vGC/ML9Az6VM+mqqrApTRcMPLOETLILUpPLfv5F6tn7//Lkly3CaGPSIuxdZ
	 Y6bc99sWpAVTeKqR8BhHd+IbpiHdO48XKIUM63WnxuruV+4vqilZEMIEvYQMjj485A4uV
	 zE53z/WAaZd1d55p0q2ab12tZ/d/bTDl/OmJ2lkspcw5vZ8dqgdi3lQmyjfJF+DGYKjhi
	 nh6cqdVQsbqs/gbj2Re3w6gNVDyfMlHG3bjRRUFpIfIUKTtBYWq+U+JJ0m1QPeSKFcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUscuZKTf/TpF+IqpjHTPAs0uhua/1PzM81cEOWU0GA=;
	b=t8w1O1bgC+EOOV8pg3FvWEx2pwuaOd/3R0Tmnn5gCXr50uprN8hHXdYgWFa+y0Ogcip8
	 4CP0YW4p/gQaABtAH6/XXHaRau64b8TG2uoklNsGptHYUIY2s5hqe8IWnA3CbuqBkTloK
	 NTKiBjP64HsO4z7OhhZEKQmYoKhFW0W7od209hkwyELMc1FBWGwpFCUzSxD4Bo4a/Mux1
	 yC0czDXr2Eluj1pMgnkcxfFZzTKUh4gM9xFOVmuBlRrUAT2R2snL/rDEt/LyTaEt47RQ2
	 T6hbU8RlU00h+77Y7jko5L64ZZr4oeOuZJi54V40dh5RqZFR6NIRmqIPASvLLpgYQ8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmuykINC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF61606A325;
	Wed, 18 Nov 2026 22:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmuykINC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119CD1F000C4;
	Wed, 18 Nov 2026 22:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041047;
	bh=uUscuZKTf/TpF+IqpjHTPAs0uhua/1PzM81cEOWU0GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmuykINCODahS+jij00eZuMz6LXthRg9yZjTYw/RaAydTUD032rD5Xc4+2lA+LA6Y
	 WGrc5/oWkwqj7V3ngNcMPpCs4eAnv8/x4z8mJkKHIjaDPXoyej+kSKKzYJCTfvPBtY
	 iNJLwoGDW2qci0VWdg3rsLgA72K4Cgb/hbL1Tbi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2634/3318] efi/riscv: libstub: Dont set image_size in handle_kernel_image()
Date: Wed, 18 Nov 2026 15:54:16 +0100
Message-ID: <20261118150440.107849171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c96d6dcee86c2..cc06edc9d01a0 100644
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



