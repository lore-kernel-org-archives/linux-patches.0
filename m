Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE85221DB6;
	Fri, 24 Apr 2026 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038145; cv=none; b=hMG45ljIfU0+lw/V5LmcWbDOtIVoFIH1a/ZiLNyU/6L78Zb4M9s+rkYJWkAXrOnsHmMivRv9EhPqkt44YHs6x64z5u3zvB46r7d9OvXifvO+sdVp2uGA6jfeMvKeZeR+HfTmSMjoSK3M7m3Yb7HLkpA3twSf8BSTuaYcQjeEQo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038145; c=relaxed/simple;
	bh=yXWHzGjS4FwSRU11zEyNnNABdYZ8e/jAlVn30kYaS28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaoFEc2yfJwcXHo94ji0ooBv34i4P6+x5MNgWGIqQgnIXbGH55p24hjAgHzzvwCo8iFmm3zVLeoIXRor+PmN69cifPwWhWQf64J20cRKiYDISs0t9Gtqiw4XrEtOloAVvbeN6CwqzZAKeIjD/HfsGkfc4ctF1xGWIa3VR39hJ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLufOlUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLufOlUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74309C19425;
	Fri, 24 Apr 2026 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038145;
	bh=yXWHzGjS4FwSRU11zEyNnNABdYZ8e/jAlVn30kYaS28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLufOlUYg5u3PH/oXtGZt7Q8/bUj62LGFcAl2HS4SR3OXAK1R7atlZhdme7avGJtL
	 oeLXvxUGINrnFT1amrsmA08VWBwaq8im4wqWUwlLNtG2+bKNld9nd+QlISLcNXvDDd
	 cVGzka5bS388UcK8cXjtM82w8d+FQw5fy5evpSNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 24/55] lib/crypto: tests: Drop the default to CRYPTO_SELFTESTS
Date: Fri, 24 Apr 2026 15:31:03 +0200
Message-ID: <20260424132435.056190824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 6d80749becf8fc5ffa004194e578f79b558235ef upstream.

Defaulting the crypto KUnit tests to KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
instead of simply KUNIT_ALL_TESTS was originally intended to make it
easy to enable all the crypto KUnit tests.  This additional default is
nonstandard for KUnit tests, though, and it can cause all the KUnit
tests to be built-in unexpectedly if CRYPTO_SELFTESTS is set.  It also
constitutes a back-reference to crypto/ from lib/crypto/, which is
something that we should be avoiding in order to get clean layering.

Now that we provide a lib/crypto/.kunitconfig file that enables all
crypto KUnit tests, let's consider that to be the supported way to
enable all these tests, and drop the default of CRYPTO_SELFTESTS.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260317040626.5697-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/tests/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -3,7 +3,7 @@
 config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
 	tristate "KUnit tests for BLAKE2s" if !KUNIT_ALL_TESTS
 	depends on KUNIT
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	# No need to depend on CRYPTO_LIB_BLAKE2S here, as that option doesn't
 	# exist; the BLAKE2s code is always built-in for the /dev/random driver.
@@ -13,7 +13,7 @@ config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
 config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 	tristate "KUnit tests for Curve25519" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_CURVE25519
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the Curve25519 Diffie-Hellman function.
@@ -21,7 +21,7 @@ config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_MD5
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the MD5 cryptographic hash function and its
@@ -30,7 +30,7 @@ config CRYPTO_LIB_MD5_KUNIT_TEST
 config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_POLY1305
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the Poly1305 library functions.
@@ -38,7 +38,7 @@ config CRYPTO_LIB_POLY1305_KUNIT_TEST
 config CRYPTO_LIB_SHA1_KUNIT_TEST
 	tristate "KUnit tests for SHA-1" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA1
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-1 cryptographic hash function and its
@@ -49,7 +49,7 @@ config CRYPTO_LIB_SHA1_KUNIT_TEST
 config CRYPTO_LIB_SHA256_KUNIT_TEST
 	tristate "KUnit tests for SHA-224 and SHA-256" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA256
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-224 and SHA-256 cryptographic hash functions
@@ -60,7 +60,7 @@ config CRYPTO_LIB_SHA256_KUNIT_TEST
 config CRYPTO_LIB_SHA512_KUNIT_TEST
 	tristate "KUnit tests for SHA-384 and SHA-512" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_SHA512
-	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-384 and SHA-512 cryptographic hash functions


