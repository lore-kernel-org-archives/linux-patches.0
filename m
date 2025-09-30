Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A827C1AB6F1;
	Tue, 30 Sep 2025 14:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244048; cv=none; b=pu5Hd74zWchQNDT4h27jz2WgSowmSiHtn5nyY4aBHEMi6i2aMZ3eOfjNJbzDNLmQR0dX8XJjDTbhoS4oR318Qs9iHECp+M4JzsdXp4WZj9ZwvuKe5Wp/Otz7Furukgl19knfp1Bj56k2iK/+Olusbv0e7I+jzaWvtbA58H2WP8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244048; c=relaxed/simple;
	bh=VDEDVx5QO7siUh0qUdkhGC2ZbT9c72m8/DpbF1sWKfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFNQObPl8JKoTx7yskyZjrk9Y1xk+tRHMuA0gcJei4jaIoarM4a3DA+rhUonwcpVN4S278hINaqOS154xszx40X1W6n0kPofT0bQMFzSbpEwVBwPYsPSR19mA8Y4ulRlGOzaZr86EtMulmjZPbH0Db3tjgVpiYixx9pP06/NOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucdKOYbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucdKOYbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CEBC4CEF0;
	Tue, 30 Sep 2025 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244048;
	bh=VDEDVx5QO7siUh0qUdkhGC2ZbT9c72m8/DpbF1sWKfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucdKOYbjQzY8ChtmJyjSo6b4xvxkGq6ApeRfS09dJiUI7LU/TUJmMOVsR7C/N5BM+
	 eVzFO6sS4RWGu2akWYZoDQsCeTfIe+FvSFfuJZnFGLoTQNC1NcfTipyXKkEh+T7KUi
	 tANaiEELhVCFI8e+0QTAsTcDqe1LTF/MUDrg8Y3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 013/122] compiler.h: drop fallback overflow checkers
Date: Tue, 30 Sep 2025 16:45:44 +0200
Message-ID: <20250930143823.531610305@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 4eb6bd55cfb22ffc20652732340c4962f3ac9a91 ]

Once upgrading the minimum supported version of GCC to 5.1, we can drop
the fallback code for !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.

This is effectively a revert of commit f0907827a8a9 ("compiler.h: enable
builtin overflow checkers and add fallback code")

Link: https://github.com/ClangBuiltLinux/linux/issues/1438#issuecomment-916745801
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler-clang.h     |   13 ---
 include/linux/compiler-gcc.h       |    4 -
 include/linux/overflow.h           |  138 ------------------------------------
 tools/include/linux/compiler-gcc.h |    4 -
 tools/include/linux/overflow.h     |  140 -------------------------------------
 5 files changed, 6 insertions(+), 293 deletions(-)

--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -72,19 +72,6 @@
 #define __no_sanitize_coverage
 #endif
 
-/*
- * Not all versions of clang implement the type-generic versions
- * of the builtin overflow checkers. Fortunately, clang implements
- * __has_builtin allowing us to avoid awkward version
- * checks. Unfortunately, we don't know which version of gcc clang
- * pretends to be, so the macro may or may not be defined.
- */
-#if __has_builtin(__builtin_mul_overflow) && \
-    __has_builtin(__builtin_add_overflow) && \
-    __has_builtin(__builtin_sub_overflow)
-#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
-#endif
-
 #if __has_feature(shadow_call_stack)
 # define __noscs	__attribute__((__no_sanitize__("shadow-call-stack")))
 #endif
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -140,10 +140,6 @@
 #define __no_sanitize_coverage
 #endif
 
-#if GCC_VERSION >= 50100
-#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
-#endif
-
 /*
  * Turn individual warnings and errors on and off locally, depending
  * on version.
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -6,12 +6,9 @@
 #include <linux/limits.h>
 
 /*
- * In the fallback code below, we need to compute the minimum and
- * maximum values representable in a given type. These macros may also
- * be useful elsewhere, so we provide them outside the
- * COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW block.
- *
- * It would seem more obvious to do something like
+ * We need to compute the minimum and maximum values representable in a given
+ * type. These macros may also be useful elsewhere. It would seem more obvious
+ * to do something like:
  *
  * #define type_min(T) (T)(is_signed_type(T) ? (T)1 << (8*sizeof(T)-1) : 0)
  * #define type_max(T) (T)(is_signed_type(T) ? ((T)1 << (8*sizeof(T)-1)) - 1 : ~(T)0)
@@ -54,7 +51,6 @@ static inline bool __must_check __must_c
 	return unlikely(overflow);
 }
 
-#ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
 /*
  * For simplicity and code hygiene, the fallback code below insists on
  * a, b and *d having the same type (similar to the min() and max()
@@ -90,134 +86,6 @@ static inline bool __must_check __must_c
 	__builtin_mul_overflow(__a, __b, __d);	\
 }))
 
-#else
-
-
-/* Checking for unsigned overflow is relatively easy without causing UB. */
-#define __unsigned_add_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = __a + __b;			\
-	*__d < __a;				\
-})
-#define __unsigned_sub_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = __a - __b;			\
-	__a < __b;				\
-})
-/*
- * If one of a or b is a compile-time constant, this avoids a division.
- */
-#define __unsigned_mul_overflow(a, b, d) ({		\
-	typeof(a) __a = (a);				\
-	typeof(b) __b = (b);				\
-	typeof(d) __d = (d);				\
-	(void) (&__a == &__b);				\
-	(void) (&__a == __d);				\
-	*__d = __a * __b;				\
-	__builtin_constant_p(__b) ?			\
-	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
-	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
-})
-
-/*
- * For signed types, detecting overflow is much harder, especially if
- * we want to avoid UB. But the interface of these macros is such that
- * we must provide a result in *d, and in fact we must produce the
- * result promised by gcc's builtins, which is simply the possibly
- * wrapped-around value. Fortunately, we can just formally do the
- * operations in the widest relevant unsigned type (u64) and then
- * truncate the result - gcc is smart enough to generate the same code
- * with and without the (u64) casts.
- */
-
-/*
- * Adding two signed integers can overflow only if they have the same
- * sign, and overflow has happened iff the result has the opposite
- * sign.
- */
-#define __signed_add_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = (u64)__a + (u64)__b;		\
-	(((~(__a ^ __b)) & (*__d ^ __a))	\
-		& type_min(typeof(__a))) != 0;	\
-})
-
-/*
- * Subtraction is similar, except that overflow can now happen only
- * when the signs are opposite. In this case, overflow has happened if
- * the result has the opposite sign of a.
- */
-#define __signed_sub_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = (u64)__a - (u64)__b;		\
-	((((__a ^ __b)) & (*__d ^ __a))		\
-		& type_min(typeof(__a))) != 0;	\
-})
-
-/*
- * Signed multiplication is rather hard. gcc always follows C99, so
- * division is truncated towards 0. This means that we can write the
- * overflow check like this:
- *
- * (a > 0 && (b > MAX/a || b < MIN/a)) ||
- * (a < -1 && (b > MIN/a || b < MAX/a) ||
- * (a == -1 && b == MIN)
- *
- * The redundant casts of -1 are to silence an annoying -Wtype-limits
- * (included in -Wextra) warning: When the type is u8 or u16, the
- * __b_c_e in check_mul_overflow obviously selects
- * __unsigned_mul_overflow, but unfortunately gcc still parses this
- * code and warns about the limited range of __b.
- */
-
-#define __signed_mul_overflow(a, b, d) ({				\
-	typeof(a) __a = (a);						\
-	typeof(b) __b = (b);						\
-	typeof(d) __d = (d);						\
-	typeof(a) __tmax = type_max(typeof(a));				\
-	typeof(a) __tmin = type_min(typeof(a));				\
-	(void) (&__a == &__b);						\
-	(void) (&__a == __d);						\
-	*__d = (u64)__a * (u64)__b;					\
-	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
-	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
-	(__b == (typeof(__b))-1 && __a == __tmin);			\
-})
-
-
-#define check_add_overflow(a, b, d)	__must_check_overflow(		\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_add_overflow(a, b, d),			\
-			__unsigned_add_overflow(a, b, d)))
-
-#define check_sub_overflow(a, b, d)	__must_check_overflow(		\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_sub_overflow(a, b, d),			\
-			__unsigned_sub_overflow(a, b, d)))
-
-#define check_mul_overflow(a, b, d)	__must_check_overflow(		\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_mul_overflow(a, b, d),			\
-			__unsigned_mul_overflow(a, b, d)))
-
-#endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
-
 /** check_shl_overflow() - Calculate a left-shifted value and check overflow
  *
  * @a: Value to be shifted
--- a/tools/include/linux/compiler-gcc.h
+++ b/tools/include/linux/compiler-gcc.h
@@ -38,7 +38,3 @@
 #endif
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 #define __scanf(a, b)	__attribute__((format(scanf, a, b)))
-
-#if GCC_VERSION >= 50100
-#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
-#endif
--- a/tools/include/linux/overflow.h
+++ b/tools/include/linux/overflow.h
@@ -5,12 +5,9 @@
 #include <linux/compiler.h>
 
 /*
- * In the fallback code below, we need to compute the minimum and
- * maximum values representable in a given type. These macros may also
- * be useful elsewhere, so we provide them outside the
- * COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW block.
- *
- * It would seem more obvious to do something like
+ * We need to compute the minimum and maximum values representable in a given
+ * type. These macros may also be useful elsewhere. It would seem more obvious
+ * to do something like:
  *
  * #define type_min(T) (T)(is_signed_type(T) ? (T)1 << (8*sizeof(T)-1) : 0)
  * #define type_max(T) (T)(is_signed_type(T) ? ((T)1 << (8*sizeof(T)-1)) - 1 : ~(T)0)
@@ -36,8 +33,6 @@
 #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
 #define type_min(T) ((T)((T)-type_max(T)-(T)1))
 
-
-#ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
 /*
  * For simplicity and code hygiene, the fallback code below insists on
  * a, b and *d having the same type (similar to the min() and max()
@@ -73,135 +68,6 @@
 	__builtin_mul_overflow(__a, __b, __d);	\
 })
 
-#else
-
-
-/* Checking for unsigned overflow is relatively easy without causing UB. */
-#define __unsigned_add_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = __a + __b;			\
-	*__d < __a;				\
-})
-#define __unsigned_sub_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = __a - __b;			\
-	__a < __b;				\
-})
-/*
- * If one of a or b is a compile-time constant, this avoids a division.
- */
-#define __unsigned_mul_overflow(a, b, d) ({		\
-	typeof(a) __a = (a);				\
-	typeof(b) __b = (b);				\
-	typeof(d) __d = (d);				\
-	(void) (&__a == &__b);				\
-	(void) (&__a == __d);				\
-	*__d = __a * __b;				\
-	__builtin_constant_p(__b) ?			\
-	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
-	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
-})
-
-/*
- * For signed types, detecting overflow is much harder, especially if
- * we want to avoid UB. But the interface of these macros is such that
- * we must provide a result in *d, and in fact we must produce the
- * result promised by gcc's builtins, which is simply the possibly
- * wrapped-around value. Fortunately, we can just formally do the
- * operations in the widest relevant unsigned type (u64) and then
- * truncate the result - gcc is smart enough to generate the same code
- * with and without the (u64) casts.
- */
-
-/*
- * Adding two signed integers can overflow only if they have the same
- * sign, and overflow has happened iff the result has the opposite
- * sign.
- */
-#define __signed_add_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = (u64)__a + (u64)__b;		\
-	(((~(__a ^ __b)) & (*__d ^ __a))	\
-		& type_min(typeof(__a))) != 0;	\
-})
-
-/*
- * Subtraction is similar, except that overflow can now happen only
- * when the signs are opposite. In this case, overflow has happened if
- * the result has the opposite sign of a.
- */
-#define __signed_sub_overflow(a, b, d) ({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	*__d = (u64)__a - (u64)__b;		\
-	((((__a ^ __b)) & (*__d ^ __a))		\
-		& type_min(typeof(__a))) != 0;	\
-})
-
-/*
- * Signed multiplication is rather hard. gcc always follows C99, so
- * division is truncated towards 0. This means that we can write the
- * overflow check like this:
- *
- * (a > 0 && (b > MAX/a || b < MIN/a)) ||
- * (a < -1 && (b > MIN/a || b < MAX/a) ||
- * (a == -1 && b == MIN)
- *
- * The redundant casts of -1 are to silence an annoying -Wtype-limits
- * (included in -Wextra) warning: When the type is u8 or u16, the
- * __b_c_e in check_mul_overflow obviously selects
- * __unsigned_mul_overflow, but unfortunately gcc still parses this
- * code and warns about the limited range of __b.
- */
-
-#define __signed_mul_overflow(a, b, d) ({				\
-	typeof(a) __a = (a);						\
-	typeof(b) __b = (b);						\
-	typeof(d) __d = (d);						\
-	typeof(a) __tmax = type_max(typeof(a));				\
-	typeof(a) __tmin = type_min(typeof(a));				\
-	(void) (&__a == &__b);						\
-	(void) (&__a == __d);						\
-	*__d = (u64)__a * (u64)__b;					\
-	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
-	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
-	(__b == (typeof(__b))-1 && __a == __tmin);			\
-})
-
-
-#define check_add_overflow(a, b, d)					\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_add_overflow(a, b, d),			\
-			__unsigned_add_overflow(a, b, d))
-
-#define check_sub_overflow(a, b, d)					\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_sub_overflow(a, b, d),			\
-			__unsigned_sub_overflow(a, b, d))
-
-#define check_mul_overflow(a, b, d)					\
-	__builtin_choose_expr(is_signed_type(typeof(a)),		\
-			__signed_mul_overflow(a, b, d),			\
-			__unsigned_mul_overflow(a, b, d))
-
-
-#endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
-
 /**
  * array_size() - Calculate size of 2-dimensional array.
  *


