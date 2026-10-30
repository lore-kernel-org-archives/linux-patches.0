Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378828;
	b=lUTqmBIAoaf1vhG18a7rJt310lODO0/0zG+QbgZNYF0V+A/2i0xYJwluQu8644m4YibK
	 wJsQ0fTTAgwC4bqKu2U3AygvFONCsEADmm2+cvssSxmhYAdcJtjzzV/D7bmCX9nKiKIYN
	 w7EBl1JRik69NQv1pDNv/3WTsVnPzlApQPi6n9iscvS73Ef/tEUUGZrk/wbHcxPCCS8K3
	 EEfVZ/3AZLZCGDx1r2+JlFzrBe+9yzZ4CG2Ek8ssXs2r0709NgFrJbGAnBYFeN9CMPsCs
	 CIRKz4TCbTQWsX/WpJqX7w6vNKPKqX9zA8ZcEC04MgOGNtPN8t9F0hHetRF9wQBRmzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378828;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jHbQL+MbMZA/zMuYfyerMN5HlZZtBCqArbZB2S+HM5Q=;
	b=XTNi42GHyHQ/9LUDEOyVXTq5W5SCXfPnZKfMfhQynTM8REZiuVdfUQhl0J1+QE1EMGJ0
	 VROI5RFnKeAkBO/DFdAPgi7BsokOvLzZfyR9E24CjSTU+q2f98yMZZF2BsdPzLfPryNIy
	 HFg2nyZ7EDH0FJjnN3hfLR50FyuMCN52YGqD7TBl8alNUtMih1L/4BWj24Ge5SASoI/uH
	 zO7nG/7N5lZJWq3+NoFOnu4RsVi0IduODc085dPYiEIEWjoJQ28tO3NPEmIdFSJB3v9CA
	 2UCAoxzLBt+48RySsHDyKueCOmlkRLurADXOdZYw7ryLLEBw+FTUPzClHyCWhtceHLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rtD5Jn4U;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ACC606A323;
	Fri, 30 Oct 2026 16:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82ACC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rtD5Jn4U
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jHbQL+MbMZA/zMuYfyerMN5HlZZtBCqArbZB2S+HM5Q=; b=rtD5Jn4UJ59yMLr+TfmFnMvhM9
	WlBTTOTsd1VRM/QAFskfyXhmWK8jgw2w8ZRGu58Wa76QFrDBYIXWoEgnH/D5eEjoYpY2aSGpd6vjF
	FyChip146x8wfBz0ZsWF4T8q/ZY9tgflmRi016cBGqF3djikYeyyT+yLDqJZrKzmHK6h9rLCMLoXs
	nXpN5eg6vxSDUPEtE9WM0kF1BIFURmx0meGiszivboTBHjUlMSqD8QfrhCFCPEsMm6+Z4I/yrPIig
	5o4LYNJg+vTimFrwhxXIXmTKP1tfND341JYxi3N4ZLv0Mzwd0nIThJL+DaRWvsn2Iu57gKh6nSHUa
	YYn3z55Q==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkq-0000000C9vQ-2Pss;
	Fri, 30 Oct 2026 16:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 8/8] MIPS: Octeon: octeon.h: fix missing function prototype warning
Date: Fri, 30 Oct 2026 09:46:57 -0700
Message-ID: <20261030164657.2808262-9-rdunlap@infradead.org>
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

Add the missing octeon_wdt_nmi_stage3() function prototype to
<asm/octeon/octeon.h> to eliminate a build warning:

drivers/watchdog/octeon-wdt-main.c:211:6: warning: no previous prototype for 'octeon_wdt_nmi_stage3' [-Wmissing-prototypes]
  211 | void octeon_wdt_nmi_stage3(u64 reg[32])

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
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
