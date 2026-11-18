Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024150;
	b=2xKfUqLlAypCz5QXh/3LOVe4RGnilkLuZiBwBp1NQFEn207A5weXrdT3fF2OLujNA1zQ
	 PzA+2MoyUfFBwNGrcOB8dn6lT/6aZe8Xuy1lIhGcXqR6QKwgL51C8FwlXJ5lSQWEN/nYg
	 tM3NgHkJRuR5UtilwKNZV1O8WBjdQkWt4/udYIOzihDG40rHq3fO+txpTndoq8ork65Jl
	 U3fLIiw9vpEyQQ8vGM15YiCDtBpEBHulR7MQguiz8WXTuVxLJtlH26XtUEqsAQ/RFVjbF
	 5ER1DTwKQCmqDVCveMXk+MB3aFi6Ma5sM2GZou/rt0WrXyBjUPjcTQSN/h2DLkbo9DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gBYYpGFUCCP6kKAEfLSiAPOZyP/HJZcDC+Y/J0TtWzI=;
	b=3grl5VHocepgaHZwl46xpKLZWeBGvwWWFndM/kTho0tA0+pGiZwHt4/UXWvtH/Zz/EGv
	 zqmKov5zP0EdakSHdjx1uzzSjMKiglNGmYWdIumeEqJI3Wdotee4uBmB2tvKE8AR1KeNW
	 SyFFiYQHCgDpZik6Uqeh8Dl1zRl5BqR+CHWpnUX/92YviFaRE8LbMGo8C3Mxyqn5Ph4K3
	 eD6+USyF3nuDadWqoVZmjfeJ71MmFyt4JJgEQtwBUNpiTdjp7tA9mP/I1wWlAq+lbQysR
	 EkQ3nbS1btHgvGKpm0UrbNaOJ6ReH6fDw71S72VDA9DcoJbHcqCOsGuFbOKKlVprl/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFyGqR9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B96606A31C;
	Wed, 18 Nov 2026 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFyGqR9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507E31F000C4;
	Wed, 18 Nov 2026 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024149;
	bh=gBYYpGFUCCP6kKAEfLSiAPOZyP/HJZcDC+Y/J0TtWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFyGqR9bQMg9TgwoxaB+lxzNaRAnAttYs2gI3WRiyfiSN9l8W/7vFpvge/Dt4Z855
	 xd2Y/LZPw7oFJAjDGhb2McBcz6CP4xhBD2NjbOpEdyThEr64DvATZO38fYu7Kgg3Wg
	 xrfG3OU/1Mr2RUfU2GgTPvvM0xK0xir1TLRpZunc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0623/2151] crypto: api - Fix DUP_FIRST crash on unregister
Date: Wed, 18 Nov 2026 15:39:18 +0100
Message-ID: <20261118150144.606870591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index e604d0d8b7b41..b981959ddb474 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -422,7 +422,6 @@ static void crypto_free_alg(struct crypto_alg *alg)
 	unsigned int algsize = alg->cra_type->algsize;
 	u8 *p = (u8 *)alg - algsize;
 
-	crypto_destroy_alg(alg);
 	kfree(p);
 }
 
@@ -492,9 +491,31 @@ void crypto_unregister_alg(struct crypto_alg *alg)
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



