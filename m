Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378826;
	b=f17dGTBPjOKfYrjyf+zHSQ2qMVzDCcZ7BqgpQ4CIMF9CXw4jU0RUbzL1wbBM67cGKT5G
	 nmpODgBXykKZ2v5XNAF2PxIXZ9znH5LNzW0NHCOw0njxO+ZAq4KDE/xD9Qus0UKbLlris
	 1J+LZrre4EUEoR9LMe1PQ6mYOIu5AuDoRy417fs697StcU26SL3eoK4Cn9gGrxFibk3N9
	 mcZ8d8JefL2QnBqRyvk8rt3rVOw/Ch1CEi/e1aokqsdwmV2D8frP6rBhNOvmF3KeskCDQ
	 XlTxoowrekAizBK+M+axPBNeX16TK+xLaqTCzDGEIpJr5ZhXbI0bX/yyfpBS75Jb4eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378826;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ceyD02qD/1W2lVI+RKwnVqOLI7eVygA8LWM+/WVG2fY=;
	b=jJwOyGwSfhe2jG/4U4sp4WFePtZiD9/LkkuKoas6l1rBmSaM/+BDAtG3QYQmWBTI4LbQ
	 3+0viZaFKes1nH9KCWjcg4IgBaK7LlQOiziifFL5H7JXV0XUYbrMcc/wfxS4BN9dTJCBh
	 8fzmlXRcg+yEdg4fE7rK5dW9b08PFzFilr7tNiJ8FLPf5NpatTckTRtYg9a2tj50ICjOl
	 B0L8WZtyYdKKi5fovBoAOInMoy9j4THjse4BzOTEv9Upyq0ZF263LKRGesLo+dY19XpLl
	 fkoW9+vSAezr80+qGgVo5FOQ+yHms5XiN1xvgH3TkQfkll8ff2EMXNsKltOB3qpZIKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=i3Q2NDis;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA4606A31C;
	Fri, 30 Oct 2026 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CAA4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=i3Q2NDis
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ceyD02qD/1W2lVI+RKwnVqOLI7eVygA8LWM+/WVG2fY=; b=i3Q2NDisXkkghOE81u/w/NJBCM
	XwcGoQ6Eo3cNxSmHlyu0W2hzlplj8AwcQk/jLlAxzYmWRot6l/qTIW4hly2EhBSi6xrZU2Sic/uLc
	Ocrjns60Y1kPKyga5LdzmmlcCpnt7maYOnqOxyw3BClsu2+102s2Ls1C+BNXYmmUmoapVExqG70g9
	aZsy+3mArJnzMyXg4wYJ/msjr7CV5hCfBIJhY1wZOyCvdGL9IHT4UMKpkNIbzPNY77NZZmhMv3XJB
	thNW7mmRtELkAUrbQSwpOba+aeN/ReQlNLiRWpHS0IGDIce7mNfoZx6l75R/4nc6vKxgzUwagtwJo
	b1lRMERw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkp-0000000C9vQ-2jXs;
	Fri, 30 Oct 2026 16:46:59 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 4/8] MIPS: c-octeon: fix missing function prototype warning
Date: Fri, 30 Oct 2026 09:46:53 -0700
Message-ID: <20261030164657.2808262-5-rdunlap@infradead.org>
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

Add the missing IPI function prototype to <asm/octeon/octeon.h> and
remove the local prototype from mm/c-octeon.c to eliminate a build warning:

arch/mips/cavium-octeon/smp.c:100:6: warning: no previous prototype for 'octeon_send_ipi_single' [-Wmissing-prototypes]
  100 | void octeon_send_ipi_single(int cpu, unsigned int action)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 arch/mips/include/asm/octeon/octeon.h |    1 +
 arch/mips/mm/c-octeon.c               |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20261028.orig/arch/mips/mm/c-octeon.c
+++ linux-next-20261028/arch/mips/mm/c-octeon.c
@@ -62,7 +62,6 @@ static void local_octeon_flush_icache_ra
  */
 static void octeon_flush_icache_all_cores(struct vm_area_struct *vma)
 {
-	extern void octeon_send_ipi_single(int cpu, unsigned int action);
 #ifdef CONFIG_SMP
 	int cpu;
 	cpumask_t mask;
--- linux-next-20261028.orig/arch/mips/include/asm/octeon/octeon.h
+++ linux-next-20261028/arch/mips/include/asm/octeon/octeon.h
@@ -298,6 +298,7 @@ static inline void octeon_npi_write32(ui
 
 #ifdef CONFIG_SMP
 void octeon_setup_smp(void);
+void octeon_send_ipi_single(int cpu, unsigned int action);
 #else
 static inline void octeon_setup_smp(void) {}
 #endif
