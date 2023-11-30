Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA761FA9;
	Thu, 30 Nov 2023 22:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQZSRUIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7210DC433C7;
	Thu, 30 Nov 2023 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385109;
	bh=EC0vuuAeHJPjllPHnkv7z61/UfDvwZPVMPYM0xDi5IU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bQZSRUIs4anOPHMaabqoE/10r3k17N228JMxPymOei2d63jdzOVIlZBlBvwr2+Ktk
	 ej4lYyDW9130DVUAzvXvNTYB3a980UDhZiVXyrhYQKU6giG/GVY5XT3bN840+PfX4Q
	 6hAYQS+3Ghodw464etBi/lBQAMTEPzR63gRokDD6i5PcwQ8Fr6IoG3fwc6KC8Qd/BB
	 x0L5pC+AGSZ1HYEq6AZb43czVhVgtk5eem3gNpSqB4LEJdEGx2/MaWyz/fdE25Y3kU
	 PdggElkR4LRM6LVIe6Ri8MKj7oS5Ims9RTsRY1/Wjt0ubu/GRxbdDKtftegqeIHwn4
	 ewYJPDCbOXFZw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:23 -0700
Subject: [PATCH 10/19] hexagon: time: Include asm/delay.h for prototypes
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-10-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1342; i=nathan@kernel.org;
 h=from:subject:message-id; bh=EC0vuuAeHJPjllPHnkv7z61/UfDvwZPVMPYM0xDi5IU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwn1WzKpRx4IzFzZsFfvf2HRnoVG4XK1U4JSmrXN2d
 cSr9kd2lLIwiHExyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgIkcW8jwPygm8bbbVk0bxm4X
 39yAQy+bP3vPjD9mv+tTwzn7qaX3HzIynD/VFXTlfqL9R8b3me/bmX+ncstKiMYZHnD0L5ne42P
 EBgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns about missing prototypes that are declared in this header:

  arch/hexagon/kernel/time.c:209:6: warning: no previous prototype for function '__delay' [-Wmissing-prototypes]
    209 | void __delay(unsigned long cycles)
        |      ^
  arch/hexagon/kernel/time.c:209:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    209 | void __delay(unsigned long cycles)
        | ^
        | static
  arch/hexagon/kernel/time.c:224:6: warning: no previous prototype for function '__udelay' [-Wmissing-prototypes]
    224 | void __udelay(unsigned long usecs)
        |      ^
  arch/hexagon/kernel/time.c:224:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    224 | void __udelay(unsigned long usecs)
        | ^
        | static

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/time.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index f04dbe4f8a4c..f0f207e2a694 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -17,6 +17,7 @@
 #include <linux/of_irq.h>
 #include <linux/module.h>
 
+#include <asm/delay.h>
 #include <asm/hexagon_vm.h>
 #include <asm/time.h>
 

-- 
2.43.0

