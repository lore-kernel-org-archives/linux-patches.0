Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793304808;
	b=hiqstR2nugPlbjcHDFgnWYTAfEcRZjarJUxCcJ/bIypoXhZzRwM4iFf8OtAWfT8yFzYG
	 ecUoF+srXXYTJIOWjabscObiJtrITcisqzbNbfX4Xx2/0/FfzF5tkdwSpfEEBISBhJWKx
	 AJXsppowSIeav1PSxY8jrtsaUGhRGDTaanSonGTxof30hTNS+AzQKQIjDl6tEyLWv8BST
	 kGM4nEDHsRqRdhbnOPXMjh95cHFflkulvdLp1FaHQDQyIipeKJwfz0N1+q0DEG20JM1d3
	 Q4OnqpMHLB0y0qscpDIQ8hsSp1TiHZi95h+m1QZDM1spuHysYIJEFZrzAdmFylGOERw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304808;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Er0GRhCzdVU5yeaX5s1ElRVbYAULyDK/JtS7EUoH5DA=;
	b=vGeD60xbaIiyjvxH240zp0SF/tPfFXRRjHKTQuelOVf7nbeNKFYwlGBKZ9FrERf8v6W5
	 353I58RdxFstFnbOFG8OR/vbm5aO/+xm1S0lhYsuATw/xFl6U9/1ARzrw8Kx7WaATPTcV
	 VlcdsXIDOKxkv1d3LKdLCpv+8dBtMszQsse19MgXy154y3xwNF35y2uxa40z9MHNzDwGA
	 nGluaE/WFxjFUfa/5mCtM/DF7sDT9gitQhuXH20yt+lou6Pfni1WI0Z8EWPiQ8aYsSS/L
	 m6abR8aK1hRSrIsBSRaNSwR3O19wYo2tZJn+H+imKX04gsb+s0wItKnZT+Cv+NBUPwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=RXMGdtYr;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FCE606A31F
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 20:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93FCE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=RXMGdtYr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Er0GRhCzdVU5yeaX5s1ElRVbYAULyDK/JtS7EUoH5DA=; b=RXMGdtYrfAa5668FmtkJtD0jWR
	52Tsrp6XYEwoye0vDyRMu59QTTY0vRswmc4gh39RfzNKFE1wNAzYGTqceEo+5PMPE9HOG6Rmi2FDb
	cnHlOGjt4bIVl2q0zktGvbaMaa23xkQ6NowEyM4hAfwCwkmVQKmLZjHI2aCiLdcRlHNbMzE+fSyY2
	2GuZubi/rI5V/00pfLG5tTPw1KKaVqsY80Xwt2nXzrfGOLa0hzz65m94BcSMn2CYDsCOm9uWggQpN
	+VG8DEGyVeAjAhO+ByRnhOJ8Dr6ypIwEDZHvHqKyTPLkBwWTUmLh3U9bC7/ZGt7aSdU7L7rdv2sk3
	UkJFxgww==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWV6-0000000AJR2-1BaD;
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
Subject: [PATCH 3/4] powerpc/ps3: mm.c: clean up kernel-doc issues
Date: Thu, 29 Oct 2026 13:13:25 -0700
Message-ID: <20261029201326.2672284-4-rdunlap@infradead.org>
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

Use the correct format for struct members and function parameters.
Use the correct function names in kernel-doc comments.
Use the correct format for function descriptions.

This eliminates these kernel-doc warnings:

Warning: arch/powerpc/platforms/ps3/mm.c:102 struct member 'vas_id' not
 described in 'map'
Warning: arch/powerpc/platforms/ps3/mm.c:195 missing initial short
 description on line: * ps3_mm_vas_destroy -
Warning: arch/powerpc/platforms/ps3/mm.c:514 function parameter 'c_out'
 not described in 'dma_sb_map_pages'
Warning: arch/powerpc/platforms/ps3/mm.c:708 expecting prototype for
 dma_region_free(). Prototype was for dma_sb_region_free() instead
Warning: arch/powerpc/platforms/ps3/mm.c:1092 expecting prototype for
 dma_unmap_area_linear(). Prototype was for dma_sb_unmap_area_linear()
 instead

This leaves around 15 unrepaired kernel-doc warnings.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Geoff Levand <geoff@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org

 arch/powerpc/platforms/ps3/mm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20260828.orig/arch/powerpc/platforms/ps3/mm.c
+++ linux-next-20260828/arch/powerpc/platforms/ps3/mm.c
@@ -79,7 +79,7 @@ struct mem_region {
 /**
  * struct map - address space state variables holder
  * @total: total memory available as reported by HV
- * @vas_id - HV virtual address space id
+ * @vas_id: HV virtual address space id
  * @htab_size: htab size in bytes
  *
  * The HV virtual address space (vas) allows for hotplug memory regions.
@@ -193,7 +193,7 @@ fail:
 }
 
 /**
- * ps3_mm_vas_destroy -
+ * ps3_mm_vas_destroy - destroy the virtual address space
  *
  * called during kexec sequence with MMU off.
  */
@@ -504,7 +504,7 @@ static int dma_ioc0_free_chunk(struct dm
  * @r: Pointer to a struct ps3_dma_region.
  * @phys_addr: Starting physical address of the area to map.
  * @len: Length in bytes of the area to map.
- * c_out: A pointer to receive an allocated struct dma_chunk for this area.
+ * @c_out: A pointer to receive an allocated struct dma_chunk for this area.
  *
  * This is the lowest level dma mapping routine, and is the one that will
  * make the HV call to add the pages into the io controller address space.
@@ -699,7 +699,7 @@ static int dma_ioc0_region_create(struct
 }
 
 /**
- * dma_region_free - Free a device dma region.
+ * dma_sb_region_free - Free a device dma region.
  * @r: Pointer to a struct ps3_dma_region.
  *
  * This is the lowest level dma region free routine, and is the one that
@@ -1081,7 +1081,7 @@ static int dma_sb_map_area_linear(struct
 }
 
 /**
- * dma_unmap_area_linear - Unmap an area of memory from a device dma region.
+ * dma_sb_unmap_area_linear - Unmap an area of memory from a device dma region.
  * @r: Pointer to a struct ps3_dma_region.
  * @bus_addr: The starting ioc bus address of the area to unmap.
  * @len: Length in bytes of the area to unmap.
