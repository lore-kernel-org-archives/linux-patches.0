Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793304809;
	b=AjABszUq3d6AcO4obmT2mtmsYPH562CUxpf/FwZVMQPI8lqcRjf8/oUFR64OnYhWNq2S
	 daFkVeqMx2Bo5O2EZzPG/txVHyZN5oyOpSI7b3dx0hScwoQFcFdXkMFgfECbh+mf5U2iF
	 DRnk5srzZavzLrZkTiCdZs7Sz0ODT9aDjZBO6qChRkQnijqqzOv3S530wCsjqSQyHqq09
	 kXEwauxbExBFNaiJv//aHSX4ZvRKEkMrYXoUOb2GsHGLxlFC0XIrJu5g8D7iLFfptHndO
	 fTRFdsf3AqswefyEp+CpGrYRnyqKTy80D0bKXWn35FzKots0rjNxT8uJidFM0ArhrlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304809;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cm7AnhXk5wAc7XObEF0sJTRKiswy58SF5A5r5BOqqXE=;
	b=0b/BFiHP1HS25KzuAm1gQdpqrwmloYteKH74PE1itNYlKbzAm7CIbCm0BcJziQlS5awW
	 mJovdtHxnf/EfRc0HKcB9E24RQHiPktgLkl4vTw1chW6/ftVSE2bHq05ChTphkac8TbKR
	 XNS4To0gUa034IJzK8a1RL6sPTDS/mx9lTDghtr3IYrcUvzHdsRH+lqbanTsWeBYNGT49
	 nxknYW8A4QAtEVRSeCvtzO+vKTsdK/3aWecjl9d/gPeh7pUw/Dc3ggIvdaVAWhMosjrJN
	 ZbAi7Ihr86sJroNHSZc3ocCneQM3FMy4MwZYm3IS1RdMm78axq42i3TYH1rbhNUzlBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bagtLapK;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E7F606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 20:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68E7F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bagtLapK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cm7AnhXk5wAc7XObEF0sJTRKiswy58SF5A5r5BOqqXE=; b=bagtLapKIDd4nwLH+Y0NvaPPwH
	KRvJ4jY+gus0W47QDqSLtf/JAJkFSUy3Vgkd5HC3jMxDn7/eHquyYBShwdeWdxBfgY105ALiSGD0u
	VmlWXYdPFcAjh9WhZ1VkM/gqrTskgGN3a9lkSR66FQOg6U9RHXIpQTpa+PYWpcvuabHrXxVnKQEWA
	iS/mS3pUGXJMqoZLM7YOpocR4WNhcex4ZB5QH8+vLBV5FHJWjfupRB9ywNn/mZYbOlBAkz6eqmRf1
	xQfWHusIoPxVfBQOtS/Vb5U75QpTTR41OPRNy9KEq9GdtUQRiv21WHssQ7xejNmX3q5gekGUkahg3
	gbdtRzXQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWV5-0000000AJR2-4Bjq;
	Thu, 29 Oct 2026 20:13:28 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geoff Levand <geoff@infradead.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/4] powerpc/ps3: htab.c: fix enum ps3_lpar_vas_id kernel-doc
Date: Thu, 29 Oct 2026 13:13:24 -0700
Message-ID: <20261029201326.2672284-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029201326.2672284-1-rdunlap@infradead.org>
References: <20261029201326.2672284-1-rdunlap@infradead.org>
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

Use the correct enum name and member name to avoid kernel-doc
warnings:

Warning: arch/powerpc/platforms/ps3/htab.c:28 expecting prototype for
 enum lpar_vas_id. Prototype was for enum ps3_lpar_vas_id instead
Warning: arch/powerpc/platforms/ps3/htab.c:28 Enum value
 'PS3_LPAR_VAS_ID_CURRENT' not described in enum 'ps3_lpar_vas_id'
Warning: arch/powerpc/platforms/ps3/htab.c:28 Excess enum value
 '@lpar_vas_id_current' description in 'ps3_lpar_vas_id'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Geoff Levand <geoff@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org

 arch/powerpc/platforms/ps3/htab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20260828.orig/arch/powerpc/platforms/ps3/htab.c
+++ linux-next-20260828/arch/powerpc/platforms/ps3/htab.c
@@ -18,8 +18,8 @@
 #include "platform.h"
 
 /**
- * enum lpar_vas_id - id of LPAR virtual address space.
- * @lpar_vas_id_current: Current selected virtual address space
+ * enum ps3_lpar_vas_id - id of LPAR virtual address space.
+ * @PS3_LPAR_VAS_ID_CURRENT: Current selected virtual address space
  *
  * Identify the target LPAR address space.
  */
