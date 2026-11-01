Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576830;
	b=fqtjPY0v+QvpzhimftipivgTVB4zdnwHtv8mgKy1JBdVuiCpbiKpRabspSRXdCTc4a44
	 XXvk2zFaF5szJNFCVmr6CAiED+C/gaQndoBLvnZGGgd1uJzr4nSjOA8Qjw2e+vq87hZPs
	 uIMywIRHXRUXpFg0EDCgjyWtiZeONElxz3ZtFKFCfwZBmL4MaI8l1NSQDcVvUSkpv9jTz
	 ku5opD3Cmocy3sQ6DJMlmtPT2KCdT6oLKgXRspaLRlHYpkieDEoKghDGa84rTCvuyAbU+
	 W+/VGXIN77Spduk8Ta2TDMzR+leVinpyn9H/BE1npJhCFtdEal0QBlqWJHGDJyYgUdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iABvmnx8biHsTNwiu9W7lYmmi7QOdUYecJ/DcrfciEw=;
	b=V27bd507UEsGWmZwlOchvSBQgVcYbcsY9Vy93nn2RZFPp1GcckMkYhTVQoEZvGmrw5l4
	 XG10/OpR8OrnJCI/npE8NQC8JTM7uFDwcD1fNfJUEGfxr1iWpwtj3qQdPv/BHHbZ1wwqQ
	 TfOj7vcl4nprljKt+hQFLyilmtAiwBAZZFiY88oVuX3v2+uFoPtawl62+SdndkhZAOvLt
	 WRmbkRovwcwiLbZLgJ2WM6DiasATNM/Dfiqzp3alvVNaB+/j7JjrG2OGL7cD7Wx57HG3V
	 C0orBqRYxEFI01OANUNY0P5KJRpAUIfg3e4TH0BW1SW0/XjLJ5fge2WUq7fJW8nwBhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jIcCwpZL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C18C606A32E;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C18C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jIcCwpZL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iABvmnx8biHsTNwiu9W7lYmmi7QOdUYecJ/DcrfciEw=; b=jIcCwpZLCPTMwexnyY1q0/pi8t
	4lXsJBBJCAtPvJTTml7edW7M6vSrmkQjDChEVL/M5JTJZ4TLCwjEC8+ebVNMvK1XoZc41dCbcSpFi
	u2yyrfx6HPe+BJARH/LOMu3pGxePyJmZq+O/L829Suy41yHlmbAIPQ4gHN2jyg6LeYgWZKsCaT53o
	0HsRECvdSdCArW0OK7+Ep23vbw09/XH5iRkYnLfJ8+fqPQTaiMA99YhzZ+i0KT6cAcZSMIpAREqxs
	RqKzzsXyPSE0hit6g+6uiaOb5f6jl2Pf0z5KuodhBOZCRY5dt3wvTqV+8SV9LIQQRD5IyYnGWXLCu
	nnw8xaQg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGO-0000000FGD8-3Qde;
	Sun, 01 Nov 2026 23:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 3/8] MIPS: Octeon: cvmx-interrupt: fix missing function prototype warning
Date: Sun,  1 Nov 2026 15:46:52 -0800
Message-ID: <20261101234657.1820661-4-rdunlap@infradead.org>
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

Add the missing interrupt function prototype to <asm/octeon/cvmx-gmxx-defs.h>
and remove the local prototype from cvmx-interrupt-rsl.c to eliminate
a build warning:

arch/mips/cavium-octeon/executive/cvmx-interrupt-decodes.c:53:6: warning: no previous prototype for '__cvmx_interrupt_gmxx_rxx_int_en_enable' [-Wmissing-prototypes]
   53 | void __cvmx_interrupt_gmxx_rxx_int_en_enable(int index, int block)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

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
