Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576830;
	b=wuomLdMNrlP461avF9nldXFyT1AvtQQeK/axoVdsskCVUAU59hsqEyIHiBvXFH4qyCCa
	 Q2kk26+pFqHiqTFaeyjPklK+qMOHXkx2osZqCpQ7snwhFBYrisZkR/IOKXfzyWXJUWeAo
	 xIjD5YgB4vsCZerkMXhztnx6Rv/uLTV63i2nLr5olJMcxVENKDvB9+d2cLWUFpLV/otKm
	 jLW8DiHw0N6RT1Q4rGGEx+VsQXh44Ac64B//WUy28gQqqJGFChGbKhKPxHMdfEiK5Lz5R
	 aa2rzcOLl3+L31QOFJGeT1jwRfMjOgktteKDVjwT9fZmE7BAT875gu7HWlE0FRfbxdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iw8tMrXv87yEJfLD/FmuiQuMIPEViBmUCiufzU85Ae0=;
	b=EYZY+SgDos6AM1DIrnioFqp8oo6OUT467Moek39ko4J13eW/bkQzOcOe1TfDwbTzeq4V
	 MQuf/61v6MMpd3zLf8MYkeaaWN5agQINbulmfgC0+O7efXDkqCuKbtnH8WkD4IUWVhWNs
	 GrnCzN97q+wIubGDMjqXXYZzyBulvC15OKyfwbBQQg7TaoHdqUXwBfoOAm9JL6E5huHDd
	 AQ1QQHmEKI1P/hloPf0vm3wzQ6wUaZBMvssgBCOmhMYMXaKRZiH9lQ10WWWUGnG4SJ0tr
	 f9xOywqwijcwCm7eL4GCjgGEybI+h+5zr9JuDCpIRpjEKmKL03sxEsyjkCaiXLu/wQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="YaEHJAo/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFCA606A329;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BFCA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YaEHJAo/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iw8tMrXv87yEJfLD/FmuiQuMIPEViBmUCiufzU85Ae0=; b=YaEHJAo/91OcoFpscsEr5nmSN3
	CYwg5KnX/K6kZP39JcCp+kB3PCaTDC3E5WGR+rMFY46WHQh2/DW9lDBFOZmExgdEWdRCQv03NSKwm
	+Zn3oNq3Mf0XZtywM4oQQcab/7Z7Zo5H7S8zBlS2bdkQFowjCWCImhvV2nvcjjhuDmeHsTb9dNwWu
	rjZHiOU0zNVlUJVA7dP3tNrriZR3aVqiVBLoek4c0eBlKVo2CV/3pnwflzFPHXykH+Ge/yuffWPgF
	oO3W5b3sCFAA3mqobzJBaUiTABgDE/VpatLvMYGzAwcs3E2mHmJX2tFRWqrcs60yjlBCLz26uiIwM
	EketqbOA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGO-0000000FGD8-1BFr;
	Sun, 01 Nov 2026 23:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 1/8] MIPS: mm/c-octeon: fix missing function prototype warnings
Date: Sun,  1 Nov 2026 15:46:50 -0800
Message-ID: <20261101234657.1820661-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101234657.1820661-1-rdunlap@infradead.org>
References: <20261101234657.1820661-1-rdunlap@infradead.org>
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
v2: add the prototypes that I forgot to add (sashiko)

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-edac@vger.kernel.org
Cc: linux-mips@vger.kernel.org

 arch/mips/include/asm/r4kcache.h |    5 +++++
 drivers/edac/octeon_edac-pc.c    |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- linux-next-20261028.orig/arch/mips/include/asm/r4kcache.h
+++ linux-next-20261028/arch/mips/include/asm/r4kcache.h
@@ -31,6 +31,11 @@ extern int mips_sc_init(void);
 extern void (*r4k_blast_dcache)(void);
 extern void (*r4k_blast_icache)(void);
 
+extern int register_co_cache_error_notifier(struct notifier_block *nb);
+extern int unregister_co_cache_error_notifier(struct notifier_block *nb);
+extern void cache_parity_error_octeon_recoverable(void);
+extern void cache_parity_error_octeon_non_recoverable(void);
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
 
