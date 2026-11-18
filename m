Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022115;
	b=B7gR5orfzD0LyFLjYIwuB6IwmTroXUjnYiiFKHoucG+yfQtBHFFCvBRv3ePu3aaVJVY4
	 UeXhYJcXo2G1SDQ8OT/1At63/sM0ompmPPmlUqFg96f7kBRtBzxHnRmO3FJu/yM3zZ1H6
	 ywJdT9p3OQNq2VgXl742hvTypPxMkD1C6hDeaPOm8MAAUzFrQY6bXokq7xk+fpSnr+gtB
	 otjFpxf8xeBw2rMwWfXg/RhJQzfUxAtjaNqE6mdNLjK1RlMGsMWVnRBj2y5FZxUzIA8+D
	 m4kgIAfWdWkpD/npCmrbJh8rN3POs3pKCwhz+sQoVYKcvUEvP2MgVH4+KCto5hRSCBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzTghHe5o55MviEl+Ih5c3micAuW5f1n3f7vyFlJVsU=;
	b=hAcIeMHW31DqAL3vJUojO5G6tQpXJV1OySxIR/MDjkllh0Zp+NquPg25CgMdy+rcu5kE
	 4M27gPOywVQOcV9fl2+KElIIiTZYiwFHacGwy6Nv2de0rPvrKtumJRqtKWZpIs3YoJicd
	 CABXnTVc2XkKP1ADFxgSmLG2hWf/tNQ448nnpvxyLEZ6g/DbTZ8rTl8XOFVIaTRBuretg
	 EvrlnPaMkZkPRVRkyrIFzqPfv/gW+K7W4rw5bFYrD/I0W1MfTJbzqDUnQLrz0cn9Ir8wD
	 R+mdVd5fc9E2MQYRjS7nQbBxBB0CJ2etsTL7V6Bhx3rO/U0Xko+XdeiOdcp3Z4ay2Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0pPJIA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4FB606A32C;
	Wed, 18 Nov 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0pPJIA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF9B1F000C4;
	Wed, 18 Nov 2026 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022115;
	bh=mzTghHe5o55MviEl+Ih5c3micAuW5f1n3f7vyFlJVsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0pPJIA3KgVBuapX0a1W/cXS/spIYbpzPl97p+0avXCPQZfK5w+WwFvLLO0JfkDQg
	 oYs5g3z/+mOFje0zS5AZOqm93GKDVufDDmh6MeXfkH5W+PAn91ChAuyV1yR7iC5ETc
	 dOJ6CbuWxlhzKnujJyMWwCc3h0FcGBJihhnsxiLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2548/2651] blk-cgroup: fix root io.stat byte counts on 32-bit
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150416.246156861@linuxfoundation.org>
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

[ Upstream commit e335b853d919f2c6246ca0993115285742a2acc1 ]

blkcg_fill_root_iostats() shifts the unsigned long sector counts by 9
before adding them to the u64 byte counts, so on 32-bit the contribution
of a CPU wraps every 4GB. Widen before the shift.

Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup io.stat")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-14-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a39167228501d..1404e89147829 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1118,11 +1118,11 @@ static void blkcg_fill_root_iostats(void)
 				cpu_dkstats->ios[STAT_DISCARD];
 			// convert sectors to bytes
 			tmp.bytes[BLKG_IOSTAT_READ] +=
-				cpu_dkstats->sectors[STAT_READ] << 9;
+				(u64)cpu_dkstats->sectors[STAT_READ] << 9;
 			tmp.bytes[BLKG_IOSTAT_WRITE] +=
-				cpu_dkstats->sectors[STAT_WRITE] << 9;
+				(u64)cpu_dkstats->sectors[STAT_WRITE] << 9;
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
-				cpu_dkstats->sectors[STAT_DISCARD] << 9;
+				(u64)cpu_dkstats->sectors[STAT_DISCARD] << 9;
 		}
 
 		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
-- 
2.53.0



