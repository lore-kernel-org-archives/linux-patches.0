Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214726;
	b=nntYnejebqYocoGAimOF20ER00O0jSbFDcJjRmKHcb/+PdQcSgn/zdYrd6GfOFMFsu7J
	 c4HCfZIgHa2erm5bUP8JqMF3fMNgBxVBYMHz94cO1pwMNvurSbE4uizasc6ifUFDuNU5Y
	 NyFhAdUh0IB4el9UA3TNaFz3u9RWPicTHbrO9Uq6zvATk3chBxWVpgFZvWgUk/SEE8KyI
	 yqrDUAEODvUIDdaFJd7ZCgCywHhNZqBjpcO97cCWhV1shXGfdb9OvCIwj4epNOzB1LB+y
	 6WGsr+lkdJKpGu4JGJV/CakVk6Z2jnGyzfIZu32VMFWwKtNDAb8eFxcm+dkgfTjq+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3dj/D2fJ86m0CnZ1d6G60lySNT9Nlk8bTgOq2AyEe/4=;
	b=DREIS18UnhO03YeHC3uLygGV6FeKf9y/8I9sP0Z19A532tarM567zU4yt9eESYQ9BPOt
	 cpMUBhZnDx9IUTNKkjlY7njE+3nnfDtcAzNfZ4VPbbleG2BE7Cju8N6knkMz3V5rm0BVr
	 lXcPITMZ2tRZsGU5CMNnNeqOQ7T4zvUr/z/PNXg2mHsxdZ7YXrjJCyZBwPqyA52lTvWi4
	 MK8UId7MKL3RlB/0todcrxWhMahPmfFHK9ebo6opLoJZX1fFSo/wa26B9fkGrOTDJ6P69
	 k7CrC73xDzBmfn1XZrBeXzBPC23ga+cnhr9T80UjkvmjmHwk6PU43/6XvDT2bDQpGHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODF8jQ8G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB26606AB0C;
	Wed, 28 Oct 2026 19:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODF8jQ8G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509811F01825;
	Wed, 28 Oct 2026 19:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214725;
	bh=3dj/D2fJ86m0CnZ1d6G60lySNT9Nlk8bTgOq2AyEe/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODF8jQ8GFV3ZbZSVMDpDxukiF9tY6qFKBsvpcEbpr9GHHWznzzTwaKS4EGE9tA1FQ
	 VtxMUN83TywCW0qMvxTHaDkAMXNHXnALYo2ekSc1X6tL+KN5VNsb0MKrwSTpf09RPt
	 zyvFUnQbbXT4hSWYdATU7gTUfa+GguHVMlYNQbQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0961/1887] crypto: af_alg - limit RX SG extraction by receive buffer budget
Date: Wed, 28 Oct 2026 17:50:57 +0100
Message-ID: <20261028170521.276750123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Douya Le <ldy3087146292@gmail.com>

[ Upstream commit 8eceab19eba9dcbfd2a0daec72e1bf48aa100170 ]

Make af_alg_get_rsgl() limit each RX scatterlist extraction to the
remaining receive buffer budget.

af_alg_get_rsgl() currently uses af_alg_readable() only as a gate
before extracting data into the RX scatterlist. Limit each extraction
to the remaining af_alg_rcvbuf(sk) budget so that receive-side
accounting matches the amount of data attached to the request.

If skcipher cannot obtain enough RX space for at least one chunk while
more data remains to be processed, reject the recvmsg call instead of
rounding the request length down to zero.

Fixes: e870456d8e7c8d57c059ea479b5aadbb55ff4c3a ("crypto: algif_skcipher - overhaul memory management")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c         | 2 ++
 crypto/algif_skcipher.c | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 80a8d3a4a3cf7..3cfdd7f1479e9 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1126,6 +1126,8 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 		seglen = min_t(size_t, (maxsize - len),
 			       msg_data_left(msg));
+		/* Never pin more pages than the remaining RX accounting budget. */
+		seglen = min_t(size_t, seglen, af_alg_rcvbuf(sk));
 
 		if (list_empty(&areq->rsgl_list)) {
 			rsgl = &areq->first_rsgl;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a1a71284fe82..0fe62be7470f2 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -82,8 +82,14 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * If more buffers are to be expected to be processed, process only
 	 * full block size buffers.
 	 */
-	if (ctx->more || len < ctx->used)
+	if (ctx->more || len < ctx->used) {
+		if (len < bs) {
+			err = -EINVAL;
+			goto free;
+		}
+
 		len -= len % bs;
+	}
 
 	/*
 	 * Create a per request TX SGL for this request which tracks the
-- 
2.53.0



