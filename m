Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D567E23D2AB;
	Fri, 13 Feb 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990905; cv=none; b=lNu43D8FSnwJQ+AP8sib3A+3FjT5Has3bqPdu1VS+ZsWotWraqZeBN99YXYb/UindD9Za4rfHphrwKEnW3IuegobELrP+Ee6MWjyRFmz0uT1jepB0oN9JXvR45g37GhBxkGe1bXygbMj6VVeaBipBrZWZYQC1z8Lq8GGsb9MvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990905; c=relaxed/simple;
	bh=2HJgN1zSHNzz1egj2iVZH0bXN3BhuaSwyzqj0Fuh13w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZbMuvxa9xe35rZmnkxtADsVP7ygnHOH34zzHJw5QlWHY778Tx0eCK1HiaKpMACw5Sq4bfTE9G0seggRZg5djNQtHScVCibD07G330Du3seByGdF0yCL9c7ApHqGJbppy7Ag6AGlaMrDndL1sdja5vwP+HPfpD9I70texOF+F24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kN4M5Rxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kN4M5Rxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE44C116C6;
	Fri, 13 Feb 2026 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990905;
	bh=2HJgN1zSHNzz1egj2iVZH0bXN3BhuaSwyzqj0Fuh13w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kN4M5RxhrJynFItHxQRK+CjPhrf8gAzoCnzWlDlObbQKpLoTln2TMKiNtV9OHTESt
	 Hh0tNBhT+bbCufA+BDbJkLNyK/iUg12AQsPKmYbRYMPXPmr2Bz2VOThdWOvqiL31go
	 xYJjfVUzfM2YMfunuYAGcfwOk7FXSl9c9XDzPtOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 10/24] crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
Date: Fri, 13 Feb 2026 14:48:29 +0100
Message-ID: <20260213134705.106238319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 14f86a1155cca1176abf55987b2fce7f7fcb2455 upstream.

With function virtio_crypto_skcipher_crypt_req(), there is already
virtqueue_kick() call with spinlock held in function
__virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
function call here.

Fixes: d79b5d0bbf2e ("crypto: virtio - support crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -550,8 +550,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 


