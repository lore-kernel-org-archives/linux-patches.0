Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18380C14;
	Mon, 15 Apr 2024 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191486; cv=none; b=iUssd94i/BXPNviuP9cPxdYnDxnvAj/uNl2jQ7moFpkNMUOqgoGAKRrYMDD/dEQZIgz7E9qYIfZnpHykUyb0O5hik3fN5Ea1Nr5K960UBaK5yGSKvyyi8JzKoSEQaPo9AxFdPhdz856HgofS5yf8MJJAQAAWvn9z0ucW7LcvkEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191486; c=relaxed/simple;
	bh=Hx4+PggJLan5/xdlxroLAUuMw6bZEinuXILhX0yXiEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK+V2eAYe0xZZPfjLZrJBsa40bdHRyyb8JaiSndMoOl7vEdQQKMAnCTCB6OTOJYJFN8NZ+21zLj1fqcuxIQ6qu8fZRz6nvBp4XiPLQRj1AUgpausnuyK64O1pTaWekaTtoYqnKueRdw8BWEd+jrzEqnj8VferGuYnLP9VhuaEAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZic7xP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZic7xP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91FBC2BD11;
	Mon, 15 Apr 2024 14:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191486;
	bh=Hx4+PggJLan5/xdlxroLAUuMw6bZEinuXILhX0yXiEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZic7xP3QEgWTdH/YR+BYlog9dJj0clpGGj3eQXQ8fQI/O9MOfeHQcj+PUs4jIeKR
	 vK3tw/d/IUPUjJPMvO1AoVRXr7zsaIt5RaULp8NGNXaYdFslWtJZLn49Lua3NjJ4X+
	 ZYnJnTk4+gVXOdrXhOlU7tf4llU9wK+wfjOSUDVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 6.8 158/172] x86/bugs: Replace CONFIG_SPECTRE_BHI_{ON,OFF} with CONFIG_MITIGATION_SPECTRE_BHI
Date: Mon, 15 Apr 2024 16:20:57 +0200
Message-ID: <20240415142005.157294572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 4f511739c54b549061993b53fc0380f48dfca23b upstream.

For consistency with the other CONFIG_MITIGATION_* options, replace the
CONFIG_SPECTRE_BHI_{ON,OFF} options with a single
CONFIG_MITIGATION_SPECTRE_BHI option.

[ mingo: Fix ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/3833812ea63e7fdbe36bf8b932e63f70d18e2a2a.1712813475.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig           |   17 +++--------------
 arch/x86/kernel/cpu/bugs.c |    2 +-
 2 files changed, 4 insertions(+), 15 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2612,27 +2612,16 @@ config MITIGATION_RFDS
 	  stored in floating point, vector and integer registers.
 	  See also <file:Documentation/admin-guide/hw-vuln/reg-file-data-sampling.rst>
 
-choice
-	prompt "Clear branch history"
+config MITIGATION_SPECTRE_BHI
+	bool "Mitigate Spectre-BHB (Branch History Injection)"
 	depends on CPU_SUP_INTEL
-	default SPECTRE_BHI_ON
+	default y
 	help
 	  Enable BHI mitigations. BHI attacks are a form of Spectre V2 attacks
 	  where the branch history buffer is poisoned to speculatively steer
 	  indirect branches.
 	  See <file:Documentation/admin-guide/hw-vuln/spectre.rst>
 
-config SPECTRE_BHI_ON
-	bool "on"
-	help
-	  Equivalent to setting spectre_bhi=on command line parameter.
-config SPECTRE_BHI_OFF
-	bool "off"
-	help
-	  Equivalent to setting spectre_bhi=off command line parameter.
-
-endchoice
-
 endif
 
 config ARCH_HAS_ADD_PAGES
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1627,7 +1627,7 @@ enum bhi_mitigations {
 };
 
 static enum bhi_mitigations bhi_mitigation __ro_after_init =
-	IS_ENABLED(CONFIG_SPECTRE_BHI_ON) ? BHI_MITIGATION_ON : BHI_MITIGATION_OFF;
+	IS_ENABLED(CONFIG_MITIGATION_SPECTRE_BHI) ? BHI_MITIGATION_ON : BHI_MITIGATION_OFF;
 
 static int __init spectre_bhi_parse_cmdline(char *str)
 {


