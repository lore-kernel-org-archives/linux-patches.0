Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193431DF261;
	Fri, 15 Aug 2025 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221523; cv=none; b=M4sjiSN1cXjyWyCIcvpHYhhGo5H+ooBr10pXZLlgQ/uDmVOH5tJqiqghQQv+eewGBt2S5nQLWJV7npaQ0D2EqcP+dKsEFlYFmPcLVq5/ekSlULRKC+xCTrxSVjXf+AzAELYl+RibIAPFNaYw+mtxREPNLv2SiGsDlktR4HhXpxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221523; c=relaxed/simple;
	bh=ymuAyPYY672se8t4t301XszaRQHED0MEWCBoF0HZS3A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RkaJG5WdsOpkhWThzL8TAdtOr9v/KCGaFuxLZbSp/lwsxESTB0M6g3BKZni4c5JPHgTzDvvtI0fF/5rP0L0qHq5GHtMTnwyNQ5XMeWmC1A0IIwf7jQ6U4UePQMT9+wRx9A/arIUYqxdn/LS9mNgS2CY1G44pv7x0a97lfXViZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irM2ACac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irM2ACac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E590FC4CEF5;
	Fri, 15 Aug 2025 01:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755221522;
	bh=ymuAyPYY672se8t4t301XszaRQHED0MEWCBoF0HZS3A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=irM2ACac0S7o3Uzris8xVq3PQHhxs0ngihn8jXcf4r5M6YswNjOTGczAC3G9bulwY
	 zSHjGAmpSz2oN+glC3ZT1og0ONSw6a64mTOt9DFBK018TXYzy617/6MHmY8RwLqCYk
	 0Ah7xqveOnuS3mufEgZ76jz6MYY202b17p8zuTmPiWXIiLZAA9gLumDdKhXIw9NoI2
	 JPj61GYkqdSQ9r9r8M5YsXso7+gGc84/bl97/U6t/kBwHXMQlwFLFviP/7M8KkHSGV
	 fSWbeBtE8WHZMYMNHJSrjXmeN0VAbRzb73eNWjX213GCVQFrrs3h4W0PfpnJjBOYTB
	 oWrTQl8meg1/Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 18:31:42 -0700
Subject: [PATCH 6/6] x86/Kconfig: Clean up LLVM version checks in IBT
 configurations
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-x86-min-ver-cleanups-v1-6-ff7f19457523@kernel.org>
References: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
In-Reply-To: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1589; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ymuAyPYY672se8t4t301XszaRQHED0MEWCBoF0HZS3A=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnz+pi3NdbsMBEOfHXUWDQ0xTxPPZlH4Ead6p2LFyO+v
 dH3nni6o5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExkeT8jQ6u5oLjYGan15hUi
 ke0fzU5oW3v5zFYT3V8QKCunt+jjbUaGycGnN/G0btlsOHXFdRthltiJ3CWrVsZyz5lwLvZGvvB
 JFgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The minimum supported version of LLVM for building the x86 kernel
was bumped to 15.0.0 in commit 7861640aac52 ("x86/build: Raise the
minimum LLVM version to 15.0.0"), so the checks for Clang 14.0.0 and
ld.lld 14.0.0 or newer will always been true. Clean them up.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Kconfig | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100..85b91267c01c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1753,11 +1753,7 @@ config X86_UMIP
 config CC_HAS_IBT
 	# GCC >= 9 and binutils >= 2.29
 	# Retpoline check to work around https://gcc.gnu.org/bugzilla/show_bug.cgi?id=93654
-	# Clang/LLVM >= 14
-	# https://github.com/llvm/llvm-project/commit/e0b89df2e0f0130881bf6c39bf31d7f6aac00e0f
-	# https://github.com/llvm/llvm-project/commit/dfcf69770bc522b9e411c66454934a37c1f35332
-	def_bool ((CC_IS_GCC && $(cc-option, -fcf-protection=branch -mindirect-branch-register)) || \
-		  (CC_IS_CLANG && CLANG_VERSION >= 140000)) && \
+	def_bool ((CC_IS_GCC && $(cc-option, -fcf-protection=branch -mindirect-branch-register)) || CC_IS_CLANG) && \
 		  $(as-instr,endbr64)
 
 config X86_CET
@@ -1769,8 +1765,6 @@ config X86_KERNEL_IBT
 	prompt "Indirect Branch Tracking"
 	def_bool y
 	depends on X86_64 && CC_HAS_IBT && HAVE_OBJTOOL
-	# https://github.com/llvm/llvm-project/commit/9d7001eba9c4cb311e03cd8cdc231f9e579f2d0f
-	depends on !LD_IS_LLD || LLD_VERSION >= 140000
 	select OBJTOOL
 	select X86_CET
 	help

-- 
2.50.1

