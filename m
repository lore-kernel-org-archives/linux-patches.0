Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CF4B04A7;
	Mon, 17 Aug 2026 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976629; cv=none; b=H7FcoYzvgxaslG39IbuSdvhN0yIz5E9LFQmsv3mBIEib6uSCrHhA6i7EhdONdKL5D3bjz2/H9m8qk+0uvAGCIoqQR7lm0gtAKPh+QL4Mpgz5rk0P8O7NKYuumPU06Aapp9gNOG4ZIqRjkCqmjP1H8BKAJGRolqvrtrx8ilgpb/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976629; c=relaxed/simple;
	bh=CatIdd72j8/LlHPWPxqJq44TfU/Iq6vi1KgHhqbKW4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZgvw3mPcGFshM20e199ApNKKf1N7jeAhkU/bcrwxY3rUqFL2TQO8lM6Gwuk1zbRzhEKhYJPPvVpr52Q1hqmqPzyfulgxPVrA7PZM4xwNj3KYd2zTUGJWhkGu73JxQa+v85lkpzbvGLfd5epwZmqjM2mUxsYzHYdLFujzxKO6xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alU/BmkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alU/BmkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8151F000E9;
	Mon, 17 Aug 2026 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976628;
	bh=D9a5jCGjFSgTDd9a1GQ5oN6Gris2ojQnLtg+1CVWvq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alU/BmkQVSgWiVmNw3dXZJvTQYgtsmy7stSEnKMBnZS4bQgx9h35VD8qGVtxsujW1
	 NPh3Eu9O/c0hQmUdtHHdU4yZtbMVJ8fyd5SSFIGwUNX87Y2r8/DG3AaLiczfK4wOax
	 +NVFz8mJhaZxbJwVEv+SuNMYKPzWiRFHd6NlhdnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	He Ying <heying24@huawei.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/456] powerpc/time: Fix sparse warnings
Date: Mon, 17 Aug 2026 15:27:18 +0200
Message-ID: <20260817132541.919327218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Ying <heying24@huawei.com>

[ Upstream commit ce0091a0e06045e70c526c8735f8b866a85e0a45 ]

We found these warnings in arch/powerpc/kernel/time.c as follows:
  warning: symbol 'decrementer_max' was not declared. Should it be static?
  warning: symbol 'rtc_lock' was not declared. Should it be static?
  warning: symbol 'dtl_consumer' was not declared. Should it be static?

Declare 'decrementer_max' in powerpc asm/time.h.

Include linux/mc146818rtc.h in powerpc kernel/time.c where 'rtc_lock' is
declared. And remove duplicated declaration of 'rtc_lock' in powerpc
platforms/chrp/time.c because it has included linux/mc146818rtc.h.

Move 'dtl_consumer' definition after "include <asm/dtl.h>" because it is
declared there.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: He Ying <heying24@huawei.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210324090939.143477-1-heying24@huawei.com
Stable-dep-of: c1c1ffa490fc ("powerpc/vtime: Initialize starttime at boot for native accounting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/time.h    | 1 +
 arch/powerpc/kernel/time.c         | 9 ++++-----
 arch/powerpc/platforms/chrp/time.c | 2 --
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8c2c3dd4ddbac3..d7212a334f7242 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -22,6 +22,7 @@ extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
 extern struct clock_event_device decrementer_clockevent;
+extern u64 decrementer_max;
 
 
 extern void generic_calibrate_decr(void);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 4406d7a89558bb..d3f579f9880173 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -54,8 +54,9 @@
 #include <linux/of_clk.h>
 #include <linux/suspend.h>
 #include <linux/processor.h>
-#include <asm/trace.h>
+#include <linux/mc146818rtc.h>
 
+#include <asm/trace.h>
 #include <asm/interrupt.h>
 #include <asm/io.h>
 #include <asm/nvram.h>
@@ -149,10 +150,6 @@ bool tb_invalid;
 u64 __cputime_usec_factor;
 EXPORT_SYMBOL(__cputime_usec_factor);
 
-#ifdef CONFIG_PPC_SPLPAR
-void (*dtl_consumer)(struct dtl_entry *, u64);
-#endif
-
 static void calc_cputime_factors(void)
 {
 	struct div_result res;
@@ -178,6 +175,8 @@ static inline unsigned long read_spurr(unsigned long tb)
 
 #include <asm/dtl.h>
 
+void (*dtl_consumer)(struct dtl_entry *, u64);
+
 /*
  * Scan the dispatch trace log and count up the stolen time.
  * Should be called with interrupts disabled.
diff --git a/arch/powerpc/platforms/chrp/time.c b/arch/powerpc/platforms/chrp/time.c
index acde7bbe07164e..b94dfd5090d80f 100644
--- a/arch/powerpc/platforms/chrp/time.c
+++ b/arch/powerpc/platforms/chrp/time.c
@@ -30,8 +30,6 @@
 
 #include <platforms/chrp/chrp.h>
 
-extern spinlock_t rtc_lock;
-
 #define NVRAM_AS0  0x74
 #define NVRAM_AS1  0x75
 #define NVRAM_DATA 0x77
-- 
2.53.0



