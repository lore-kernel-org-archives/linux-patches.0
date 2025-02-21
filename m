Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960420E6E6
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740149559; cv=none; b=g9+l9WHd9X+tUDucNvy27nky5MqduajMMY5g6uzgEx7dMRNlHbxAIG/Fms777fmLwawUqGlQxl9JC6cIQeYi3rfJe6goZf5BRmIREACj9PXWucRcoaXk0Rxm/q0N3bbavcQbeGX4Es4aY62e0ex0NJs6RDSK6QUIQKUm341eJLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740149559; c=relaxed/simple;
	bh=VWMhrPMtisJb4hIm7Q7em7/129wWiVmvlzMbHR8p3mI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LmrL52Ois/aUnSYBUu1TLXM7v36WHm0Wlm4cQ7xPorgECkIWQbq/tu7SvlwyOAzbHCSI2adNsz+VAhEmuec/nC5KdsNZ3UxzYJmlXe7/2yn2xcWcMGX1E3tjJjdgxjQKKqpQf1jZ2BNu1hfwXOV7DwqYsgbFDNaWLMbY6GgQf9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LiWj8y0t; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LiWj8y0t"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4399a5afc95so10310345e9.3
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 06:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740149556; x=1740754356; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PJklh7u9DqRRvWHRSedTQSVAJYR9DI+wbKJuVOJ/zZU=;
        b=LiWj8y0tvJhKN8Ll3JxLgOdxYJ7I2Tt6yutYRnzpLZmP4SByTBpZSu83pXCiVj05I4
         PxB5GH4G7YnPV+402vsiGku06uYHVOtQneEUqdioFB0XUcbb3Yb0db5yirccCmzKhnnW
         3AqveJJ8RxtQnWI8je2lVQy+z0mqJnG8uxAEjZ2RZk147cuQ6psOfpabblybxj07h4OD
         x8008zST7A7lTLXovvho41bEkpdjR0QLKzBJ3tPczLMM8RS9N7v4Lo4aEleTPpi6rQmt
         W7r+4UAtvPyOtz9VOFKIDlAm2yHWBh819Met1xOFNeUriVqEPnqFw03yEO8j9J90KjmC
         7J7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740149556; x=1740754356;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PJklh7u9DqRRvWHRSedTQSVAJYR9DI+wbKJuVOJ/zZU=;
        b=I6+Jl2qIwnn1XMr+Rgota8vEf2xYzqTU7qfcrOSl33HcHVgj+tP9n1xGuPFRvVaQuk
         K0KzazBlie01ll9UZojIYjtTxgojQReAUOKBc5H5j+yEgkH8r6Xdbn4h51aSeFNx5F1J
         KbMc3QJmtJ4eqLFwV9fhFUX7aY/bP4vspXiuSorfSHQGx5om+FoxFqecoAhjpDCs2Pwn
         u3MZUg6zgHs7iZs+HErVa3b5ieJyM2Jje4S56RHi3Oe0o2e9uWFV66CM3k85oyRJYeZN
         QqvNNqpJtufdJKoNKnn7U8xY/Ad795mnncSBQfBygF77zbEM15757mty1msBYGyxQ1PI
         uJeQ==
X-Gm-Message-State: AOJu0YwYdBZE6KrBZv4FrcC9f5vuRd8nM3qCFdRqTWx0PlYy0At/zh1o
	bCPk8JYCPSDmADy0nRE0zFIQhgs6tqotml86rEFENPGvml9CLNIxW7f9M2pwPU2+ivOUms8L8WM
	ejEjkrgkVKw==
X-Google-Smtp-Source: AGHT+IEwZvTcD91+iLHw+VrVG2ux5qKn48gbc83ImXS9beNu4zdCBswbeRoOKzBIt4Xn/WEPEMWSlmskee/ysg==
X-Received: from wmbfk14.prod.google.com ([2002:a05:600c:cce:b0:439:7d73:d8fc])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6d0a:0:b0:38d:dd70:d70d with SMTP id ffacd0b85a97d-38f6e947399mr3767006f8f.18.1740149555851;
 Fri, 21 Feb 2025 06:52:35 -0800 (PST)
Date: Fri, 21 Feb 2025 14:51:56 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221145156.195014-1-derkling@google.com>
Subject: [PATCH 5.10] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
From: Patrick Bellasi <derkling@google.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev, Borislav Petkov <bp@alien8.de>, 
	Patrick Bellasi <derkling@matbug.net>, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

commit 318e8c339c9a0891c389298bb328ed0762a9935e upstream.

In [1] the meaning of the synthetic IBPB flags has been redefined for a
better separation of concerns:
 - ENTRY_IBPB     -- issue IBPB on entry only
 - IBPB_ON_VMEXIT -- issue IBPB on VM-Exit only
and the Retbleed mitigations have been updated to match this new
semantics.

Commit [2] was merged shortly before [1], and their interaction was not
handled properly. This resulted in IBPB not being triggered on VM-Exit
in all SRSO mitigation configs requesting an IBPB there.

Specifically, an IBPB on VM-Exit is triggered only when
X86_FEATURE_IBPB_ON_VMEXIT is set. However:

 - X86_FEATURE_IBPB_ON_VMEXIT is not set for "spec_rstack_overflow=ibpb",
   because before [1] having X86_FEATURE_ENTRY_IBPB was enough. Hence,
   an IBPB is triggered on entry but the expected IBPB on VM-exit is
   not.

 - X86_FEATURE_IBPB_ON_VMEXIT is not set also when
   "spec_rstack_overflow=ibpb-vmexit" if X86_FEATURE_ENTRY_IBPB is
   already set.

   That's because before [1] this was effectively redundant. Hence, e.g.
   a "retbleed=ibpb spec_rstack_overflow=bpb-vmexit" config mistakenly
   reports the machine still vulnerable to SRSO, despite an IBPB being
   triggered both on entry and VM-Exit, because of the Retbleed selected
   mitigation config.

 - UNTRAIN_RET_VM won't still actually do anything unless
   CONFIG_MITIGATION_IBPB_ENTRY is set.

For "spec_rstack_overflow=ibpb", enable IBPB on both entry and VM-Exit
and clear X86_FEATURE_RSB_VMEXIT which is made superfluous by
X86_FEATURE_IBPB_ON_VMEXIT. This effectively makes this mitigation
option similar to the one for 'retbleed=ibpb', thus re-order the code
for the RETBLEED_MITIGATION_IBPB option to be less confusing by having
all features enabling before the disabling of the not needed ones.

For "spec_rstack_overflow=ibpb-vmexit", guard this mitigation setting
with CONFIG_MITIGATION_IBPB_ENTRY to ensure UNTRAIN_RET_VM sequence is
effectively compiled in. Drop instead the CONFIG_MITIGATION_SRSO guard,
since none of the SRSO compile cruft is required in this configuration.
Also, check only that the required microcode is present to effectively
enabled the IBPB on VM-Exit.

Finally, update the KConfig description for CONFIG_MITIGATION_IBPB_ENTRY
to list also all SRSO config settings enabled by this guard.

Fixes: 864bcaa38ee4 ("x86/cpu/kvm: Provide UNTRAIN_RET_VM") [1]
Fixes: d893832d0e1e ("x86/srso: Add IBPB on VMEXIT") [2]
Reported-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Patrick Bellasi <derkling@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/Kconfig           |  3 ++-
 arch/x86/kernel/cpu/bugs.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0c802ade80406..00ae2e2adcadb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2463,7 +2463,8 @@ config CPU_IBPB_ENTRY
 	depends on CPU_SUP_AMD && X86_64
 	default y
 	help
-	  Compile the kernel with support for the retbleed=ibpb mitigation.
+	  Compile the kernel with support for the retbleed=ibpb and
+	  spec_rstack_overflow={ibpb,ibpb-vmexit} mitigations.
 
 config CPU_IBRS_ENTRY
 	bool "Enable IBRS on kernel entry"
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0b7f6bcbb8ea9..725f827718a71 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1061,6 +1061,8 @@ static void __init retbleed_select_mitigation(void)
 
 	case RETBLEED_MITIGATION_IBPB:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
+		mitigate_smt = true;
 
 		/*
 		 * IBPB on entry already obviates the need for
@@ -1070,8 +1072,6 @@ static void __init retbleed_select_mitigation(void)
 		setup_clear_cpu_cap(X86_FEATURE_UNRET);
 		setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
-		mitigate_smt = true;
-
 		/*
 		 * There is no need for RSB filling: entry_ibpb() ensures
 		 * all predictions, including the RSB, are invalidated,
@@ -2469,6 +2469,7 @@ static void __init srso_select_mitigation(void)
 		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB;
 
 				/*
@@ -2478,6 +2479,13 @@ static void __init srso_select_mitigation(void)
 				 */
 				setup_clear_cpu_cap(X86_FEATURE_UNRET);
 				setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
+
+				/*
+				 * There is no need for RSB filling: entry_ibpb() ensures
+				 * all predictions, including the RSB, are invalidated,
+				 * regardless of IBPB implementation.
+				 */
+				setup_clear_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 			}
 		} else {
 			pr_err("WARNING: kernel not compiled with CPU_IBPB_ENTRY.\n");
@@ -2486,8 +2494,8 @@ static void __init srso_select_mitigation(void)
 		break;
 
 	case SRSO_CMD_IBPB_ON_VMEXIT:
-		if (IS_ENABLED(CONFIG_CPU_SRSO)) {
-			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
+		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
+			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB_ON_VMEXIT;
 
@@ -2499,9 +2507,9 @@ static void __init srso_select_mitigation(void)
 				setup_clear_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 			}
 		} else {
-			pr_err("WARNING: kernel not compiled with CPU_SRSO.\n");
+			pr_err("WARNING: kernel not compiled with CPU_IBPB_ENTRY.\n");
 			goto pred_cmd;
-                }
+		}
 		break;
 
 	default:
-- 
2.48.1.601.g30ceb7b040-goog

