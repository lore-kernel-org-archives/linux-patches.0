Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576830;
	b=VTw8NHEbvDLpVF+3iBlti9eCKBoPQRMpVDCzoYYVzVd+XNXfcCvOvQD9RTe2zLYlySY0
	 jNV7NRtrNW+WNAi7JhXQ+5YjeyCz3k8vxoTqQOqiW1oHO1xfEXFaY/YU4Rb3/+I0ymBKZ
	 vcqbINzf+TFoAR6L/CU4SaGKbbeUBMowybuDaOcS02z7jcj2y6u0uR0nGdzcQs69EP63S
	 bjkS29ggpXuvyM6+WbjMnEH/B1CEHzbTxRuoq3SPcJhcCflC6Sl7RNJkLStZMFu2X4tmx
	 HqTukHC59ezlpiDaaAZ/OGohilqv2r5kK7NNNe8rTsEDwuUytU+QemncecFEtwC4vqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=W823g+HWu0Z2BJIzugixvNKPAupqiS0l97ePX+3gs28=;
	b=V3YLt72N7HulUGE+afkt3D/BYGAb0FGRXTNtL42Fu0KrPejg8zRljfhowmJKOHZ8mzCA
	 3tWqqn4/fa929d/dv6rh3T7TeN4Uh7bcrRtcDNABukLEIUPLlV1tWJpmCxLufGI+6dPHe
	 Esozdku0XOhwVDAurbAHUn3Rrru57ibjZL0QAOEefsh1i4V9AtbfApwrS6Rs0nQl+3tzE
	 MsbCHWAbjL4vk1kuxXFhlQSWLD82cv4Zt17RIyf6kKBwXFCd9eVt5gEzm1ZFMniC8ryrS
	 easKvINrpwrvcMeQJWx74fDwKnwzfYT3+HyQxRLLMwwLt7rXmjt3UvdFi1vU47GjgGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TuEPwhZv;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C16E606A32D;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C16E606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TuEPwhZv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W823g+HWu0Z2BJIzugixvNKPAupqiS0l97ePX+3gs28=; b=TuEPwhZvlUgo2FHZ28mofXGa/2
	Sr1GCtSSXAztXDl62C69CAfc3R4/3PtSRLZrEK3bM+/wLehkqR85qHGAOCuEoZeQV22sP22HegU6Y
	TLmPIDiF5YOp6Uxaje0DS4siGE7uH6xKbmw5x9nQPldBQ08yFwpYvw5QodECfP6ex7mCxai2t9zD3
	LW8jf0d8rdil4De5Mh2tP6kYRfyWpV4BIawoVRyiZERvW783XkN2S0K90SS8IxDlPOLkk4R4ycQZ5
	lYckd6ausSViE+TQjm3e27PJCGS3tKhKl2cm+PvT41wxBwTB0xk83dnxu7bFTRe+Ppy7yi1tUxMQy
	Ys7cpqSQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGP-0000000FGD8-0O9h;
	Sun, 01 Nov 2026 23:47:01 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 4/8] MIPS: c-octeon: fix missing function prototype warning
Date: Sun,  1 Nov 2026 15:46:53 -0800
Message-ID: <20261101234657.1820661-5-rdunlap@infradead.org>
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

Add the missing IPI function prototype to <asm/octeon/octeon.h> and
remove the local prototype from mm/c-octeon.c to eliminate a build warning:

arch/mips/cavium-octeon/smp.c:100:6: warning: no previous prototype for 'octeon_send_ipi_single' [-Wmissing-prototypes]
  100 | void octeon_send_ipi_single(int cpu, unsigned int action)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

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
