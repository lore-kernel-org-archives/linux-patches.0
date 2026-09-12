Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B843B7B6B;
	Sat, 12 Sep 2026 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243565; cv=none; b=bpRiMvjcqNeh4yA5rrq83KsBtBSoJMkG55ZRcIcyMbZAIsE12CKdbzst8j/Xec7Ew57NgZUyaAwRQ9OxDvwj5jfq0iXkEH2xq3Sy1//TAqTjkfRnilVe+aZcMJn3BGQcylWvnj77brACBl7PmokiMxe3GqjPTJcNHejsmxcuz28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243565; c=relaxed/simple;
	bh=7vAdWhNayauS6R/m2Joo6+tL0G7vCAtmrkXPGd7+LGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1CU3TcAxDITSHN1m5V8Tlbu2ezvb+Cg2Q7jNnKM37bJiiq01w24ghH8wtbggSJ8Xx6li1B6nLuQKiajQl/Ubi5/QMsnfTJcqX9/vUZSI6SJQIpYB5Txv38f02WGlUPO/xYWMpX/qz/c5WuawgI5caXq6wCnRUsdR5L2UhxShvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brKoR3V5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brKoR3V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE071F00893;
	Sat, 12 Sep 2026 20:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243560;
	bh=+5iqmilphH4pszx9CFBmK9HJJ9U+vjYjxjPjEatt7GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brKoR3V5SISzarXyW0V3J4bpn/HWG6yZDlAJZzxmdFCDrbWnVVREWl7x8PkGCRtme
	 FOs3tvPeMd32tcxm5mzkjCYA4HqPkaCHzo6LPU3P9xhxkFdJ+qIyBqvlGla8U1tk83
	 CtoXbzhTY9PPJUkhuSKR7CCgrI50GgDaw1CWi7Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 788/798] crypto: ecdh - extend cra_driver_name with curve name
Date: Sat, 12 Sep 2026 09:06:56 +0200
Message-ID: <20260912065535.124826601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit c5ae16f5c6b91dc78a08885a753489d608de4abd ]

Currently, 'cra_driver_name' cannot be used to specify ecdh algorithm
with a special curve, so extending it with curve name.

Although using 'cra_name' can also specify a special curve, but ecdh
generic driver cannot be specified when vendor hardware accelerator
has registered.

Fixes: 6763f5ea2d9a ("crypto: ecdh - move curve_id of ECDH from ...")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 04a427b8c9564..07eb34fef25b7 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -141,7 +141,7 @@ static struct kpp_alg ecdh_nist_p192 = {
 	.init = ecdh_nist_p192_init_tfm,
 	.base = {
 		.cra_name = "ecdh-nist-p192",
-		.cra_driver_name = "ecdh-generic",
+		.cra_driver_name = "ecdh-nist-p192-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct ecdh_ctx),
@@ -166,7 +166,7 @@ static struct kpp_alg ecdh_nist_p256 = {
 	.init = ecdh_nist_p256_init_tfm,
 	.base = {
 		.cra_name = "ecdh-nist-p256",
-		.cra_driver_name = "ecdh-generic",
+		.cra_driver_name = "ecdh-nist-p256-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct ecdh_ctx),
-- 
2.53.0



