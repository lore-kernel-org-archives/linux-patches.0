Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576830;
	b=0OjriHmByHwN1lM1tnRRR9yn5E4JRLNaX4Chg2aUItrYcvzUvKf873ntgSrJdUjA1w2U
	 DLEVjeJBStk245vwiJaGX30FB2tibNLuzssH7tghvPw7CwuTIQ9UnUCDCUCjDgXd9tZuz
	 pChVbsMMS8ojihVog+vDXu5NwCXdwCvDhROWZAHSQWd81eMbD6ICRX61Hyr0GzydN+gtW
	 j+u77Iz341Fhaq4wd0tAJ6s5TwYrJYeidjD4eONxkr2nByORFeGkdjbz+YCL24H90eDui
	 Qux5E22y+GdDYi8rx3Vmg4ph1VQC014TmWJvhG4SEpBYUBt/68ToCOBitI58lluK0oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LKioqDMC3xU2l9aGKxQySOAbKbM1ak4QmbvG8jrOOtg=;
	b=DL+WTBkj5YkKISvQIiiR8JefVvEdmfSwRPu2tXDepwEXWPKjmdivRR4kF3p8SNOSPAxQ
	 7KdoppoBF5OlNnPcHWUmk8QPO4uIaR1VsMO4tY844faMeXT0fHDD9AIK6peBg/h5PnUWu
	 nYR2JplxUMtAfAoW1iALTd6ndQrzf92mCDDiZjvZgQ8/bPBlpuNEC/RFGaRr2iI4hfW7h
	 bSkvsT7H0DreTexwo59umrISo4qDcG2AT0YejmHE0zRgv5o0Aw0aW3G4jJIaxfEPav8G2
	 Furjks4vKhPHh0UtPe3qZgai13Eo6HycGKKb6zDINB66hgX4id3vVPoJTrfY6jNPDOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LPphV+Lg;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE81606A324;
	Sun,  1 Nov 2026 23:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BE81606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LPphV+Lg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LKioqDMC3xU2l9aGKxQySOAbKbM1ak4QmbvG8jrOOtg=; b=LPphV+LghTprV6ehsGNciQnupJ
	dQPyNRGNdUQF2USg906mrHf2y3LE1TAheTIWsJpX6CLUAVh97ZX6Dy6y3kmTkPgFDeMGgkuke0/iV
	yZAzGBiLg+wUx2oyqKQ0toh77y61dgxRMvOyVDY0DUg8ZEVNuY2SYgr9Y3v6BXwoLsBE5In2+QSy7
	ImsKYVkRBaTeap7mQYkrhVvIOHtv7EX8J+1qsPl8ASq3ts3s7h/OtD7bcXs9SrkxR9Hwxpb/95bhp
	bqUQLYvC8wtzY9+e/SL8ON3aAZ+t04Hl3FPu+EUO5HV0XYozF6gGnoz2alhj32DuxOiYsV1pLQbc0
	uWGtvS/g==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGO-0000000FGD8-2Jxa;
	Sun, 01 Nov 2026 23:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 2/8] MIPS: Octeon: cvmx-helper: fix missing function prototype warning
Date: Sun,  1 Nov 2026 15:46:51 -0800
Message-ID: <20261101234657.1820661-3-rdunlap@infradead.org>
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

The missing function prototype is already in cvmx-helper-errata.h.
Use that header file in cvmx-helper.c and cvmx-helper-errata.c
to eliminate a build warning:

arch/mips/cavium-octeon/executive/cvmx-helper-errata.c:49:6: warning: no previous prototype for '__cvmx_helper_errata_qlm_disable_2nd_order_cdr' [-Wmissing-prototypes]
   49 | void __cvmx_helper_errata_qlm_disable_2nd_order_cdr(int qlm)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

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
