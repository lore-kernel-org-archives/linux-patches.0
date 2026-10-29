Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305591;
	b=GoYQQHlzKRiTxtBCeFbGyG9/auplhZpgkjgY1pVA1/4QrfEDfD8J88TqTS2OiDzyAWce
	 KVQbWHpzsRGiw79RZsuPLVwfNybnc0Oe1B3dwfk4JrBibTD/QcyHV5nzGLcxp/YYqWSFN
	 69H0ceq+KTwt+Ob1kXxxU+NJjVXA1If14WFRcx4TnSqLu9XRLNa+/DEkGjZPT3UY3qiRB
	 XxHflMOUKkImS82vE7oRgnrErfS+qK7RXe6k8OP3wotocLY+E9FBjiXDLAUGEznpglOLf
	 5gUbHups6OGsWIr3jQtMnxDsYWHc3LQZ/VVypB8vUKbIriuezKZBeJzzOJv+9NKlb7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uoYdoTyf0RSOoKCuR6ERzUt+BbC8XDEu81o8SJZDjls=;
	b=qCRQHoI/4a79KDy+2deBLrfLkEcMqmwXt7S61IuRDPFpLQIiOrDDDnIa9WHmdym5t832
	 LnQxC2bW4oqA79MfGBqnmjBUniTAW6hau50m/Dr4ukAK0lYxHdt1/qgd2K3VRDizRYwzm
	 fGlEIfUtqGCu+gqqd8JJAZ9OWRGSDKuOiGgWHCYY0S8C4Q0qTEhlEJ+iqT70xsVtcqIX0
	 enz+r5EMhfsIIHKy0ifj2MGynqy4Hfh6hAIYz8pxjgRmjToacdXcAFup+D6ORoFR1+Pxj
	 P9zVx2ayEJz9y/cFZvFHbIJYgnaSGGXwLtoeK7xbMY+XxwdICg+/nTP5+iwGagjXScw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Hc56+B2p;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB91606A31F;
	Thu, 29 Oct 2026 20:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EB91606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Hc56+B2p
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uoYdoTyf0RSOoKCuR6ERzUt+BbC8XDEu81o8SJZDjls=; b=Hc56+B2pCORd8ZAzwUaeolyhto
	MH3kGJ8n0zwFtqFo3jvmzuaQ/Edlf2MEkOJRlbdnYYUqhaKjPIji4bpL4gPWaPljo92G0nrXoH0V4
	RetN+K+Tu/4nWF+cJ2ad56bInD2MZVPe/qPy3vXmfZUaxQtTgddji6LDWyva7QpcP2waK1VO6Y8Er
	OQqBnN3/ZkeoUIBDN6pU0N1Wk6CJ5bhkdkRMWqD8wcjQ5oJUhFhgNqL4E/ziqWtLo5471rbD2A6T/
	69aJPA0Qmhyt90lByBckB0HPesHNRufRtGFRH7fQswkSqwGagVevuuE9Nll0e21zoiWiQPU5R0m57
	ZBbhbazA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWhi-0000000AJot-344o;
	Thu, 29 Oct 2026 20:26:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Guo Ren <guoren@kernel.org>,
	linux-csky@vger.kernel.org
Subject: [PATCH 4/4] csky: mm/tcm: add missing prototypes
Date: Thu, 29 Oct 2026 13:26:24 -0700
Message-ID: <20261029202624.2685097-5-rdunlap@infradead.org>
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

Include <asm/tcm.h> to provide function prototypes that were missing:

arch/csky/mm/tcm.c:109:7: warning: no previous prototype for 'tcm_alloc' [-Wmissing-prototypes]
  109 | void *tcm_alloc(size_t len)
arch/csky/mm/tcm.c:124:6: warning: no previous prototype for 'tcm_free' [-Wmissing-prototypes]
  124 | void tcm_free(void *addr, size_t len)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Guo Ren <guoren@kernel.org>
Cc: linux-csky@vger.kernel.org

 arch/csky/mm/tcm.c |    1 +
 1 file changed, 1 insertion(+)

--- linext-2026-1007.orig/arch/csky/mm/tcm.c
+++ linext-2026-1007/arch/csky/mm/tcm.c
@@ -2,6 +2,7 @@
 
 #include <linux/highmem.h>
 #include <linux/genalloc.h>
+#include <asm/tcm.h>
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 
