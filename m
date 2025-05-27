Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60F178F32;
	Tue, 27 May 2025 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365230; cv=none; b=aeD1ofM5KKGvoAnaBNonOrpOQ5aOQSwOoxP7UKCOo1Tsqas0800Ytj3Ic0O4ET0fPATmv1Mwlbr8Bdi/uWbOUa8DZOpAiOSBr9LWQYho/X4V3KnbEnWjct4kXy30OWqjRPfQI3dINe+6/XclLyamZC1dE8ne6Rdm+FWwkSBal00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365230; c=relaxed/simple;
	bh=cxr+n5nYvgCDnsxKCOPwRTiu4VveEHjEzYxMwqeSFzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnYrxjQ4V3aUuYThs1gaX+GswD+bGSjAf8wViHVL/kmQHd62dtKIfklHA7gABPnaDas6ra4K/cttqB1X4On8Q1Zo576aUCHtNSCaE77wZKRsIcbrBjKn505GlEZSeEFSibV2A4vWH9weaPJH/8KTmXHrEE4l5z3qYN3IunBAJbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ufm0KZRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ufm0KZRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4F6C4CEE9;
	Tue, 27 May 2025 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365229;
	bh=cxr+n5nYvgCDnsxKCOPwRTiu4VveEHjEzYxMwqeSFzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ufm0KZRhxF+SjlK+HtZhH0LezbbaGwtI6ZqbZm1k3dIHmEoYqhR7x3Rc49Ss+C7sU
	 iQIbks1UHPczFBPQCTGY8avsJmugExUpeRi0TckhLQ8qpB4DikJyKbpROXmkmUaZga
	 cZfpk/ojNpQFANkSyEGpbPetIt/Z0H1MuAMVvFrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/626] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Date: Tue, 27 May 2025 18:23:20 +0200
Message-ID: <20250527162457.507110397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ee509efc74ddbc59bb5d6fd6e050f9ef25f74bff ]

The type needs to be zeroed as otherwise the user could use it to
allocate an asynchronous sync skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index ceed7f33a67ba..fd3273b519dc0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -844,6 +844,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
2.39.5



