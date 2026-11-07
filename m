Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064453;
	b=bEN9MqGK0cCicZYLID9CQRTZ0Pn3WcEio2sVx5FRwgBICBp1C52f7jFwgGkUFidyHEfw
	 1Hn4iuhTD2RY7nw7tlRkPocBydPO67H8T8/CqQkmCLY4Mb+6TaOLDpx0U6VBs4EzwltOA
	 YQo07R5wGKrlPCpeVZhhtpwXJHu5pYATAOqSucV0cHn6tHDWhhmMn/cN7WAb4mwNCw+rX
	 09tMQGddHOkT80E8tHyH3ZzkTsXkWxlZd/HbbCsP5r0CT+5kg3qh0nUDDRbrVbIUklCn3
	 IZsPvxGag3k7vCN579X7oglvC0m6RdtGlrWXfQ8h2iq3swj5vTpZUEaH40Dqi9ujJRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rP/3nVExHH5ZCWxBLn5e2X/6zMYMOC1JMC8MBHxb5Lg=;
	b=BYMxK+rWF6i1BVMZRR1usc/EC4g3PT2XbSmKKdnw48TNOm1rYwiL+y6stD85zKKsvkfs
	 XDYl89I9GQlDgbYYK3RlBYLKqcOkbaFN6XCQNZnu5MjDJruDaFeBCbnLEYMmuPE3jjh1A
	 P7J/zEt6t+5zhaboB51HaL5LJLM+4lJSMt/JLxg8dMv0ULui8dm1fUugdISgzB5omK0y4
	 53ZMqHrQ5q5S3CunLbEMFP3a/sDvl6QrhFFhoBMDTEEEQL7alP0b5ltlv70J7LBrqq09i
	 jdCGarb9/H1syKs8MIn1HcN9ilsWcuQgiVBl09u0q9+S0s/8z1mbfXBlKOntoufVTXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbsxUZKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D2C606EEB5;
	Sat,  7 Nov 2026 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbsxUZKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858BD1F008A5;
	Sat,  7 Nov 2026 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064452;
	bh=rP/3nVExHH5ZCWxBLn5e2X/6zMYMOC1JMC8MBHxb5Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbsxUZKNF4tYHwbIrQDQ8lAq0L6prlECYoeGVlC6cjtUqUPfRKZ1Q7slgU6j4QAJi
	 uHcs9hbbBpUoRieysDQoxhCXiFRBcKKSQ1zY4iXBROrGQVVca2MgDyqkxJfiuXZsTL
	 ebPeW30YW3VTUNDtwccWfCdkq5dEf3snbkwFFeMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Jia <jiahao1@lixiang.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0495/1257] zram: fix idle age_sec underflow in idle_store()
Date: Sat,  7 Nov 2026 08:46:31 -0500
Message-ID: <20261107134953.107048709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hao Jia <jiahao1@lixiang.com>

[ Upstream commit 59042a88efe1d5ddc457f192f4c6368909693133 ]

After commit 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking"),
idle_store() computes the idle cutoff as:

	cutoff = ktime_sub((u32)ktime_get_boottime_seconds(), age_sec);

Because the left operand is cast to u32, when age_sec exceeds the current
uptime the subtraction wraps modulo 2^32 and the huge result is
zero-extended into the s64 cutoff.  mark_idle() then marks every entry as
idle instead of matching nothing.  For instance, running

	echo 86400 > /sys/block/zramX/idle

on a machine up for only two minutes marks all newly written pages idle
and hands them to idle writeback and recompression.

No slot can have been accessed before the system booted, so an age_sec
that reaches back past uptime cannot match any slot.  Return early in that
case, without walking the table or taking any slot locks.

Track the cutoff as time64_t rather than ktime_t.  Both cutoff and ac_time
are boot-time values in seconds, so a plain arithmetic comparison against
ac_time in mark_idle() is correct and no ktime helpers are needed.

Link: https://lore.kernel.org/20260828083149.45760-1-jiahao.kernel@gmail.com
Fixes: 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking")
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a9b3bb1d3bef3..4ba0f77b2abd8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -415,7 +415,7 @@ static ssize_t mem_used_max_store(struct device *dev,
  * Mark all pages which are older than or equal to cutoff as IDLE.
  * Callers should hold the zram init lock in read mode
  */
-static void mark_idle(struct zram *zram, ktime_t cutoff)
+static void mark_idle(struct zram *zram, time64_t cutoff)
 {
 	int is_idle = 1;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -439,7 +439,7 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 		is_idle = !cutoff ||
-			ktime_after(cutoff, zram->table[index].attr.ac_time);
+			cutoff > zram->table[index].attr.ac_time;
 #endif
 		if (is_idle)
 			set_slot_flag(zram, index, ZRAM_IDLE);
@@ -453,21 +453,26 @@ static ssize_t idle_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	ktime_t cutoff = 0;
+	time64_t cutoff = 0;
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
 		 * If it did not parse as 'all' try to treat it as an integer
 		 * when we have memory tracking enabled.
 		 */
+		time64_t uptime;
 		u32 age_sec;
 
-		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) &&
-		    !kstrtouint(buf, 0, &age_sec))
-			cutoff = ktime_sub((u32)ktime_get_boottime_seconds(),
-					   age_sec);
-		else
+		if (!IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) ||
+		    kstrtouint(buf, 0, &age_sec))
 			return -EINVAL;
+
+		/* No slot can be older than the system uptime */
+		uptime = ktime_get_boottime_seconds();
+		if (age_sec >= uptime)
+			return len;
+
+		cutoff = uptime - age_sec;
 	}
 
 	guard(rwsem_read)(&zram->dev_lock);
-- 
2.53.0



