Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C653227
	for <patches@lists.linux.dev>; Sat, 23 Apr 2022 21:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9DDC385B1;
	Sat, 23 Apr 2022 21:27:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="neZM7woj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1650749225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLnH9LfNsXw8wnO3OV8d9NzfRRH/27wi66m+Mfcg6bE=;
	b=neZM7wojbPocSxxW9ePwx+8ckM3cZBd2kXkC75pofXty4huWgO6u1+GvhmZZpdD1+4WSi/
	xJwd76y+kiSznfLfnQWBxkEzKCT9t7vmKX7ZcGPsk66ob1Er5AYwAfnAOlSHmbhv0Mq18w
	Wx7NwYsLLtAHXkYtdm+k4R1kb4tr1QY=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d56cf015 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sat, 23 Apr 2022 21:27:05 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	arnd@arndb.de
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v6 01/17] ia64: define get_cycles macro for arch-override
Date: Sat, 23 Apr 2022 23:26:07 +0200
Message-Id: <20220423212623.1957011-2-Jason@zx2c4.com>
In-Reply-To: <20220423212623.1957011-1-Jason@zx2c4.com>
References: <20220423212623.1957011-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Itanium defines a get_cycles() function, but it forgot to do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/ia64/include/asm/timex.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/timex.h b/arch/ia64/include/asm/timex.h
index 869a3ac6bf23..7ccc077a60be 100644
--- a/arch/ia64/include/asm/timex.h
+++ b/arch/ia64/include/asm/timex.h
@@ -39,6 +39,7 @@ get_cycles (void)
 	ret = ia64_getreg(_IA64_REG_AR_ITC);
 	return ret;
 }
+#define get_cycles get_cycles
 
 extern void ia64_cpu_local_tick (void);
 extern unsigned long long ia64_native_sched_clock (void);
-- 
2.35.1

