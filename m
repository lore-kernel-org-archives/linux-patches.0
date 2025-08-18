Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A58C32BF50;
	Mon, 18 Aug 2025 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543497; cv=none; b=iqj1E4qTPtexYpABROET00ercVmQEJZtrIFvIEx50kacC7zo9n/wR1X2c/4ektYxxZZVNwEnpfS7u/mu8ALF6QUe+paWqBpU3O4ooYG9OyXTTROMKDOgG8II1FrWDxTC7VwcZ3r97IM8B6wUwwmXuKBSqoKdsdz7HnKLCJJ8eqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543497; c=relaxed/simple;
	bh=n9wtTbZr78bneGp9rs2dl5VTHuhlIejKNjhnDVexSd8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NIaD1XBBv7lTTJkpKoxWkzCVH+wV6Z7OnBKFUhB3HAIRqaPKEfrGBNtIR1x+ko6QgqHQyKhbBsbzc1LX3yIqVYFV0jUlTVuoFKIleyflP+gvYdEfY8/WKU7xJDcPE/G8vwliDib7Tmwi3BTsn5xaXNmgGgr0ySBnE1ALSjs9yeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPBOhsZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPBOhsZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9EFC4AF0B;
	Mon, 18 Aug 2025 18:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543497;
	bh=n9wtTbZr78bneGp9rs2dl5VTHuhlIejKNjhnDVexSd8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IPBOhsZIu5+/3d/Chkq/NnpV/bl5UgoVOOI61lLjYN4Cp9Wo5pn+hPut9mvba3Gq+
	 rv4pn9Y1BI3IyESLuVWXf9Jjz+UFOfctqXFDdxzNZbNphxI/S4bDRAQk1B1FN/mKCq
	 1eoZeYT3afMcRePPJSJrdi6UxM53A2GvoqXrImxzjB1NDao82UktklUgPhVHd5I/u2
	 OjIcdabo2Shtz9VpJb1+Lw47NwQhBPDXpH4qoCmNaClhM7JJQTTx3NnqZAn6PfBpHt
	 IsP4zVopeR4n0qOHfVmUsSvmvyOZ5rGhUuiI+zrQ3a9Wv6C+uOuyph2edZxNC652Al
	 qngbpyJlawQtQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:26 -0700
Subject: [PATCH 10/10] KMSAN: Remove tautological checks
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-10-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1867; i=nathan@kernel.org;
 h=from:subject:message-id; bh=n9wtTbZr78bneGp9rs2dl5VTHuhlIejKNjhnDVexSd8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxdpTPo4d83atdxffqwtOpPw7XPF2TUVEdHmG074h
 hbqHmLi6ShlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQAT2SXEyPBt7+I07/dC02f3
 1W7u7ub1zku1F9x56toJ3pezC8uPCXIx/DPj3n4ueemmn++8d9k0lCu7SzxWyTmcGb9F8tSHN/p
 BC9kA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, two KMSAN checks can be cleaned up.

CONFIG_HAVE_KMSAN_COMPILER will always be true when using clang so
remove the cc-option test and use a simple check for CONFIG_CC_IS_CLANG.

CONFIG_HAVE_KMSAN_PARAM_RETVAL will always be true so it can be removed
outright.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
---
 lib/Kconfig.kmsan | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/lib/Kconfig.kmsan b/lib/Kconfig.kmsan
index 0541d7b079cc..7251b6b59e69 100644
--- a/lib/Kconfig.kmsan
+++ b/lib/Kconfig.kmsan
@@ -3,10 +3,7 @@ config HAVE_ARCH_KMSAN
 	bool
 
 config HAVE_KMSAN_COMPILER
-	# Clang versions <14.0.0 also support -fsanitize=kernel-memory, but not
-	# all the features necessary to build the kernel with KMSAN.
-	depends on CC_IS_CLANG && CLANG_VERSION >= 140000
-	def_bool $(cc-option,-fsanitize=kernel-memory -mllvm -msan-disable-checks=1)
+	def_bool CC_IS_CLANG
 
 config KMSAN
 	bool "KMSAN: detector of uninitialized values use"
@@ -28,15 +25,9 @@ config KMSAN
 
 if KMSAN
 
-config HAVE_KMSAN_PARAM_RETVAL
-	# -fsanitize-memory-param-retval is supported only by Clang >= 14.
-	depends on HAVE_KMSAN_COMPILER
-	def_bool $(cc-option,-fsanitize=kernel-memory -fsanitize-memory-param-retval)
-
 config KMSAN_CHECK_PARAM_RETVAL
 	bool "Check for uninitialized values passed to and returned from functions"
 	default y
-	depends on HAVE_KMSAN_PARAM_RETVAL
 	help
 	  If the compiler supports -fsanitize-memory-param-retval, KMSAN will
 	  eagerly check every function parameter passed by value and every

-- 
2.50.1

