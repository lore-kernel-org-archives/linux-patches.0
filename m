Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3D91FA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F965C433C8;
	Wed,  9 Aug 2023 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578164;
	bh=r3OlAe0GEBBzMp+cus2sFSlrwgZqQ5yG3CW6lq3ObE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sz62opNQqPXRvB72T8k9t8s7QPE8z2/Sad84wNNhSU/10xs5sLjANJ3oTx1VSb/ca
	 juMBUoeAr+bt41GZ3xvQDXDXxvqGUca8ull2HuZdE6P2Jov8rqPjHtOkkItwsSFF4D
	 Ltnj+qUshxlkwLHWj/AxCOM9bAaS9p8O4HJajwpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <suagrfillet@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.4 099/165] Documentation: kdump: Add va_kernel_pa_offset for RISCV64
Date: Wed,  9 Aug 2023 12:40:30 +0200
Message-ID: <20230809103646.019961791@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Shuai <suagrfillet@gmail.com>

commit 640c503d7dbd7d34a62099c933f4db0ed77ccbec upstream.

RISC-V Linux exports "va_kernel_pa_offset" in vmcoreinfo to help
Crash-utility translate the kernel virtual address correctly.

Here adds the definition of "va_kernel_pa_offset".

Fixes: 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear mapping")
Link: https://lore.kernel.org/linux-riscv/20230724040649.220279-1-suagrfillet@gmail.com/
Signed-off-by: Song Shuai <suagrfillet@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230724100917.309061-2-suagrfillet@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kdump/vmcoreinfo.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index c18d94fa6470..f8ebb63b6c5d 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -624,3 +624,9 @@ Used to get the correct ranges:
   * VMALLOC_START ~ VMALLOC_END : vmalloc() / ioremap() space.
   * VMEMMAP_START ~ VMEMMAP_END : vmemmap space, used for struct page array.
   * KERNEL_LINK_ADDR : start address of Kernel link and BPF
+
+va_kernel_pa_offset
+-------------------
+
+Indicates the offset between the kernel virtual and physical mappings.
+Used to translate virtual to physical addresses.
-- 
2.41.0



