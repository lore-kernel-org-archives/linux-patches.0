Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45363824B3;
	Mon, 15 Apr 2024 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191855; cv=none; b=fyVwwFnwO2ome20HYYcmrSD68/DifOnfyAdNbnx4xj5C8Fkw1qvmqQY6n6tIr+PAi8ncEx4qy28WClySKvbPavv5vfpIPh7X9q8raqhuJL4/Xlee6YDetK71JeMZTz7eUd9+ZFXuV1Zc81mZK5MxvmZwqdfaDi/Pi4+HferqHUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191855; c=relaxed/simple;
	bh=bHkLUvy2IdHI6zsjHnJ/vwD3NqeqWwxTSAlKedgSwN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8pTROkVq4c73TNWqxor/z7yAtQ1qSkslJQgXdyBXvmyTqk8tiXlIkDg5GeEBrvDbK95YqxysRXeA878WDpUK5EDXsH/Es2QxU06Od+HNc5p/QfRlfkTA48CTqnpfTc/3IPojBue0GIRPWs8Zjnk1Mn2vl8dP33V4rKO6MHXrzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGULawWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGULawWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B25C113CC;
	Mon, 15 Apr 2024 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191855;
	bh=bHkLUvy2IdHI6zsjHnJ/vwD3NqeqWwxTSAlKedgSwN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGULawWm7XloL4W3QzgdmwulaSxKm58Hp1C2Q6GC6AyBamoeWmaKc1DOo7bBbJrQS
	 TfcZG0kBSMK2c85HTdihl4QiMQNzmU38j8Lm4Am6Ztg9nSCusiagwIRSBS614TFvyK
	 44lEIfJAsD/J+w6eDsuuegDxNVt9GpJmA1kyv/34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 108/122] x86/bugs: Fix BHI documentation
Date: Mon, 15 Apr 2024 16:21:13 +0200
Message-ID: <20240415141956.614101730@linuxfoundation.org>
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

commit dfe648903f42296866d79f10d03f8c85c9dfba30 upstream.

Fix up some inaccuracies in the BHI documentation.

Fixes: ec9404e40e8f ("x86/bhi: Add BHI mitigation knob")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/8c84f7451bfe0dd08543c6082a383f390d4aa7e2.1712813475.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst   |   15 ++++++++-------
 Documentation/admin-guide/kernel-parameters.txt |   12 +++++++-----
 2 files changed, 15 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -439,11 +439,11 @@ The possible values in this file are:
    - System is protected by retpoline
  * - BHI: BHI_DIS_S
    - System is protected by BHI_DIS_S
- * - BHI: SW loop; KVM SW loop
+ * - BHI: SW loop, KVM SW loop
    - System is protected by software clearing sequence
  * - BHI: Syscall hardening
    - Syscalls are hardened against BHI
- * - BHI: Syscall hardening; KVM: SW loop
+ * - BHI: Syscall hardening, KVM: SW loop
    - System is protected from userspace attacks by syscall hardening; KVM is protected by software clearing sequence
 
 Full mitigation might require a microcode update from the CPU
@@ -666,13 +666,14 @@ kernel command line.
 		of the HW BHI control and the SW BHB clearing sequence.
 
 		on
-			unconditionally enable.
+			(default) Enable the HW or SW mitigation as
+			needed.
 		off
-			unconditionally disable.
+			Disable the mitigation.
 		auto
-			enable if hardware mitigation
-			control(BHI_DIS_S) is available, otherwise
-			enable alternate mitigation in KVM.
+			Enable the HW mitigation if needed, but
+			*don't* enable the SW mitigation except for KVM.
+			The system may be vulnerable.
 
 For spectre_v2_user see Documentation/admin-guide/kernel-parameters.txt
 
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3343,6 +3343,7 @@
 					       reg_file_data_sampling=off [X86]
 					       retbleed=off [X86]
 					       spec_store_bypass_disable=off [X86,PPC]
+					       spectre_bhi=off [X86]
 					       spectre_v2_user=off [X86]
 					       srbds=off [X86,INTEL]
 					       ssbd=force-off [ARM64]
@@ -5926,11 +5927,12 @@
 			deployment of the HW BHI control and the SW BHB
 			clearing sequence.
 
-			on   - unconditionally enable.
-			off  - unconditionally disable.
-			auto - (default) enable hardware mitigation
-			       (BHI_DIS_S) if available, otherwise enable
-			       alternate mitigation in KVM.
+			on   - (default) Enable the HW or SW mitigation
+			       as needed.
+			off  - Disable the mitigation.
+			auto - Enable the HW mitigation if needed, but
+			       *don't* enable the SW mitigation except
+			       for KVM.  The system may be vulnerable.
 
 	spectre_v2=	[X86] Control mitigation of Spectre variant 2
 			(indirect branch speculation) vulnerability.


