Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774FF7D
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 10:31:50 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3DB2D1EC059E
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 11:31:48 +0100 (CET)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Sat, 12 Feb 2022 11:31:49 +0100
Resent-Message-ID: <YgeMldc5UYF+OmqO@zn.tnic>
Resent-To: patches@lists.linux.dev
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Fri, 11 Feb 2022 17:25:21 +0100
X-Sieve: CMU Sieve 2.4
Received: from h4.fbrelay.privateemail.com (h4.fbrelay.privateemail.com [131.153.2.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 2F2E21EC063D
	for <bp@alien8.de>; Fri, 11 Feb 2022 17:25:16 +0100 (CET)
Received: from MTA-06-3.privateemail.com (mta-06-1.privateemail.com [68.65.122.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id B138B1800BA2
	for <bp@alien8.de>; Fri, 11 Feb 2022 11:25:13 -0500 (EST)
Received: from mta-06.privateemail.com (localhost [127.0.0.1])
	by mta-06.privateemail.com (Postfix) with ESMTP id 2941718000A1;
	Fri, 11 Feb 2022 11:25:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mebeim.net; s=default;
	t=1644596711; bh=6Ha7f3kz/R+A6JdZ7BSXcV6i13FwfVY9kKSUvrpDx5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK61m1awd/3dFIXVCfWF/cm9Ah9sZwTkzqj2ImKMSv9jCQW2oBSVGaYgZrUOGtfhq
	 OXrIdUaG7r/6+BbpASHszVVsIz2e2kCwrijEwm6L5lRpE8IbJl62TGWikSUBB9zIrA
	 +f09TZz47mPehmeY203fi7WOcys5IBxOm/EZWX7gVkIvKr3fZelDPZta0EJM9nmnCO
	 qPkmLwz+5urH4EFB0UKI4coDYOAYry9kaHTwFJmSMV7yOjtWkCuW4iV0/kiFTRnzqe
	 c0FFHCpgY09ycUD8Z9duDZjPfJujL4EuXYGnfnXOQsa/GwlyqHQHp9Oti5c3PPCVTF
	 IsDrIGLi0K67w==
Received: from warhead.local (unknown [10.20.151.152])
	by mta-06.privateemail.com (Postfix) with ESMTPA id 60EF218000A9;
	Fri, 11 Feb 2022 11:25:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mebeim.net; s=default;
	t=1644596711; bh=6Ha7f3kz/R+A6JdZ7BSXcV6i13FwfVY9kKSUvrpDx5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK61m1awd/3dFIXVCfWF/cm9Ah9sZwTkzqj2ImKMSv9jCQW2oBSVGaYgZrUOGtfhq
	 OXrIdUaG7r/6+BbpASHszVVsIz2e2kCwrijEwm6L5lRpE8IbJl62TGWikSUBB9zIrA
	 +f09TZz47mPehmeY203fi7WOcys5IBxOm/EZWX7gVkIvKr3fZelDPZta0EJM9nmnCO
	 qPkmLwz+5urH4EFB0UKI4coDYOAYry9kaHTwFJmSMV7yOjtWkCuW4iV0/kiFTRnzqe
	 c0FFHCpgY09ycUD8Z9duDZjPfJujL4EuXYGnfnXOQsa/GwlyqHQHp9Oti5c3PPCVTF
	 IsDrIGLi0K67w==
From: Marco Bonelli <marco@mebeim.net>
To: bp@alien8.de
Cc: Marco Bonelli <marco@mebeim.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2] x86/head64: Add missing "__head" for sme_postprocess_startup()
Date: Fri, 11 Feb 2022 17:23:50 +0100
Message-Id: <20220211162350.11780-1-marco@mebeim.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YgaBsh6ipzp8aaYX@zn.tnic>
References: <YgaBsh6ipzp8aaYX@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Authentication-Results: mail.skyhub.de
X-Spamd-Bar: ----

This function was previously part of __startup_64(), which is marked
"__head", and is currently only called from there. It also calls
sme_encrypt_kernel(), which is marked as "__init".

Signed-off-by: Marco Bonelli <marco@mebeim.net>
---
 arch/x86/kernel/head64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index de563db9cdcd..4f5ecbbaae77 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -126,7 +126,7 @@ static bool __head check_la57_support(unsigned long physaddr)
 }
 #endif
 
-static unsigned long sme_postprocess_startup(struct boot_params *bp, pmdval_t *pmd)
+static unsigned long __head sme_postprocess_startup(struct boot_params *bp, pmdval_t *pmd)
 {
 	unsigned long vaddr, vaddr_end;
 	int i;
-- 
2.30.2

