Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621461;
	b=R3mEGiHveP6cdMNICjfOsrJ/qRB0NJWBkL/YAECqW7cC/p5A0Yo3il4YTT2XaUWh9B4Q
	 aQLbAGoTNMYEo1JhXGZ3BJR3vRtp+8fATX4Pzm0gnTwyiv1XXcYxy3vFbDpgybHVYuyl7
	 2jKDeUAhurGBOIXj3MDVWc1u4cYMajZxSkYhOv2UA2gnxXui7XcQ2dZlyOetOD88m/19o
	 9cGOs5kkispQAI/TG/u+25Q8ifi1IDjAmqJqhJiMgQdRFYho5JVkV5CF777cZ20rVaN2A
	 w0x0qJDCVVi+7fZacEC5aBcf2FwwN10eKvYuexK8lkPU9CZpRjhwr23ErtNn5wjGr7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y18R0VyOxtO0AWL71Sr+Z5ZbweC1TpbAAvqkm2ULukc=;
	b=veVt9mQ6zXAA7ZbCJEzwBl4atL0yPuNbq5j0HucJuY9EFaiA8susmBSnEJ3oX25/zZk7
	 q4fOcVJLKCVLy2z/mwuBdVKwHUgS9qCJvtTeyUbEwnuXKjQBSqTHvUoBbI723Ep57XoSb
	 1Hp6r72zo/X+I3pKZVOdF5YnW+jXSdszigq57xotAQiK0xtAedzCSrYsWEGMDgr2rNVvv
	 FxLp0g5hAqBLNMFROz45y8xLJfQwg/go86eQQOOGFMps6U95laYQCdvBAjlN3ajQnSXhf
	 PK5bAu+pH8HaQHKH3JOQ6hY1VsWnRUmVtQknbD0eOvMb1EVJtjJ8bou2hO0UVp/4C+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rf9JRlc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE2606A337;
	Wed, 25 Nov 2026 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rf9JRlc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175031F000D0;
	Wed, 25 Nov 2026 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621460;
	bh=Y18R0VyOxtO0AWL71Sr+Z5ZbweC1TpbAAvqkm2ULukc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rf9JRlc0Mn6sFNIuXNNybTiJ1gw/dDk4fl3A5ozfD+NGoLenUxLv6j+fWzvi+P++i
	 d8YIyoNisFB1MYR2KyJb4HIDubw/KDaGdjORrCecat5LCAxRWZEnZk3Me5fR6rRvce
	 nz8zCKq+MUMQ8u+Sy/tAEphUYrAQF+PUfVKjBcQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 232/990] nvme-auth: common: add KUnit tests for TLS key derivation
Date: Wed, 25 Nov 2026 15:26:39 +0100
Message-ID: <20261125143827.523650395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit f990ad67f0febc51274adb604d5bdeab0d06d024 ]

Unit-test the sequence of function calls that derive tls_psk, so that we
can be more confident that changes in the implementation don't break it.

Since the NVMe specification doesn't seem to include any test vectors
for this (nor does its description of the algorithm seem to match what
was actually implemented, for that matter), I just set the expected
values to the values that the code currently produces.  In the case
of SHA-512, nvme_auth_generate_digest() currently returns -EINVAL, so
for now the test tests for that too.  If it is later determined that
some other behavior is needed, the test can be updated accordingly.

Tested with:

    tools/testing/kunit/kunit.py run --kunitconfig drivers/nvme/common/

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 41ad4af45ac9 ("nvmet-auth: keep the old keys if the new ones fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/.kunitconfig       |   6 +
 drivers/nvme/common/Kconfig            |   8 ++
 drivers/nvme/common/Makefile           |   2 +
 drivers/nvme/common/tests/auth_kunit.c | 175 +++++++++++++++++++++++++
 4 files changed, 191 insertions(+)
 create mode 100644 drivers/nvme/common/.kunitconfig
 create mode 100644 drivers/nvme/common/tests/auth_kunit.c

diff --git a/drivers/nvme/common/.kunitconfig b/drivers/nvme/common/.kunitconfig
new file mode 100644
index 0000000000000..60a038dc9423d
--- /dev/null
+++ b/drivers/nvme/common/.kunitconfig
@@ -0,0 +1,6 @@
+CONFIG_KUNIT=y
+CONFIG_PCI=y
+CONFIG_BLOCK=y
+CONFIG_BLK_DEV_NVME=y
+CONFIG_NVME_HOST_AUTH=y
+CONFIG_NVME_AUTH_KUNIT_TEST=y
diff --git a/drivers/nvme/common/Kconfig b/drivers/nvme/common/Kconfig
index da963e4f3f1f8..d19988c13af5f 100644
--- a/drivers/nvme/common/Kconfig
+++ b/drivers/nvme/common/Kconfig
@@ -13,3 +13,11 @@ config NVME_AUTH
 	select CRYPTO_DH
 	select CRYPTO_DH_RFC7919_GROUPS
 	select CRYPTO_HKDF
+
+config NVME_AUTH_KUNIT_TEST
+	tristate "KUnit tests for NVMe authentication" if !KUNIT_ALL_TESTS
+	depends on KUNIT && NVME_AUTH
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for some of the common code for NVMe over Fabrics
+	  In-Band Authentication.
diff --git a/drivers/nvme/common/Makefile b/drivers/nvme/common/Makefile
index 681514cf2e2f5..fd9d01a609463 100644
--- a/drivers/nvme/common/Makefile
+++ b/drivers/nvme/common/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_NVME_KEYRING)	+= nvme-keyring.o
 
 nvme-auth-y			+= auth.o
 nvme-keyring-y			+= keyring.o
+
+obj-$(CONFIG_NVME_AUTH_KUNIT_TEST) += tests/auth_kunit.o
diff --git a/drivers/nvme/common/tests/auth_kunit.c b/drivers/nvme/common/tests/auth_kunit.c
new file mode 100644
index 0000000000000..28b8dd1e3b186
--- /dev/null
+++ b/drivers/nvme/common/tests/auth_kunit.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Unit tests for NVMe authentication functions
+ *
+ * Copyright 2026 Google LLC
+ */
+
+#include <crypto/sha2.h>
+#include <kunit/test.h>
+#include <linux/nvme.h>
+#include <linux/nvme-auth.h>
+#include <linux/slab.h>
+
+struct nvme_auth_test_values {
+	u8 hmac_id;
+	size_t hash_len;
+	u8 expected_psk[NVME_AUTH_MAX_DIGEST_SIZE];
+	char *expected_psk_digest;
+	u8 expected_tls_psk[NVME_AUTH_MAX_DIGEST_SIZE];
+};
+
+static void kfree_action(void *ptr)
+{
+	kfree(ptr);
+}
+
+static void kunit_add_kfree_action(struct kunit *test, void *ptr)
+{
+	KUNIT_ASSERT_EQ(test, 0,
+			kunit_add_action_or_reset(test, kfree_action, ptr));
+}
+
+/*
+ * Test the derivation of a TLS PSK from the initial skey.  The vals parameter
+ * gives the expected value of tls_psk as well as the intermediate values psk
+ * and psk_digest.  The inputs are implicitly the fixed values set below.
+ */
+static void
+test_nvme_auth_derive_tls_psk(struct kunit *test,
+			      const struct nvme_auth_test_values *vals)
+{
+	const u8 hmac_id = vals->hmac_id;
+	const size_t hash_len = vals->hash_len;
+	const size_t skey_len = hash_len;
+	u8 skey[NVME_AUTH_MAX_DIGEST_SIZE];
+	u8 c1[NVME_AUTH_MAX_DIGEST_SIZE];
+	u8 c2[NVME_AUTH_MAX_DIGEST_SIZE];
+	const char *subsysnqn = "subsysnqn";
+	const char *hostnqn = "hostnqn";
+	u8 *psk = NULL, *tls_psk = NULL;
+	char *psk_digest = NULL;
+	size_t psk_len;
+	int ret;
+
+	for (int i = 0; i < NVME_AUTH_MAX_DIGEST_SIZE; i++) {
+		skey[i] = 'A' + i;
+		c1[i] = i;
+		c2[i] = 0xff - i;
+	}
+
+	ret = nvme_auth_generate_psk(hmac_id, skey, skey_len, c1, c2, hash_len,
+				     &psk, &psk_len);
+	kunit_add_kfree_action(test, psk);
+	KUNIT_ASSERT_EQ(test, 0, ret);
+	KUNIT_ASSERT_EQ(test, hash_len, psk_len);
+	KUNIT_ASSERT_MEMEQ(test, vals->expected_psk, psk, psk_len);
+
+	ret = nvme_auth_generate_digest(hmac_id, psk, psk_len, subsysnqn,
+					hostnqn, &psk_digest);
+	kunit_add_kfree_action(test, psk_digest);
+	if (vals->expected_psk_digest == NULL) {
+		/*
+		 * Algorithm has an ID assigned but is not supported by
+		 * nvme_auth_generate_digest().
+		 */
+		KUNIT_ASSERT_EQ(test, -EINVAL, ret);
+		return;
+	}
+	KUNIT_ASSERT_EQ(test, 0, ret);
+	KUNIT_ASSERT_STREQ(test, vals->expected_psk_digest, psk_digest);
+
+	ret = nvme_auth_derive_tls_psk(hmac_id, psk, psk_len, psk_digest,
+				       &tls_psk);
+	kunit_add_kfree_action(test, tls_psk);
+	KUNIT_ASSERT_EQ(test, 0, ret);
+	KUNIT_ASSERT_MEMEQ(test, vals->expected_tls_psk, tls_psk, psk_len);
+}
+
+static void test_nvme_auth_derive_tls_psk_hmac_sha256(struct kunit *test)
+{
+	static const struct nvme_auth_test_values vals = {
+		.hmac_id = NVME_AUTH_HASH_SHA256,
+		.hash_len = SHA256_DIGEST_SIZE,
+		.expected_psk = {
+			0x17, 0x33, 0xc5, 0x9f, 0xa7, 0xf4, 0x8f, 0xcf,
+			0x37, 0xf5, 0xf2, 0x6f, 0xc4, 0xff, 0x02, 0x68,
+			0xad, 0x4f, 0x78, 0xe0, 0x30, 0xf4, 0xf3, 0xb0,
+			0xbf, 0xd1, 0xd4, 0x7e, 0x7b, 0xb1, 0x44, 0x7a,
+		},
+		.expected_psk_digest = "OldoKuTfKddMuyCznAZojkWD7P4D9/AtzDzLimtOxqI=",
+		.expected_tls_psk = {
+			0x3c, 0x17, 0xda, 0x62, 0x84, 0x74, 0xa0, 0x4d,
+			0x22, 0x47, 0xc4, 0xca, 0xb4, 0x79, 0x68, 0xc9,
+			0x15, 0x38, 0x81, 0x93, 0xf7, 0xc0, 0x71, 0xbd,
+			0x94, 0x89, 0xcc, 0x36, 0x66, 0xcd, 0x7c, 0xc8,
+		},
+	};
+
+	test_nvme_auth_derive_tls_psk(test, &vals);
+}
+
+static void test_nvme_auth_derive_tls_psk_hmac_sha384(struct kunit *test)
+{
+	static const struct nvme_auth_test_values vals = {
+		.hmac_id = NVME_AUTH_HASH_SHA384,
+		.hash_len = SHA384_DIGEST_SIZE,
+		.expected_psk = {
+			0xf1, 0x4b, 0x2d, 0xd3, 0x23, 0x4c, 0x45, 0x96,
+			0x94, 0xd3, 0xbc, 0x63, 0xf8, 0x96, 0x8b, 0xd6,
+			0xb3, 0x7c, 0x2c, 0x6d, 0xe8, 0x49, 0xe2, 0x2e,
+			0x11, 0x87, 0x49, 0x00, 0x1c, 0xe4, 0xbb, 0xe8,
+			0x64, 0x0b, 0x9e, 0x3a, 0x74, 0x8c, 0xb1, 0x1c,
+			0xe4, 0xb1, 0xd7, 0x1d, 0x35, 0x9c, 0xce, 0x39,
+		},
+		.expected_psk_digest = "cffMWk8TSS7HOQebjgYEIkrPrjWPV4JE5cdPB8WhEvY4JBW5YynKyv66XscN4A9n",
+		.expected_tls_psk = {
+			0x27, 0x74, 0x75, 0x32, 0x33, 0x53, 0x7b, 0x3f,
+			0xa5, 0x0e, 0xb7, 0xd1, 0x6a, 0x8e, 0x43, 0x45,
+			0x7d, 0x85, 0xf4, 0x90, 0x6c, 0x00, 0x5b, 0x22,
+			0x36, 0x61, 0x6c, 0x5d, 0x80, 0x93, 0x9d, 0x08,
+			0x98, 0xff, 0xf1, 0x5b, 0xb8, 0xb7, 0x71, 0x19,
+			0xd2, 0xbe, 0x0a, 0xac, 0x42, 0x3e, 0x75, 0x90,
+		},
+	};
+
+	test_nvme_auth_derive_tls_psk(test, &vals);
+}
+
+static void test_nvme_auth_derive_tls_psk_hmac_sha512(struct kunit *test)
+{
+	static const struct nvme_auth_test_values vals = {
+		.hmac_id = NVME_AUTH_HASH_SHA512,
+		.hash_len = SHA512_DIGEST_SIZE,
+		.expected_psk = {
+			0x9c, 0x9f, 0x08, 0x9a, 0x61, 0x8b, 0x47, 0xd2,
+			0xd7, 0x5f, 0x4b, 0x6c, 0x28, 0x07, 0x04, 0x24,
+			0x48, 0x7b, 0x44, 0x5d, 0xd9, 0x6e, 0x70, 0xc4,
+			0xc0, 0x9b, 0x55, 0xe8, 0xb6, 0x00, 0x01, 0x52,
+			0xa3, 0x36, 0x3c, 0x34, 0x54, 0x04, 0x3f, 0x38,
+			0xf0, 0xb8, 0x50, 0x36, 0xde, 0xd4, 0x06, 0x55,
+			0x35, 0x0a, 0xa8, 0x7b, 0x8b, 0x6a, 0x28, 0x2b,
+			0x5c, 0x1a, 0xca, 0xe1, 0x62, 0x33, 0xdd, 0x5b,
+		},
+		/* nvme_auth_generate_digest() doesn't support SHA-512 yet. */
+		.expected_psk_digest = NULL,
+	};
+
+	test_nvme_auth_derive_tls_psk(test, &vals);
+}
+
+static struct kunit_case nvme_auth_test_cases[] = {
+	KUNIT_CASE(test_nvme_auth_derive_tls_psk_hmac_sha256),
+	KUNIT_CASE(test_nvme_auth_derive_tls_psk_hmac_sha384),
+	KUNIT_CASE(test_nvme_auth_derive_tls_psk_hmac_sha512),
+	{},
+};
+
+static struct kunit_suite nvme_auth_test_suite = {
+	.name = "nvme-auth",
+	.test_cases = nvme_auth_test_cases,
+};
+kunit_test_suite(nvme_auth_test_suite);
+
+MODULE_DESCRIPTION("Unit tests for NVMe authentication functions");
+MODULE_LICENSE("GPL");
-- 
2.53.0



