Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564E21CD29;
	Sat,  3 Aug 2024 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722705604; cv=none; b=qtfUVXLy37IZ0zWeLSPq81nYKr2nZW0lWBFywX37xeJGEsO5ieTVBrVtuYDTE5sFIknANmMv4gv+MD2V+2apVLoSDvF6UtayTF5wCk/jUVkKoxlmyWBO4TcJg0vQEujjswcEyX1rnXZudxqLIGYylljue8BE7tdD560UfUSOlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722705604; c=relaxed/simple;
	bh=wAJXsZWjWUJHcpBsQrd6IQHKlhr0eAklXX73TEcw0lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r07Du+x7evAWlZvx4qR4lVCAKfgu3v3fq3vt9IqgatEwQLulGoImMa0TEOCu+zkgCwzb+0nRNGgDKuxci5goEQVTt9N765iPx2AIFM+9i1WWChmq+wA83vFU0umuQXGszssHM7OSSE/KZZpRn0i+ci4d29hwWk8bKf9cfyqFMQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hexFtRfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hexFtRfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A801C4AF0C;
	Sat,  3 Aug 2024 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722705604;
	bh=wAJXsZWjWUJHcpBsQrd6IQHKlhr0eAklXX73TEcw0lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hexFtRfI6XNJXhk+PBHGqKqzrsrszLylDsHVMUdvMulNNyRJTMp4f1JKoAVCxARY8
	 iUQK1RWzwBptRf+eE84AOZhJP5kODjp61VSi2p6zl4HD05OFCF1h9UH4w+UZcyQa6o
	 MgXmEuOFZ+VcsQ5G68qslc4epj20+45g1LeNUeDLu5P/QHUN7XeRmMfONJ/aN7M7wT
	 ddTY3YStuXy2SE1m+f4j7gNTtMWm2//1/Z9TqpVEAfUH93nDAojov/W1570lstZs8A
	 swtFZUnH5x7ModV9QPl/ps9xRtN4NeHEpgkukV8tqeTQb1a+s+JfwFtNbVcHbpeMBi
	 cBE3V2JBJnD6A==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 3/5] Compiler Attributes: add more Clang documentation links
Date: Sat,  3 Aug 2024 19:19:31 +0200
Message-ID: <20240803171933.483316-3-ojeda@kernel.org>
In-Reply-To: <20240803171933.483316-1-ojeda@kernel.org>
References: <20240803171933.483316-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some more documentation has been written in Clang for some of the
attributes, thus link them.

In some cases, they only have a "No documentation." entry, but at least
they are acknowledged (and documentation may be eventually written).

In one case, the link has been updated instead, since the URI fragment
changed.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/compiler_attributes.h | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 5d171a7f8cbd..2d1ad2a74a4e 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -22,6 +22,7 @@
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alias-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alias
  */
 #define __alias(symbol)                 __attribute__((__alias__(#symbol)))
 
@@ -29,6 +30,7 @@
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-aligned-function-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-aligned-type-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-aligned-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alignas-align-alignas-aligned
  */
 #define __aligned(x)                    __attribute__((__aligned__(x)))
 #define __aligned_largest               __attribute__((__aligned__))
@@ -50,7 +52,7 @@
  * inlinable [-Wattributes]" is emitted).
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-always_005finline-function-attribute
- * clang: mentioned
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#always-inline-force-inline
  */
 #define __always_inline                 inline __attribute__((__always_inline__))
 
@@ -79,6 +81,7 @@
  * Note the long name.
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-const-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#const
  */
 #define __attribute_const__             __attribute__((__const__))
 
@@ -146,6 +149,7 @@
  * Optional: only supported since clang >= 14.0
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-error-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#error-warning
  */
 #if __has_attribute(__error__)
 # define __compiletime_error(msg)       __attribute__((__error__(msg)))
@@ -186,6 +190,7 @@
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-mode-type-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-mode-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#mode
  */
 #define __mode(x)                       __attribute__((__mode__(x)))
 
@@ -222,6 +227,7 @@
  *   return [expression];
  *
  *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#fallthrough
  */
 #if __has_attribute(__fallthrough__)
 # define fallthrough                    __attribute__((__fallthrough__))
@@ -239,7 +245,7 @@
  * Note the missing underscores.
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noinline-function-attribute
- * clang: mentioned
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#noinline
  */
 #define   noinline                      __attribute__((__noinline__))
 
@@ -269,8 +275,7 @@
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noreturn-function-attribute
- * clang: https://clang.llvm.org/docs/AttributeReference.html#noreturn
- * clang: https://clang.llvm.org/docs/AttributeReference.html#id1
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#noreturn-noreturn
  */
 #define __noreturn                      __attribute__((__noreturn__))
 
@@ -323,6 +328,7 @@
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-pure-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#pure
  */
 #define __pure                          __attribute__((__pure__))
 
@@ -358,6 +364,7 @@
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-used-function-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-used-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#used
  */
 #define __used                          __attribute__((__used__))
 
@@ -384,6 +391,7 @@
  * Optional: only supported since clang >= 14.0
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warning-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#error-warning
  */
 #if __has_attribute(__warning__)
 # define __compiletime_warning(msg)     __attribute__((__warning__(msg)))
@@ -412,6 +420,7 @@
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-weak-function-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-weak-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#weak
  */
 #define __weak                          __attribute__((__weak__))
 
-- 
2.46.0

