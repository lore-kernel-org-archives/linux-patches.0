Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E323EC14;
	Thu, 12 Dec 2024 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019127; cv=none; b=T9r9BP8u0T5vGOQmIfIIcJXJ1ubwx+Vamoeec0qkI4ru16tfT4iPZt4VGOZ+eiXrgWKk4BWHmppUDXuxEh0paKLKWHtIVX/x70ZlfK4sGu/Q0j1EXRd1uiAwBihKHTi60AZZcxpDQE/XPLOSFGyprsx+q6gkM6XmOnW+lfdbg28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019127; c=relaxed/simple;
	bh=DU5ZProBw0nO+oAUYS3Wc8GGXZmJIk6YV6a33KTL+qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO9MNcfpThQwmIpsJtUcnxT4/FiV/u5UMgb/+jjnx/PergfSnvqhp9sM2ZdQ71fAIw1wmckeRt7spKwimhklkNR+K5TTQVPPhBMkS8+sFBUtMXtOvoWmKXl29VL+WlrTdX6yyL7sS6zX0rTopqez3IOZ/V1BIAFNP9NdacnTHx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjJavzfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjJavzfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76F3C4CECE;
	Thu, 12 Dec 2024 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019127;
	bh=DU5ZProBw0nO+oAUYS3Wc8GGXZmJIk6YV6a33KTL+qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjJavzfCNBH7Sr3vbXHj6SOV4K2Dg/mottiiO/eFoGvkPkm1DoGmXoNv0BGq+ph41
	 Ip/XJH4V/NCnhYca7REkhEEgVLp05DMG1ISgHX+zjlwwFuw6Xj7tTsxKUBsyBZzsHW
	 oLMOi4xumEj0vLhYHGpQt1qDh/s6j3nQVqBBDZa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/772] microblaze: Export xmb_manager functions
Date: Thu, 12 Dec 2024 15:50:40 +0100
Message-ID: <20241212144353.861899358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



