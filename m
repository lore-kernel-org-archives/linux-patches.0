Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3112572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2FFC433D2;
	Tue, 18 Apr 2023 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821586;
	bh=7EZMG0SaFZG0Pk5jCl9AoWvbj6mu7r41U/G+/BHfBdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6WVUHzdUpvN7N+oTF8iiebzHahg2Rv9QNmx15uLT2De/NIRb3XnzDRulf2CRHFwM
	 906meRjIOFdapWaGZ7YyG+Z2M4/b9hnicFDpnL06nVHGVXuplNCf5BlYxdHqSVDKKM
	 CpJtKT8+wlTxFYpnneS4mJ5V8DGVsHirzB7VRc4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 57/91] riscv: Do not set initial_boot_params to the linear address of the dtb
Date: Tue, 18 Apr 2023 14:22:01 +0200
Message-Id: <20230418120307.576451817@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit f1581626071c8e37c58c5e8f0b4126b17172a211 upstream.

early_init_dt_verify() is already called in parse_dtb() and since the dtb
address does not change anymore (it is now in the fixmap region), no need
to reset initial_boot_params by calling early_init_dt_verify() again.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230329081932.79831-3-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -286,10 +286,7 @@ void __init setup_arch(char **cmdline_p)
 #if IS_ENABLED(CONFIG_BUILTIN_DTB)
 	unflatten_and_copy_device_tree();
 #else
-	if (early_init_dt_verify(__va(XIP_FIXUP(dtb_early_pa))))
-		unflatten_device_tree();
-	else
-		pr_err("No DTB found in kernel mappings\n");
+	unflatten_device_tree();
 #endif
 	early_init_fdt_scan_reserved_mem();
 	misc_mem_init();


