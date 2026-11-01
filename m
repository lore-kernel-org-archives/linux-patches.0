Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576830;
	b=uzlb6loQICwIyy2FI33UprLP1zQ+wvIXXsMHn2KTMLy/9CW/0cW8A/pXPPx1yWuKZx+y
	 dWvK5uE5Ja226YfjODGaMksnT1uf2NQ+btBpkFcV0Cds/fiFv5vG5LJYwicASfL7HMF09
	 3YQ8bEYBrWQntK+LELf5qPcoKbWWqy5wlUqTrqLnqWi0x4E5NuQJnhhINbj42UQIVtIrH
	 9qfNE3yZNhUjOC4ohwwxF01w6vSZTm6DBZRZPJYis9AjA8w0U+ONaIlZj+EUjNPWPxaLe
	 mzwf3Nn+1ZcdGPWTq1PY3ftdsKTVCFaETM8lTudfn8AUvfCxNWEc2DrvxddbVWEJCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aVe5M+ceIXwZsicsk9QlaIE77Fhd8XUt6FPXcPseJkk=;
	b=e7C7mstfvMkAIPR0DMU8XCn+4jaulLvMzBrnjj+U7qj3s1148F2mjdCi80tsjU7dKqG3
	 1lJBl7g/1GmBhqJs6M5V8saDEeeArCFo6of8sfhUS2Mow/wrh4LBu2p8HNXlt7AuyXDJg
	 NU+YDtUZue2dALsFiI2pMIBr6PdT/IN3mB0Zjy5trHk8iHaPhG+djGIyjtk8gSY7Arfvm
	 JqlocDOFN4nU49dRa/hL+uMFDAqgVWZjJNZLaLtUqknqRPSSYaVDz9CPSNFKOBZJ7HTbA
	 8u2JXx1Ofc0P/ZpOdlxUZbrFiEVYANUqeCyieZQQEyMeJyPw9750opIyzzUmO++RydQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73BE606A330;
	Sun,  1 Nov 2026 23:47:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A73BE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aVe5M+ceIXwZsicsk9QlaIE77Fhd8XUt6FPXcPseJkk=; b=fiaqUD9eWZfXZrxssE/N0fS2Xd
	2T0jeN2REo+FQa0vA9TzycbfP1qLOXo/zWGvJh+QiGWVsioTO1H3hMERtCLzOM0qydqu8H7CO3RwT
	D1Y6vc1DyierNvPW/LKXcvulJeIOdp0vErgmCopW4zONXCrLR5A9nZfZ/HCQaUFtZ8Vdo4P+ETZyw
	HnSiB5IvZ4ystwDhl/Fs17z5QkCJ4WrOj8M51jnIV2OR03aqBm8+8PuGEkdsIaFwRyz353w1soYCx
	c4OTZU+JhtnW61VHlHXolt494iABzFDjHYLLHrILIFB3NvQDfBqMx/f1YS4kOzwcptJtugMUfO/6h
	/qY3nWIQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGQ-0000000FGD8-0nN6;
	Sun, 01 Nov 2026 23:47:02 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 8/8] MIPS: Octeon: octeon.h: fix missing function prototype warning
Date: Sun,  1 Nov 2026 15:46:57 -0800
Message-ID: <20261101234657.1820661-9-rdunlap@infradead.org>
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

Add the missing octeon_wdt_nmi_stage3() function prototype to
<asm/octeon/octeon.h> to eliminate a build warning:

drivers/watchdog/octeon-wdt-main.c:211:6: warning: no previous prototype for 'octeon_wdt_nmi_stage3' [-Wmissing-prototypes]
  211 | void octeon_wdt_nmi_stage3(u64 reg[32])

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org

 arch/mips/include/asm/octeon/octeon.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20261028.orig/arch/mips/include/asm/octeon/octeon.h
+++ linux-next-20261028/arch/mips/include/asm/octeon/octeon.h
@@ -49,6 +49,7 @@ extern void octeon_init_cvmcount(void);
 extern void octeon_setup_delays(void);
 extern void octeon_io_clk_delay(unsigned long);
 void __init octeon_fill_mac_addresses(void);
+void octeon_wdt_nmi_stage3(u64 reg[32]);
 
 #define OCTEON_ARGV_MAX_ARGS	64
 #define OCTEON_SERIAL_LEN	20
