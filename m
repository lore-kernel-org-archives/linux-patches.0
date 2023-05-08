Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC3B168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B471C433EF;
	Mon,  8 May 2023 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543427;
	bh=Ua/MFmWesgy32z8E9MDOiD9RzCL39IRCi8eEaA907E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdonb1Wxg5jAfqo6IxD7QrGoQZuYj603ypGhNZvnxOVQomXd/ji8A6Wd9hgGdZvpx
	 BFV6cXaeO8SB+ROT1Tx8RVfOQRSvBU5VhIP5kuBqQSs0Pqr/1l1QuNx6VYYNQ1zWLG
	 dshh8ztHHDYgp4BOcE3ZtRvcxGVeXZY9bP2TEi7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Song Shuai <suagrfillet@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.3 079/694] riscv: mm: remove redundant parameter of create_fdt_early_page_table
Date: Mon,  8 May 2023 11:38:34 +0200
Message-Id: <20230508094435.102696366@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

commit e4ef93edd4e0b022529303db1915766ff9de450e upstream.

create_fdt_early_page_table() explicitly uses early_pg_dir for
32-bit fdt mapping and the pgdir parameter is redundant here.
So remove it and its caller.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Song Shuai <suagrfillet@gmail.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: ef69d2559fe9 ("riscv: Move early dtb mapping into the fixmap region")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230426100009.685435-1-suagrfillet@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -843,8 +843,7 @@ static void __init create_kernel_page_ta
  * this means 2 PMD entries whereas for 32-bit kernel, this is only 1 PGDIR
  * entry.
  */
-static void __init create_fdt_early_page_table(pgd_t *pgdir,
-					       uintptr_t fix_fdt_va,
+static void __init create_fdt_early_page_table(uintptr_t fix_fdt_va,
 					       uintptr_t dtb_pa)
 {
 	uintptr_t pa = dtb_pa & ~(PMD_SIZE - 1);
@@ -1034,8 +1033,7 @@ asmlinkage void __init setup_vm(uintptr_
 	create_kernel_page_table(early_pg_dir, true);
 
 	/* Setup early mapping for FDT early scan */
-	create_fdt_early_page_table(early_pg_dir,
-				    __fix_to_virt(FIX_FDT), dtb_pa);
+	create_fdt_early_page_table(__fix_to_virt(FIX_FDT), dtb_pa);
 
 	/*
 	 * Bootime fixmap only can handle PMD_SIZE mapping. Thus, boot-ioremap


