Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047686;
	b=p3Lm/q6XAA6CVgA6tyswh3BtF2CMT01PLGOWptra7eLfhk0dryb5EZ1qK8fcgF2VJfDq
	 zmXt6Gdc4jVacBhPQJP3Z7xbemFETOq2SlyAQdvhO2g4Hlzo7o21WLKK8063iGLwMLQPe
	 jbSym+bywFUex44pKT3f7wkKA31/mOOWRcNz3Lq48LdDb4qs8PpeITBXu/nRQo7CaSwNj
	 PZKSPYXShp5Zoay+tIM6Eb1T3huAotQTLmVdzfSzgReYgNflcQONbUAYvQA8mUquklBnx
	 9XJaroUsYCF8ayDyaxNWoxoAXXvXYvQr6TuF+qhrX4Kyt5AwCXjc3T046+mMPY/k1iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJwfXpd9IFiU/nMR1FNGaORqQxEVQlNPbYAZSopg0fU=;
	b=G9qNzHZ5mJG1uzAz3NkhxQClLRSSjs45QjFu9y+7PcQqZLbYELZeHOvsuV6zsBuL8hF1
	 y/oEIxS63Z86uxMypKcgcTLzTtTaHgEh2NVq4Vt9uGHOxPx290Z8aiRvfMIt2EY1mJSTd
	 rzSAY+ZlAVMUGCJ6ftdZnYnzZSc96qoKbhl/rlno/MS4rYaGbSPOqbCyJzKRwKOgMjxqT
	 /+zz5GZKXTDUIzYDmrkBHJ6nC1+4eYnEbM/GKBUoBAXWrMMA/WpnqzRKvwZhlFSdxDY+V
	 T8mlmE+izl0h6Piqtnj4avIPkuuxPlqmZ7gJ9RbxzNpBXbJJZEXs2WLcqvvXWlsRZmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWLoZYCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE05D606A320;
	Thu, 19 Nov 2026 00:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWLoZYCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468621F000CF;
	Thu, 19 Nov 2026 00:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047685;
	bh=GJwfXpd9IFiU/nMR1FNGaORqQxEVQlNPbYAZSopg0fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWLoZYCT6gG6IzfxGQDP0H6qx5vCpUIDjuE92Spp3dUIxTxz/tdTbPcdtVk7qmrIz
	 6wJLZHCr5af6mbVjjndtdWHxDmGUAE7w9xOzD688qN0WjUe8n1C9NyTPT6sxgax/XH
	 sXnXFodP/9com6d6QjZgOtMqT8UPCE7OOV5LymZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1686/2857] hwrng: virtio - Remove usage of the deprecated ida_simple_xx() API
Date: Wed, 18 Nov 2026 15:45:20 +0100
Message-ID: <20261118150302.040566144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e4db80d80cff590eb5fe0444b665cec839c34133 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 0f7bf47f5a0c ("hwrng: virtio - prevent use-after-free after a failed restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 279cdbdeee845..14ab1c2a7350b 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -154,7 +154,7 @@ static int probe_common(struct virtio_device *vdev)
 	if (!vi)
 		return -ENOMEM;
 
-	vi->index = index = ida_simple_get(&rng_index_ida, 0, 0, GFP_KERNEL);
+	vi->index = index = ida_alloc(&rng_index_ida, GFP_KERNEL);
 	if (index < 0) {
 		err = index;
 		goto err_ida;
@@ -186,7 +186,7 @@ static int probe_common(struct virtio_device *vdev)
 	return 0;
 
 err_find:
-	ida_simple_remove(&rng_index_ida, index);
+	ida_free(&rng_index_ida, index);
 err_ida:
 	kfree(vi);
 	return err;
@@ -204,7 +204,7 @@ static void remove_common(struct virtio_device *vdev)
 		hwrng_unregister(&vi->hwrng);
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
-	ida_simple_remove(&rng_index_ida, vi->index);
+	ida_free(&rng_index_ida, vi->index);
 	kfree(vi);
 }
 
-- 
2.53.0



