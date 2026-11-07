Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064843;
	b=qCxvJI6niwZTofeKPWvStBbrtl8GFV6k4NcdzXwptBBAbvYQUjcm0wGeid7qlQkVH+6e
	 x+S0eqIbMMqT3KQhK1YdMMtaEnDtJjMtW2qoyzGomklCqA35NXeOywmck315D3bwHLnZq
	 m11cgzMUnUON8IpqLeRkDaFpP7rz8UBzx54K6KEbaKQIluZlh051KPaHtmdlru8WI3qcz
	 rY3WfCNdPyVP8iJyATljRfEHlPs0c08IwtXfo2kusG71kOiBwmyWsovp29cQXXAhY+0Mg
	 6K6wyjV2PRvPJMpDus8KcX4HpBtX+wS0tCG2G/jO/C7VRL/pLLxWU26cnJOBom1+vqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZCZhv4RKZ23o5bUu8R43/diJGYONHDUgAWWcr9Q7X4=;
	b=kG/q+O1OItLn0U3ZhaUvX6qSlO9ciJIhXJv0nr8gCbdFvtudAK7YerZqqYGCFoxmXPT7
	 xfxa/eJlzCKN20aAcfbXhIJJlNSopzoWbCGQirR1+vn41pK0DNOWPQSC6t3aQDcNqtiAI
	 JMZDfjkR65k9KADbIlSoafl6HGlW5yfunmIUwLqSbpM/5kfMstS4FE9cM16Lqg4oofTy0
	 7Vnb+qPZoDEWgCBfZQ37baerqb+6jeZzRd7pU1dYz+5kALXsxfraJtAlN8oTL7I79vRJJ
	 QYR5/BO4Y36ta9f1X8xJ5EmOdCok/wx3cIotEBjQFXzNxl5qxhlsNfKS3GBwiGVF0WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4T9TUPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39836606B8A5;
	Sat,  7 Nov 2026 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4T9TUPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C461F0089F;
	Sat,  7 Nov 2026 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064843;
	bh=OZCZhv4RKZ23o5bUu8R43/diJGYONHDUgAWWcr9Q7X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4T9TUPtG6aVZiWPlGl9XMiOl9uJoLqp7g9XAcRv19PcvacP4Ecm1assJkAG14pHj
	 gnhIoBpaG6ba8kDKvgsqxE7jeAhrUqTf1JaxkeHIeA0+dKXtt+i2cfZnB/wGijF5He
	 QKxK8iA9D1/oCtcnksp+AN8MwZe91VeZOMrimoFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0769/1257] ARM: 9523/1: topology: allocate the cacheinfo early on the boot CPU
Date: Sat,  7 Nov 2026 08:51:05 -0500
Message-ID: <20261107135000.535427403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



