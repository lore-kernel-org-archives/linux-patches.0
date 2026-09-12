Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA422BCF4C;
	Sat, 12 Sep 2026 18:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238325; cv=none; b=XVe6IjltZa+7QuO/akBYwHJerPlbjNgluEF851fyn48RF2fje4E/nq6uXyTG4TV46yfLMtB4EopRjoFq+Lc/oeVX6Rbs5fE1UXHYRS6DAq8Y6kpXL6kNZBVw1m6h5aLFR+TXEWUkDtboQ0gsGjzlK1141g74oDOfztxyqf7lMiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238325; c=relaxed/simple;
	bh=vx6yfJbfHpN7oyy+oqk92H95s9nScYp5PhshCFm61Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRtYPU+6zeWQ6HsJfeNBHANjEgEi5VKtIfkaFWp2HuFHysU3zGOMR6nwnfoVL9N8nJp9amPWIxHorSnj071viMDZ5U2Is6VE0ViwC6aW3WJC9pQTinKaPG91qYQK0IPDtgqwtF4DXiimBjzcYcARt/aSOAE3wPcQJTKQ21tfbbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05gc20gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05gc20gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ADE1F000FF;
	Sat, 12 Sep 2026 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238324;
	bh=j93Vwgi0fYnAkcK01k/Dw+qYsUtoIYluhIOWk6yrfYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05gc20gibapa3dwZOce8qmusILFHlYKxuKXcN0GdQAWadHxBZuBNKu890iBDuk7cc
	 JrreMYpzIXk9GAVLGTEcEG7uHfdhNJ6D3JY/hb9q84nmyJzfeDVuSmd/gWpnlCQARm
	 iAYue52RpfLYgWpDJ4/mZ47b9qkAeKbQaBihJhkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Laight <david.laght.linux@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/935] crypto: atmel-ecc - replace min_t with min
Date: Sat, 12 Sep 2026 08:57:47 +0200
Message-ID: <20260912065536.853660474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 004d87cbfa221..e21466dfd0753 100644
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



