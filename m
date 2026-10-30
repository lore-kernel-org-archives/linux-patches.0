Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378832;
	b=xKefQXIxp5Nk8pM3lFbnBr0doRSclphCsNB7zlGGpcB+GxcEU+e3l8Q/oian9R5JGw/9
	 SXuiZLZ8aWBMi+IxV8l0AtmwPZjXu1pHmsMsnBNskLmOrS/CxAtCiy+h0EZrGtvTWpqTR
	 b4AB/vpO32AqG/FzHJL6ZcF25E6EtvepPX5Dt4EB5Bq0Ux+3P2+kLXu1EcRg+AeHZVFRv
	 eJsKOUktnlTiKBvfoZNW74HDzgtPkWYpWh+6urS+a6NW4oLmJ3ToOqyeL5PBoEAMyNAJN
	 5yb0qJtfLFYDjkchXwEOgnGmTw9IpPVo/Ii+jvoZ/auG6YL5Gb2zWMIxy0/fhk0US+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378832;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jFRMIwMZYfX6rjdCZI0F2E6qbwLWy+pIayUsY0ypjh8=;
	b=EcqHI6Bx5BQ+x6c1zgN44doMw3qnKjKcrMXg4Mh/8UtanWGGdiDDz3UtWaOZXo8c2EsW
	 9skw3QeDSMSNjLHsSPVnirfhtFTtAVMHg+eGb887O+CFZpTiZWn8AtZvQ9k25ptAd5ZS3
	 zTUVemaFBGrcvrNL68KBtvZzNIioCdbYgKRYGEfrCIK6vnzqq0R9o6M0OxwqBDxNbfXoP
	 fGeVnv7WoOAfRb8ZG4WSUmpZFHuv6NSAP/W3E7XSFLjxoYiLGmQuWd5SKQRlcarHjYs3w
	 KSLwM5TfXJfT4f2QkLVqmEjuwNd5wDKrMZYzcDFRP7xq6Wi1RLG1tgdwr48bQqxCscg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=a2XYnDTt;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBAB606A31F;
	Fri, 30 Oct 2026 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CBAB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=a2XYnDTt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jFRMIwMZYfX6rjdCZI0F2E6qbwLWy+pIayUsY0ypjh8=; b=a2XYnDTt8XG1FQ77u1zaEpaI2d
	f49q90cg4znbGmWbaxnQiAuft8gcbvrXLVNFKnF7Qiyn4ptzwDu0gId0gEAbz5+lFCjeOtfDr6LaU
	9yi4qI0mIXYWBktGlMLLmXuugHKyaTZEbn5LmKYe4I7HzhmSCoLwA1O5JGDG8nRKiDw6gHE1NVNeA
	gAphxSAgb/rxZHpVVLCiCPGFXfGwBfpnazNH4E5EI340WDfjrwypcH65qQ1fU89N8ZI/G0lngpQ82
	yki9hlUk0wdsNvWyZ+TN/zXwbNrXh7oNVWJ/dBHH+LW9tourLe5TBZ05ScbViik5K2IhfMEyYruMl
	Wq9EXHIA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkp-0000000C9vQ-1YAO;
	Fri, 30 Oct 2026 16:46:59 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 3/8] MIPS: Octeon: cvmx-interrupt: fix missing function prototype warning
Date: Fri, 30 Oct 2026 09:46:52 -0700
Message-ID: <20261030164657.2808262-4-rdunlap@infradead.org>
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

Add the missing interrupt function prototype to <asm/octeon/cvmx-gmxx-defs.h>
and remove the local prototype from cvmx-interrupt-rsl.c to eliminate
a build warning:

arch/mips/cavium-octeon/executive/cvmx-interrupt-decodes.c:53:6: warning: no previous prototype for '__cvmx_interrupt_gmxx_rxx_int_en_enable' [-Wmissing-prototypes]
   53 | void __cvmx_interrupt_gmxx_rxx_int_en_enable(int index, int block)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 arch/mips/cavium-octeon/executive/cvmx-interrupt-rsl.c |    2 --
 arch/mips/include/asm/octeon/cvmx-gmxx-defs.h          |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- linux-next-20261028.orig/arch/mips/include/asm/octeon/cvmx-gmxx-defs.h
+++ linux-next-20261028/arch/mips/include/asm/octeon/cvmx-gmxx-defs.h
@@ -339,6 +339,7 @@ static inline uint64_t CVMX_GMXX_TX_XAUI
 }
 
 void __cvmx_interrupt_gmxx_enable(int interface);
+void __cvmx_interrupt_gmxx_rxx_int_en_enable(int index, int block);
 
 union cvmx_gmxx_hg2_control {
 	uint64_t u64;
--- linux-next-20261028.orig/arch/mips/cavium-octeon/executive/cvmx-interrupt-rsl.c
+++ linux-next-20261028/arch/mips/cavium-octeon/executive/cvmx-interrupt-rsl.c
@@ -39,8 +39,6 @@
 #define PRINT_ERROR(format, ...)
 #endif
 
-void __cvmx_interrupt_gmxx_rxx_int_en_enable(int index, int block);
-
 /**
  * Enable ASX error interrupts that exist on CN3XXX, CN50XX, and
  * CN58XX.
