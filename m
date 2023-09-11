Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02461170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6DEC433C7;
	Mon, 11 Sep 2023 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442127;
	bh=THzNyZ+F0jWaCTw6IKBKln/lrApay70AHVhi70vJiic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEOw+0XbtSNI37v+xKric6pFQezSnpLShkCj3f5bWI1HyeG+WQ+GPx+EFApDRRSnN
	 P0AWTUajB7cxYqDIYGWujvg3EygvQAXeHoZHgan/kmHcfR9JFfntM4BAACYJwHYPNw
	 mk3zXMzu6CzgOEta2jZPOVubmk6YIIhgOw8QbWq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.5 656/739] riscv: Mark KASAN tmp* page tables variables as static
Date: Mon, 11 Sep 2023 15:47:35 +0200
Message-ID: <20230911134709.432830664@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit dd7664d67b478afeb79a89e4586c2cd7707d17d6 upstream.

tmp_pg_dir, tmp_p4d and tmp_pud are only used in kasan_init.c so they
should be declared as static.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306282202.bODptiGE-lkp@intel.com/
Fixes: 96f9d4daf745 ("riscv: Rework kasan population functions")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230704074357.233982-1-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/kasan_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -22,9 +22,9 @@
  * region is not and then we have to go down to the PUD level.
  */
 
-pgd_t tmp_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
-p4d_t tmp_p4d[PTRS_PER_P4D] __page_aligned_bss;
-pud_t tmp_pud[PTRS_PER_PUD] __page_aligned_bss;
+static pgd_t tmp_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
+static p4d_t tmp_p4d[PTRS_PER_P4D] __page_aligned_bss;
+static pud_t tmp_pud[PTRS_PER_PUD] __page_aligned_bss;
 
 static void __init kasan_populate_pte(pmd_t *pmd, unsigned long vaddr, unsigned long end)
 {


