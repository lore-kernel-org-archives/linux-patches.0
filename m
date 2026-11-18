Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028142;
	b=w2ZgXW5OE2+gquESadg5oZnNhcAeJsd//yLfwQskFscNJgk4LWPJT1tIAlCw87igW4eG
	 lX18ceg478E9Jkjado5FJfbaoRNqyvE3Xz2UuUAxHmVBJ6kh1xfvMSh+cq3zsItBVByxi
	 QjO3sgsv6A2+u3kcxngBo/FnFU5y8M8MAfIpnDclEeHfjD5MZa8qbPw7aSRTxddEIn2wC
	 2hYbo1vDCh0ptQSirYlHH+0w0h6zXflxwwWYVm7VFFuwdxKWPSBgaO1Xy4zWIrmXv0G2m
	 vEQtEFUYqHt1XY8gzZvmW2ZjJsM0cfhNavURWCfGQJhjWaCyf70G+MpUFkX6vvwIeyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mX1ZabzSx2A/IgtU0lHK8CwtKrJ/Uy2NiFhvgvD/Oow=;
	b=gKcOuQmIJW3dDJycrCwVNNE1FnCZnjClDDxD21YvMHW4OYAKuQGkUVu+1QARtz5jcefr
	 5ljhDreQ5Ots9UPzY3x6KUxCPvltLnoTluaqJ1oDlG5QM/mW3QCs6ThsRT/7tnO5rYXcP
	 FINaphTApyjxlO8MuhA9iuKTZc0lRBBt1jWzmJXFN+Q3dwNxm9L2n1EIw2LzGZdkq/Nyt
	 d8V0vJHKzaeAtivcb/KXA39ulEQedBAUHg6JRQEYKvBUJJA2qlhvNAyqRAESMGcHggpH/
	 GQdSzjGyzD9pasvx/hcaZwH9BSR2XzCnzX9n/k6QuUzxkgcUYlM8rFV6Q9wbog4Yz1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s9UiShe/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5B5606A31C;
	Wed, 18 Nov 2026 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9UiShe/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C66F1F000C4;
	Wed, 18 Nov 2026 18:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028142;
	bh=mX1ZabzSx2A/IgtU0lHK8CwtKrJ/Uy2NiFhvgvD/Oow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9UiShe/MJ+sdZEl7bV7UPyG/PwK5m975aYysOgDaq5znrfEoN9IZAN86zPySZRW0
	 A5zYNXrCKaJb0EgK3BboO5toZ7wkuwkaC2Or23TBuJAxC5HlDHRxFyugUWRtNvD1qp
	 GmzCLY2ecGPbm4beZAhcIOBWe7vhaL1CCypJCTxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2038/2151] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:02:53 +0100
Message-ID: <20261118150235.970729581@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7d96874ba80ba7a2ab578ea9139c2af79c353b88 ]

tg_set_conf() parses the limit into a u64 and stores the iops ones
through an unsigned int, so anything above UINT_MAX is truncated and a
multiple of 2^32 becomes a limit of 0. The next IO of the group then
divides by it in tg_within_iops_limit().

Clamp to UINT_MAX, which means no limit, like tg_set_limit() does on the
default hierarchy.

Fixes: af133ceb2610 ("blkcg: move blkio_group_conf->iops and ->bps to blk-throttle")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 64e78c79a7b47..03c3bfc165161 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1398,7 +1398,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
+		*(unsigned int *)((void *)tg + of_cft(of)->private) =
+			min_t(u64, v, UINT_MAX);
 
 	tg_conf_updated(tg, false);
 	ret = 0;
-- 
2.53.0



