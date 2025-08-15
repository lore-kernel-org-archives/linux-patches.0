Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AC91A9B53;
	Fri, 15 Aug 2025 01:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221514; cv=none; b=YFgdSZfs12Mvc2WbXKHKPuQjfiUKTmZehOEcuFMhuDSPjXlSHC5gS3O22zmziDxkrovlHIX9jlbv5IYSPM93vTKbp+AA90CDNGjdgwm+xu4jOlMfrnXtuZoj8KjvHkIdGJI0zDuSuFV8UokfwXK+Orj41eyX6YIroT1qZdI8ZpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221514; c=relaxed/simple;
	bh=mZKg/HKBlbq+tlm3qWX2x6vIoBEhFQs2e30B2TkZCWs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kqucek+rv8AoEDyGAVvGXcbeYtb1R6m89KzWQ08IIBDGVPe4oOLGaJo7Tx8M6LU+DKwgQkyzTTlPUWbubiVex85UjMU9oNBXcP4cD/G0WACbwx+oOHx5UfuzCox21X2S53sfOq4afa0P1Peir+cTV3iAzeLpYLM8A2DKKdKlPC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOVt3QMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOVt3QMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508A5C4CEED;
	Fri, 15 Aug 2025 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755221514;
	bh=mZKg/HKBlbq+tlm3qWX2x6vIoBEhFQs2e30B2TkZCWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WOVt3QMI/C/doXO2+GERrhw5jGu/qAeM1gF7taMSix+Pg9DiNCg8ej8ZfiMRlhEi9
	 bQ+qJdZQonW4tmNXdmBTVcz/l2TLm29Ilo141/6xPl+5HyppgjH+B+2XOjxkKF/qE2
	 trAz7wSkCmb/eionR4FZw4bYixJmg8Sz4jDgITCkHSO7MIDvGSoGaivnN33wG0JOst
	 evCkD0xG/0wKDJdGsVZDXF7XYuoh55tSJOOXv7keQaFAmFzA2Veo1CljpCkOYn2XQb
	 BOXxwAaE1P45h/hUSEdVGVgR+ynrPNKmTcr7n5QhdFVP4CoH1xKeildPhIDocbW5cP
	 jX1DwDoNTihZQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 18:31:38 -0700
Subject: [PATCH 2/6] x86/build: Remove cc-option from stack alignment flags
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-x86-min-ver-cleanups-v1-2-ff7f19457523@kernel.org>
References: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
In-Reply-To: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1352; i=nathan@kernel.org;
 h=from:subject:message-id; bh=mZKg/HKBlbq+tlm3qWX2x6vIoBEhFQs2e30B2TkZCWs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnz+piXCwZdfnOufioPxwnPVO8Ji1iSHyrEM26ZbpB1p
 bja8TR7RykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhICwsjw6yfa9dt0K9zL+U+
 vFJf8bntTybPvtqJ614k3kh3fXL/2BWG32ycfe5WlrulBF9asL5edeKafMD7lxtFFvaZnd+5ccL
 Fy+wA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

'-mpreferred-stack-boundary' (the GCC option) and '-mstack-alignment'
(the clang option) have been supported in their respective compilers for
some time, so it is unnecessary to check for support for them via
cc-option. '-mpreferred-stack-boundary=3' had a restriction on
'-mno-sse' until GCC 7.1 but that is irrelevant for most of the kernel,
which includes '-mno-sse'.

Move to simple Kconfig checks to avoid querying the compiler for the
flags that it supports.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index ed5657395d6a..f0aa58d2ec17 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -37,10 +37,11 @@ export RETPOLINE_VDSO_CFLAGS
 
 # For gcc stack alignment is specified with -mpreferred-stack-boundary,
 # clang has the option -mstack-alignment for that purpose.
-ifneq ($(call cc-option, -mpreferred-stack-boundary=4),)
+ifdef CONFIG_CC_IS_GCC
       cc_stack_align4 := -mpreferred-stack-boundary=2
       cc_stack_align8 := -mpreferred-stack-boundary=3
-else ifneq ($(call cc-option, -mstack-alignment=16),)
+endif
+ifdef CONFIG_CC_IS_CLANG
       cc_stack_align4 := -mstack-alignment=4
       cc_stack_align8 := -mstack-alignment=8
 endif

-- 
2.50.1

