Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF482E370A;
	Thu,  7 Aug 2025 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754602597; cv=none; b=m/2ojEI3zlx311y9dHra8QUnQ0uq62iOlsTlB+dFjRyTpO+7DKRz7jjTDO36hItdTOimxmJyJBocmREMaLGPRHJDEpxf4QxHuPgQZh4J0LqubWjHlIz5AbDKfu2I6dbLoNSwkkhArO6cRxH8lIUkpfIiNCe99uRBaucBte3k2uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754602597; c=relaxed/simple;
	bh=tUwmAkc0BRax/F/1mqhQobRKhACAzjEdHbZ1NnCs6/U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=e3e9Ocgp19WH+5t6UBLmrFea6AtVZ0t4HXcbyxMupczv3K/TWzXPHlV7D7KnYMcnM6lsMMs3TZoEYFlfwj7AbJodvyoII0gv/HIpoEcTwWssVWg+UdFfldMp33DjmKv/k3ymEg0QuMEOqxvGH5RMFk45ga6mxT+myH5jKcEg15A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2tGZJeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2tGZJeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4E6C4CEEB;
	Thu,  7 Aug 2025 21:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754602596;
	bh=tUwmAkc0BRax/F/1mqhQobRKhACAzjEdHbZ1NnCs6/U=;
	h=From:Date:Subject:To:Cc:From;
	b=X2tGZJeYhMMsvygEOa69O8xBM9b1+OCVmtFGwOqaqJYuHj8CL12krOGTltv82cjyw
	 DCEt9FV3xE1WuGRd+/NhFwUdaSHRJDR6W9WL10Ex6Aya3QICPpJt1yoRQEnCOgKfwb
	 XliWF0pAW1BrcjspziGyHUlMDkGEtitNfIXkIWYc+TrQn/THF2Ryep9XTGYaStjVnh
	 udp8M5ATamGEpT7u7pISjCqR1geLrwLX3MZq9YWQziOyvqB0BUtJHEIIk7lXP1mu+V
	 b5VhCL8M0Chs6pv3glF6TO88GV2s8vTJsRb13LhN5vx8wUz0gQk75Uiv6mqlzQPGSp
	 FlL5aNDti4Zsw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 07 Aug 2025 14:36:28 -0700
Subject: [PATCH] hardening: Require clang 20.1.0 for __counted_by
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFsclWgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDCwNz3bTMCt3k/NK8ktSU+KRK3eQcoCJdQ0tdE3ODFFPjNEvjxEQDJaD
 ugqJUoFKwydGxtbUAMY4gcmkAAAA=
X-Change-ID: 20250807-fix-counted_by-clang-19-470d53f93aa0
To: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-hardening@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2288; i=nathan@kernel.org;
 h=from:subject:message-id; bh=tUwmAkc0BRax/F/1mqhQobRKhACAzjEdHbZ1NnCs6/U=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlTZZIyZjzPKm5Zf+nC/7+nA5Qrss4VfS3I9pi+N96BS
 +3vwq8iHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiZ1oY/ork1xgrmhTtFAne
 PdNu45nyTTMExNSLJewfTjg7J/j1k2OMDDvaqrfEbrtq/a33YlSwb07JbK3S+61qpXfOrj5YzPs
 7kR0A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After an innocuous change in -next that modified a structure that
contains __counted_by, clang-19 start crashing when building certain
files in drivers/gpu/drm/xe. When assertions are enabled, the more
descriptive failure is:

  clang: clang/lib/AST/RecordLayoutBuilder.cpp:3335: const ASTRecordLayout &clang::ASTContext::getASTRecordLayout(const RecordDecl *) const: Assertion `D && "Cannot get layout of forward declarations!"' failed.

According to a reverse bisect, a tangential change to the LLVM IR
generation phase of clang during the LLVM 20 development cycle [1]
resolves this problem. Bump the version of clang that enables
CONFIG_CC_HAS_COUNTED_BY to 20.1.0 to ensure that this issue cannot be
hit.

Link: https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef5e61fb26c5659eb581489 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Should this be marked for stable? If this makes 6.17 final, I think we
are fine for mainline and newer but I wonder if a patch that adds
__counted_by to a structure would ever be backported and expose this
problem there.
---
 init/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index af4c2f085455..a2675ee1ef8c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -117,10 +117,11 @@ config CC_HAS_NO_PROFILE_FN_ATTR
 
 config CC_HAS_COUNTED_BY
 	bool
-	# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
-	# https://github.com/llvm/llvm-project/pull/110497
-	# https://github.com/llvm/llvm-project/pull/112636
-	default y if CC_IS_CLANG && CLANG_VERSION >= 190103
+	# clang needs to be at least 20.1.0 to avoid potential crashes
+	# when building structures that contain __counted_by
+	# https://github.com/ClangBuiltLinux/linux/issues/2114
+	# https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef5e61fb26c5659eb581489
+	default y if CC_IS_CLANG && CLANG_VERSION >= 200100
 	# supported since gcc 15.1.0
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
 	default y if CC_IS_GCC && GCC_VERSION >= 150100

---
base-commit: f627b51aaa041cba715b59026cf2d9cb1476c7ed
change-id: 20250807-fix-counted_by-clang-19-470d53f93aa0

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

