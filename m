Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA8025F78A;
	Tue, 11 Mar 2025 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707312; cv=none; b=TgsXiju1Fk04xN1BCdQp6iNmwNxqVMOitYBJTw2Wc4CKTXs6iwAK0BZCsA+/vdjz3vdOVUNZkNMDQe78Pu7/GRJRJWsCuzzDTA1jTozN3aD3VL8su/6zQNTMr6aRR3Fjsa3Vyp34Xn85ch9k6X6YqgPTxZbtFBalBYGnSjStECE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707312; c=relaxed/simple;
	bh=knmTFYVHLn6wWrFx7xXBlCkLAOi3FP22ZzLww15drfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmSKludbp39rmbma4WAEGd+/VM4tBmDwqhG143TzaS0yHkqOonCmRs7KEKcUmTvjxK/GESmyh1Hgw2B01FZ7iZAksXQs8BtEUjG7KPgABXhnqIBMc+Bs2XKxPTppfcBhhly1f6QaaC5SygWWM2jBsSTjufn+EJ11OUc8WyGEeEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnOs4J92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnOs4J92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE280C4CEEC;
	Tue, 11 Mar 2025 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707312;
	bh=knmTFYVHLn6wWrFx7xXBlCkLAOi3FP22ZzLww15drfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnOs4J92j6LEcKAApvZk+LAAaZpqR1xxZbm4f++2dXzPa5lWhgNkADF5Yuk2Cgc+V
	 1gQHUzs5j1P5xzPostL1b9AwndN9xNvJxhydLLWyo8KAsz7tBTFWjNxrKa0tZ6FCLG
	 RngqoVwLEkA4/tqv7fhmvT/k+x3+A1i31K14uxKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei he <helei.sig11@bytedance.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/462] crypto: testmgr - fix version number of RSA tests
Date: Tue, 11 Mar 2025 15:59:41 +0100
Message-ID: <20250311145810.805548719@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: lei he <helei.sig11@bytedance.com>

[ Upstream commit 0bb8f125253843c445b70fc6ef4fb21aa7b25625 ]

According to PKCS#1 standard, the 'otherPrimeInfos' field contains
the information for the additional primes r_3, ..., r_u, in order.
It shall be omitted if the version is 0 and shall contain at least
one instance of OtherPrimeInfo if the version is 1, see:
	https://www.rfc-editor.org/rfc/rfc3447#page-44

Replace the version number '1' with 0, otherwise, some drivers may
not pass the run-time tests.

Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 24bc1924edb72..8a31946899f05 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -184,7 +184,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 #ifndef CONFIG_CRYPTO_FIPS
 	.key =
 	"\x30\x81\x9A" /* sequence of 154 bytes */
-	"\x02\x01\x01" /* version - integer of 1 byte */
+	"\x02\x01\x00" /* version - integer of 1 byte */
 	"\x02\x41" /* modulus - integer of 65 bytes */
 	"\x00\xAA\x36\xAB\xCE\x88\xAC\xFD\xFF\x55\x52\x3C\x7F\xC4\x52\x3F"
 	"\x90\xEF\xA0\x0D\xF3\x77\x4A\x25\x9F\x2E\x62\xB4\xC5\xD9\x9C\xB5"
@@ -214,7 +214,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 	}, {
 	.key =
 	"\x30\x82\x01\x1D" /* sequence of 285 bytes */
-	"\x02\x01\x01" /* version - integer of 1 byte */
+	"\x02\x01\x00" /* version - integer of 1 byte */
 	"\x02\x81\x81" /* modulus - integer of 129 bytes */
 	"\x00\xBB\xF8\x2F\x09\x06\x82\xCE\x9C\x23\x38\xAC\x2B\x9D\xA8\x71"
 	"\xF7\x36\x8D\x07\xEE\xD4\x10\x43\xA4\x40\xD6\xB6\xF0\x74\x54\xF5"
@@ -258,7 +258,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 #endif
 	.key =
 	"\x30\x82\x02\x20" /* sequence of 544 bytes */
-	"\x02\x01\x01" /* version - integer of 1 byte */
+	"\x02\x01\x00" /* version - integer of 1 byte */
 	"\x02\x82\x01\x01\x00" /* modulus - integer of 256 bytes */
 	"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
 	"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
-- 
2.39.5



