Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88745813C;
	Thu, 30 Nov 2023 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSbf7xJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F99C433C8;
	Thu, 30 Nov 2023 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385108;
	bh=7iRhKYSMmLe1tg+RMmGjPwuoMr67OSKfZwtxWBepaw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RSbf7xJPbKK56JUVqAUYUO8oIGdPx4ZRlYchC9ITqD/F0th+hk817puU9S4FVKQQP
	 v04O/dduboKR+4rm+U8ZLc78xY2ftiTbKRcQ7smc/0BRwl6lQ7Fd+7Rpj3SSoqhcEb
	 N1Tyn9TVTNDIpH6iEg9UWAZeUA+fVbPagqsuTWKkUEpeif8+X5EL4r9zu2/+R6ywnr
	 3MMRQ5FN9lGxdBRBP4kiArwq9AXCfSK5qV4i4OCYvDdKvcL4mlCswLucHMDJxHh8iH
	 q8qvqmjDX+SuvmtMeNnTNvqXypbPmAEtb0lf6WiSbPlLIStMlWWs/cMvvacjPLEgOp
	 bu2MF+uYSd0Rg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:21 -0700
Subject: [PATCH 08/19] hexagon: time: Include asm/time.h for prototypes
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-8-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1306; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7iRhKYSMmLe1tg+RMmGjPwuoMr67OSKfZwtxWBepaw4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn3NCVltoZM2rWXbeOm/0qLytAuBxc+2nf7xpbCVY
 ekViZjPHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiD18y/JXZsj6wbO2LSfrv
 LKa+Pe79teHDm+jHslqlMb2e06VPFqUxMly7ccDt2XMPpgo/bvsbNn8Xn+uqsebfMXFGKcvx5Xc
 2TuIBAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/time.c:118:6: warning: no previous prototype for function 'setup_percpu_clockdev' [-Wmissing-prototypes]
    118 | void setup_percpu_clockdev(void)
        |      ^
  arch/hexagon/kernel/time.c:118:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    118 | void setup_percpu_clockdev(void)
        | ^
        | static
  arch/hexagon/kernel/time.c:135:6: warning: no previous prototype for function 'ipi_timer' [-Wmissing-prototypes]
    135 | void ipi_timer(void)
        |      ^
  arch/hexagon/kernel/time.c:135:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    135 | void ipi_timer(void)
        | ^
        | static

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/time.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index febc95714d75..59f00bf54fe9 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 
 #include <asm/hexagon_vm.h>
+#include <asm/time.h>
 
 #define TIMER_ENABLE		BIT(0)
 

-- 
2.43.0

