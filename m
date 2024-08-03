Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDD03B1A1;
	Sat,  3 Aug 2024 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722705610; cv=none; b=GJpRyw7mFJ4zZ6Ed/U5hAx/4k+Ler5JtbRgn7diRtvBdPlPJZ/gUO08r9+abekIRGk35I8M+LTwtor7bK9kVjV7rmZ9QU3hCo3N0ncyKah7NaVMOfUz8IqwMuo1aptLJkOe9N3uzmIvSUFbGG0hcQBykmdJXNTeITIfDtXZJwdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722705610; c=relaxed/simple;
	bh=rnbH9kFxPcja9/hUhgnU5THreC2oxdLcAfmUx26FtSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn+qsF5XZJTtMwNoyaVGLoPAoZYFh83OyhNc9B4o9UbsdW5xmTf885RJuSj4uH909fzToMhkYmb4Qydlz2rg9H0wwg7WKcsRHviSOrMiP3X0MVjjpH/DKD/lBjXFkofYJ4GQ+fqCL3q68LgBzjncuEOENBTD2LBueYDnfZObqOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWiudmB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWiudmB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5440EC4AF0B;
	Sat,  3 Aug 2024 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722705609;
	bh=rnbH9kFxPcja9/hUhgnU5THreC2oxdLcAfmUx26FtSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWiudmB49S6Li4IR87H55Kj/kxjmSUPjCjslUuJ/zaft3rnP4G6XHPhQ9v7GK12H6
	 jA7I6AL3cqQUo5ul/1XEwGNgOBkjibAoUKQ17y1pLafPKvgPgS0dFSKjTQgOPgWFSt
	 GIJ5FeExgUkSVaK9h7djZRQYBdkPHyZN35GGntDGIyR5O9K8Xy92BCypykt2QZINT6
	 c0MwwAQfnzsKXnlJRMejqT2MamqJ8ISSFr/Ft0ug3N392MLoYjs1GVVvBG8RM6jbCK
	 XX/iPQ77kzm1x8fLQ/ACqO1jFNznndBuhrRoA0V+p5wuRkSDIOTqJ4EMDPIc/0CWZ2
	 gn0EzQyEbuPTQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 5/5] Compiler Attributes: make version constraints more consistent
Date: Sat,  3 Aug 2024 19:19:33 +0200
Message-ID: <20240803171933.483316-5-ojeda@kernel.org>
In-Reply-To: <20240803171933.483316-1-ojeda@kernel.org>
References: <20240803171933.483316-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Over time, some version constraints have been added that did not follow
the formatting of the rest. Fix it for consistency.

Some of the version requirements can be simplified, too.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/compiler_attributes.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index a6e8c9406f7a..908e59e261c0 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -112,7 +112,7 @@
 
 /*
  * Optional: not supported by gcc
- * Optional: only supported since clang >= 14.0
+ * Optional: only supported since clang >= 14
  *
  * clang: https://clang.llvm.org/docs/AttributeReference.html#diagnose_as_builtin
  */
@@ -146,7 +146,7 @@
 #endif
 
 /*
- * Optional: only supported since clang >= 14.0
+ * Optional: only supported since clang >= 14
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-error-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#error-warning
@@ -262,7 +262,7 @@
 #endif
 
 /*
- * Optional: only supported since GCC >= 7.1
+ * Optional: only supported since gcc >= 7
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
@@ -280,7 +280,7 @@
 #define __noreturn                      __attribute__((__noreturn__))
 
 /*
- * Optional: only supported since GCC >= 11.1
+ * Optional: only supported since gcc >= 11
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
@@ -388,7 +388,7 @@
 #define __must_check                    __attribute__((__warn_unused_result__))
 
 /*
- * Optional: only supported since clang >= 14.0
+ * Optional: only supported since clang >= 14
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warning-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#error-warning
@@ -400,7 +400,7 @@
 #endif
 
 /*
- * Optional: only supported since clang >= 14.0
+ * Optional: only supported since clang >= 14
  *
  * clang: https://clang.llvm.org/docs/AttributeReference.html#disable-sanitizer-instrumentation
  *
-- 
2.46.0

