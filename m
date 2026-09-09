Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D376A56C64A;
	Wed,  9 Sep 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964592; cv=none; b=dkrqlYWihVGJSXT4Pu1uYxLi+bSnoT4FXodq1qTGJqlTUKUIkh+paRDTqTcayPI20wFOUoszNVx7LkQqJzOgAriC1tBPnR+jmEAlHkoEWAd/3awjfj1G0IdvMhBRerKsSPaPwruXEBOPHpZeG7lE22hd8CRfTElSTMe08itWnP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964592; c=relaxed/simple;
	bh=qLDQkbvVoE/SkCSETI794j4H/ggrhKW2YWxOkcf4oKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbFUL5r6/o8qwFpRDpcy4A1A5zAyjTM/MV5vmZnATk64lTFjCcxV+FBQgSLX5upEYtNO7HpFXz6lpP/Q/maN7nvkBqhIOSjUzIl0vWRm0Umbn+8QiN5WWlqKpZvjOEHtixk0mYOu8jTh4yeGytN+PbMH6kO3xFJ5dMMt6lpJ2Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGH3Vl2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGH3Vl2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7B81F00A3A;
	Wed,  9 Sep 2026 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964591;
	bh=+RFSIctfLpyZqi17eyNp237kEZv/WTLCqzz6dhDkb/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGH3Vl2sBKWlLGQ6/rr/+rLJ4Dwrq968dR/DYegBFtH0WGFWtRDB6QBH8VP5FHzs/
	 PuMP9mptb2+LoTUVJtS1xe5XBJsmmNTm64QyddGoyenuTByPB/ArMeAh0eSClWUl5S
	 wvzXzMarIg6WOWU8XoapLv6bkrsfRzd/2enE5xOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Laight <david.laght.linux@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/583] crypto: atmel-ecc - replace min_t with min
Date: Wed,  9 Sep 2026 15:42:04 +0200
Message-ID: <20260909134253.197186105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 5b085b2a038a1458f9398cb3b3b03cba6e38e1e0 ]

Use the simpler min() macro since the values are all unsigned and
compatible.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: David Laight <david.laght.linux@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f07a0d251db7 ("crypto: atmel-ecc - avoid stale fallback key after set_secret failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-ecc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -56,7 +56,7 @@ static void atmel_ecdh_done(struct atmel
 		goto free_work_data;
 
 	/* might want less than we've got */
-	n_sz = min_t(size_t, ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
+	n_sz = min(ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
 
 	/* copy the shared secret */
 	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, n_sz),
@@ -150,7 +150,7 @@ static int atmel_ecdh_generate_public_ke
 		return -EINVAL;
 
 	/* might want less than we've got */
-	nbytes = min_t(size_t, ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
+	nbytes = min(ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
 
 	/* public key was saved at private key generation */
 	copied = sg_copy_from_buffer(req->dst,


