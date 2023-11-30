Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEED461FA8;
	Thu, 30 Nov 2023 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGtXcu/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE0CC433CA;
	Thu, 30 Nov 2023 22:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385111;
	bh=EdN8Pm6F3yJWgG228GNUTTy5IE1ZyAfvxfmglMzzKn4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KGtXcu/IJwnroeqUYYrNTjmPTZIKUdc6AjmPKuUqwk3CLvE86aFMdWV63hvc2Q9cf
	 sylXoK//NtHnu93W9gDGG9o34DfQ9tel60aWpcMowY4jTQXdlxLJR/0EcJd1nfCbhd
	 wzecEbAVQ6rAHVMAIymKU6Ds2xX+0ZiRv0szWdcizIjWX2suxVbGeK7X2H+RmqPokZ
	 om9nxuD1m9mLhoULt+IOPyvNpkF9nFEleUh9kTJLK4lwGm5ZeD6fHUHobn+ud6iAqk
	 /Rh5vZJMBed2klYBbovyh9Rou2Ew+p9sqjR5ZI/CLbo2lmfV13LNsxDnCmmnTnHwx6
	 z6dhHx/FUuYGw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:26 -0700
Subject: [PATCH 13/19] hexagon: process: Include linux/cpu.h for
 arch_cpu_idle() prototype
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-13-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1057; i=nathan@kernel.org;
 h=from:subject:message-id; bh=EdN8Pm6F3yJWgG228GNUTTy5IE1ZyAfvxfmglMzzKn4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn03emYc/7/68cv1wam/Vx/xddBi6liiXDjn/MH34
 Ud/T6sy7ChlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQAT2RLH8E+JaTZH8l+hS37+
 97JnGPZ/VNv3fcKpW2s/GBS/XvFpofFlhv95Hy+yH3h0J0rkhM/DNKldTa4Pxd6qt721fPlX7yy
 3WA03AA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/process.c:43:6: warning: no previous prototype for function 'arch_cpu_idle' [-Wmissing-prototypes]
     43 | void arch_cpu_idle(void)
        |      ^
  arch/hexagon/kernel/process.c:43:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     43 | void arch_cpu_idle(void)
        | ^
        | static

This prototype is declared in include/linux/cpu.h, include it in
process.c to clear up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index dd7f74ea2c20..51e37fc92857 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/cpu.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task.h>

-- 
2.43.0

