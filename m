Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341A72572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE13C4339B;
	Tue, 18 Apr 2023 12:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822397;
	bh=CM6XRlSLbRIFu9ZYWx2s0PTk7kALrNAe/TEpeKMf95c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nue+hqvHqEgLlc9JRp3cFW3j7/NzxH1L7kDbSYSA9tRlGuLQIBVR+fdOOXSYJ3vMt
	 x2ulx2Jv9l6UnTzjXswb+SVYG92O2S7u2r+o2kgO+139b+FGdfjrCBx9ohTh+wZ3U8
	 cVLZjUjciJgRfhTKPlM2RhhzzvSnPOmIDRrhhKqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 104/139] riscv: Do not set initial_boot_params to the linear address of the dtb
Date: Tue, 18 Apr 2023 14:22:49 +0200
Message-Id: <20230418120317.712080553@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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
@@ -278,10 +278,7 @@ void __init setup_arch(char **cmdline_p)
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


