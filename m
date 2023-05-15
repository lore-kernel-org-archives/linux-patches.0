Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CAAD512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51346C4339C;
	Mon, 15 May 2023 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169451;
	bh=ieltGLTLLywDiGRea3LFOSf+OYyD0IxQUjOpP1/I/s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2LNokENSje9xfkWdAZeM8KqrgZrS65deAzmMhYo/4fmnOcDYaAEzssUfcBgXXMFO
	 AHga/7gHfalx1Bw0tcpKl5kJ6ammIGKZX4G/GkJU51i2+dSqyeoblZZys+o2smS6Ll
	 FdGXLvgfXj5t6dBtNNj4iwE6lcwLUwxkCCu1Vaac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	kernel test robot <lkp@intel.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Drew Fustini <dfustini@baylibre.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 054/246] riscv: compat_syscall_table: Fixup compile warning
Date: Mon, 15 May 2023 18:24:26 +0200
Message-Id: <20230515161724.201625607@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

[ Upstream commit f9c4bbddece7eff1155c70d48e3c9c2a01b9d778 ]

../arch/riscv/kernel/compat_syscall_table.c:12:41: warning: initialized
field overwritten [-Woverride-init]
   12 | #define __SYSCALL(nr, call)      [nr] = (call),
      |                                         ^
../include/uapi/asm-generic/unistd.h:567:1: note: in expansion of macro
'__SYSCALL'
  567 | __SYSCALL(__NR_semget, sys_semget)

Fixes: 59c10c52f573 ("riscv: compat: syscall: Add compat_sys_call_table implementation")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
Link: https://lore.kernel.org/r/20230501223353.2833899-1-dfustini@baylibre.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 4cf303a779ab9..8d02b9d05738d 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -9,6 +9,7 @@ CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
 endif
 CFLAGS_syscall_table.o	+= $(call cc-option,-Wno-override-init,)
+CFLAGS_compat_syscall_table.o += $(call cc-option,-Wno-override-init,)
 
 ifdef CONFIG_KEXEC
 AFLAGS_kexec_relocate.o := -mcmodel=medany $(call cc-option,-mno-relax)
-- 
2.39.2



