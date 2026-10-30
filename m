Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378826;
	b=G3IgYNCxncezEtOzhJn5C2ByaKCUTCiHZ12wqHIYXKUjAFd8tCIefqP2ARbLO0DechyW
	 zOLsCL+f7IVDCCguvNKvl0v4vMSfxLYYXDKXDOpWbTikhhjztmH7awLvOc+97dgk+lp0P
	 vZY93CX8sCQa+EEcfp2YEpw1ijK0Ak2e734QbKVFbR3R/ZADm4iihCHVOdfDPCOa/By+j
	 SwsWJe4fnBCp5VB3LES/2lwiYS2iDfvBiV7D1Ts4oTGPCOmikLEn5aEOV0c5iiVWj0AIK
	 IZ2eKxFwwFwbMyF+o5Zd2A8dUFUs09di3KOFNJCM1lNIqzNWNb6HKk5bEP0nA9mW1Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378826;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Q/wiJjG67NUjUqOdEl7qK8HsyH5Ucf+j1POGNfCKhKo=;
	b=1d+8FYX8s9YXTBunsUzfXNms1YbPinK9iaPwRotWdK3YsnBezot766raux0450DADyT+
	 4ePktJensjyrXAO0ga2XR1Y9IJsl1jx3SU2ajVBcN7FFJTtY0ZMSojca02XNWsQjlV7K2
	 4nCL+w1FJlRrMpNbXbf4wUpV55xIK8yuI7vrslyW6K0TfecWOmvLl+GztBw+lguwvk04d
	 y38ylYewcNLmvZnC6RdactcyYvESx/1+VfZBwz1vZoPkrimyMukvJMGbtIoErJYkDwJwT
	 mCCb9SyV58BKZ+EJP+skpEf0PlLOHFITW6aeyrihvfyM3p6sdvI6Cns4gBqM0d+yONQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0PMKCuFU;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB6D606A31E;
	Fri, 30 Oct 2026 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CB6D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0PMKCuFU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q/wiJjG67NUjUqOdEl7qK8HsyH5Ucf+j1POGNfCKhKo=; b=0PMKCuFUyceLQ23jiv3MPch0xv
	E89b2EAIXbpQrLjHao16JL3JvHela8qiCmfORA+YtHTcuwNPqiZo8PAiL2w/NJkIyNXVjkx0vmTYc
	lwaVz78zE+mAPuZRZiIACBtLWdONO9yiwaOEM6WjCTbjQ5UW7GuQUmcjkGY+lC6FrKvDPMYxRhD5o
	8sPLmPIskp+5UgxwnvP9Oh63ke9w6q4rW1P+egonUMBBMwhiCv6tMRp4qTL5w4CCr3v4CqlZzq+4h
	anK0FrRUl40FTp3J29tKPDEQ/9WUNmdYGpNCteKWbiV9QGYGfPGhuF1BcHwEtpjiJW6WlPTJ69z4i
	Rh4XIaCQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkp-0000000C9vQ-0a4Y;
	Fri, 30 Oct 2026 16:46:59 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 2/8] MIPS: Octeon: cvmx-helper: fix missing function prototype warning
Date: Fri, 30 Oct 2026 09:46:51 -0700
Message-ID: <20261030164657.2808262-3-rdunlap@infradead.org>
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

The missing function prototype is already in cvmx-helper-errata.h.
Use that header file in cvmx-helper.c and cvmx-helper-errata.c
to eliminate a build warning:

arch/mips/cavium-octeon/executive/cvmx-helper-errata.c:49:6: warning: no previous prototype for '__cvmx_helper_errata_qlm_disable_2nd_order_cdr' [-Wmissing-prototypes]
   49 | void __cvmx_helper_errata_qlm_disable_2nd_order_cdr(int qlm)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 arch/mips/cavium-octeon/executive/cvmx-helper-errata.c |    1 +
 arch/mips/cavium-octeon/executive/cvmx-helper.c        |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20261028.orig/arch/mips/cavium-octeon/executive/cvmx-helper.c
+++ linux-next-20261028/arch/mips/cavium-octeon/executive/cvmx-helper.c
@@ -42,6 +42,7 @@
 #include <asm/octeon/cvmx-spi.h>
 #include <asm/octeon/cvmx-helper.h>
 #include <asm/octeon/cvmx-helper-board.h>
+#include <asm/octeon/cvmx-helper-errata.h>
 
 #include <asm/octeon/cvmx-pip-defs.h>
 #include <asm/octeon/cvmx-asxx-defs.h>
--- linux-next-20261028.orig/arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
+++ linux-next-20261028/arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
@@ -37,6 +37,7 @@
 
 #include <asm/octeon/octeon.h>
 
+#include <asm/octeon/cvmx-helper-errata.h>
 #include <asm/octeon/cvmx-helper-jtag.h>
 
 /**
