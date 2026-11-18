Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031028;
	b=Dbdtou6CioDNFxfAo+rF9qu3Z9/2ylCOvVApaH3rhX0Vk0MC0QtguB06EasDf3FcQapm
	 OBHty+Qifs2HNx6Awx01KgD7j3XQlYB3UfJYGOuB9Y8uJ4SuQWFtQ+gl2/Yrq1Brl4re2
	 osLYq7omtmUuatCKwcTgNl6FnS/BKa7FoI1wLdcbplUBJvoP2qU2eeGjfiVGUc2bBlOd8
	 i7iZB15jUVGATMoacHUK0HPmL9LRvYBQozLZY7Ty9QA0zU5P1E8IoyZZerFZK2svGF5Ym
	 tSzLEwtrZsZBW5RFB5Nq9mnlgFuYKXL6rRAnDpCDPaMOVqhLTCTdQ6v5v0Kcz0KO6mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nG0hA235rajmP4it7WyxRSXl/GtdGDSN9cpidiD+oRs=;
	b=kDCC+IiXfd+835jal6npZgFWN4ho6hfJWLRbHU5svso5Gq8CFL7NJT7plKqUFJi8FQrP
	 m2belujBchMaNLhWUjFpcmHA0whjcN28LKhtZ45P/778PceOfkkxqxkaMz7RE/l53VFcQ
	 PQpEHxA7WuM8cpSQz+V/InnnKCzcxp0ivo1RiATNbaE2crMeaDYPwVveZe2qDIly/ELvh
	 /N+Bu7NrV5mUNZ1IuWQXL+TyzjtjG+JdH3bnUbZaXf7gLTQNUK05T6APAVyzoLoe8ecs4
	 m9Vjkh0hNYuix/dvmNrsgIyCbSlCHEQsvrTcm7znOLxNFq+kW9CRh2H22uhKYCuzYaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojm4bwUs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2948606A325;
	Wed, 18 Nov 2026 19:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojm4bwUs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F2C1F000C4;
	Wed, 18 Nov 2026 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031028;
	bh=nG0hA235rajmP4it7WyxRSXl/GtdGDSN9cpidiD+oRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojm4bwUspCEhIuNtZPIgYE4OjPeW/0tlPnsXn1UGdrfD6TYtxVeyPLYwI2pZ/XH2o
	 KR/OjlVt6QQWk4YYZJUDwlmPZxPHkQaDV5KhK3fCVfyyPV5rzGsT3+RLJjrjrNBmPF
	 CZUezUu5YmnJG0rxhqhPt4cc1kP4ODKCXy5Ld/28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0912/1756] efi/riscv: libstub: Dont set image_size in handle_kernel_image()
Date: Wed, 18 Nov 2026 15:50:39 +0100
Message-ID: <20261118150046.279953403@linuxfoundation.org>
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



