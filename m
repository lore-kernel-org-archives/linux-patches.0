Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE74839FD;
	Mon, 15 Apr 2024 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191876; cv=none; b=nd55yNy+k1hKeat3r6Le+HMsiiw2FgOt8rWl/LqeRqGi7cKBpeduVBhwuWKt+PpTRXT1MU3AmTYQdxxTn26Z1AWjV8uuRKhiefjE9EQo0fh5Da1GSagBns4kKbT4vjIo8uq7ZL5YuDe/+wJsg6U6FgCj8F0tc6Zh+eeFEq+8fcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191876; c=relaxed/simple;
	bh=ddnAxzzu7qGKiHjYcWFGUzgK6FCltf9i9rwZ1KJhksc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjefdC4KgdhYobDnzfsWrx3sZ3lQZNbHC/jCv8YFWc+qggGbPt4W63QaUbQ5f7bVJKfEWmxropJpUoODOPmu3QGR+hLL5GCceCB8y40wD4hLoZ51KP42xx4kJIm8eIvvwjWWjSQG2b7PwLazZ/W7KtonSEJWz5pHeoGEoiHyvNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEagbGAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEagbGAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B732EC113CC;
	Mon, 15 Apr 2024 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191876;
	bh=ddnAxzzu7qGKiHjYcWFGUzgK6FCltf9i9rwZ1KJhksc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEagbGAjSEAgV6qpVlV1NamQH4MJAVyD5LSIBB3r7Wz9domRKR1wtJSj+1GSUIjz+
	 njX/cyelTvVapIdPy2mxcU+iUUJbgheuV+XkQQvgIVvBO4ay7u1Qd1hvFnY/o7dHcP
	 NsO70m6fpUag0kW5dUcwSUvMBawEmqafBRTPYR2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 6.6 114/122] x86/bugs: Replace CONFIG_SPECTRE_BHI_{ON,OFF} with CONFIG_MITIGATION_SPECTRE_BHI
Date: Mon, 15 Apr 2024 16:21:19 +0200
Message-ID: <20240415141956.792029367@linuxfoundation.org>
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
@@ -2566,27 +2566,16 @@ config MITIGATION_RFDS
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


