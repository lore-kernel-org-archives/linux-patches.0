Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE2C1A3159;
	Tue, 27 May 2025 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367533; cv=none; b=H02YJLhr3WAt83Q6Mc8/+PY+u6oX+THNBsIys2MYte9BoSbr1ykhDzXyTZtIepajqXrTzcn2TIGA1NTgLE38qnyAccmmIzvzUMYrWWLRgGiPtFGDCehh9dA9a4t78NLCfuIBxG/KCKdizhtbnJfM/oOj5/+9sbIdpKA3pmZXlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367533; c=relaxed/simple;
	bh=csaGidVQpb1dtuWTJ9Sev2eW2gSZwFYkk0dChFfUHlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcuKOa4dSFiwzah/nvSy43KizHVzKkZmMxcFT+BAfi/1s2jMXhc4Id47W1eiLJ/lKMwC8xyD79XIKJHQVHykNskf4w2etQJQT2sT8Kg6vjEXbIpzXU0g+GJ7hRlGTRFPQrI8RWzrWyW4tH3G+jVAkoocv6SQUfy/BPixe0BohpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYlvzFrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYlvzFrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF23FC4CEE9;
	Tue, 27 May 2025 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367533;
	bh=csaGidVQpb1dtuWTJ9Sev2eW2gSZwFYkk0dChFfUHlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYlvzFrTPnQfZF4xiN/vurAOEuw2h3RuAFvZpk9rMhh/ryMJNQxKbRi2s3/w0TfsF
	 AdN4sEXoBFg5TSR3MQQN4qEZbRdVDPamvW4YSFTUPZ9klJAJVExPnLvOXuEQ1ZLLcY
	 v/0/IKFmmzhdSN6+JqevFKP8a6974BpnoBkI8egY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 378/783] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Date: Tue, 27 May 2025 18:22:55 +0200
Message-ID: <20250527162528.485091944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index a9eb2dcf28982..2d2b1589a0097 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -681,6 +681,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
2.39.5



