Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021788;
	b=E6xEwqhYvlecRpaihw6EWbHFaoccp0fe3KHJ/FphbWRi75OmWs24PqDRbFr3yrqi2zIW
	 SJoVVluwoGrTi3YdYcxfTYVrGJ+pTQ3srj+w1HI7Ut0iFvemn8FGHo0h6C2xNlFOmR2dW
	 gtWv2USXw+rOlEQilLDkVQ6VluK8onSZIMOe047YhY0vTsbiIhvLsJfZ94duhaBq7nxwG
	 a0opTjaSF6VBq8X/pXS8hKfdXODD4XhfrZ4GGlna9IgjLfqCQ/I1qTHi0mfxeaxP1uQrS
	 9d+qHQRU1jQSf1dc38K2/5aV+vStqgoaDlWJjF57wqQoqtaEI5mCiQaJUO45CCpYdrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F7yHWfn1B8kBudF/5in6wmuycZBPRow8oNlw5H2rb0E=;
	b=di7BnCTXeVAizfSlHusbjVFOHhZzLzhiZm0Ibe9EGJIXng++IZSpzFTAE4QmwvNQ9Zpm
	 x2u5kZT1q/js3IqXsYwZyb+BKdmm/HZJ2fUFc+UPKyxcdi5ozry6kL4TCCxq2NZGUPy9/
	 pnwJ9GWL1jQ8ZD+xS+0lJFN3CgfDz/hJGdtS0ufXK97qH9jQc5cPMj5Co589Ad6c01LPY
	 ww+z1Sgn3ZALnHFrede4H5mwdCjsAP44vzc30c+8C6Wh3WrPM93FWuXQYF0Uo1Ou0czwQ
	 NsnKf+ADy5WhJU6Gnej3ZLF5eqpThYOKD1VSClagS+6RLkZT+DDEwI+Sq9yzTP0btLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5ddz3Kt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB746606A325;
	Wed, 18 Nov 2026 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5ddz3Kt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48CF1F000C4;
	Wed, 18 Nov 2026 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021788;
	bh=F7yHWfn1B8kBudF/5in6wmuycZBPRow8oNlw5H2rb0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5ddz3Kt/m4u8XvoKM9X3BuUrvssb13yqpjbl3Dge2r2cX2/CUgHLPYcjU2hZIVOc
	 G2GPWgV7FNFGyH8RLVbE7DIc/qGBs6/goZKY1Cn6u8+4Uqhda4kTZsvSL6d4p/zoVx
	 fEWi45tYOWEmRUO6jqCYdaPF6J/EOfXJ9duB7R5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2431/2651] block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV
Date: Wed, 18 Nov 2026 16:01:11 +0100
Message-ID: <20261118150412.725216177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9cb9605d1f62d..2685f6177ceb6 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -236,6 +236,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 		ret = bio_copy_from_iter(bio, &iter2);
 		if (ret)
 			goto cleanup;
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
 	} else {
 		if (bmd->is_our_pages)
 			zero_fill_bio(bio);
-- 
2.53.0



