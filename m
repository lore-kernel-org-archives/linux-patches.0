Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623F20F083
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740147641; cv=none; b=XI45nBRd9t/fMXXJHlbYtPQIfncQl5eDtr9+oAR91bn+6RMdg7YgE71yhaimkNisfwji8uWLAagBz/Y2pdS4/R0710HNQhqAhJNVc+X2sOV3m3pqEYZ2AgVLB4u4yb+AwGRnaNcQaEvWO39D7xAGfCoqYYPvf++ZfXf0a2vknW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740147641; c=relaxed/simple;
	bh=GWlurt06QDhPiSWaPjMSrBRcLwFlXoXALEmItpHXRwg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UTtaPxyOTFNMQ3bdXvRm90Tt1Pex8IOD6L5KExE6GE5OAQ5j+wtXToTeiBCTx0ZHF/ayc+XSihqq0THYDE4jC7oDjFGJj11JNjKnd47HL12P/ABcf+MJfvT2xnPRmMJZts7Y6CB+seCQKbWWmEqVRMEMuLaPbGEoxMPRnNojm+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BvpYbdgO; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BvpYbdgO"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38f3eb82fceso1038692f8f.0
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 06:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740147638; x=1740752438; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gAN4vizlfThj3/spjFigcf7y4206n2EgGnYQHkF382M=;
        b=BvpYbdgOFpfAndBW6zll+C5LOEMSdfpMbWHH3KwxMilGhbENEFUbYuwT4szM25aRwU
         L6Quejd2XQ7CjfgRuXBSOENIw78qrjW7EOBehvvS51mam5k4JOBlejVTdGvRJWHsTbJ0
         W94gUIHtusen5MHKFD4n0Nc5GD2UOX0je4+w8YGUFWRgE6gjgq9PjWDIQe85Qxc+4MKS
         l8hkO4YI5IfC9iOllb0dqAKCvWLryjSdwsX3lgGzk12i91daYo9Zy9q2NL4L9sCrTAnM
         BWUGvj2ZSxrgZdGaqG+fZ/BakA5ExDVJLn6W7brEMfVCm7noEVJWdQO08iMmDCr2L5MT
         kIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740147638; x=1740752438;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gAN4vizlfThj3/spjFigcf7y4206n2EgGnYQHkF382M=;
        b=oXDKiGvJyYRTjHhnhJlwxdGngSzQg88BdFefymNe6Ofu14gPbM15vpguAc0wjASbNc
         lp2g6NTVZDESrDYaVEO/etxREQp2Qk3Nig2dE2iYF7oNJ46RxR+R7pKHA/hqBlS6FnoY
         hGKlQGVn0D62+QMPr163xEfcKH2TouAJ2vYcUZVSnt1QLWokSGGa5R5QMutvO4OoOmGm
         5rwkgyflOo+WKvegM7LO0LLYVH4KfCMSJycw9UoCC6FkBjpwtyqVvB0FjsrwCWNK7ra+
         3YsAOG84MVovvdCJOopcNZt++ULK3wSvnz7gXcDgJuP2o/YGAbDZCJiTxcqm/LvUG7ZZ
         H8jA==
X-Gm-Message-State: AOJu0Yxoxa+OKIYfg/qT9EVrb/beSugoMDhAqoTQUQLScl8L8mgOLvIr
	xElMeDz8Cu++zDpk01H38/ZQHk970mCPvcXAN7JSP7nTqI8oygbD1L02sCYZqO4BxCTAcxMYV7B
	NwR95cWUcXg==
X-Google-Smtp-Source: AGHT+IH0boqnUtNJDnNpCgtZHuh2dD37zGiE7VV1gYmY0oLj/YDEXi+H9uvRRXJRzLv9+vDrYYowHY6OLX2sWQ==
X-Received: from wrbhb24.prod.google.com ([2002:a05:6000:4918:b0:38f:40d1:8309])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6e8a:0:b0:38d:e378:20f7 with SMTP id ffacd0b85a97d-38f6f09749emr2344534f8f.41.1740147637844;
 Fri, 21 Feb 2025 06:20:37 -0800 (PST)
Date: Fri, 21 Feb 2025 14:20:02 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221142002.4136456-1-derkling@google.com>
Subject: [PATCH 6.6] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
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
 arch/x86/kernel/cpu/bugs.c | 21 ++++++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 05c82fd5d0f60..989d432b58345 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2514,7 +2514,8 @@ config CPU_IBPB_ENTRY
 	depends on CPU_SUP_AMD && X86_64
 	default y
 	help
-	  Compile the kernel with support for the retbleed=ibpb mitigation.
+	  Compile the kernel with support for the retbleed=ibpb and
+	  spec_rstack_overflow={ibpb,ibpb-vmexit} mitigations.
 
 config CPU_IBRS_ENTRY
 	bool "Enable IBRS on kernel entry"
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7b5ba5b8592a2..7df458a6553eb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1113,6 +1113,8 @@ static void __init retbleed_select_mitigation(void)
 
 	case RETBLEED_MITIGATION_IBPB:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
+		mitigate_smt = true;
 
 		/*
 		 * IBPB on entry already obviates the need for
@@ -1122,9 +1124,6 @@ static void __init retbleed_select_mitigation(void)
 		setup_clear_cpu_cap(X86_FEATURE_UNRET);
 		setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 
-		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
-		mitigate_smt = true;
-
 		/*
 		 * There is no need for RSB filling: entry_ibpb() ensures
 		 * all predictions, including the RSB, are invalidated,
@@ -2626,6 +2625,7 @@ static void __init srso_select_mitigation(void)
 		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB;
 
 				/*
@@ -2635,6 +2635,13 @@ static void __init srso_select_mitigation(void)
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
@@ -2643,8 +2650,8 @@ static void __init srso_select_mitigation(void)
 		break;
 
 	case SRSO_CMD_IBPB_ON_VMEXIT:
-		if (IS_ENABLED(CONFIG_CPU_SRSO)) {
-			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
+		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
+			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB_ON_VMEXIT;
 
@@ -2656,9 +2663,9 @@ static void __init srso_select_mitigation(void)
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

