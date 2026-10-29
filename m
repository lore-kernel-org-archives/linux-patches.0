Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305591;
	b=t1ptIHu5UfRHxUgMx+J1LgO6yj3Mh1grdNhNtBNdzxAdit8pKRnDoEGdhjV//x5vPKUK
	 3pvUIMYOVtu2tRz4MufDyXmauNn8bDZ58IXvi74b5grsjZykGOjEN6RdVpb0PqLtKO+Ah
	 vbRQsDGCnmgBHuxWUjdSo3cEeXwJ4m4/SHEVsxoRqjxol9JpOJ16s15Cg23+SDN9jaXoH
	 x+5ojcQ+oM8n24teWaRJki/VqOWuAoehFdrciSfoPd6+cCRFUcG2JeWYH5nI4QQngwVhH
	 wDn5BGJ/GLQuFZo1xce8c1jRk3CssC2nfhMEqlAwAKoeS7JD11/ThIXMiEUtQOG+RJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eBOCPJzPTSwNl8OKVG3qWyl63/wUQagNt/mFrLFX0tU=;
	b=SEbLo4UztnWOOiF/SZl24Gfm3xeNyQTiUdD3FjTljccUOxCg4SzWVuvwgz124+tWPnHp
	 DiT695snzAmbyGS/50SyXP3IbkVd5klkIMZDmCID6orSw9dA7T6aEPLUpvoaD8O/cYlxN
	 ipR0w5DqYSm5j1AjYQ6cxDNgxFa+38Y8Vaktviw1+Yj52Z0M+uZxagU0WLUVJhXyGuIIf
	 LJiUH8NZxXJZN6Ux5Xbt0FBtvDGx8VVUm3sUAoue5bpIvXIOiQNVm3srHbA0cPCuQseym
	 RBOMoimJpjzvYAnPCPVVs2IVKsj3lknuQOxg4YhPRY/bnWrpqy0MOTMMN5fVoi7xu7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=v196cuHy;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A060B606A31C;
	Thu, 29 Oct 2026 20:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A060B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=v196cuHy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eBOCPJzPTSwNl8OKVG3qWyl63/wUQagNt/mFrLFX0tU=; b=v196cuHyrMDzrg7lXfoPQ9fJRY
	NdV/a/lEKZhGwGXWg1shJyrjWfIvfJaN/6d4e2Gjd7pMRKRpuk78sy6FoJaNCgrnER+XuYUWqQxx2
	Eq++fGgF1MwIuCVGYv8CManLdueUmPjyywGUj1udVft0rfP/x9/4zH1DT+hTonaRal+6vN0hst7CY
	YT07N8NFYNT/vrwd2P9lT5V0Lr1i9dYohCucuYKEn1/GpH3ZR1jFN9W9opjL6JqX8vsKYfU4Ur74G
	BKOmRkWQtHpIpYuSj6aDWffem00Aqq+TIx+GnKgRTELfUHMmi15NJ6E0kQrEuWU0+nDpqi4Wq72CB
	9IlKjjkg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWhi-0000000AJot-0efd;
	Thu, 29 Oct 2026 20:26:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Guo Ren <guoren@kernel.org>,
	linux-csky@vger.kernel.org
Subject: [PATCH 1/4] csky: cachev2: add missing prototype
Date: Thu, 29 Oct 2026 13:26:21 -0700
Message-ID: <20261029202624.2685097-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029202624.2685097-1-rdunlap@infradead.org>
References: <20261029202624.2685097-1-rdunlap@infradead.org>
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

Add a missing prototype to avoid a build warning:

arch/csky/mm/cachev2.c:46:6: warning: no previous prototype for 'local_icache_inv_range' [-Wmissing-prototypes]
   46 | void local_icache_inv_range(void *priv)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Guo Ren <guoren@kernel.org>
Cc: linux-csky@vger.kernel.org

 arch/csky/include/asm/cache.h |    1 +
 1 file changed, 1 insertion(+)

--- linext-2026-1007.orig/arch/csky/include/asm/cache.h
+++ linext-2026-1007/arch/csky/include/asm/cache.h
@@ -17,6 +17,7 @@ void dcache_wb_line(unsigned long start)
 void icache_inv_range(unsigned long start, unsigned long end);
 void icache_inv_all(void);
 void local_icache_inv_all(void *priv);
+void local_icache_inv_range(void *priv);
 
 void dcache_wb_range(unsigned long start, unsigned long end);
 void dcache_wbinv_all(void);
