Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A08E1D524;
	Mon, 15 Apr 2024 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192229; cv=none; b=Gq3DqZLVOT2miywxyR6hG6Je5h2IwSl30XonrZep7z1lDHsoknlF+bY0yNGNjIQSa9zS58l3//8Z/p8qH7tI7pdldIH4wbmM7/AJpMNTvUkRsgkGkQXTmlmHTDxaU2fWrn2NMjsOxllnk36TV1Qm9TYzUFb5HNgbtX3kzCUZ+Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192229; c=relaxed/simple;
	bh=ugvm+DdOUekMkmZk+bD4LysdxGoU3xyg0WQjG7tvtPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk4wKHHLi2nggUzn+gi30Dd0bgnzN75YlZtf+CVGIprXUlcmNVZxBV6TqtYyH/28HAQ3DVS19OVrmi8G2Yxgsfc5i+hM+8QPYyJ338BqAUnwg0Q6L0S45g8/ZXhOHvXkN3+c8tdp4K8PhQ/b3nvoN1CEanEcMt/l2EZMOUeu8Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5tD+ylX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5tD+ylX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF40AC113CC;
	Mon, 15 Apr 2024 14:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192229;
	bh=ugvm+DdOUekMkmZk+bD4LysdxGoU3xyg0WQjG7tvtPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5tD+ylXmpnnH6HQtVBb1jvToMJJTYZG3M4ZLsKpXM7p43bqWIkRwesRFEeu1tcpY
	 UNSDfjrsVt9klCdNlXP+PKWJEE6wGsn87Is18dNlQ/oI7TOG8WcAmzc30utU9qrcHU
	 wtoXJhV6bVMxOV5NVkukzsi7PIyfvcD41DRXujW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 38/45] x86/bugs: Fix BHI documentation
Date: Mon, 15 Apr 2024 16:21:45 +0200
Message-ID: <20240415141943.387321727@linuxfoundation.org>
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
@@ -716,13 +716,14 @@ For user space mitigation:
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
@@ -3093,6 +3093,7 @@
 					       reg_file_data_sampling=off [X86]
 					       retbleed=off [X86]
 					       spec_store_bypass_disable=off [X86,PPC]
+					       spectre_bhi=off [X86]
 					       spectre_v2_user=off [X86]
 					       ssbd=force-off [ARM64]
 					       tsx_async_abort=off [X86]
@@ -5410,11 +5411,12 @@
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


