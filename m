Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9766911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7785C433C8;
	Mon, 28 Aug 2023 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218341;
	bh=2H0mnyFDVAEAHfeyMwT9IpvMUvIzPDoBa+1rcr6mfC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6LuPHoIM51a/e09ua+80CyG0wjJYTTHgZNoP6jnNTfbVoehGJNXT+Ng/4trki8yE
	 TkZTGC+zQVJAz8/0huerbJAzpe/Cupf7fICqeS30l29XJC3efG6H3g+IrdkXx8oFTy
	 owYZ57qX1A9Y/p7E10twFddsCKvLoeObb3WmLEHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/129] powerpc/mm: move platform specific mmu-xxx.h in platform directories
Date: Mon, 28 Aug 2023 12:11:59 +0200
Message-ID: <20230828101153.992304071@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 994da93d196866f914c9d64aafb86e95e3decbb2 ]

The purpose of this patch is to move platform specific
mmu-xxx.h files in platform directories like pte-xxx.h files.

In the meantime this patch creates common nohash and
nohash/32 + nohash/64 mmu.h files for future common parts.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Stable-dep-of: 66b2ca086210 ("powerpc/64s/radix: Fix soft dirty tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mmu.h                | 14 ++------------
 .../include/asm/{ => nohash/32}/mmu-40x.h     |  0
 .../include/asm/{ => nohash/32}/mmu-44x.h     |  0
 .../include/asm/{ => nohash/32}/mmu-8xx.h     |  0
 arch/powerpc/include/asm/nohash/32/mmu.h      | 19 +++++++++++++++++++
 arch/powerpc/include/asm/nohash/64/mmu.h      |  8 ++++++++
 .../include/asm/{ => nohash}/mmu-book3e.h     |  0
 arch/powerpc/include/asm/nohash/mmu.h         | 11 +++++++++++
 arch/powerpc/kernel/cpu_setup_fsl_booke.S     |  2 +-
 arch/powerpc/kvm/e500.h                       |  2 +-
 10 files changed, 42 insertions(+), 14 deletions(-)
 rename arch/powerpc/include/asm/{ => nohash/32}/mmu-40x.h (100%)
 rename arch/powerpc/include/asm/{ => nohash/32}/mmu-44x.h (100%)
 rename arch/powerpc/include/asm/{ => nohash/32}/mmu-8xx.h (100%)
 create mode 100644 arch/powerpc/include/asm/nohash/32/mmu.h
 create mode 100644 arch/powerpc/include/asm/nohash/64/mmu.h
 rename arch/powerpc/include/asm/{ => nohash}/mmu-book3e.h (100%)
 create mode 100644 arch/powerpc/include/asm/nohash/mmu.h

diff --git a/arch/powerpc/include/asm/mmu.h b/arch/powerpc/include/asm/mmu.h
index 13ea441ac5319..2b396de45e9ec 100644
--- a/arch/powerpc/include/asm/mmu.h
+++ b/arch/powerpc/include/asm/mmu.h
@@ -326,18 +326,8 @@ static inline void mmu_early_init_devtree(void) { }
 #if defined(CONFIG_PPC_STD_MMU_32)
 /* 32-bit classic hash table MMU */
 #include <asm/book3s/32/mmu-hash.h>
-#elif defined(CONFIG_40x)
-/* 40x-style software loaded TLB */
-#  include <asm/mmu-40x.h>
-#elif defined(CONFIG_44x)
-/* 44x-style software loaded TLB */
-#  include <asm/mmu-44x.h>
-#elif defined(CONFIG_PPC_BOOK3E_MMU)
-/* Freescale Book-E software loaded TLB or Book-3e (ISA 2.06+) MMU */
-#  include <asm/mmu-book3e.h>
-#elif defined (CONFIG_PPC_8xx)
-/* Motorola/Freescale 8xx software loaded TLB */
-#  include <asm/mmu-8xx.h>
+#elif defined(CONFIG_PPC_MMU_NOHASH)
+#include <asm/nohash/mmu.h>
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/include/asm/mmu-40x.h b/arch/powerpc/include/asm/nohash/32/mmu-40x.h
similarity index 100%
rename from arch/powerpc/include/asm/mmu-40x.h
rename to arch/powerpc/include/asm/nohash/32/mmu-40x.h
diff --git a/arch/powerpc/include/asm/mmu-44x.h b/arch/powerpc/include/asm/nohash/32/mmu-44x.h
similarity index 100%
rename from arch/powerpc/include/asm/mmu-44x.h
rename to arch/powerpc/include/asm/nohash/32/mmu-44x.h
diff --git a/arch/powerpc/include/asm/mmu-8xx.h b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
similarity index 100%
rename from arch/powerpc/include/asm/mmu-8xx.h
rename to arch/powerpc/include/asm/nohash/32/mmu-8xx.h
diff --git a/arch/powerpc/include/asm/nohash/32/mmu.h b/arch/powerpc/include/asm/nohash/32/mmu.h
new file mode 100644
index 0000000000000..af0e8b54876ab
--- /dev/null
+++ b/arch/powerpc/include/asm/nohash/32/mmu.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_NOHASH_32_MMU_H_
+#define _ASM_POWERPC_NOHASH_32_MMU_H_
+
+#if defined(CONFIG_40x)
+/* 40x-style software loaded TLB */
+#include <asm/nohash/32/mmu-40x.h>
+#elif defined(CONFIG_44x)
+/* 44x-style software loaded TLB */
+#include <asm/nohash/32/mmu-44x.h>
+#elif defined(CONFIG_PPC_BOOK3E_MMU)
+/* Freescale Book-E software loaded TLB or Book-3e (ISA 2.06+) MMU */
+#include <asm/nohash/mmu-book3e.h>
+#elif defined (CONFIG_PPC_8xx)
+/* Motorola/Freescale 8xx software loaded TLB */
+#include <asm/nohash/32/mmu-8xx.h>
+#endif
+
+#endif /* _ASM_POWERPC_NOHASH_32_MMU_H_ */
diff --git a/arch/powerpc/include/asm/nohash/64/mmu.h b/arch/powerpc/include/asm/nohash/64/mmu.h
new file mode 100644
index 0000000000000..87871d027b75e
--- /dev/null
+++ b/arch/powerpc/include/asm/nohash/64/mmu.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_NOHASH_64_MMU_H_
+#define _ASM_POWERPC_NOHASH_64_MMU_H_
+
+/* Freescale Book-E software loaded TLB or Book-3e (ISA 2.06+) MMU */
+#include <asm/nohash/mmu-book3e.h>
+
+#endif /* _ASM_POWERPC_NOHASH_64_MMU_H_ */
diff --git a/arch/powerpc/include/asm/mmu-book3e.h b/arch/powerpc/include/asm/nohash/mmu-book3e.h
similarity index 100%
rename from arch/powerpc/include/asm/mmu-book3e.h
rename to arch/powerpc/include/asm/nohash/mmu-book3e.h
diff --git a/arch/powerpc/include/asm/nohash/mmu.h b/arch/powerpc/include/asm/nohash/mmu.h
new file mode 100644
index 0000000000000..a037cb1efb57e
--- /dev/null
+++ b/arch/powerpc/include/asm/nohash/mmu.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_NOHASH_MMU_H_
+#define _ASM_POWERPC_NOHASH_MMU_H_
+
+#ifdef CONFIG_PPC64
+#include <asm/nohash/64/mmu.h>
+#else
+#include <asm/nohash/32/mmu.h>
+#endif
+
+#endif /* _ASM_POWERPC_NOHASH_MMU_H_ */
diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
index 8d142e5d84cd0..5fbc890d10943 100644
--- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
+++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
@@ -17,7 +17,7 @@
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/ppc_asm.h>
-#include <asm/mmu-book3e.h>
+#include <asm/nohash/mmu-book3e.h>
 #include <asm/asm-offsets.h>
 #include <asm/mpc85xx.h>
 
diff --git a/arch/powerpc/kvm/e500.h b/arch/powerpc/kvm/e500.h
index 94f04fcb373e1..962ee90a0dfea 100644
--- a/arch/powerpc/kvm/e500.h
+++ b/arch/powerpc/kvm/e500.h
@@ -20,7 +20,7 @@
 #define KVM_E500_H
 
 #include <linux/kvm_host.h>
-#include <asm/mmu-book3e.h>
+#include <asm/nohash/mmu-book3e.h>
 #include <asm/tlb.h>
 #include <asm/cputhreads.h>
 
-- 
2.40.1



