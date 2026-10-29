Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793304809;
	b=u9M9qsU/XjDgKpBRFqIl1FzP03awF11cYcAtuzQEcPtRCgL4u5oS8VC2LPlijUekhqGL
	 YMwMhoLxNNjJCH4Mo5M4kARtq47Tz5TgTHUeTaTk4JOfJdwjHr0/lbNC1iy1dJLuGAnDt
	 Fx4mFVmS/beD6LDR00+cCmM6Bz/zeZ3kq1S0ETG92n2zJi8x3LH2Y1swbA3HjVzgcgk+a
	 56NCxtOdoUtOQA4Bwx9dWdGNVlSL5Qnc2p6CIbgap82aVZK+7BmbuQG9JhmG8M0DygBGQ
	 PTbbVNXLYEnBxV2XVF8tY7Owh6b+Qn792Su80bNDZV7y6/8jyuLW6x7wR4xniM0jgkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304809;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=j5wlQy9DCaktYGyQf5jBA58+1SExlqWK2qFF4AF0tHE=;
	b=Q7RijaorUfNCeN/QQI6xWxPBPS9WYMBWwblhoDDi0BbbgKK8Dh/w+xkxozaT55pelc/6
	 vjjE+HtC03h1FyrVDZF73oMtYODKKIA4FuXHAJUEy4zFduuOzRMct7xBunPi9Ui/eycJ0
	 X7rwzWDT41n/V1JQnbTGwvRx3RmPPSkcVi8UvFwOuFZsfEHAlIFkDL1+kTyUA3SgxzAR4
	 YuwbdHmjDhNKPRyBY8NL49PaV1vQQrxo+GrOOO7dSqxZTV0F/5JKsFZ/0Mon0zd9JfsAf
	 rnqupq2PxbVeskjOIPFL17um2s45RvJbwOLbFchjchR+yeiMkfxvR4pITBF0t6MedBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LlXSNsnD;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE276606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 20:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE276606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=LlXSNsnD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=j5wlQy9DCaktYGyQf5jBA58+1SExlqWK2qFF4AF0tHE=; b=LlXSNsnDOIdm4GZ9AenZo9tsU6
	ihmFx5dR9N4k6VcXIgf/BHd54XYUCNH1i3UtY8Rm3U+i1588tVMgXdGHn7yg2kp19F7bg9kWG5Oos
	K8GO8b+7LPiRWsT71Wfvs4/2/ZFACmy04UD4LL5tPN7cemXTBKPeuwiZpDXij4/iUf3mcOlHsLAgh
	3WbggiK5T/etPUK4BWFG+dGDtm5wI9Bbhy11UyDPgx4gfGREkGC1uazLEhieSgph3xnQn8dZ5ZHjv
	O6q70wPt1pSWQhmwstMp4iEeNoR7lzqq+Y4QwAN/TgckIX6QsX2E4ii0d5qtexwQ5KiGEeQ2ai02c
	Z/F9NrOw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWV6-0000000AJR2-2OX1;
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
Subject: [PATCH 4/4] powerpc/ps3: os-area.c: fix some kernel-doc warnings
Date: Thu, 29 Oct 2026 13:13:26 -0700
Message-ID: <20261029201326.2672284-5-rdunlap@infradead.org>
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

Add one struct member kernel-doc description.
Convert an enum and a struct to common C comments instead of kernel-doc
comments to avoid warnings.

Warning: arch/powerpc/platforms/ps3/os-area.c:139 struct member '_db_data'
 not described in 'os_area_db'
Warning: arch/powerpc/platforms/ps3/os-area.c:152 Enum value
 'OS_AREA_DB_OWNER_ANY' not described in enum 'os_area_db_owner'
Warning: arch/powerpc/platforms/ps3/os-area.c:152 Enum value
 'OS_AREA_DB_OWNER_NONE' not described in enum 'os_area_db_owner'
Warning: arch/powerpc/platforms/ps3/os-area.c:152 Enum value
 'OS_AREA_DB_OWNER_PROTOTYPE' not described in enum 'os_area_db_owner'
Warning: arch/powerpc/platforms/ps3/os-area.c:152 Enum value
 'OS_AREA_DB_OWNER_LINUX' not described in enum 'os_area_db_owner'
Warning: arch/powerpc/platforms/ps3/os-area.c:152 Enum value
 'OS_AREA_DB_OWNER_PETITBOOT' not described in enum 'os_area_db_owner'
Warning: arch/powerpc/platforms/ps3/os-area.c:152 Enum value
 'OS_AREA_DB_OWNER_MAX' not described in enum 'os_area_db_owner'
Warning: arch/powerpc/platforms/ps3/os-area.c:197 struct member 'valid'
 not described in 'saved_params'
Warning: arch/powerpc/platforms/ps3/os-area.c:197 struct member 'rtc_diff'
 not described in 'saved_params'
Warning: arch/powerpc/platforms/ps3/os-area.c:197 struct member
 'av_multi_out' not described in 'saved_params'

This leaves around 20 unrepaired kernel-doc warnings.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Geoff Levand <geoff@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org

 arch/powerpc/platforms/ps3/os-area.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20260828.orig/arch/powerpc/platforms/ps3/os-area.c
+++ linux-next-20260828/arch/powerpc/platforms/ps3/os-area.c
@@ -119,6 +119,7 @@ struct os_area_params {
  * @count_32: number of usable 32 bit index entries
  * @index_16: byte offset of the database id index for 16 bit variables.
  * @count_16: number of usable 16 bit index entries
+ * @_db_data: 1000 bytes of shared flash memory database
  *
  * Flash rom storage for exclusive use by guests running in the other os lpar.
  * The current system configuration allocates 1K (two segments) for other os
@@ -139,7 +140,7 @@ struct os_area_db {
 	u8 _db_data[1000];
 };
 
-/**
+/*
  * enum os_area_db_owner - Data owners.
  */
 
@@ -182,7 +183,7 @@ static const struct os_area_db_id os_are
 
 #define SECONDS_FROM_1970_TO_2000 946684800LL
 
-/**
+/*
  * struct saved_params - Static working copies of data from the PS3 'os area'.
  *
  * The order of preference we use for the rtc_diff source:
