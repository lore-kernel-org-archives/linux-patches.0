Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA57340DFC3;
	Thu, 19 Mar 2026 00:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773879626; cv=none; b=HKhxG6NL3qoDKzqRXKvur1wPYLV+7f2Xr6brznuT/d5TwUYF5YVsYsJ1N1Z3mTelRPkT/vttByxWpbaqPOZLIsJqbZ2xSaWg4YnfKwBbN45cRHya5X3xIKpKcS1wwgM8tlSRQOHqo1Df8brt9xOpmDnCcnHKQCQR1uHMX66JSSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773879626; c=relaxed/simple;
	bh=Ktfxvbp0muCpnpCw2TRj93irv70jwBLD8ChJOREtDGE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SQkcHlo4nVhQ9/ShoUhwHm9VGJF9zGWlluDgbT9n62quhmINqVXn1is3PV8IJ0NVRtwGE5oRkgEUm2Qnz97MifoqnI34AjtnEehf+4kcPdBeiHugqb7pCtg7FYAloyf7F+34G9Y6BqBUu6+r6RMtIPsEXuta4ScSb+Hlndx7hyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDhiz6Q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDhiz6Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F285AC19421;
	Thu, 19 Mar 2026 00:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773879626;
	bh=Ktfxvbp0muCpnpCw2TRj93irv70jwBLD8ChJOREtDGE=;
	h=From:Date:Subject:To:Cc:From;
	b=aDhiz6Q4ntRp2Bjfdfh4g/GjYoMKAJo0IqWtmyQJQ+GCghX9/JuMsKxLhTDgzXfjr
	 yXyH5QhswCu3LSbjzZ8CJPfNPiRipH9HCIewd5GYYxoJPXRzMQ02CePdm5v3JYpdHq
	 RBYsfl9/BnPz3FnB977QSNxuKpeN1ScKg9hKVocQlVZq8XHelJvVlyQ1llUpFaQX/e
	 R+IFOvVFMoAawI+3kjSybUVmEC+r7w9NCpDShXQ3RSY3T3OhQqIWm6twUwPsH75acs
	 MKbcRXI0ukcMxh37ZvMpj/4Ks/D6a038/GwAOMXYKCtWhKj4EMFG91iex0sxc0K9oF
	 dLf1w4GVN7Azg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 18 Mar 2026 17:20:18 -0700
Subject: [PATCH] init/Kconfig: Require a release version of clang-22 for
 CC_HAS_COUNTED_BY_PTR
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-counted_by_ptr-release-clang-22-v1-1-e017da246df0@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXN2wqDMBCE4VeRve5CTKGnVylFzGZsUyRKNkqL+
 O6m9vKD4Z+FFClA6VYtlDAHDUMsqA8VyauNT3DwxWSNPZljfWEZppjhG/dtxpw4oUerYOnLmK3
 ls1ydwBvvbEelMiZ04bM/3B9/6+TekPzL0rpuV7Sr0oMAAAA=
X-Change-ID: 20260318-counted_by_ptr-release-clang-22-7c9bced0db2f
To: Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-hardening@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2029; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Ktfxvbp0muCpnpCw2TRj93irv70jwBLD8ChJOREtDGE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJm7HT00FssXTn21YItE4fqNQiuN8oSFqlUEyt9GKFk3P
 73N/eNURykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZiIgiLD/6KfW+zOzFsjXtVz
 Yid/dVhFjyyLWOvKR5FvX5x69GLeK2lGhrZtLcdiFGYxil+d3SG29NPRBMen6/91N9x6urh31al
 bK1gA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 150a04d817d8 ("compiler_types.h: Attributes: Add __counted_by_ptr
macro") used Clang 22.0.0 as a minimum supported version for
__counted_by_ptr, which made sense while 22.0.0 was the version of
LLVM's main branch to allow developers to easily test and develop uses
of __counted_by_ptr in their code. However, __counted_by_ptr requires a
change [1] merged towards the end of the 22 development cycle to avoid
errors when applied to void pointers.

  In file included from fs/xfs/xfs_attr_inactive.c:18:
  fs/xfs/libxfs/xfs_attr.h:59:2: error: 'counted_by' cannot be applied to a pointer with pointee of unknown size because 'void' is an incomplete type
     59 |         void                    *buffer __counted_by_ptr(bufsize);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is disruptive for deployed prerelease clang-22 builds (such as
Android LLVM) or when bisecting between llvmorg-21-init and the fix.

Require a released version of clang-22 (i.e., 21.1.0 or newer) to
enabled __counted_by_ptr to ensure all fixes needed for proper support
are present.

Fixes: 150a04d817d8 ("compiler_types.h: Attributes: Add __counted_by_ptr macro")
Link: https://github.com/llvm/llvm-project/commit/f29955a594aedf5943d492a999b83e8c6b8fafae [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 444ce811ea67..7484cd703bc1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -146,7 +146,7 @@ config CC_HAS_COUNTED_BY
 config CC_HAS_COUNTED_BY_PTR
 	bool
 	# supported since clang 22
-	default y if CC_IS_CLANG && CLANG_VERSION >= 220000
+	default y if CC_IS_CLANG && CLANG_VERSION >= 220100
 	# supported since gcc 16.0.0
 	default y if CC_IS_GCC && GCC_VERSION >= 160000
 

---
base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
change-id: 20260318-counted_by_ptr-release-clang-22-7c9bced0db2f

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

