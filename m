Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB1EBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603DC433D2;
	Tue,  7 Mar 2023 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214546;
	bh=f8D20QC3CJzX/ndMRx1yYHKDtzyAqslqUxzqFV+byVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P59on7lxSK22sQEYqx4sCaZ/gCfM4OFPL/M/Djcr24bMOHGF8MpZsbxw5gUHtKRea
	 PmRiriRoZyxZD+i/QkspG+IaBRywmesjbctc5QvBrXRJUE3cVIXYh3eAHvD5AObPmx
	 L27uhRhzSRzK6yF88S1Ejr9KxheHbS7YrwRIWLnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 856/885] RISC-V: add a spin_shadow_stack declaration
Date: Tue,  7 Mar 2023 18:03:10 +0100
Message-Id: <20230307170038.959753678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

commit eb9be8310c58c166f9fae3b71c0ad9d6741b4897 upstream.

The patchwork automation reported a sparse complaint that
spin_shadow_stack was not declared and should be static:
../arch/riscv/kernel/traps.c:335:15: warning: symbol 'spin_shadow_stack' was not declared. Should it be static?

However, this is used in entry.S and therefore shouldn't be static.
The same applies to the shadow_stack that this pseudo spinlock is
trying to protect, so do like its charge and add a declaration to
thread_info.h

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: 7e1864332fbc ("riscv: fix race when vmap stack overflow")
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230210185945.915806-1-conor@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/thread_info.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -43,6 +43,7 @@
 #ifndef __ASSEMBLY__
 
 extern long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE / sizeof(long)];
+extern unsigned long spin_shadow_stack;
 
 #include <asm/processor.h>
 #include <asm/csr.h>


