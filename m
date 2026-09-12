Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9287309EEB;
	Sat, 12 Sep 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229082; cv=none; b=dh8N9MvekJNUv1sf/23RVKfQl7f0mZw2hb0DdZ7kG3NqC6JT0B5Q6AZ2C+/ScMxdIHiaDCH7IwWfyQMJTjx+lc0XsdyuRbpU0CUoREj0UNxR10hHCmm/Z4dDYNbEuRz0JXquGFeIKgI9OoOyvbMyQjz0+xi8U2k8p8VXQLMxG1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229082; c=relaxed/simple;
	bh=UBy87H8k5JcB6uur1MlcKa4H4i7etNKN7Ydj9pjJL50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdgmVjxFamhcGc9Fz2HV45QCloVMgfHe86fKHKcbvwazDqI4Eaqj0VpCjz4yj9nnP4iTY1V0WEqPINN1ccI3QYUhOb7lPvAzDreujEsOEc2ZXGgCI9d/5lynJuMPBJJGE9d0sNi47giNVkmaRz/fbBSZnJohjKhF1qieH388MRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4RU+3Gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4RU+3Gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF01A1F000FF;
	Sat, 12 Sep 2026 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229080;
	bh=9B0ePnyZppAA8CoZ/7ZhWgjanUrAxxJfk+JO4PoqKjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4RU+3GkI+Slx10dIqVG4zCIwCa2BZ0yQ/0POzyR0kdsBcK34bMwIRtXCIM7eTwGj
	 mj/hpdYkGz5SV90vS1aGXC1Gp4+Sao2gzEA8l42e5o6kJZFxXwkgAvCn6rpicNcDuv
	 hfCXnxAdgKbadhJVi/i6w7nfANu7KMBZuXGN0GWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Laight <david.laght.linux@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0518/1191] crypto: atmel-ecc - replace min_t with min
Date: Sat, 12 Sep 2026 08:54:06 +0200
Message-ID: <20260912065559.884007035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 75fb7be844cf1..6f784e2e596c6 100644
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



