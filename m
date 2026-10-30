Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378827;
	b=gZ7/QEmyi0WssPMYzgTGj693Pj+45L3UC9B3cc+FPirAU3Mr53Ikhr3rA+99ucbgwkhX
	 wZp9RQcDZOnUtN4RbM4no2L2sDt4y76R7/Tdv+Zx8Q0I82oyk6h89ESVSxhZQbWeDVi1/
	 DQ7+TUVVDPdrr6WR0Fo7FtNQ1DAYxYjqrze42uV5zsogWDlVWpcdqz5p9Ak5eZ19wIAq+
	 JWm1SS7+V5B0FfixwR48CG8G4hYwJBDwELqn6/dEPlKgibta+RdoxQUm6HDYuRD/INDYm
	 Y3r59LZjwZn4Ym6Ee3K9vqjN7OjOl3GOg5f53VMCgZcmW48v1PmWvXrKHcbUjVMi5MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378827;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SIjKFuLJxGefDYh25VVpnKhp8QIUropUW4sW2ca/jwM=;
	b=e8ot8D6FnJn4/LI4MZQS4LPxqgfJB9Srp+mZBe6xiTAIbDpP2ioAjE1oR2toHOhaFCQK
	 F+3x7wiGesrGoRjkFbwjPUrxAbLxzGiZ6vQD70kRfSx3hdJP5/ucWmxhn8xWTh902lxrK
	 3dbboSFAOvEMWyD0ernEi4A2uXRENxXXX74Zw124gFzzxAE3BrHmeDHbniDixTMfKJwdq
	 hgSvEHrKEUl60xb/8SRLfKfbH5Lh9JqUG/3pRe6TZQffsvXMnzPZXhlImHwL4RLOtxaXf
	 brMdW7KJiDUUuGOL6+tSjE26+4QFMlYeA7CMdKWlmcpaXEAUOyLCCwcwxnc5cywbt+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=S0wbKgWY;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82934606A320;
	Fri, 30 Oct 2026 16:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82934606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=S0wbKgWY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SIjKFuLJxGefDYh25VVpnKhp8QIUropUW4sW2ca/jwM=; b=S0wbKgWYtC4D/9J5Zo3YSFlHSq
	xDMHIKyFvELtzyXRv/AguKmArTPxSUEJx09JZjKiWZ1RHPL9xGB+iSfwevKl+4CkqNw7iWmr7l9fB
	yJPN3xIRn2SyJ7blfCFXpXJVAS5C/UdklhCyYxlNoQdgIgQJD8o9tMw5pTvi2PNT3bKf44qP9BCds
	OMgv2WiaKBKbxZcNMKmfd4fkkbg/NDF5CuFZBBzoJuoSJSetsxOvXczX9OptvP4aRx5KQWFzyueXL
	1x0RJrQUGYm7s0HOgg5fwolLxlob7G2Zz/GTdb+lSQRCstIAAskMSTszCOP/XLiFtCY2pcduIyir9
	njH45olg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkp-0000000C9vQ-3hLn;
	Fri, 30 Oct 2026 16:46:59 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 5/8] MIPS: Octeon: octeon-platform: fix missing function prototype warning
Date: Fri, 30 Oct 2026 09:46:54 -0700
Message-ID: <20261030164657.2808262-6-rdunlap@infradead.org>
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

Add the missing octeon_fill_mac_addresses() function prototype to
<asm/octeon/octeon.h> and remove the local prototype from setup.c to
eliminate a build warning:

arch/mips/cavium-octeon/octeon-platform.c:701:13: warning: no previous prototype for 'octeon_fill_mac_addresses' [-Wmissing-prototypes]
  701 | void __init octeon_fill_mac_addresses(void)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 arch/mips/cavium-octeon/setup.c       |    2 --
 arch/mips/include/asm/octeon/octeon.h |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- linux-next-20261028.orig/arch/mips/include/asm/octeon/octeon.h
+++ linux-next-20261028/arch/mips/include/asm/octeon/octeon.h
@@ -48,6 +48,7 @@ extern void octeon_user_io_init(void);
 extern void octeon_init_cvmcount(void);
 extern void octeon_setup_delays(void);
 extern void octeon_io_clk_delay(unsigned long);
+void __init octeon_fill_mac_addresses(void);
 
 #define OCTEON_ARGV_MAX_ARGS	64
 #define OCTEON_SERIAL_LEN	20
--- linux-next-20261028.orig/arch/mips/cavium-octeon/setup.c
+++ linux-next-20261028/arch/mips/cavium-octeon/setup.c
@@ -1156,8 +1156,6 @@ void __init prom_free_prom_memory(void)
 	}
 }
 
-void __init octeon_fill_mac_addresses(void);
-
 void __init device_tree_init(void)
 {
 	const void *fdt = NULL;
