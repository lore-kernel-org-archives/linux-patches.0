Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032898;
	b=CDZm5FODeh+IiLYAoyn4zEfd+P5hJJWrBo5ODD1676MQnbSBleFfQu8JPNPzE/g3/3eS
	 on8ePnN2cQGPzgdKWHqKxA3TX5+dzrmMhEQEP0rP+6uvjLJaTSoSU4m6YQD58bSeyJBhn
	 NaXLTZvTHwZdGXnGkD7Swr7B9ewyRqaIHZlX4fQKnNv0kle/K53/kRf7uRByS6zkYVaI9
	 w0fLJumONnk2YNR5gss7UVrU1XA4CMLFEvw5QKzv40ytJEFJNV2PDQfqyGbeKDkdDrzxO
	 si7HGpzuWj8FiYLEsgO0rp1XjBzRaqxxRLakRmv3WaQGoi1rSxdzFFk2GBpgiHpXl1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=paGnxtB16p+aLc59UfiaVl/SrKy4ZUMeZ9xxB0rWqr0=;
	b=nZEEZGeDXBFjTBUmE5b429qASyfxydEBZYMpC/uqj/oR1pCD+9dUy5cG8E/l3qv7RnhN
	 cQOANy2fXHYFhAIeKrRmO0Lt6tQgWn1wKEHAqJsT817oqnKpffU/lOE1XKSY2dxWZjysX
	 Il/eWbcjYclENPtzxkoJ8CudsSLcyaVhlXbFaQ4WSsIbSGo88DLDk9aNWmJvx1sI084Cg
	 Jf+zCtGQfNWqpCdmRmm9TRCOWmzjIfAIYVrlZp0uXFJHOckuN1TzFtH6Dh+1ffTOmuLwr
	 1prqZwhi+ZEy68HYxQpetIeK3U3HXAc2WgXbWS4kbvolJ0uhxKSm/XaNVdp1aBMCQSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQ+TUzlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4243560A2604;
	Wed, 18 Nov 2026 20:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQ+TUzlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AC31F000C4;
	Wed, 18 Nov 2026 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032898;
	bh=paGnxtB16p+aLc59UfiaVl/SrKy4ZUMeZ9xxB0rWqr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQ+TUzlgL5RDB+TA+pu6yvelIsDno6xw3eqZIxX1K4ZCqsCFegOb9YtPlNlarWS3t
	 pkjo+ju/sfuk5VLHNEAj+QpXYqitaIlH2uCORE5+Oai3i2m83j+01L9qqohAIukU3p
	 sSudbLbVT6wegtPQZNene2HjOcWy3BR7CW5esymw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1575/1756] block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV
Date: Wed, 18 Nov 2026 16:01:42 +0100
Message-ID: <20261118150112.466580304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b5fd1d8574615..12c586b29e75f 100644
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



