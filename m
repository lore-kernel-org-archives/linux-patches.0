Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378832;
	b=TPk170MsPBm6WQs/nFSc+rVyR4jCwDwwNO0wXQYiikgo6CPpyv/iI78So1WXpJjKdo3H
	 neEnWWzWybHryfhzpP2gB7I8OH+XcTw8qz3rMMxLLExkUP3gPHZNXT+IcxYqZiZEHgrhy
	 uqxr0qBmPEO0ksV9w9ejp1cPp38IL+1bK75XzFgKH0KkLOIY7sKqU/Cqm2rIbm8ebGUjH
	 1fMNZ/uHtCSzOb0cCqF0o2cPSuEWqf8c7w7xaLOHbXRLx/TqxIA7Q8zVj9OQFwpTdo4Kx
	 0IDrd77xGPEe29SkLPLHwVL/YzqtjYW50JhMHGFBb6gYTh/SOlvolQdwBGifANY3aOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378832;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=04m83N1IlMXq6WsWOtwZxzl6XD+UtNwFu0qMu14VGqw=;
	b=WnqIOffW1tYECaUwgwMX9u69t11zVonSKu6d8OsNIyrkmxwGN47jRKYCMfPDXl+sszVO
	 Oe3HUBwtDtL4CSYR0vi2rnWEHfAm9Q68d3AJEj/E1gr/k/29ThtpWGO8ha45b9c2WjHIU
	 cY99SsmGle7tecbGLoqlFy1AQjicQwedi76uKqFktOsKAT7DA9Ub7Y9aGhkzJc5akArDv
	 RjGtpClgXL0Hp64ydwsmX+bl989AzIaIDaWvL/wnKAaqu7ql8ev/9qczFz+2MoUzhN7jW
	 pwU++52Pox9Jz1dzCrTLG6/HEUhCq8U2P9K6GlWn6H95izviebFOOyRn4a52r9fR1MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZsoFnbxB;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9DB606A31A;
	Fri, 30 Oct 2026 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C9DB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZsoFnbxB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=04m83N1IlMXq6WsWOtwZxzl6XD+UtNwFu0qMu14VGqw=; b=ZsoFnbxBAlkv+KtUpwfdoQ1oqu
	PwHtH5qveZ4+fvoA28RY6ONzg317zLbVCQhlsOPo8gjYpjppyl2AjZFvTy+3chdl9ZDoNvc3Ewojr
	+bVVfNRfTJabWoeo2O6q1SBCoBK+gCdFlHS5H7rY/EjojYYD/hTIFyh8iSKbfz2ARmLVtpz4vbBPi
	gCc+6vIfCR22w0uvzG5f455/TLUcoswsav6z6lpWDlu8hfT3pCDHLx9YC1N6WKE/3vOKIcdhI4VxQ
	tfg7eyue/9XsapnDV8QxKRhexud+dlk2EzSDVIGgLvnFIPR7O1pIGcPACVitCdmy090Ei1RaAU2Xz
	vwgLglzw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpko-0000000C9vQ-3mhG;
	Fri, 30 Oct 2026 16:46:58 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 1/8] MIPS: mm/c-octeon: fix missing function prototype warnings
Date: Fri, 30 Oct 2026 09:46:50 -0700
Message-ID: <20261030164657.2808262-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030164657.2808262-1-rdunlap@infradead.org>
References: <20261030164657.2808262-1-rdunlap@infradead.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing cache function prototypes to <asm/r4kcache.h> and remove
2 local prototypes from the edac driver to eliminate build warnings:

arch/mips/mm/c-octeon.c:297:5: warning: no previous prototype for 'register_co_cache_error_notifier' [-Wmissing-prototypes]
  297 | int register_co_cache_error_notifier(struct notifier_block *nb)
arch/mips/mm/c-octeon.c:303:5: warning: no previous prototype for 'unregister_co_cache_error_notifier' [-Wmissing-prototypes]
  303 | int unregister_co_cache_error_notifier(struct notifier_block *nb)
arch/mips/mm/c-octeon.c:342:17: warning: no previous prototype for 'cache_parity_error_octeon_recoverable' [-Wmissing-prototypes]
  342 | asmlinkage void cache_parity_error_octeon_recoverable(void)
arch/mips/mm/c-octeon.c:351:17: warning: no previous prototype for 'cache_parity_error_octeon_non_recoverable' [-Wmissing-prototypes]
  351 | asmlinkage void cache_parity_error_octeon_non_recoverable(void)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-edac@vger.kernel.org
Cc: linux-mips@vger.kernel.org

 arch/mips/include/asm/r4kcache.h |    3 +++
 drivers/edac/octeon_edac-pc.c    |    4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20261028.orig/arch/mips/include/asm/r4kcache.h
+++ linux-next-20261028/arch/mips/include/asm/r4kcache.h
@@ -31,6 +31,9 @@ extern int mips_sc_init(void);
 extern void (*r4k_blast_dcache)(void);
 extern void (*r4k_blast_icache)(void);
 
+extern int register_co_cache_error_notifier(struct notifier_block *nb);
+extern int unregister_co_cache_error_notifier(struct notifier_block *nb);
+
 /*
  * This macro return a properly sign-extended address suitable as base address
  * for indexed cache operations.  Two issues here:
--- linux-next-20261028.orig/drivers/edac/octeon_edac-pc.c
+++ linux-next-20261028/drivers/edac/octeon_edac-pc.c
@@ -19,9 +19,7 @@
 
 #include <asm/octeon/cvmx.h>
 #include <asm/mipsregs.h>
-
-extern int register_co_cache_error_notifier(struct notifier_block *nb);
-extern int unregister_co_cache_error_notifier(struct notifier_block *nb);
+#include <asm/r4kcache.h>
 
 extern unsigned long long cache_err_dcache[NR_CPUS];
 
