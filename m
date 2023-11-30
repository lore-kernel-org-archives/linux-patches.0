Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7055813C;
	Thu, 30 Nov 2023 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rqt92E6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5A7C433C7;
	Thu, 30 Nov 2023 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385108;
	bh=VyEBkAMr19XxUfVVNM6/EkqIIF53FOqlnMqSm0a8uXQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Rqt92E6uT0/WnyJ4KS92FJsF5vlx3r104iY/idRXEwCuaikxmOxZ8O288KJoZOud2
	 peWE12zsP7+NvQCoW7dA5WnmiQOWhW0GqQLmzEDFxZ8OKP9m1uoaxaLOs5ukcf6b0Q
	 jB1DT7BjPIv68x2VyLnDoD2Ns+0axApSdSZK3ADosOU/Dbk4uwtr8ijvQOQvAiU3gZ
	 cvHmYyAxRPcjM7O0xL9WmQr2d9pyBBKCxMeUbGJ/6SAQal3pVHVv4msoH2CQ4iVciH
	 OirV98XHzJ2nLNSUyWJIeTodjRl3XL3ZM63I/zraq8PbdFSp2f/sCJIzUpv/bn118i
	 1tihKXtdgNuiQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:20 -0700
Subject: [PATCH 07/19] hexagon: vm_tlb: Include asm/tlbflush.h for
 prototypes
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-7-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3191; i=nathan@kernel.org;
 h=from:subject:message-id; bh=VyEBkAMr19XxUfVVNM6/EkqIIF53FOqlnMqSm0a8uXQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn2p5345V75VmBu39tkVe6fn/67ey/5/J8OmcZ5wX
 tS6Dy/edZSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJyE5i+J/+1y9Yrjq+hvfT
 437jWQt+lT3YMOfhoa+f53lazdeZHRbM8D8r8K3C/yKuvTPU+w4tOXTRft7bSlb7pV4/bt648ue
 SggkPAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns about several missing prototypes that are declared in this
header:

  arch/hexagon/mm/vm_tlb.c:25:6: warning: no previous prototype for function 'flush_tlb_range' [-Wmissing-prototypes]
     25 | void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
        |      ^
  arch/hexagon/mm/vm_tlb.c:25:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     25 | void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:37:6: warning: no previous prototype for function 'flush_tlb_one' [-Wmissing-prototypes]
     37 | void flush_tlb_one(unsigned long vaddr)
        |      ^
  arch/hexagon/mm/vm_tlb.c:37:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     37 | void flush_tlb_one(unsigned long vaddr)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:47:6: warning: no previous prototype for function 'tlb_flush_all' [-Wmissing-prototypes]
     47 | void tlb_flush_all(void)
        |      ^
  arch/hexagon/mm/vm_tlb.c:47:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     47 | void tlb_flush_all(void)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:56:6: warning: no previous prototype for function 'flush_tlb_mm' [-Wmissing-prototypes]
     56 | void flush_tlb_mm(struct mm_struct *mm)
        |      ^
  arch/hexagon/mm/vm_tlb.c:56:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     56 | void flush_tlb_mm(struct mm_struct *mm)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:66:6: warning: no previous prototype for function 'flush_tlb_page' [-Wmissing-prototypes]
     66 | void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
        |      ^
  arch/hexagon/mm/vm_tlb.c:66:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     66 | void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:78:6: warning: no previous prototype for function 'flush_tlb_kernel_range' [-Wmissing-prototypes]
     78 | void flush_tlb_kernel_range(unsigned long start, unsigned long end)
        |      ^
  arch/hexagon/mm/vm_tlb.c:78:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     78 | void flush_tlb_kernel_range(unsigned long start, unsigned long end)
        | ^
        | static
  6 warnings generated.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/mm/vm_tlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/mm/vm_tlb.c b/arch/hexagon/mm/vm_tlb.c
index 53482f2a9ff9..8b6405e2234b 100644
--- a/arch/hexagon/mm/vm_tlb.c
+++ b/arch/hexagon/mm/vm_tlb.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <asm/page.h>
 #include <asm/hexagon_vm.h>
+#include <asm/tlbflush.h>
 
 /*
  * Initial VM implementation has only one map active at a time, with

-- 
2.43.0

