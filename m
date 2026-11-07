Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063434;
	b=pnkp+fKYQZCpBD9rFFk8Z9YKIPGElwxFPcNvFoUnXVvD+c5EtaKw0QX8oxVnkOFhfUc7
	 x0PiHSHklKBPOxhc8e/CWMVrWqpJDcoMmjpQ5O7WaADdX+VGOEc4SzXBklAYc1PsWeTvm
	 cYqPB3OfRZB9ddcjB5n+uFbXQJg2ziu2d6gTGvH0E2/UiczJsroHgbUIZu2kP/qFDz5bc
	 ne/XQZQx8CS6aGq7Jami/iUdfz61jxndW2qoNmSRt0QS2T50Fi6B6ZlQTddjPqXXd0gNq
	 U5Hh8QiQ9L/E0rXprLH91OAB9BKugMY95mgs4IDEfnI32YGkZ7WxPHmLvT248erEkwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nNO9n5gfmnZUzG44j0mmuQ35Wx5rrQRquyMKBobdea8=;
	b=pQyzAod0Ew6puWfgIBS93dR4fxdsLPwTuC3Nk96ObLoXxZXcOttVDEZ0x7XAZqOlP768
	 BCQw+1SXS0p7AcazYJkqeT8VY8T/mdnuxu3LAONunh7QyABZmtdFEuEYhC7MhL7eDAY9T
	 H3ZqWRyjqMT6dgkHNqrHtLfLcZflfcXADYO2WaR1e6xYNoCC3RQYcM8ITlvKF6fbt7KxE
	 DOMuBzxRzAMTUc7Gx0x5QqyDRtYHBJZ/3GTM3t6zjuuT8Io9SpkG1WS1kazdP3m+6+bgJ
	 P4mUd1udqM+ewzRIw5SHGFakPy8d4Mkn/AZe0fx+dV5rowZSAke17+5IStXQQj8ObVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXO7fEh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07625606D801;
	Sat,  7 Nov 2026 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXO7fEh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C361F008A3;
	Sat,  7 Nov 2026 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063433;
	bh=nNO9n5gfmnZUzG44j0mmuQ35Wx5rrQRquyMKBobdea8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXO7fEh2ZkoiJxd6eln/u9MlFq9IPP5otvZIIdWkZTLe4h77kMUl6mHYKAmjQ8ezQ
	 tYbORN97hN6TCB1s5OH+1oIDyaPbU2U/EkRDCBdFzIxDtJs4QQ5nEO83E42MEqvDP7
	 DA2USG34EjYkpOJ/6WoJpxZnEKoEgGHDVQO2HYNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 561/869] ARM: 9523/1: topology: allocate the cacheinfo early on the boot CPU
Date: Sat,  7 Nov 2026 08:54:03 -0500
Message-ID: <20261107134912.326161472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 2d4234f99900403842b2c031fefb4c5816ac4df8 ]

ARM secondary CPUs allocate cacheinfo in detect_cache_attributes(),
called from secondary_start_kernel() with interrupts disabled. With
PREEMPT_RT, the allocation takes a sleeping lock and triggers
"BUG: sleeping function called from invalid context".

Call fetch_cache_info() for each possible CPU from init_cpu_topology()
on the boot CPU, following commit 5944ce092b97 ("arch_topology: Build
cacheinfo from primary CPU"). This supplies the arrays before secondary
CPUs populate them. Suppress -ENOENT and -EOPNOTSUPP, which leave cache
detection to the existing late path.

The CLIDR fallback uses the boot CPU's cache geometry. A secondary CPU
with more cache leaves can still require late reallocation and trigger
the warning.

Assisted-by: LLM

Fixes: a9ff94477836 ("ARM: 9433/2: implement cacheinfo support")
Cc: stable@vger.kernel.org
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20260912195552.76673-5-kmehltretter@gmail.com/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/topology.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 2336ee2aa44a2..e6b50cd43ce53 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/arch_topology.h>
+#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
@@ -238,8 +239,20 @@ void store_cpu_topology(unsigned int cpuid)
  */
 void __init init_cpu_topology(void)
 {
+	int cpu, ret;
+
 	reset_cpu_topology();
 	smp_wmb();
 
 	parse_dt_topology();
+
+	for_each_possible_cpu(cpu) {
+		ret = fetch_cache_info(cpu);
+		if (!ret)
+			continue;
+		/* CPUs without a usable CLIDR return -EOPNOTSUPP. */
+		if (ret != -ENOENT && ret != -EOPNOTSUPP)
+			pr_err("Early cacheinfo failed, ret = %d\n", ret);
+		return;
+	}
 }
-- 
2.53.0



