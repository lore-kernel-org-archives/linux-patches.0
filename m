Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A3061FA9;
	Thu, 30 Nov 2023 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqR12Zph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E23C433C9;
	Thu, 30 Nov 2023 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385113;
	bh=H2KgktOmxlFakbDCBg9Lx90ohy51y4EAhksCtcUukEY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TqR12ZphljwBzmKJBc0pYZhXzVSAcMQ6YtYgDfK8yhWTemmwoNyfQLyDmOeCsYtz2
	 QAs8MiEYcHDPEYHYQIn37442lFT02vWuLlZxbtvuUF6mT52RHsAb2MNxsq0wBVvPaY
	 oTusPS0lhnj7/Oob+b2JLS+tOYlfiH4UhfGQJ6WNvNb34hWqplyipLkr649S8jNzfB
	 b1W9RooqP2+/yF4lgaNJjjoRINHoSXRfgqPnglR+qBY+8y+8UBFzDZjdj+0Waj1H8P
	 tcikSND7frxoWoga6BvzSr8CYozydId8nQRsF2kN9YHmmM9QMESoNWmxWQBilzSzjc
	 DdwextR6j1Ywg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:30 -0700
Subject: [PATCH 17/19] hexagon: irq: Add prototype for arch_do_IRQ()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-17-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1030; i=nathan@kernel.org;
 h=from:subject:message-id; bh=H2KgktOmxlFakbDCBg9Lx90ohy51y4EAhksCtcUukEY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwv3pFz6XreH6vskgplLk7RyDxwpnmHeqNZ+2PbvtX
 dNegfA1HaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAixScZGY5Nq1j8XXzpc9UL
 vzce/yq0S8l+m/12KQHNnxv/Lt6frrCA4b+fzmL+z5cuC5767vL7zzqtO21yIYaXvx1zdcjp853
 WZsoDAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/vm_events.c:83:6: warning: no previous prototype for function 'arch_do_IRQ' [-Wmissing-prototypes]
     83 | void arch_do_IRQ(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/vm_events.c:83:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     83 | void arch_do_IRQ(struct pt_regs *regs)
        | ^
        | static

This function is only called from assembly but the irq header is a
reasonable place to put a prototype to silence the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/include/asm/irq.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/hexagon/include/asm/irq.h b/arch/hexagon/include/asm/irq.h
index 1f7f1292f701..a60d26754caa 100644
--- a/arch/hexagon/include/asm/irq.h
+++ b/arch/hexagon/include/asm/irq.h
@@ -20,4 +20,7 @@
 
 #include <asm-generic/irq.h>
 
+struct pt_regs;
+void arch_do_IRQ(struct pt_regs *);
+
 #endif

-- 
2.43.0

