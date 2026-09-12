Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8F847CA62;
	Sat, 12 Sep 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218205; cv=none; b=BIF+UMVMHwEU34lYSWwvd7j/Wo1yicYTYG/AtUaG6PZJn6NuR8z0VrgYqNHByUbKgNvGlGCinY/3zysGjy979p1Zf4rC2NKqiMedWM+AECek5CElOb1xjs/kbtesitfOFcaGcDDZs738pHRgE7MIXZfWKMSnyfkRULCd1udldGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218205; c=relaxed/simple;
	bh=CpzjYJ7iggPTUl4526zR6xqW2zmI2F1VkrzD3y1vFjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOgHd/bC4ZGVf6OXAcHil040+zYvXZgbS9fupsgYDdDrz6oH2MOuI9aO97PuSEf45PKz4L0Q63XRAeT5Md6otPktliTRUXxDYXQdrTvtEcbu3eK0+aDIBtPv2arKXPGQwWi66XT99Ha5WhhT6G40fbYH4hOy6vqMXaf/jQ2hXHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEb907GR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEb907GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83371F000FF;
	Sat, 12 Sep 2026 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218204;
	bh=RFPh5ZT0nabdUIyUR0qdiLVhwI64dxuKjSZwqsS2pcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEb907GRUVzTwzX1U+ppKAbFZCX1/B1Dc67N2pBaswMRTPiWCcslRLTzzr0UooH1W
	 BTMxueJW76sg06LPkacg3SMAKjEIiVBla/jWl3nFysUAcBbmIXPzWyB1ivJMzdJ5kU
	 Vmq9GSIPQQfQZxZT/qSow1AKl9tbnnKFO01DHcwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1095/1376] selftests: harness: Restore order of test functions
Date: Sat, 12 Sep 2026 08:58:41 +0200
Message-ID: <20260912065631.964971765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 465b05bae5ac553c13315681c1490dc565337771 ]

The recent addition of explicit constructor orders for fixture tests
broke the ordering of those relative to non-fixture tests and the
reverse-constructor-order detection.

Restore the ordering of the test functions relative to each other by
using the same explicit test order for all test registrations and
__constructor_order_first().

Rename the constant, as it is not specific to TEST_F() anymore.

Link: https://lore.kernel.org/r/20260422-kselftests-harness-order-v2-1-93ea980ea3ac@linutronix.de
Fixes: 6be268151426 ("selftests/harness: order TEST_F and XFAIL_ADD constructors")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 37ffa24c9d07 ("selftests: harness: Mark test fixture objects __maybe_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index a4e5b8613babf..cdf1e75ef0f73 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -75,7 +75,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		memset(s, c, n);
 }
 
-#define KSELFTEST_PRIO_TEST_F  20000
+#define KSELFTEST_PRIO_TEST    20000
 #define KSELFTEST_PRIO_XFAIL   20001
 
 #define TEST_TIMEOUT_DEFAULT 30
@@ -196,7 +196,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		  .fixture = &_fixture_global, \
 		  .termsig = _signal, \
 		  .timeout = TEST_TIMEOUT_DEFAULT, }; \
-	static void __attribute__((constructor)) _register_##test_name(void) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) _register_##test_name(void) \
 	{ \
 		__register_test(&_##test_name##_object); \
 	} \
@@ -240,7 +240,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 	FIXTURE_VARIANT(fixture_name); \
 	static struct __fixture_metadata _##fixture_name##_fixture_object = \
 		{ .name =  #fixture_name, }; \
-	static void __attribute__((constructor)) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
 	_register_##fixture_name##_data(void) \
 	{ \
 		__register_fixture(&_##fixture_name##_fixture_object); \
@@ -366,7 +366,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		_##fixture_name##_##variant_name##_object = \
 		{ .name = #variant_name, \
 		  .data = &_##fixture_name##_##variant_name##_variant}; \
-	static void __attribute__((constructor)) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
 		_register_##fixture_name##_##variant_name(void) \
 	{ \
 		__register_fixture_variant(&_##fixture_name##_fixture_object, \
@@ -468,7 +468,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		__test_check_assert(_metadata); \
 	} \
 	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
-	static void __attribute__((constructor(KSELFTEST_PRIO_TEST_F))) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
 			_register_##fixture_name##_##test_name(void) \
 	{ \
 		struct __test_metadata *object = mmap(NULL, sizeof(*object), \
@@ -1335,7 +1335,7 @@ static int test_harness_run(int argc, char **argv)
 	return KSFT_FAIL;
 }
 
-static void __attribute__((constructor)) __constructor_order_first(void)
+static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) __constructor_order_first(void)
 {
 	__constructor_order_forward = true;
 }
-- 
2.53.0



