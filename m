Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB161FA8;
	Thu, 30 Nov 2023 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/HdNAJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4875AC433C7;
	Thu, 30 Nov 2023 22:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385112;
	bh=SyeQxpwEYp0veTEP/7Rc3L91GqBR2jtDAMQTWPD7lrg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X/HdNAJwtn51jVsXbRV0W4LAUtqWiOSwszcXGUPIsdDwpRuez17Z0zvAEf3xBnq+C
	 EpD64o26KsiOzryLuaSWtX33UMXIOp+6hLes+Pn5/N7g63qDwkXUdnCy6nrs76dQ35
	 avliyNLLp0ZO4nb75ufM0U7yHYzE87bhJnLXiMVDv7IHlgrbJ0Hc9hK1mY/qCJ9gAd
	 C4HIsdpdOuxKcbFomtqJytiyK9AVgc1lW1YiIjlGAUWtBRgluEQ43U5jDRSEo2XfXZ
	 NBAPbAcsIDWj/w/zxWeY4pAJVUaNcFO2tXkSpp/ZeTE3XXGCflaigLFnABtgaTAoTs
	 /5ANLOuOm6FCg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:28 -0700
Subject: [PATCH 15/19] hexagon: vdso: Include asm/elf.h for
 arch_setup_additional_pages() prototype
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-15-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1093; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SyeQxpwEYp0veTEP/7Rc3L91GqBR2jtDAMQTWPD7lrg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwv27gxSb3288E/BC1G1XhYzkNpOiKp8iXyX2/vM71
 PawC13oKGVhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABPxf8zwV27+dM1Z72T5DK3Z
 EnsNJfed80y6fuXd6jsreRKyXVfl/mT4Zx70/xh3ec46q86UoAqPZaXivdflDwfM0lM9c01t58d
 WRgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/vdso.c:49:5: warning: no previous prototype for function 'arch_setup_additional_pages' [-Wmissing-prototypes]
     49 | int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
        |     ^
  arch/hexagon/kernel/vdso.c:49:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     49 | int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
        | ^
        | static
  1 warning generated.

Include the header that declares the prototype to clear up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/vdso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/vdso.c b/arch/hexagon/kernel/vdso.c
index b70970ac809f..2e4872d62124 100644
--- a/arch/hexagon/kernel/vdso.c
+++ b/arch/hexagon/kernel/vdso.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/binfmts.h>
 
+#include <asm/elf.h>
 #include <asm/vdso.h>
 
 static struct page *vdso_page;

-- 
2.43.0

