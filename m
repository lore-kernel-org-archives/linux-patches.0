Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EF9AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4757BC433EF;
	Wed,  4 Jan 2023 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849077;
	bh=aIv8rPttAvRaqF4jQcjIWVmTppUsBhvUmRnG4goKeAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlK/CwTLXVKAA6Gc17UtvuCKnKeuP4dnwEmt+sMuwSaDf0CU4vZ3XMNTJXa1QUeyt
	 Tei3s9nNmq/oYhIs8892WlAC6+sFlHBy5Qn7f5ErTSw/yMdfrbDb78HwckJzgopM3u
	 9eQF4ZJQRMmvBuUf7ON4F4yAm7D9zyaXAIH3w29Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@kernel.org>,
	Guo Ren <guoren@linux.alibaba.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 129/207] riscv: Fixup compile error with !MMU
Date: Wed,  4 Jan 2023 17:06:27 +0100
Message-Id: <20230104160516.010691480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

commit c528ef0888b75f673f7d48022de8d31d5b451e8c upstream.

Current nommu_virt_defconfig can't compile:

In file included from
arch/riscv/kernel/crash_core.c:3:
arch/riscv/kernel/crash_core.c:
In function 'arch_crash_save_vmcoreinfo':
arch/riscv/kernel/crash_core.c:8:27:
error: 'VA_BITS' undeclared (first use in this function)
    8 |         VMCOREINFO_NUMBER(VA_BITS);
      |                           ^~~~~~~

Add MMU dependency for KEXEC_FILE.

Fixes: 6261586e0c91 ("RISC-V: Add kexec_file support")
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221207091112.2258674-1-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -502,7 +502,7 @@ config KEXEC_FILE
 	select KEXEC_CORE
 	select KEXEC_ELF
 	select HAVE_IMA_KEXEC if IMA
-	depends on 64BIT
+	depends on 64BIT && MMU
 	help
 	  This is new version of kexec system call. This system call is
 	  file based and takes file descriptors as system call argument


