Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6505120E6FB
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740148941; cv=none; b=oMELbn/Bfd27rnVXANHx17R0iOAKINy7w82dAnrWCjXAaVu0DwwUchETfYBWFAAm0gMgfrOGKEJIIhPuJt8ZUxJmZtq/CVbuN6FvhYGitwNb6DSQf4P31NsQoEtOG7jzPnyw1UykkTl+pheDysoQfTY/9Y//DBoF6yZWrCQWDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740148941; c=relaxed/simple;
	bh=AFjIBXObHULWwBBeti/UQ9IenIPyekvwF6dd/WNVR1k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qVsfqrZMDRAtqcBI/QK4H/7vVnihV87iKiscFG+gD0+d6cCjWU+Ffq+SJo1MPkfhs98VnousZ+WTzBIQNEfnRfZZplhbCDoIMZAQ2DA3HXhyXD6KsJXSw7HjR9IJutaYN+m1+oFceEaHpsBzBPzl7P2dajGKuwSNZW/Oi7AQ+xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYXN7u/7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYXN7u/7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4398a60b61fso11497225e9.0
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 06:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740148937; x=1740753737; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nkqxYFvP1YOYc3/mGAzLSNb9s+ekzsxk4Sz8UsgdvTg=;
        b=bYXN7u/7F5zzyBYf3tgipdCqNwkAk91RofknLvpMfsEN6kahQ6qoU5kbt4qZ3GXxmW
         Hkt2VSPUC2jB0uPsp2u5IeVdBVwAKSR7+IaEtPudmZxwjdaodh2ocEtZNxwlycZpbkO+
         ROMsadiAs5V5OSjpNCtEYzAGKOSJqgMyUxFCf0ncfc+Ubgu4gDgyfAOcipwoJfi+p3qB
         Yot/ZTARu5FrjXGfDfj3kGnBxFGT3HV8EhPzL6x7+vq+5N7BqbXlZWCvwoGw8ud2aPXo
         16KbN3w75AsJeLt7kAdg6GzChiSrUuz4ivoAYdFC0S7do610G4IAUc+Os2nXeQLDuDIH
         0GEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740148937; x=1740753737;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nkqxYFvP1YOYc3/mGAzLSNb9s+ekzsxk4Sz8UsgdvTg=;
        b=nt07M1fse5JcT3Fwtx6g7zFMkTUTogYnxhpJevcy2wd6ETVhIOKsBp87dzOkSSLrJA
         F3aD2k6NOA2aPKEBvDVXype4VivhMZB8V4grWC5mVGWsGIrtyUEG/O8PP/MGloubvJfx
         gyKTCOeQ0l2IYOGUHXfdoVO6g296AMLQsBZVlYclu+mZ+Qi9gsY2I8+fJ9sqDCWF3tDe
         K6R946O8Alra/OibAAAQGhWmD8Fz7fte19rGb99M/zl+NOPYp4moS4LAkFiGccdUYXtK
         ey+ZrRgvzyRXgWI2h3ggU2X71YFp/EfaaLkH6tsb2ZxkgBWo83jhiJgGzFqx0Fv+vtR1
         ONDw==
X-Gm-Message-State: AOJu0YycVHr1bh/R1XBFivZ6WoyywebqFQyzFi9Fl4qHcGoSoe52IsmG
	t6nD/9XoI2clShRaM/bXbcTP7F8AzKHyo43zEG+rFsyIniuWcjrSDitbfhodvZ7od40dUyMtpf/
	rhJdlZhL4JQ==
X-Google-Smtp-Source: AGHT+IF3X1+pcfYXoY0cCWqu4lNatPIFh55YyQdIDckUD8if227AnRzs56DLXcCjuXNi/nuuw+YQUa8szzXjQg==
X-Received: from wmsd12.prod.google.com ([2002:a05:600c:3acc:b0:439:80fc:8bb2])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5108:b0:439:9898:f18c with SMTP id 5b1f17b1804b1-439b5b3dbbcmr11992165e9.26.1740148937808;
 Fri, 21 Feb 2025 06:42:17 -0800 (PST)
Date: Fri, 21 Feb 2025 14:42:09 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221144209.135763-1-derkling@google.com>
Subject: [PATCH 5.15] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
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
index 2f6312e7ce81f..90ac8d84389cf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2449,7 +2449,8 @@ config CPU_IBPB_ENTRY
 	depends on CPU_SUP_AMD && X86_64
 	default y
 	help
-	  Compile the kernel with support for the retbleed=ibpb mitigation.
+	  Compile the kernel with support for the retbleed=ibpb and
+	  spec_rstack_overflow={ibpb,ibpb-vmexit} mitigations.
 
 config CPU_IBRS_ENTRY
 	bool "Enable IBRS on kernel entry"
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f84d59cd180b3..dfc02fb32375c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1092,6 +1092,8 @@ static void __init retbleed_select_mitigation(void)
 
 	case RETBLEED_MITIGATION_IBPB:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
+		mitigate_smt = true;
 
 		/*
 		 * IBPB on entry already obviates the need for
@@ -1101,8 +1103,6 @@ static void __init retbleed_select_mitigation(void)
 		setup_clear_cpu_cap(X86_FEATURE_UNRET);
 		setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
-		mitigate_smt = true;
-
 		/*
 		 * There is no need for RSB filling: entry_ibpb() ensures
 		 * all predictions, including the RSB, are invalidated,
@@ -2607,6 +2607,7 @@ static void __init srso_select_mitigation(void)
 		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB;
 
 				/*
@@ -2616,6 +2617,13 @@ static void __init srso_select_mitigation(void)
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
@@ -2624,8 +2632,8 @@ static void __init srso_select_mitigation(void)
 		break;
 
 	case SRSO_CMD_IBPB_ON_VMEXIT:
-		if (IS_ENABLED(CONFIG_CPU_SRSO)) {
-			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
+		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
+			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB_ON_VMEXIT;
 
@@ -2637,9 +2645,9 @@ static void __init srso_select_mitigation(void)
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

