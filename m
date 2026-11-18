Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039100;
	b=cMVY5DZMOyoeIpb2Kfy4HUXH/yUSdL6CczfSQ/2alU+RGd0H85fGgE9BufbY1TdhoGpX
	 0NSJ8B110e3s0RLRlnS9162qCQDOx8kNLQF9MjXf5zqJ4Vo7+PV41xl5T+jG68iSfCpRb
	 YTQ2Z0t6ns83kWr3DYhzPHfp8y9Vyc3iXGgXUgNb3zPWrjP23wOtSKPYyAtBahESJr+Ct
	 FFjEEp9rPIHOd2ielV4PzXk4F0nyhr1Yg4PBYpKROPY/ugmu3+0cTMRKBKPpuV175duLm
	 qQFNcH0Ig1BKqcOU0ka2UuF+AzV+6hVCBof4BzUl9wM6+OLeb2z52OAPiO7fiCDyeMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9a5NIO3Sg9wgBlX31kdnfOaUFkXGgIwUyBtYEdWqJc=;
	b=wEc2tLMP84tYm6YH2tZnEcdz0HNswJvv5OkOlou3gEn5GfhohvE82IW76LlYSrkI+p3d
	 kOFPfqxAhdAt+FnPGQR8MzzPzCN9ZEFNo2gbAiOhyPOABNzZhZj0GbsPM3kZuliXKBHyT
	 hVfS601HthxHMsCFKAwpRDAKGMYiIh2Ahe0qAwF19s4gj6iVumUZOFx7IfTOVmGvDio8l
	 nBUyc+bCK2BlJ9oJkxszkgdcYySAd32Cx7cRsJlQXa6vw5Cbv4A8OIIaVqV7yxShzW2Lx
	 DqBjnh1f9dJOXieu8HaQTIU3u8NMrQ27YagmU8cnw7yiiOhLPE9dgj/MQWDZ9MI0VeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSbv65x3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C432606A32C;
	Wed, 18 Nov 2026 21:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSbv65x3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B766A1F000C4;
	Wed, 18 Nov 2026 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039100;
	bh=Q9a5NIO3Sg9wgBlX31kdnfOaUFkXGgIwUyBtYEdWqJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSbv65x3kjYsT5GGRlZCyHGCNbhhFa77AzuXNfZBv7FHJFLO3Ui8YrcUEkL4GAnns
	 YnTjQX3jcIK+dar39J4wq/30AyIu8UC+OEmfLhJtCj4zwoHR5qMoY3/nkefaUHDUH4
	 fstwxfHRxG7eLecddJVm+iUKXz7B7IoLlwSBwXds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wei Wang <wvw@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1962/3318] arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend
Date: Wed, 18 Nov 2026 15:43:04 +0100
Message-ID: <20261118150420.947009161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wvw@google.com>

[ Upstream commit beeec04046227eba42b7cc5ab32498aa43da9632 ]

TPIDR2_EL0 is a live EL0 register on systems with SME, but
cpu_do_suspend()/cpu_do_resume() don't preserve it. Its value is
UNKNOWN after a warm reset, so the task that initiates suspend can
return to userspace with a corrupted TPIDR2_EL0.

Save and restore it alongside TPIDR_EL0 and TPIDRRO_EL0. The new slot
fits in existing padding, so sizeof(struct cpu_suspend_ctx) is
unchanged.

Fixes: a9d691585950 ("arm64/sme: Implement support for TPIDR2")
Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Wei Wang <wvw@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index eb60c97355530..2cc5fb405769c 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 14
+#define NR_CTX_REGS 15
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 51c48ac29ad5d..574136a35ea21 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -105,6 +105,10 @@ SYM_FUNC_START(cpu_do_suspend)
 alternative_if ARM64_HAS_TCR2
 	mrs	x2, REG_TCR2_EL1
 	str	x2, [x0, #104]
+alternative_else_nop_endif
+alternative_if ARM64_SME
+	mrs_s	x2, SYS_TPIDR2_EL0
+	str	x2, [x0, #112]
 alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
@@ -152,6 +156,10 @@ alternative_if ARM64_HAS_TCR2
 	ldr	x2, [x0, #104]
 	msr	REG_TCR2_EL1, x2
 alternative_else_nop_endif
+alternative_if ARM64_SME
+	ldr	x2, [x0, #112]
+	msr_s	SYS_TPIDR2_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13
-- 
2.53.0



