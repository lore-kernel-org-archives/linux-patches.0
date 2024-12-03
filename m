Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C2A1FA16E;
	Tue,  3 Dec 2024 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240441; cv=none; b=F3pBJ91Yx0kLz/hIrjPejJfKuoNA9d63Rn99Qy8B6m248k3cLrRW9FZ2f+WkKNGrso5FAtQfBM02XqV4JBPNYsM9dqM2ju13WT4VIyaILLQKPVwRsXER+ruRJiFBwszKgtkVlKJS8xBYAiqVUkGqGVme43kV0w4Q/Q9E8siQD8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240441; c=relaxed/simple;
	bh=FfdZBBmdo5lp2AiVOOYueXX+UW5pljWekEXbQ7dlVjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUM0et47zJEaSM/SvZ1/MaXXVo3qix2C6F/Im0UeBRc5AQHn17HJsyBKHVqMPbYMrGzXc69veBfEDvxeISlWquieQlXWK0LfEcWELyvq/9t07BeoY+wyrDPBhNA7jPHIj6AzRSMJExLEWEbhC5uBA2azplQj6Qtm9b4W0nSYsEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6aHJcP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6aHJcP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F442C4CECF;
	Tue,  3 Dec 2024 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240441;
	bh=FfdZBBmdo5lp2AiVOOYueXX+UW5pljWekEXbQ7dlVjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6aHJcP9szuQgvjtR1G1I6aGgeepNr0HhCTAoM1jsNeAwMCshDaCrIN24H/JAs6/0
	 etCMOGaf9pLzpq7hhXPqJCnYeg/za749pSRCnPEHQMOeUgSn6o12Q4t/35lvNGj/Y2
	 eWO16VcBToql14HNuIRQAOC1RCSXUD1QOnFJLVL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/826] microblaze: Export xmb_manager functions
Date: Tue,  3 Dec 2024 15:37:11 +0100
Message-ID: <20241203144747.800616374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit badf752b5e4b17d281f93f409d4718388ff912e6 ]

When TMR_MANAGER is enabled as module there is a need to export functions
which are present in architecture code.

It has been found by running:
make W=1 C=1 allmodconfig
sed -i -e 's/WERROR=y/WERROR=n/g' .config
make C=1 W=1

which errors out like this:
ERROR: modpost: "xmb_manager_register" [drivers/misc/xilinx_tmr_manager.ko] undefined!
ERROR: modpost: "xmb_inject_err" [drivers/misc/xilinx_tmr_inject.ko] undefined!

Fixes: a5e3aaa654c1 ("microblaze: Add xmb_manager_register function")
Reported-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/e322dbbbde0feef83f44304ea13249d365d1dc5f.1718799090.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/microblaze_ksyms.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
index c892e173ec990..a8553f54152b7 100644
--- a/arch/microblaze/kernel/microblaze_ksyms.c
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -16,6 +16,7 @@
 #include <asm/page.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
+#include <asm/xilinx_mb_manager.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
 extern void _mcount(void);
@@ -46,3 +47,12 @@ extern void __udivsi3(void);
 EXPORT_SYMBOL(__udivsi3);
 extern void __umodsi3(void);
 EXPORT_SYMBOL(__umodsi3);
+
+#ifdef CONFIG_MB_MANAGER
+extern void xmb_manager_register(uintptr_t phys_baseaddr, u32 cr_val,
+				 void (*callback)(void *data),
+				 void *priv, void (*reset_callback)(void *data));
+EXPORT_SYMBOL(xmb_manager_register);
+extern asmlinkage void xmb_inject_err(void);
+EXPORT_SYMBOL(xmb_inject_err);
+#endif
-- 
2.43.0



