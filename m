Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592809445;
	Mon, 15 Apr 2024 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192089; cv=none; b=pg1JCoJT64O6Yh62S1NqnFQa2O1dpG/niyqp/fCsiXtLEB/TqrPZU/2w9Bz/OYfyyvUEcTq3BgM9yvjX24tvk1hlhb8ZUqmbMuIoTygvXBa1/WM+WUDFv/NV6Vovmy6kvzRHkdvOnb0fVfv7ywju/jDpG4Q2o1Q7ySxlXxA23Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192089; c=relaxed/simple;
	bh=WyMKLCBgYL91PSpakeLQ739r93ax3ZEhc4jPdEouOpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eObQR+Cv92r8V6yhZXF6e6m06kBCCtstAw7ecZctG4lV6NbnvrrgtgzhMpGso4D7uz6vktXfBhnzZ0jopN1A0ofyhDilXDvQevAIDXJ0onX5Rk5RHpNlaNC9syMURajt5gp4GEemcmsDJyERdPBzPFB9gdTc4cES9E98dWZB1dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u06nVZBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u06nVZBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5033C113CC;
	Mon, 15 Apr 2024 14:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192089;
	bh=WyMKLCBgYL91PSpakeLQ739r93ax3ZEhc4jPdEouOpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u06nVZBn8FHn+vCNxoVUPZSngY1SwGGDCdMPG4tD+jl4QIwpQ0XZzosayn2K4bPi1
	 o8fAeU3gviA/xoIRP3i3r70jO/CSK5qIz5cNKpKtTwHIpxrcTu9Sl/0Oe3uM+rx5n/
	 t9b8VYA6jmseIdXHiSWHHi9XULU1MNHZaVFh8BtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 63/69] x86/bugs: Remove CONFIG_BHI_MITIGATION_AUTO and spectre_bhi=auto
Date: Mon, 15 Apr 2024 16:21:34 +0200
Message-ID: <20240415141948.065926281@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 36d4fe147c870f6d3f6602befd7ef44393a1c87a upstream.

Unlike most other mitigations' "auto" options, spectre_bhi=auto only
mitigates newer systems, which is confusing and not particularly useful.

Remove it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/412e9dc87971b622bbbaf64740ebc1f140bff343.1712813475.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst   |    4 ----
 Documentation/admin-guide/kernel-parameters.txt |    3 ---
 arch/x86/Kconfig                                |    4 ----
 arch/x86/kernel/cpu/bugs.c                      |   10 +---------
 4 files changed, 1 insertion(+), 20 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -669,10 +669,6 @@ kernel command line.
 			needed.
 		off
 			Disable the mitigation.
-		auto
-			Enable the HW mitigation if needed, but
-			*don't* enable the SW mitigation except for KVM.
-			The system may be vulnerable.
 
 For spectre_v2_user see Documentation/admin-guide/kernel-parameters.txt
 
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5742,9 +5742,6 @@
 			on   - (default) Enable the HW or SW mitigation
 			       as needed.
 			off  - Disable the mitigation.
-			auto - Enable the HW mitigation if needed, but
-			       *don't* enable the SW mitigation except
-			       for KVM.  The system may be vulnerable.
 
 	spectre_v2=	[X86] Control mitigation of Spectre variant 2
 			(indirect branch speculation) vulnerability.
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2581,10 +2581,6 @@ config SPECTRE_BHI_OFF
 	bool "off"
 	help
 	  Equivalent to setting spectre_bhi=off command line parameter.
-config SPECTRE_BHI_AUTO
-	bool "auto"
-	help
-	  Equivalent to setting spectre_bhi=auto command line parameter.
 
 endchoice
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1602,13 +1602,10 @@ static bool __init spec_ctrl_bhi_dis(voi
 enum bhi_mitigations {
 	BHI_MITIGATION_OFF,
 	BHI_MITIGATION_ON,
-	BHI_MITIGATION_AUTO,
 };
 
 static enum bhi_mitigations bhi_mitigation __ro_after_init =
-	IS_ENABLED(CONFIG_SPECTRE_BHI_ON)  ? BHI_MITIGATION_ON  :
-	IS_ENABLED(CONFIG_SPECTRE_BHI_OFF) ? BHI_MITIGATION_OFF :
-					     BHI_MITIGATION_AUTO;
+	IS_ENABLED(CONFIG_SPECTRE_BHI_ON) ? BHI_MITIGATION_ON : BHI_MITIGATION_OFF;
 
 static int __init spectre_bhi_parse_cmdline(char *str)
 {
@@ -1619,8 +1616,6 @@ static int __init spectre_bhi_parse_cmdl
 		bhi_mitigation = BHI_MITIGATION_OFF;
 	else if (!strcmp(str, "on"))
 		bhi_mitigation = BHI_MITIGATION_ON;
-	else if (!strcmp(str, "auto"))
-		bhi_mitigation = BHI_MITIGATION_AUTO;
 	else
 		pr_err("Ignoring unknown spectre_bhi option (%s)", str);
 
@@ -1650,9 +1645,6 @@ static void __init bhi_select_mitigation
 	setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
 	pr_info("Spectre BHI mitigation: SW BHB clearing on vm exit\n");
 
-	if (bhi_mitigation == BHI_MITIGATION_AUTO)
-		return;
-
 	/* Mitigate syscalls when the mitigation is forced =on */
 	setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP);
 	pr_info("Spectre BHI mitigation: SW BHB clearing on syscall\n");


