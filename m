Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE97811F1;
	Mon, 15 Apr 2024 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191867; cv=none; b=dXDBN5Ir8W5KTqYwK0ulnJgdP7kQP8IE37CidcoebLsvWAi/KFkRANtMWUTBTh5xPcy4JAx+6b+NpoBJRiT4yDAhho5sCyoVTYEPZO74LN6ZmQ2wHEZohfOjL1/kUOXjy0E3wYOajW5gK70ADsy93BoEwJ4dkyKENMfvqlaST6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191867; c=relaxed/simple;
	bh=1g9w57xAoCvjWZxjtDRV4ZRd9d/+/jWuVg8JiYF7Tp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIdjo/8+GvAkoVHF0FYMZUfw+0BP8r/D8n2yBqq2oDvJ+PBzBO43CfsEPP5Nhz0zYnhrhDj3WC+NFb61NmFn56OI1slSBjYDnHpZ9fRyYFrKPPWOt+vXFK8s4hGltUjTaxeLSKbHqlfj3UQ4HNmrIN8GrOiPgoqFZupvkXReb7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lR8GUVAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lR8GUVAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B284AC113CC;
	Mon, 15 Apr 2024 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191867;
	bh=1g9w57xAoCvjWZxjtDRV4ZRd9d/+/jWuVg8JiYF7Tp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR8GUVANKBk8pxoVQ6SZhvjsjbzcefs+WvzxFoRUl5mM5qPZSSrtwudp9m/xxbL6L
	 j7KIPfCNI9wLnPuh4lWoDmU9SM+LfhaybSoULmfWV/cykqlP4xwEOZ9H/Cd7gVaVNE
	 tKMvzzD+aE1LXtUyHzIloOvwwEahUP9OppcaInbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 112/122] x86/bugs: Clarify that syscall hardening isnt a BHI mitigation
Date: Mon, 15 Apr 2024 16:21:17 +0200
Message-ID: <20240415141956.733630097@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -661,8 +661,7 @@ kernel command line.
 	spectre_bhi=
 
 		[X86] Control mitigation of Branch History Injection
-		(BHI) vulnerability. Syscalls are hardened against BHI
-		regardless of this setting. This setting affects the deployment
+		(BHI) vulnerability.  This setting affects the deployment
 		of the HW BHI control and the SW BHB clearing sequence.
 
 		on
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5922,8 +5922,7 @@
 			See Documentation/admin-guide/laptops/sonypi.rst
 
 	spectre_bhi=	[X86] Control mitigation of Branch History Injection
-			(BHI) vulnerability. Syscalls are hardened against BHI
-			reglardless of this setting. This setting affects the
+			(BHI) vulnerability.  This setting affects the
 			deployment of the HW BHI control and the SW BHB
 			clearing sequence.
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2817,10 +2817,10 @@ static const char *spectre_bhi_state(voi
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


