Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053550;
	b=dmKEiNexsAglhptjjnvlY8bPEWfQqLucKpNo9WySLUWsPmSFYW7+9+4rj+X0bV4KJJH5
	 FcfvW/+iTGPSLlJz1TSEHn3h6O55k0yYI9Q7eF/y+uES7LTuuptBsHAfiM9bzia/eHaob
	 obHPlrbuM3j7HyOWzU5owPD+62w+Kqe1MjGNguOURGgrJc1zUCmNdejWsXloja6xmh5vL
	 jFGf658bnM2SxtyvdaSb+uhUZp4w61+Ljtbq0/oWbxo8TNu5XZDAmcBksMmVotpol4oE8
	 rUmlnJA6bRY/l4Z2nGw/aWU9Z/DOWOMP27nOS6UJ+pBtaRLGdVHs2YbRB/UA//AINqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8kHmkVWQh7dfOkNgVM04fEk5tlIgieScbj8VUVvPioY=;
	b=LGMc36HdErBUyurlzX5QqUdJBmX23f9N1Qvq+yup4Koze/JrRuKRy4JynCFfI1HdjgbB
	 qXtw/Pyy/+jbKCAaNvj02onpR+3vLAbnxDlMAmGaZDNVKCslIUjlIAnyeO1jTVjWWKTTF
	 AdAhj+Hk43xxmuhsfOhgRerpphGhfGcOHDM5iSdFWO/Vk8rnEZkxBuHLAkuqvXNTYfW08
	 Z5uYMxtSF37srAnczKk90K0+fmLq8hfBYlfi7Oz4Rg0AyKoPSc4fAbw6S9jGvMHl8k8hB
	 1GsTjJuX5zzoOS3visi5b5SljDWOTUbsGD1KPd+yYk98Ux/NvW4cV4NTgftxM/QQkNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8vNLc6x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2D606A320;
	Thu, 19 Nov 2026 01:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8vNLc6x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8759C1F000C4;
	Thu, 19 Nov 2026 01:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053550;
	bh=8kHmkVWQh7dfOkNgVM04fEk5tlIgieScbj8VUVvPioY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8vNLc6xku4kUs65zCzXdnuDevvFQK85UlZBNXlfxG3qIPtAm20gLA9GaCdAdylyF
	 pZ/ZRZlgXzPjL+/npnC7lZDfUP8Cq+86SXatmpTv8r7tyDKNgdxjvEcs4mX1aRPmLz
	 6oYOmHwaiR2jlK+DKPBx96neAQFHuNE8bZP3uOXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0959/2214] crypto: algif_skcipher - rewind rounded output bytes
Date: Wed, 18 Nov 2026 15:43:55 +0100
Message-ID: <20261118150050.663632097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 2f90facc7b94934653eb7ebfadcc25d503b89196 ]

af_alg_get_rsgl() advances the receive iterator by the unrounded RX
scatterlist length.  For a continuing skcipher request,
_skcipher_recvmsg() then rounds its local length down to a whole chunksize
without restoring the iterator.

A later chunk starts after bytes which the provider never wrote, while the
syscall returns only the processed length.  When copy_splice_read()
supplies non-zeroed pages and publishes that return as a dense prefix, the
gap exposes stale bytes from a previous page lifetime.

With unprivileged xts(aes), a 31-byte MSG_MORE request followed by one
final byte advances a 47-byte destination while returning 32 bytes.  A
hardened v7.2-rc5 image retained all 15 seeded stale bytes in 4,829 of
4,829 records.  With init_on_alloc enabled, all 72,345 gap bytes observed
were zero.

Rewind the iterator by the tail excluded during rounding, before rejecting
a zero processed length.  The crypto request uses only the rounded length;
af_alg_free_resources() releases the entire RX list before another receive
iteration.

The fixed target-like kernel returned byte-identical dense 48-byte output
in 4,771 of 4,771 rounds.  The unmodified kernel returned the vulnerable
32-byte short record in 2,409 of 2,409 rounds.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: adapted the rounding block to code lacking the upstream zero-length check and CRYPTO_SKCIPHER_REQ_NOTFINAL flag ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a1a71284fe82..c037c3969e9d6 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -82,8 +82,17 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * If more buffers are to be expected to be processed, process only
 	 * full block size buffers.
 	 */
-	if (ctx->more || len < ctx->used)
-		len -= len % bs;
+	if (ctx->more || len < ctx->used) {
+		size_t excess = len % bs;
+
+		len -= excess;
+		iov_iter_revert(&msg->msg_iter, excess);
+
+		if (!len) {
+			err = -EINVAL;
+			goto free;
+		}
+	}
 
 	/*
 	 * Create a per request TX SGL for this request which tracks the
-- 
2.53.0



