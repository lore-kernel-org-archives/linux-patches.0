Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062155;
	b=W7IAwZ5k++GUgN5SzetjmMoEaF/hjJUJzIls/9ofXrkXG4HGJYXEAVyDPx4DfUvbSdtg
	 WDkpeafOqfEEhBN/repnYCMaIS/yWJRt2vAAKIGtpI5Xvn5wS0Mp9sEGfo+wMLoeqGaZ5
	 WdmPeAfTzF76jsyIAA0nzsZ7f4dqNtrl/6ukZcxupS+DkvW+KGP7SC8fTXqQ+ID8lEA+z
	 Od93TH+vAuUlbS4RjdZ2Y0cW40rYZRMDcQkj8gdHGDySV3O/wgccg7Q9GZl6e1ieSlnre
	 oiCuCZIhJ83DKPSRTYtJEz8hFmqcW8tLBlllnXLeL3h47s0ZxYL0juBsPFXr6VKBVOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5pTXExaW7E6/cas4dZh7nGiyGEsyPT70u2i2KbgFuAA=;
	b=zEJHboEwmT1QfWi3vIB1Kibn8F5INpCmdKx5bLVJjL1aR4rGGIQ8lyPSw0Okk238K6zN
	 wVGv2BTJfXfTo/+PekSvrr/K0r2SnFQmQvDFzuCPm92pZUrJS9cQDbM7KW53pL4NE6yII
	 XHPp6xWjOV/wNzCdn20n1jiu8FDOKvMd8HYittH5Rxy4cIbsNjHnLCQps3388D6rQ0xZl
	 4onAGIVOiC5yak0KkhJJ8ha80l0m8OECd4hdyTqGukljwdRGoCfeOa4ub9wZPiKeRQU0f
	 leB9/iVGuj9/7nV7SRY1luVZbnDid/tjbxLRsb/DrphSttwbBfvnbmYh+nAle8LbheA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdoYnEaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B20606A332;
	Thu, 19 Nov 2026 04:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdoYnEaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE6C1F000C4;
	Thu, 19 Nov 2026 04:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062154;
	bh=5pTXExaW7E6/cas4dZh7nGiyGEsyPT70u2i2KbgFuAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdoYnEaRtxPFidIwqzRktU9ARU1m9z4qIXb79zDcKuRbTmP9D4MKk4uTV5/s8Zs2Y
	 N+Ern+E3trgrWvRQM0MsdHhdmb5gQkxqOfgMZbK2JXN1Yf5ykGPxFWNuMHYVd8Q+XG
	 iG3BbtEL2LesnRS7PLa8K3HFlM6oQUwx7txouU7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1808/1848] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150034.995366122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4d3436cd677d8..bfbc2e2352bb0 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1480,7 +1480,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
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



