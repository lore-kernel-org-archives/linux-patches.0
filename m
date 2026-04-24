Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597BF3537DF;
	Fri, 24 Apr 2026 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038094; cv=none; b=W/pYAf4AhMB5vOIVsmnP7AC7+MFlvO9167N+6XxnXSoToEyBmmCas03k2uDDsahYeW9QGFyCUbT2H8YLcEI+QuUv0/muFv8Le0TIuI5L39HkGnOwQTGhKIRvHIjZXMto0Fc9zQM4kv386T8xiz8gtUQrV3AmA+8tKusDrM/Se2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038094; c=relaxed/simple;
	bh=0iEiqTfDuW1G85gYn7uhvcJg2POyTTK13J1nK3OriKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odJWcA55AIiV105gtj3XkA4QGzBCAJZZYodCuh/ON3fMwpEJTKh5MqFMhenbUEjV0GotaRyGK0Zw2zALAcl/vR8w9nN5hvqfz0NHc7Rfq1LTogcNcRDzLT1REpYGWaFS5dALbQJPKzKqOqNbIAX773X8171+ICwf/WI1OnSTops=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcQmXVqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcQmXVqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47E3C19425;
	Fri, 24 Apr 2026 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038094;
	bh=0iEiqTfDuW1G85gYn7uhvcJg2POyTTK13J1nK3OriKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcQmXVqN912Q4PrcYG0QL0SN/3YbsD9Cv4+JUZjJb/atMAoOkNMI8QtP6Pduc1iZh
	 gDwt+hhsJ8yFNW+56DqzhxwN1fuBMHbJ7daaAMv8ahsIq4ezkRNn5JPoAnHMEHZFHk
	 /mBjhuDMQ9NhFbiXt5yBQjA73bV7yUC0f9X3TdaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 21/55] lib/crypto: tests: Add a .kunitconfig file
Date: Fri, 24 Apr 2026 15:31:00 +0200
Message-ID: <20260424132434.493557648@linuxfoundation.org>
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

commit 20d6f07004d639967dcb00994d56ce6d16118e9e upstream.

Add a .kunitconfig file to the lib/crypto/ directory so that the crypto
library tests can be run more easily using kunit.py.  Example with UML:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto

Example with QEMU:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto --arch=arm64 --make_options LLVM=1

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260301040140.490310-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/.kunitconfig |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 lib/crypto/.kunitconfig

--- /dev/null
+++ b/lib/crypto/.kunitconfig
@@ -0,0 +1,23 @@
+CONFIG_KUNIT=y
+
+# These kconfig options select all the CONFIG_CRYPTO_LIB_* symbols that have a
+# corresponding KUnit test.  Those symbols cannot be directly enabled here,
+# since they are hidden symbols.
+CONFIG_CRYPTO=y
+CONFIG_CRYPTO_MD5=y
+CONFIG_CRYPTO_SHA1=y
+CONFIG_CRYPTO_SHA256=y
+CONFIG_CRYPTO_SHA512=y
+CONFIG_INET=y
+CONFIG_IPV6=y
+CONFIG_NET=y
+CONFIG_NETDEVICES=y
+CONFIG_WIREGUARD=y
+
+CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST=y


