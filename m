Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576829;
	b=sp+oc+ydnHxIvQYEakR48wRw91bl522+GLxymPMbcBxUXfgwtydVdyEfWIvHw/xJ+pSk
	 kcAx4CqZXggOeXeWsDf6nPSyMB+b4sDOmpnSuCeqho8qzneIpbZ/ShO7n8ELRGyGimMJr
	 yynKmoivC/G1+bnkLM6+6kq9exAQsJSvLsK0C62RCiGA/8BPUl+IxR/iDdSAqVpMtK29T
	 4klHm+ZKe5h/zKt2t8jyFdJIPgpjTYufOKMVMLhzRygaqBKp/b2bQ2t3O9kh99jiPTJgK
	 kijOsN7IRRhSd2lkwazwafSxg78stfT7gBcaFNlcFAvxrFAS/6+Fp7iCU1Rig1k960w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576829;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hcnX4djeYK0SpDsVXHlBjeqFMbrAduZsiPbBTsAkWkM=;
	b=EodJZc8kgBj9cHyS/TenTyb2YmteW4Ly8JsG+lRRYT58Ffwphtvjc7kszMrDgbRdMuPR
	 eRjl+3BWazi+ZjI9BGYKkzBe1pfN94wgcsM1YN0M4CERD7ShdbA3TZEiBq+xFSWIIwI2x
	 Vd2n3ZMtbrr2ZwSpbeXKrr9BYR6r2BCelA/f+BKOCNarPNC+PEoxQzuNuXx0eFhFAgX4J
	 SAv8+10r9EBcI1NudwoRFASjr1+7IH/TXPWZjPVzZtxaie1NZhsnxF5glAW9qfjR5vk5H
	 BvGQfvfzuH7AMqZpUnbtvZwV0kZfgUTqASz37UDjxrcsB1cIOps0dAUq1x7EMTWiy+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="AiwLAjp/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF03606A326;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BF03606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=AiwLAjp/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hcnX4djeYK0SpDsVXHlBjeqFMbrAduZsiPbBTsAkWkM=; b=AiwLAjp/DAEdzOXU+CKmbn5VeV
	xyT3mYpYORLB5b/ABK5o2PqvLdgiCpZNMAKc8+N8JbKZZSbAGvoIGWEQuISb0L2WBjNo4ntondEAA
	WGHapz/ttXKIWVSvsNW+Q/bHBaCjXnnJXDkiByHDxwrTzXwTlxe6c2CGntE8LtL5h26dLqb3h79o4
	WlX5QqlfomKF7HCJ/Y1XrPfnwhzqDeBhf6X04GARdHzTU7Uhf+/HHk5oXXk+QyZSm8SbwhRAITWZi
	4NQXrNORx+DKvr0O763LH/Pt87ZVWno8vI06qGDE0RhtgQejj8qdP+Hv0bLFEgt4afXUEmFgoYEqk
	CKV1tYQA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGP-0000000FGD8-1c7g;
	Sun, 01 Nov 2026 23:47:01 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 5/8] MIPS: Octeon: octeon-platform: fix missing function prototype warning
Date: Sun,  1 Nov 2026 15:46:54 -0800
Message-ID: <20261101234657.1820661-6-rdunlap@infradead.org>
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

Add the missing octeon_fill_mac_addresses() function prototype to
<asm/octeon/octeon.h> and remove the local prototype from setup.c to
eliminate a build warning:

arch/mips/cavium-octeon/octeon-platform.c:701:13: warning: no previous prototype for 'octeon_fill_mac_addresses' [-Wmissing-prototypes]
  701 | void __init octeon_fill_mac_addresses(void)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

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
