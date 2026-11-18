Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022113;
	b=4Y3lqIH6mTOz9T9aa0vclQUROLcuEro3U6PtAk9JKIFa+r3LYcYq3rORmWAdLNRTGh0Z
	 x2tbCmMSKhZat2LL9gC8WyJLZoTEZXxcsnxVAcjYoC29IgnE1IfjXnrlexAURpoycuLgU
	 Cx8ONYoc+nnRkQu1VtXx7nplnBEQpEwTFR7ToqyNAyylnzYr7UJIYrwhwOiKc4IjOFujW
	 RWalMpR3ZYQ6Py3gGVZztBh0dNgZ7tgdGamIKYw5rhea7jPM/nS4Hyz6hRoqAyznFptAx
	 KPWPLmDIyjoQSHjpGQxjjAZWTZQ477zV8tFVct0Oww5qnT82Rhej98S325x5j9kSxqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i5TfCq4PpkEiRNuwfhqzMeDXnXBFyn6QEBgx1T4ijSg=;
	b=hjYgUUAJf7Xx0mCbTF6hykw9CDT7OOous1+b70lLKD20pN6u9TYJ8CZQXnJydYNWO7IN
	 uu9zoeZ0ESWS57wrWSoEGaLwRvxdM+kGMaakFjDT8FQs3IsBK88SMTCOX8nBhHN6l4ftX
	 XwOScT6MxOVKoGOGBBF9F7tXf2O4gw56arJ/5jGGim6nM8wjEHd4uyY9LN0zd6qF19neA
	 5pu3vgQ3SquuCFP9okzCeY8mK4W3YTSDHZ9ETQs4w93VD1qOT/LYbZrkwfB0HEmS/F9TG
	 T1zPFoHUhwPX9FPJHnUQBRihfXz/hcJ/Et5RmTdpD70V9O5qOXBfUApFKeXzfhmu0cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzTWmCU9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0FE606A320;
	Wed, 18 Nov 2026 17:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzTWmCU9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2E41F000C6;
	Wed, 18 Nov 2026 17:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022112;
	bh=i5TfCq4PpkEiRNuwfhqzMeDXnXBFyn6QEBgx1T4ijSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzTWmCU9TGf0d6N36OrKtYOoeiPIcobhA113r4rEVFhXkQl7v6MO9uOAfdyK/Hd3j
	 SQA+byZ4+EgjG+NmPbxNvbdom8jHfH82zV1RcN+y0wPMTfQhPxZ5YDjCd2o4WQ+zDf
	 h/wZxRGKm6BUqcBa86i1f5rXrsCDDJBw0VMcKOAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2547/2651] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:03:07 +0100
Message-ID: <20261118150416.214576871@linuxfoundation.org>
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
index ffc3b70065d4b..4f10fe05744be 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1386,7 +1386,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
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



