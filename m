Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028036;
	b=jm0BxVaDfd6/RN8kN5f45JsxrO6T4k2cPVrB6lA+To+0ZcwJd8OQtUvJc6ZRC93p7wBh
	 u6Wzn0ZuVQMJCHTL8ORFMnTh0P+3tX3ZnQuGVR/5NRLVjcZA8GmDYPoUGcUQIPVNUqdiJ
	 AjjD6zjoI8MI9UPOazU6BXATVWCZYoDicyCV/32cA/Z15tOByktoPh1TKw/gvlMWLldSV
	 l3JJrSbeEmS3JOl9+9hlxVd0UdaAff6gIcSCk2I1eNPLy9p/1QTF9zHvKDZchaBbvLKjr
	 4G8DL3Bh2pL/KXCZ+0EL860mlrsyIKFlJND17llxivZKPEjOJYIq7RAxLw+JGiBJIrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=az7+J7ePNUwqj26IvMLgLsSlPdWT+7eUrKCW6MEGwkM=;
	b=qzPwffvCdatMqdhES/sA6UiR2Ju7fYVMKD0SUVL6Y4FqF+84oxTqBESogkAlO/Y5K4+u
	 kd8jfYa9pmJaHpV4UtYbEOlx4uyiaqM8LKe/KlI9pd71EHq8uODfJlFCTIBbe6gnTlpA3
	 P5VDVJZIxJWN1oTO+7Vv65wIWctSvZZ4plzCHmnN5fx9io0OSbq0BJqaoRCLeRz0BrCHr
	 iPPHk6REq+AUJYfusblEN5jKOFIgeRHGVusz4GORZ8GcY/VYVVbaaZ/u9UMElUa0e5K5Y
	 PufgnWZFtT2yJcoF9TNlvECNcsCBXz7vM5A34A2Avecl/3C3L/M8ICpZqfv+2M0haUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYV64LvQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C11606A31C;
	Wed, 18 Nov 2026 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYV64LvQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399151F000C6;
	Wed, 18 Nov 2026 18:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028036;
	bh=az7+J7ePNUwqj26IvMLgLsSlPdWT+7eUrKCW6MEGwkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYV64LvQ1XSDKuwkWUwJvTrY7Xe3S24tQ8Om2vXUQuoGWnwaLzzmiCotdhXqOs+Xt
	 mkp/o3WA4/Ravg0+j1bKWcn75TlgZ4vGHVkw/Rs/x1SuScrBXZv0I5Y2z5I/yjg/18
	 sx4ow7VNRzgaY80JfwT+5VTQnGb6PEGbs1X0itHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1961/2151] block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150233.190642754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 17a1dc2886786..dc61bb68277df 100644
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



