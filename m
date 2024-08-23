Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA0C63A;
	Fri, 23 Aug 2024 00:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371937; cv=none; b=SIperVK4gAo6Kl62x9sU0gLHsjaemfAe4T7FiAcpbycCYlBunqLtdHBxGc1TPTKAfw9bj7RF8nSpgeVSnX3ZQMwcQCUOmQhBo3wuK+hI6KA9ZMybI3NxE/EaT41U020ZMxyXdj1qyGLETxLn29xjhYMVPzCwmcHWmZMurWmhOvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371937; c=relaxed/simple;
	bh=hR348iFeerciLqBqWHS3fQeIxVKDvQfpmtUSU4LpnR4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=M+zvhRD2ZEAZNYaVQw7ZaD++EF2vDQFUJtSQ9UV9MU1M9AuQbTShrfEZDbUwce7bl2Xb29xmpv3lNl0sV6XPj0ulhAl/+xMCdjccf+cpM9ImQkmaNC3d/BaS8hUIn5guzd2somNixLKMOqE0e4rt1Eq9AP4DBSmbB2KglrvNSeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U56DRAnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U56DRAnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E629C32782;
	Fri, 23 Aug 2024 00:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371937;
	bh=hR348iFeerciLqBqWHS3fQeIxVKDvQfpmtUSU4LpnR4=;
	h=From:Date:Subject:To:Cc:From;
	b=U56DRAnAIl4WrFQvlPLEWvV4zoUhuOOkJnrxO8Hrdfui+dr0sRNl1mMqFuoLQcljh
	 KpaGDfWV3W7UT6+WTf8lHFJV606WPyn6rohpw6VWdO5a9DAGGr+bR6+/zIM3ThKcyQ
	 y4axf3sIzkn6GgsuLgASAbD863nuHlvPEG60F0y3k1TEDGjHpEXqL+0DpRDTtG58ED
	 K+43zzwYZQ/shBs996oZhSYhuICZShrlXWldSyJSe0ZPz2g4r5lSDFKl4WCXwId6u5
	 a3mSVGUx6iqtTNtqOVVgJFhrNIN7n9/+2zocDa9sltXiqviKQwbiEbNLzqDMN1Y+tl
	 pdopWggV/qNqw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 22 Aug 2024 17:12:13 -0700
Subject: [PATCH] x86/resctrl: Annotate __get_mem_config_intel() as __init
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240822-x86-restctrl-get_mem_config_intel-init-v1-1-8b0a68a8731a@kernel.org>
X-B4-Tracking: v=1; b=H4sIANzTx2YC/x3N0QqDMAxA0V+RPC9Q4zZkvzJG6WraBTSONgxB/
 PcVH8/LvTtULsIVHt0OhX9SZdWG/tJB/ATNjDI1Azm6upEIt/GOhatFKzNmNr/w4uOqSbIXNZ5
 RVAyHkByFWz+4d4AW+xZOsp2j5+s4/kyu4AV4AAAA
To: Fenghua Yu <fenghua.yu@intel.com>, 
 Reinette Chatre <reinette.chatre@intel.com>, x86@kernel.org, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; i=nathan@kernel.org;
 h=from:subject:message-id; bh=hR348iFeerciLqBqWHS3fQeIxVKDvQfpmtUSU4LpnR4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnHLz84X8XOkPy4bFNjt9SaiQ2m505eE87olbG6ornn6
 O0O09sHO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBETBYyMjTbcSZfv2xycsGG
 s269Plctyva2Js2Ydalc9ErK2ujC75qMDBNjrlZ+2iawbS2bp4klV/6xd9pq7+eWb3ln96D/cOI
 hbX4A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent LLVM change [1] that deduces __cold on functions that
only call cold code (such as __init functions), there is a section
mismatch warning from __get_mem_config_intel(), which got moved to
.text.unlikely. as a result of that optimization:

  WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)

Mark __get_mem_config_intel() as __init as well since it is only called
from __init code, which clears up the warning.

Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1930fce9dfe9..b28646f1d9d6 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -199,7 +199,7 @@ static inline bool rdt_get_mb_table(struct rdt_resource *r)
 	return false;
 }
 
-static bool __get_mem_config_intel(struct rdt_resource *r)
+static bool __init __get_mem_config_intel(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	union cpuid_0x10_3_eax eax;

---
base-commit: 7424fc6b86c8980a87169e005f5cd4438d18efe6
change-id: 20240822-x86-restctrl-get_mem_config_intel-init-3af02a5130ba

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

