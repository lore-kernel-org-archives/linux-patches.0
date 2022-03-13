Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7F816
	for <patches@lists.linux.dev>; Sun, 13 Mar 2022 06:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HYHvArPm/w8FD7LNJtF+84AxJQbKFURG89SVQOTeHYU=; b=UQiO/xl1jFgMHO6cirGG6hMZEC
	KmnnBh9KoOE2tw5zqE/7gxW2xUY6uiGwjgcHQxcL2L5TXrznv+I0lvE8bY23fWHzPrYxdXuGBHzqJ
	BWnt33p5IB/3bITg6BnibnBxRx9H7xyoGWf2LBG3KmDesCU9HzxFXN4zb+jPSxfxiMCNkEUF75YsU
	YnyrKLhFmuP2DatHuoNPhUeG7wSV2TykFLfFKNaqIuDed9j13ftivQhuUqmsZWMXHy4t0g9VeJAx4
	eL6WlLtTbCujMVLL+hAVyiPkZUCQc59RHAbyg/C+jtLEmdYx3tp9U/vStwPeVgYX88YlVYAtyUMBi
	Rj/913gw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nTICB-002Ha0-Sz; Sun, 13 Mar 2022 06:59:16 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Victor Gallardo <vgallardo@apm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc/4xx: cpm: fix return value of __setup handler
Date: Sat, 12 Mar 2022 22:59:15 -0800
Message-Id: <20220313065915.3161-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from cpm_powersave_off().

Fixes: d164f6d4f910 ("powerpc/4xx: Add suspend and idle support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
From: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Victor Gallardo <vgallardo@apm.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/platforms/4xx/cpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20220310.orig/arch/powerpc/platforms/4xx/cpm.c
+++ linux-next-20220310/arch/powerpc/platforms/4xx/cpm.c
@@ -327,6 +327,6 @@ late_initcall(cpm_init);
 static int __init cpm_powersave_off(char *arg)
 {
 	cpm.powersave_off = 1;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", cpm_powersave_off);
