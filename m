Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1082961FB1;
	Thu, 30 Nov 2023 22:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Df8a1gRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC6CC433C9;
	Thu, 30 Nov 2023 22:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385105;
	bh=SGbX3slxapmVTtvef9qGjSMQnvHlVDxghjEsVzp976s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Df8a1gRkpKoIi0oSX7ux8tpEJfE2pF0LQNbSdZ/cA/G3ie1TNKM0T/b6KbUpBPTNK
	 3ijvzHpb+R6TaNz/Kx6ucwa164hHsB3stE/Wpme2OaY5RQyYY1w7WT4tQPenngeDCI
	 ncPSXaKmuQerwaJtEJ2fLLs6yhdVwkFB1+Kx4wSGME8mzz5dZkiQomgI3k8yI3EQaG
	 CmjSr+rdkbX7q06fYeH4ER6+ApNQKjmaimPe57ipkx1deIwzAL4P+7LQEuSq1apGKW
	 gFtIVbd2iAXItOygIV3YfWmByukmmFF+K+a8K23CufmrqkH4TEgxIfI9AgQfyFVsgb
	 25SyIlHS1QtOA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:16 -0700
Subject: [PATCH 03/19] hexagon: mm: Include asm/setup.h for
 setup_arch_memory()'s prototype
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-3-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=954; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SGbX3slxapmVTtvef9qGjSMQnvHlVDxghjEsVzp976s=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwr2q8Xk2qz49idvWcPfCTIcbX0t3fstVnhTv/OKiT
 NDSX5w/O0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEMq8zMjRdY7i8zmde//yC
 nftEOjbP+jztZanps8XyXMt/y75hX3SEkeGXdb7+1qYiBguz00+WBkW81PFhrVN4LXVaeHnMNcW
 Pn5gA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/mm/init.c:138:13: warning: no previous prototype for function 'setup_arch_memory' [-Wmissing-prototypes]
    138 | void __init setup_arch_memory(void)
        |             ^
  arch/hexagon/mm/init.c:138:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    138 | void __init setup_arch_memory(void)
        | ^
        | static

The prototype is in asm/setup.h, include it to clear up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/mm/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/mm/init.c b/arch/hexagon/mm/init.c
index f164b377b93b..3458f39ca2ac 100644
--- a/arch/hexagon/mm/init.c
+++ b/arch/hexagon/mm/init.c
@@ -12,6 +12,7 @@
 #include <linux/highmem.h>
 #include <asm/tlb.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/vm_mmu.h>
 
 /*

-- 
2.43.0

