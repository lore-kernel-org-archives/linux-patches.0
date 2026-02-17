Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673EF284B3B;
	Tue, 17 Feb 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361204; cv=none; b=ezw/kherSF3gN/3CUoIew+KCOmYG9v0+hphqnWZIGvD3ngIl/bg/9t9msCfri4CesW5oogstT3UvwX05Pg/7Ye2kK7SMu4N8QLnkCP9563z/wpEyeu0fjdaz9YcOvZzTO8uxeLizCeS8+7IqhfftMMmtLlyGmvDThxy89ozadeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361204; c=relaxed/simple;
	bh=xmByrFG6Ola4QfVPOISm6pFxAIsOTnlcbliMh8+ESdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pbh1/KV5jNWLLBczwQzFb2+MTp/e6IX9GAFAgf1X/zQmLxuNbfTf0PsrKIfOBrqXhAgmLnH6sIS8udSProEWvo1eRwnlW+2lVLee7OOVEq99OWo3GwX6VyRiJhCNp8KXyzFcER2e6gFS3ryzbRAy+Cq5D0WpXy5X0LYQJuokiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQ44TzKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQ44TzKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F71C4CEF7;
	Tue, 17 Feb 2026 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361204;
	bh=xmByrFG6Ola4QfVPOISm6pFxAIsOTnlcbliMh8+ESdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQ44TzKqkxhyGfDpD9OXsjTmgwGduvrdNdCP+vn3QRKS8DMlXkDRxFHKxxRjxy2dr
	 FblKMXxStnxDgkDRUz88C+3YEh7sxrXEfVIfzpdvHCXjqLeyCIXLlcKNpMJM0EMiji
	 tAWzPYBBTxyDv+YurVSXFUKYdvfbOXf85aPpY0XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 07/64] crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
Date: Tue, 17 Feb 2026 21:31:03 +0100
Message-ID: <20260217200007.785345957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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
@@ -556,8 +556,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 


