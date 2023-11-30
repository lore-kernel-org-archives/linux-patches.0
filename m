Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E6D61FA8;
	Thu, 30 Nov 2023 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNk7lAJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B60C433C9;
	Thu, 30 Nov 2023 22:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385111;
	bh=UVsaiOanWdR5CMSmLZhioGnszmVOScZ/2txfhWSWtfI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UNk7lAJDiFUre/HCzF71IhPzCqJdGV/qGOjjU1/ZkJ+I5qO/DCq6NCFvsoTTRIP23
	 0Hq84ufznmPc7IBPQSfNRpUKq9ennXYyNgaZ9XGuNXQbZQ41AHDx5xhBPtWcTR3SUE
	 okdGr5MA+QTHYm6XdSr7Jgh3WD+8BnByuN69UYgfti2hVoZCGIFkwbaf9W4/HCyiV2
	 W76DbXmULCbje2isfp7nzeqWfWR3iJHZceTCyP4N5aT7SeLyt2R9ZJbLdCr32tD+T6
	 TZ4G2fThwsDYVzfyWlQRzcjQ/jAnTxrma86Xw62hB22okF3M/NuLCVo3jIYTRdmKYt
	 0fxpr9LZwqv4Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:25 -0700
Subject: [PATCH 12/19] hexagon: reset: Include linux/reboot.h for
 prototypes
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-12-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1768; i=nathan@kernel.org;
 h=from:subject:message-id; bh=UVsaiOanWdR5CMSmLZhioGnszmVOScZ/2txfhWSWtfI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn26zWkvFY9lfEw765ZQlPtj243WxRO8RJdvuqJVe
 nX9+UONHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiQt2MDJ9lte9LpomsaPn+
 yE59wZa2wtk5Zbv25W/9fbriRpqh3x6G/14lLMJf2j6u40/M7zJfom3Um12V3cExLW3vaZXV854
 WcgMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/reset.c:9:6: warning: no previous prototype for function 'machine_power_off' [-Wmissing-prototypes]
      9 | void machine_power_off(void)
        |      ^
  arch/hexagon/kernel/reset.c:9:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      9 | void machine_power_off(void)
        | ^
        | static
  arch/hexagon/kernel/reset.c:15:6: warning: no previous prototype for function 'machine_halt' [-Wmissing-prototypes]
     15 | void machine_halt(void)
        |      ^
  arch/hexagon/kernel/reset.c:15:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     15 | void machine_halt(void)
        | ^
        | static
  arch/hexagon/kernel/reset.c:19:6: warning: no previous prototype for function 'machine_restart' [-Wmissing-prototypes]
     19 | void machine_restart(char *cmd)
        |      ^
  arch/hexagon/kernel/reset.c:19:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     19 | void machine_restart(char *cmd)
        | ^
        | static
  3 warnings generated.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/reset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/reset.c b/arch/hexagon/kernel/reset.c
index da36114d928f..efd70a8d2526 100644
--- a/arch/hexagon/kernel/reset.c
+++ b/arch/hexagon/kernel/reset.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/reboot.h>
 #include <linux/smp.h>
 #include <asm/hexagon_vm.h>
 

-- 
2.43.0

