Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305591;
	b=GWl75yLGexkXCu8lg4NS80BUMZ8QodRThDI+IiI6z1n4YIYOtel0PGh4NtexKctmEqEB
	 KHN7s6QqXUFB0w3T7vJ46i3++etBZkE12ZqiNKBd191PTEBEgRDKqMZeXHIUJU9fqgVkS
	 0OjIrazn1O/8ESQP6/NgWdGvzeaRCsHfbaGw8mSsx7pxks3eNqcnIQOwpb6pE01Us/aNi
	 jqOgxRtZ9qnBZHPHwcDbE7eaWPPR1cNxYXqgzmQyKLhaE3aE6oOjPS92LTi5xHGeVQt06
	 HbzAOR1zWMOMo9eUD4AGIj0qM8bzFg1sMQgEKVr8SKxD411H/SINwhY4rWa6f1uBByw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=em+eDkKHMBqO7CuYUMqXJnhqq7+NpV32/QiONBtUPj4=;
	b=E8cbo/MyyzyPnatK8jrSBgw2HUORTmEjxLeERrKNDv+cm4Xwf5EadY0w+lCq8BW+w2hL
	 piOSiChbqpd7TIMC/dxD1VwgvnS5OEbfUxbZq5EmGbPrTRdKEGPpdy4Zjzj/hIVxc8cNk
	 xhsFywD5l7FBwwuaAbeNBMnOgjlufpiDWsWksfH7RUUFsxc0F6xKftReMkVfd8Ui5lMqX
	 PkWdDjxc7nLJrq7GwGTcblzjQisCE0OVEyK3qGKMzp47ZORwmTiI51RGjTC2o4ZKl/Rse
	 Ch3C5XK7pz/6InnBtOjBXBGREg0CoLDJCPLElJtRfuToChnow8wlRszV7daJWm9EKNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=oYLN09+E;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D72606A31E;
	Thu, 29 Oct 2026 20:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1D72606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=oYLN09+E
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=em+eDkKHMBqO7CuYUMqXJnhqq7+NpV32/QiONBtUPj4=; b=oYLN09+EIi0gXFi0rg4lUcGxew
	RmejWKFv1DjhPLkWFokX0R+pO55DEzWt9BGsVO188Hg6FxCpqgE12mTmL2pelwsag96pH5KFb9QhL
	2AQOWE303MzDuzT1tSYBVxtwDnBxGMepOyYaCARqYpSzDAxFXidYztnF66rZBPiPXTj6wJMUOak0b
	/mJRqIvPoF7KCzy4lfoTpglXIJVYYx+W8AQXUAi1d7xlw9QqarpunBSGhewHrUvJWzJHzVKQ19/ll
	243OdeevW4b1Eve8Fuln5ajYLy/LOBT1nFSxUse2cn5cZ18avr2N3q76kdtEdhqRmkJC1XK9Get+X
	8SeaSB/w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWhi-0000000AJot-2HDL;
	Thu, 29 Oct 2026 20:26:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Guo Ren <guoren@kernel.org>,
	linux-csky@vger.kernel.org
Subject: [PATCH 3/4] csky: kernel/process: add missing prototype
Date: Thu, 29 Oct 2026 13:26:23 -0700
Message-ID: <20261029202624.2685097-4-rdunlap@infradead.org>
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

Include <linux/cpu.h> to provide a function prototype that was missing:

arch/csky/kernel/process.c:90:6: warning: no previous prototype for 'arch_cpu_idle' [-Wmissing-prototypes]
   90 | void arch_cpu_idle(void)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Guo Ren <guoren@kernel.org>
Cc: linux-csky@vger.kernel.org

 arch/csky/kernel/process.c |    1 +
 1 file changed, 1 insertion(+)

--- linext-2026-1007.orig/arch/csky/kernel/process.c
+++ linext-2026-1007/arch/csky/kernel/process.c
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/sched/debug.h>
+#include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
