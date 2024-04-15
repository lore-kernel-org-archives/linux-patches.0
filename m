Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F71D524;
	Mon, 15 Apr 2024 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192241; cv=none; b=YfbGTHu0HbmMiQvf1mcAG5MgW/sg9bsIHM7sntmGExpluZU08aFqgYyEqQG/YAu5y3TKjMI9cMQq7mQnccKkjQE7tDo+Moau617MLiPOL5wBER4883EefLWWNXtfXLJ8Vz8fBMA2mlBy9uNUXS/xOE6UqSgwYG4hbPXYfYOthsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192241; c=relaxed/simple;
	bh=UBJyjVsmOpP9zeC1SAunK88smfZT2ZXVYoEvQuy5xG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8tSoG+dVmEK0Vgyg9Fnia4h8vBFBAiQYLKJKoNS7nUCPx1XsJ+SImDGLxCnJcURhMm/7hiJDzcdlz0Kw2mJXKNnh8heOVqC3U035CUstVPTprI/Q2dTbZJA0np5n3PSDgZ5FXEefsnkl0rhzUt7nGMoaW4zsA1Ctn/BS1w9WJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlJDtcHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlJDtcHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AA1C113CC;
	Mon, 15 Apr 2024 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192241;
	bh=UBJyjVsmOpP9zeC1SAunK88smfZT2ZXVYoEvQuy5xG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlJDtcHaiLYS47PkWzwtHVDasJNk2cxqiH/xQLOqKW6/0R0fQ/d2ODDrorfBnopWh
	 iP9YMiURtkWrJC3jQHw1niOPjubqEO3r1W6mO99PHkeDLERVI9R4o+EhSxbLXABpL4
	 8qRrOigq+aecMG1+YqXfbKClIIwvio4/GBksdKFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 42/45] x86/bugs: Clarify that syscall hardening isnt a BHI mitigation
Date: Mon, 15 Apr 2024 16:21:49 +0200
Message-ID: <20240415141943.505229084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 5f882f3b0a8bf0788d5a0ee44b1191de5319bb8a upstream.

While syscall hardening helps prevent some BHI attacks, there's still
other low-hanging fruit remaining.  Don't classify it as a mitigation
and make it clear that the system may still be vulnerable if it doesn't
have a HW or SW mitigation enabled.

Fixes: ec9404e40e8f ("x86/bhi: Add BHI mitigation knob")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/b5951dae3fdee7f1520d5136a27be3bdfe95f88b.1712813475.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst   |   11 +++++------
 Documentation/admin-guide/kernel-parameters.txt |    3 +--
 arch/x86/kernel/cpu/bugs.c                      |    6 +++---
 3 files changed, 9 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -441,10 +441,10 @@ The possible values in this file are:
    - System is protected by BHI_DIS_S
  * - BHI: SW loop, KVM SW loop
    - System is protected by software clearing sequence
- * - BHI: Syscall hardening
-   - Syscalls are hardened against BHI
- * - BHI: Syscall hardening, KVM: SW loop
-   - System is protected from userspace attacks by syscall hardening; KVM is protected by software clearing sequence
+ * - BHI: Vulnerable
+   - System is vulnerable to BHI
+ * - BHI: Vulnerable, KVM: SW loop
+   - System is vulnerable; KVM is protected by software clearing sequence
 
 Full mitigation might require a microcode update from the CPU
 vendor. When the necessary microcode is not available, the kernel will
@@ -711,8 +711,7 @@ For user space mitigation:
 	spectre_bhi=
 
 		[X86] Control mitigation of Branch History Injection
-		(BHI) vulnerability. Syscalls are hardened against BHI
-		regardless of this setting. This setting affects the deployment
+		(BHI) vulnerability.  This setting affects the deployment
 		of the HW BHI control and the SW BHB clearing sequence.
 
 		on
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5406,8 +5406,7 @@
 			See Documentation/admin-guide/laptops/sonypi.rst
 
 	spectre_bhi=	[X86] Control mitigation of Branch History Injection
-			(BHI) vulnerability. Syscalls are hardened against BHI
-			reglardless of this setting. This setting affects the
+			(BHI) vulnerability.  This setting affects the
 			deployment of the HW BHI control and the SW BHB
 			clearing sequence.
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2797,10 +2797,10 @@ static const char *spectre_bhi_state(voi
 		return "; BHI: SW loop, KVM: SW loop";
 	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) && rrsba_disabled)
 		return "; BHI: Retpoline";
-	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
-		return "; BHI: Syscall hardening, KVM: SW loop";
+	else if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
+		return "; BHI: Vulnerable, KVM: SW loop";
 
-	return "; BHI: Vulnerable (Syscall hardening enabled)";
+	return "; BHI: Vulnerable";
 }
 
 static ssize_t spectre_v2_show_state(char *buf)


