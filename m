Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F962F83B8;
	Fri, 10 Oct 2025 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102287; cv=none; b=HLTWkbzWXQMU+d7N/NLuQqVWvrgvIuAuJZrFOzsF3tfBLD6gf/zoumuvR+fJE00koao/FFlLCXclpfhg7Qoz/wXIKIb2idRlcY85Nz9r+Uf3PDBw4PUfvt3DEGhEKM/qqdKYfB8TB1y2NUPcUaqx0n/vK8E+MepvAKZgIcnsAWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102287; c=relaxed/simple;
	bh=ohLUyIbuOzU9Me1i2n3TK1EBXSfBZQi4lIeJ/yUfwME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjW/uz2vSfBWQ6S3kqvPdJ2ipDT7ZNaXQYLobeOBloWj3ZODL1XAEwyicF+rx9oKc/c29Ptf2g0oCqzwE2tWY1tuywIFqn7aC/M1apRF6M3QPjSliJOPazYFYSXoZqfAGwXlxlWUK4hv426OFXEgiz+Hnvo9lS9OlHqbPWDL47g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BclmSP4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BclmSP4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A98C4CEF1;
	Fri, 10 Oct 2025 13:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102287;
	bh=ohLUyIbuOzU9Me1i2n3TK1EBXSfBZQi4lIeJ/yUfwME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BclmSP4zs2cnNDGVcnm4b794b+6LwI3sE4VwiMrinSGq4lKvKD1Z2zuy3rfVrTX5c
	 A27UuCgUqZYSbFwklRvEMwL6NFVI5imHeLFtrqKrq/YsYTOdVC90WESeR8i1VrVclP
	 O24CwtPn9z8Eak3LFB0yl4ERiQiYfaA8upf2g8FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Jon Kohler <jon@nutanix.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 20/26] Revert "crypto: testmgr - desupport SHA-1 for FIPS 140"
Date: Fri, 10 Oct 2025 15:16:15 +0200
Message-ID: <20251010131331.941774189@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit ca1354f7999d30cf565e810b56cba688927107c6 upstream.

This reverts commit 9d50a25eeb05c45fef46120f4527885a14c84fb2.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Jon Kohler <jon@nutanix.com>
Link: https://lore.kernel.org/all/05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org/
Link: https://lore.kernel.org/all/26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/testmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ee33ba21ae2b..3e284706152a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4186,6 +4186,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha1),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha1-lib,cbc(aes-generic))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha1_aes_cbc_tv_temp)
 		}
@@ -4206,6 +4207,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),ctr(aes))",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
 		.generic_driver = "authenc(hmac-sha1-lib,ecb-cipher_null)",
@@ -4216,6 +4218,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.generic_driver = "authenc(hmac-sha224-lib,cbc(des-generic))",
@@ -5078,6 +5081,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "hmac(sha1)",
 		.generic_driver = "hmac-sha1-lib",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(hmac_sha1_tv_template)
 		}
@@ -5448,6 +5452,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "sha1",
 		.generic_driver = "sha1-lib",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(sha1_tv_template)
 		}
-- 
2.51.0



