Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831256;
	b=hQX8zeHFnz19SKLgkmkvWJATJAx8CxcIhyni2IKA6DgHHsV76ibMeUORr7thIvr8lW78
	 aMc5yoUJotlsVsen/v8V5ugQEzhhmwoMp7nR8zDSJJDWW4oQETeaD/Mz/IGiJ7pjC/svE
	 zUPd3PAMYHe5FQXAIE8pNuBGSs5mCmJYSQ10Eoi27Wn3tQVJ8ZETQMw1YkkiG10i0qO4C
	 UnqyFA2AWwcA03ek9hBdJp4Gh4xAD0mb39GHVqAYjyNoCCVvIEX4tLP6JCyx9VmqcDm4I
	 uQEzslGQU6GmZIoKou59/fnuMX/ai8QVJuxXBUVA3HqQEVx83oyf3vm9OP5JJkM5vdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOSi0b4aCNVu2sYpVWTBOgFIwSk3+gnNLp6dyuhaGTM=;
	b=ti+7iPFT1ik/0MtDpxBV87y4hCXLXGblJwmLlj78PCZqJbDaLaG2k7a0NMqDCRI28Os4
	 CoQiRhG8cmx8++fMlGvfc2AItUaJOIu+bakc+zj+ZfZKB0xrCND+AZDpsp9bmZc1VYp+L
	 RpzbQP6olALMvumSkteVy79Zgw/ZGfwo2Kf3idQu3it1BHlJMLrvRztQ+IqN99gKlMUin
	 V9rMfqjzXTJNfxNOB5dKKRy8A1MaBVjOdQR7+vcxjjxBZ9yIAWTlvY2X2/660Suxwh4AX
	 qTeY2AAxke5OKjMzzHyHj0liIfO3pUtSua8JIhhjFVIu9Yhh+mkNWKs2c9agjgOxNhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAnnlNcr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF713606A33E;
	Wed,  4 Nov 2026 22:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAnnlNcr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2591F0093A;
	Wed,  4 Nov 2026 22:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831255;
	bh=WOSi0b4aCNVu2sYpVWTBOgFIwSk3+gnNLp6dyuhaGTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAnnlNcr2HJFRn24VU93v5Qu8sHqbSeIufUNoEZRcNNBuZTy+p5dSjMcbCtNFUeN2
	 tdgj4CtzMmvF9V++B6HvH6l6nuRzpqJTcdnv+ZdVVrRhtYoE6t1aqD+dI6ojEW9D1E
	 uQ+hfb+as/FkpWguhj+jli7hjMpT7xioOdJPRo1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0555/1005] LoongArch: Expand module virtual address space to 2GB
Date: Wed,  4 Nov 2026 16:04:48 -0500
Message-ID: <20261104211059.439051404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 18210a104bb97e28c26dc31fd9fc7b5c381fec62 ]

The current 256MB module virtual address space is easily exhausted when
loading massive graphics drivers such as amdgpu along with the large
unstripped symbol tables, resulting in allocation failures of "execmem:
unable to allocate memory".

Thus, expand the module virtual address space to 2GB while keeping
the current normal code model '-mcmodel=normal', rather than using the
medium code model '-mcmodel=medium'. This approach avoids the extra
performance overhead and larger binary size of forcing every function
call into a 2-instruction sequence of 'pcaddu18i + jirl'.

Given that individual module code segments rarely exceed 128MB, most
jumps remain fast direct calls by using the bl instruction. For the
long-distance jumps exceeding the +/-128MB limit, apply_r_larch_b26()
emits PLT entries, while signed_imm_check() guarantees the run-time
safety by rejecting any out-of-bound instruction offsets.

There is still a risk that the distance between .init.text and .text of
the same module exceeds 128MB. So we divide the 2GB virtual space to be
two sub-regions: the first 256MB is for module text, and the rest is for
module data.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
[ sashal: Kept the existing #ifdef CONFIG_EXECMEM guard in init.c instead of upstream's #if defined(CONFIG_EXECMEM) && defined(MODULES_VADDR), and added the new module text/data region defines after it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h |  2 +-
 arch/loongarch/mm/init.c             | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index e3563a52e5b5b..e3ba4759b4d00 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -80,7 +80,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
  * still reliably trap.
  */
 #define MODULES_VADDR	(vm_map_base + PCI_IOSIZE + (2 * PAGE_SIZE))
-#define MODULES_END	(MODULES_VADDR + SZ_256M)
+#define MODULES_END	(MODULES_VADDR + SZ_2G) /* 256MB for text, rest for data */
 
 #ifdef CONFIG_KFENCE
 #define KFENCE_AREA_SIZE	(((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 900ce1da75a43..aaf66c0a096c1 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -221,15 +221,26 @@ pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);
 
 #ifdef CONFIG_EXECMEM
+#define MODULES_TEXT_START (MODULES_VADDR)
+#define MODULES_TEXT_END   (MODULES_VADDR + SZ_256M)
+#define MODULES_DATA_START (MODULES_VADDR + SZ_256M)
+#define MODULES_DATA_END   (MODULES_END)
+
 static struct execmem_info execmem_info __ro_after_init;
 
 struct execmem_info __init *execmem_arch_setup(void)
 {
 	execmem_info = (struct execmem_info){
 		.ranges = {
-			[EXECMEM_DEFAULT] = {
-				.start	= MODULES_VADDR,
-				.end	= MODULES_END,
+			[EXECMEM_MODULE_TEXT] = {
+				.start	= MODULES_TEXT_START,
+				.end	= MODULES_TEXT_END,
+				.pgprot	= PAGE_KERNEL,
+				.alignment = 1,
+			},
+			[EXECMEM_MODULE_DATA] = {
+				.start	= MODULES_DATA_START,
+				.end	= MODULES_DATA_END,
 				.pgprot	= PAGE_KERNEL,
 				.alignment = 1,
 			},
-- 
2.53.0



