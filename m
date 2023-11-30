Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EBE5813C;
	Thu, 30 Nov 2023 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpVXLuZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F28C433CA;
	Thu, 30 Nov 2023 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385107;
	bh=3jTdePnDxDgW+mAOsWvsQgyVchSLgWCm37lJv5Fnu7k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jpVXLuZAbkuKhPkW592SMQNw17/hgMSeiIbkdOwnikY7Iua8SnBkApzQ+SoC7xXdE
	 vzU6Lx9y5S9Ij4vE9lPLKmJczQY8zQzPPuEtOzzJ3aLulTYqhiXI0IY5H74VdUJLuj
	 +dO5TNnKGdUp6VZwUlhlxVkl4bRFyqLlBJetAdnzOuoiZXCCue5gihRxY8uSfrXK1v
	 4P5F/HRHy4pf/mLPpoRzaSQ/OHaE7o0iF/QSF7VPUboLcF7JlWNUu7B9L6zu1mkwdG
	 iSnouAxT4aVzJTIQfSAdQoVWAtjBOzfGvczrj7gOQXarXjdfYsE8W9hmbQ5reHWo6x
	 mXstKKKJo/BfA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:19 -0700
Subject: [PATCH 06/19] hexagon: vm_fault: Include asm/vm_fault.h for
 prototypes
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-6-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1946; i=nathan@kernel.org;
 h=from:subject:message-id; bh=3jTdePnDxDgW+mAOsWvsQgyVchSLgWCm37lJv5Fnu7k=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn0VdcoFLiksskcSYlap8TUcmGUWrLW3do8Y89JvH
 LO+inh1lLIwiHExyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgIn0vGL4p/zAZ96rGefETWc9
 yOx+vJDrw6Xeu6u7C18fyTuTUFqT+peR4blPs51hcK707lP9JzLv3H4haVo6Ibu1fwfPmrUTy9j
 fMgEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/mm/vm_fault.c:157:6: warning: no previous prototype for function 'read_protection_fault' [-Wmissing-prototypes]
    157 | void read_protection_fault(struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:157:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    157 | void read_protection_fault(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/mm/vm_fault.c:164:6: warning: no previous prototype for function 'write_protection_fault' [-Wmissing-prototypes]
    164 | void write_protection_fault(struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:164:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    164 | void write_protection_fault(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/mm/vm_fault.c:171:6: warning: no previous prototype for function 'execute_protection_fault' [-Wmissing-prototypes]
    171 | void execute_protection_fault(struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:171:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    171 | void execute_protection_fault(struct pt_regs *regs)
        | ^
        | static

The prototypes for these functions are defined in asm/vm_fault.h, so
include it to pick them up and silence the warnings.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/mm/vm_fault.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/mm/vm_fault.c b/arch/hexagon/mm/vm_fault.c
index ab0f0a791e00..3771fb453898 100644
--- a/arch/hexagon/mm/vm_fault.c
+++ b/arch/hexagon/mm/vm_fault.c
@@ -12,6 +12,7 @@
  */
 
 #include <asm/traps.h>
+#include <asm/vm_fault.h>
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 #include <linux/sched/signal.h>

-- 
2.43.0

