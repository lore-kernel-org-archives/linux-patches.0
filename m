Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016949;
	b=sdqLFNPHta3Zi+x1JfU4hfO4z5M6jcxVNkzNu9j7X5ZBIGsqQ8juhTthF8nnluyjAhFi
	 y405TvpZUA8ZOCZM4oyl4rnqoC9xzstnNoO/EUiC7aKqRmGdkwqI9MbXL6OQlBPjbrwbC
	 eiUK+KLznz3bgf8tvoA88fOmui5tiePH9423nUJcgoben7wc57FdJ5eJr0qWapWhil6Qq
	 S4AQ3QPjG5eTPeaBddZs8G4bTkh5IdwPaGqwhV7/m2ZQ8EaRwnhU8h7OM1apV+OaAdSah
	 aKkjLcFNmWsn2rvBOcTfuPP2UL1/He18QDiBjhVLaPykFQ4o24THTmLsuNOBZy+gWnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mhc+ZpU9sllDL6+blBWfS2bgEHRhcY8TvYirlMtRzdU=;
	b=AUFmDSUQCFbeFRVzBKyY91DGLwH3j3k/migxbG9iIKnhHXFgkZiU7xzizWnK5/ponVUB
	 tCSdIH3simOs5smIu5e+K7IWAECi2S4CmJ2gygMJS3J5kIcGb2pIuc9Z4i7sJMD4e0+qQ
	 17S63peIez7ApocshoqTbVLSZKcFyNDcNdGTTCamq1rvyUDvilNy4hqOYJBO44A+fblEW
	 rHNY5EK5IRDcOUHIwivgAJKOYF3TZ0cWeA56pIimzJPTtBqMAg6zTjy3/juTadb+uB2Xb
	 HTc350JuvJKI+SloxaWrPRfzoctfm6Po64iCyllnQcG0RZl2i1UCiu+z4dBQq25Bs3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2YuTQZd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26277606A320;
	Wed, 18 Nov 2026 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2YuTQZd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A941F000C4;
	Wed, 18 Nov 2026 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016948;
	bh=Mhc+ZpU9sllDL6+blBWfS2bgEHRhcY8TvYirlMtRzdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2YuTQZdYpMXLv1skj4ucHxQIupB1CmRlk+gTuhTPBp6/F6AkHy1x+zBY1+Iyo/q4
	 mhguCiqZgno1jJz73TvjFiPqC68ofqjYI+sz3STtNbG7VdPd4XJ+4b0qNlrLqT8hwV
	 /lAsHluYy4fYfhCPYRwrGFkY7bbBlFiNSeAPxZjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0693/2651] crypto: api - Fix DUP_FIRST crash on unregister
Date: Wed, 18 Nov 2026 15:32:13 +0100
Message-ID: <20261118150312.795715635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1dfb35de0800967c972eee35e19f3dfc8d50e512 ]

The flag CRYPTO_ALG_DUP_FIRST is buggy because upon unregistration
it tries to unregister the original algorithm rather than the
duplicate which was allocated during registration.

Fix this by locating the duplicated algorithm and unregistering
that instead of the original.

Also remove the duplicate crypto_destroy_alg call.

Reported-by: Chenghai Huang <huangchenghai2@huawei.com>
Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 37de377719aec..a6839e2a20f38 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -424,7 +424,6 @@ static void crypto_free_alg(struct crypto_alg *alg)
 	unsigned int algsize = alg->cra_type->algsize;
 	u8 *p = (u8 *)alg - algsize;
 
-	crypto_destroy_alg(alg);
 	kfree(p);
 }
 
@@ -494,9 +493,31 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	LIST_HEAD(list);
 
 	down_write(&crypto_alg_sem);
+	if (alg->cra_flags & CRYPTO_ALG_DUP_FIRST) {
+		struct crypto_alg *q, *r = NULL;
+
+		list_for_each_entry(q, &crypto_alg_list, cra_list) {
+			if (crypto_is_larval(q))
+				continue;
+			if (strcmp(q->cra_driver_name, alg->cra_driver_name))
+				continue;
+			r = q;
+			break;
+		}
+
+		if (!r) {
+			up_write(&crypto_alg_sem);
+			ret = -ENOENT;
+			goto not_found;
+		}
+
+		alg = r;
+	}
+
 	ret = crypto_remove_alg(alg, &list);
 	up_write(&crypto_alg_sem);
 
+not_found:
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-- 
2.53.0



