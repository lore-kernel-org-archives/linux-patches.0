Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED43221540;
	Mon,  2 Jun 2025 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873617; cv=none; b=ERW67o9cu9h9EdcQ+gDIVFoTzcrvd9n3USB2hXBt5mAu5fLvJn+sGXwwDIxhSfMYqVnkFK3deAE/J/Ed07zsftg3NxmyERYICbYrOJ2fdDjF4ZAwAkfV8qaWCCEDVR+aSYBE1yhiYdI56wxx9m8FW1A4Ro9KPm0jaw9CuhIug8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873617; c=relaxed/simple;
	bh=dTIzzPXXO0QVJIb71YtymwdMd2wIwKg2AZwbsKt2egY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbQ4DiVrPYP3rgTOxfze/bSampqyoDXYdeXdh5kva+baOFPt2sYiTRQZsHa3L2XJn7bjxbcOMcG72NaqP4yUa21PugikwplahngJi293VuhUbBzdWCxV0yunWf23l09Lejenogn6AvGRHMJJM78YJ1hD3lmwSngDJVcm/nHtBfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gb1ty9sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gb1ty9sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BE5C4CEEB;
	Mon,  2 Jun 2025 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873616;
	bh=dTIzzPXXO0QVJIb71YtymwdMd2wIwKg2AZwbsKt2egY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gb1ty9sw7pv2khUnhkHG4fYlqGVjcMx/Orth8xMWBrNnyGMzXX7ynEaG5c/fd/b9S
	 2cadf3HQqWKMKT1ywvS5CJsLZqh4tCu2YtyhskHUgh4r7egFxUo/ar4MlAe/L8oUiv
	 boHYK/h4b4OWEWXYMZTZHjf21bJrEV3Vfqfu/xyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/444] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Date: Mon,  2 Jun 2025 15:44:21 +0200
Message-ID: <20250602134348.903270863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7b275716cf4e3..acc879ed6031a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -811,6 +811,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
2.39.5



