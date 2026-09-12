Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2FF2D47F1;
	Sat, 12 Sep 2026 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222689; cv=none; b=YWJUEfIkXVEFAQE1jeulRLHbN59CyLmjEXvWIA+xCP37BCB6aLvpKWcvt11T8HkHFvXjUlIOtfjknG03pAFuo5W/FiJlEgVh0faWAdOyVPryLM9RuSHBCTpiwRMOpqRcmulT0/jznZehdYuh8O6g32ib/3pzhYXBCcFXoCcwMYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222689; c=relaxed/simple;
	bh=RwzpS959SnQCkUj3/GSXCI14NUpC28YxlCaVYkrgLv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S93gLnkfsv8RShATA4lBLmYcQU4AcWsto46SM/5cuRkJSF9KlCEZolTWhYQ6sySwjbFy0aUsbUSCi6C6s7qDG7rsR/Dq0SFdKUniA0GAG4Q28XCZeJhMEbmY3bnATk8aUh3zAHU/MZxJl9h7NCct5lmQB8anAgfgHm5nmpkOyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMgj2dbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMgj2dbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28531F000FF;
	Sat, 12 Sep 2026 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222687;
	bh=WSezKDpG5kY8o0CgZewM8bLzZSlwxWz+yUg+S4lL8E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMgj2dbdppMAPSxyTfrjx2OY2GbgClYzM40TIrMBxIZa/GA+oihJHs9fzhsxxO/Do
	 tbE27sZDcJDT7d2+Y47TCch231EKUI4Ok4XgJTIsrLQeqDi2293HLgyxlF0EgimRZa
	 CyMzl7ozqZ0KlMrUO5IjDQmw8IT/1CrP8OrJUdsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Laight <david.laght.linux@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0638/1424] crypto: atmel-ecc - replace min_t with min
Date: Sat, 12 Sep 2026 08:51:10 +0200
Message-ID: <20260912065621.577756261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 5b085b2a038a1458f9398cb3b3b03cba6e38e1e0 ]

Use the simpler min() macro since the values are all unsigned and
compatible.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: David Laight <david.laght.linux@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f240f9b588f4 ("crypto: atmel-ecc - reject hardware ECDH without a public key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9da5a03880807..0ce56b095805a 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -56,7 +56,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 		goto free_work_data;
 
 	/* might want less than we've got */
-	n_sz = min_t(size_t, ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
+	n_sz = min(ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
 
 	/* copy the shared secret */
 	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, n_sz),
@@ -150,7 +150,7 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
 		return -EINVAL;
 
 	/* might want less than we've got */
-	nbytes = min_t(size_t, ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
+	nbytes = min(ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
 
 	/* public key was saved at private key generation */
 	copied = sg_copy_from_buffer(req->dst,
-- 
2.53.0



