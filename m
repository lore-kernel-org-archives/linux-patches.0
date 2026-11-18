Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042434;
	b=bsV5MeXYGo3QQ8TYJ7CnmR3dsfpn2n+RKjxswOgjqjnW9uPbahfAk1BViL190UaFnqIR
	 mM51utulcC0+FnOLJPvdY2nGPkwGDzEWEz0QEvPFMig30cRyzmSpKjj3iiZK/S549KW8B
	 C6p3b5FutHwKg49/peD8hQyaZq0VUgXR9UeF6E84iQZKE43Bm+7WrXLrg0OIu2L7UIgkw
	 UyIzqaBKvfugnr8HLWKhaZ8RMdwM9C+DTpadj5PY8ttlTvN7IdX5AIcH2l38Z1HgUdWdk
	 rzQUBcnJPCMe9DWU7tOW+DmQGUQaVzxfK33aPHF3j19VF80jwk9H93L6fiUtxVZ4RSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6opQv1FEhcGCDJAbpxNK8gli9KpDbkT2yGjaxx/JEfo=;
	b=tGxl24vEzS4ukLu/3rSCxU7j8FJ/vAz3r0ggJoD+CK7HMSBcdxaF8vVmBi6kY50HGALE
	 zC2mqEJ5DSpFRt6liFeMsQ/wcaZfW5qsx4kfL2e+QK7aK+WbbvJvOmMqzFfv9X9YXI0AB
	 FbJDDGURkg2MYLL4luHISS8xhJmrQ9nzkWMuZ4P1pnMLScKVTJGQxBFuisKwb1ne0lSgf
	 8kOEDQxhHgf2XKGXUOJk4q2ucFyoeblyIsU06ep22plDQc+KYb1DLwKpkZG/nqBPpNGNd
	 qV6adM/N/cP/JUPpoFlwWHInBSAk5DYFA4mJ1f3NE19deYqZhyd1ysIkslOzlvvcqvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqnKZicz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26F9606A31C;
	Wed, 18 Nov 2026 22:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqnKZicz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034E11F000C4;
	Wed, 18 Nov 2026 22:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042434;
	bh=6opQv1FEhcGCDJAbpxNK8gli9KpDbkT2yGjaxx/JEfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqnKZiczLZZKKPuPHBlnt8m1FGixKvUaHUm1pD8vcumBaVSZFDFEr2klXf6I0dP/k
	 xcXvj1LCgUbVQuNT/lu4rW5uOlDQBbIuDJgICng1qoaV6Ibx3IWnJ0yIEqoYXWpMH9
	 I0JZ9fVK64cA5KqBXLbokCG0XtFaWLpQRkuur18M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3170/3318] block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150454.932611465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: TJ Adams <tadamsjr@google.com>

[ Upstream commit 82e72ea18d0af724914c31a1f274c1aef452aad0 ]

When a passthrough request uses transfer direction SG_DXFER_TO_FROM_DEV,
bio_copy_user_iov() sets up a temporary iterator iter2 with
data_source = ITER_SOURCE to copy user data into the bio pages before
execution.

bio_copy_from_iter(bio, &iter2) copies the data and advances iter2, but
the original iter is never advanced. Consequently, iov_iter_count(&i)
remains non-zero in the caller loop in blk_rq_map_user_iov():

	i = *iter;
	do {
		if (copy)
			ret = bio_copy_user_iov(rq, map_data, &i, gfp_mask);
...
	} while (iov_iter_count(&i));

Because i is never advanced, blk_rq_map_user_iov() loops indefinitely,
continually allocating bios and consuming map_data pages until it
exhausts pages and fails with -EINVAL.

Fix this by calling iov_iter_advance(iter, bio->bi_iter.bi_size) in the
map_data && map_data->from_user branch after bio_copy_from_iter().

Fixes: 13f3956eb568 ("block: Fix WARNING in _copy_from_iter")
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Assisted-by: LLM
Acked-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://patch.msgid.link/20260929160813.1599129-1-tadamsjr@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0aadbaf7a9ddd..eba5a37cae81e 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -218,6 +218,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 		ret = bio_copy_from_iter(bio, &iter2);
 		if (ret)
 			goto cleanup;
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
 	} else {
 		if (bmd->is_our_pages)
 			zero_fill_bio(bio);
-- 
2.53.0



