Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033202;
	b=KSrMrMBzuGjvSbHWgs8MI0+ShDG0s6Rl14NweniquYofSMeZQm+7A3T6jOVJfh/Amn94
	 ieMz6cX/Y26mPeM/1nksagEldUvGI6F9mTgSOQZFqIF1Ubgb6j2U6F0+11LftzzCTVb+u
	 8KZAbZNUsySEJ7VqflrNED6lwl3X8r3fNf03/KKsyMhy06UNVHR2avvqvLVLZ0PfG+b+i
	 2Rx4qUOfPB46axboL3XooTVefZ0PF+xwze6MZ2/4Jqe+sMruMkFx/zK2GNqYE0tfWzNbv
	 ElZOHvVlSguLDji/JVHthns1PptnaEuiZEte0XnIx2sLtUd3uqw3mdY2HnwrwsvzDiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uno+4HRdTnVM2/YA7gwqyzSoBB0HwmGfiYIUeWST/LM=;
	b=CDOHlB4LlmVo7Ab7WlGAtA+X9CNzQ7+3FEcRn5yI7L/OqwkKFBcVWg8tN+a4AVvOXrQ3
	 n1hu5cvnQrRqWsAmhmjLuwJqE54L5G2tsmN2jul/fLCq8PSauGKWUtLZ2qOEcwlmBjZSC
	 5ih93FJs4E+HukpdlRTa+7AsYmT4I1O707Y31OYusvCg7X53oKI3N/IIrfM9eZM9j2WZz
	 t3b48x/7E5AAI6EB9j8qI03R2QVp2YFt8VXxiaRq3nP7g+zwhNje1r9MbJbeGLU2EIjaJ
	 LTdowZ6ZI5wBKCizuX6RVzuGbMiqF9aHtboObBgEieBx52iFYStjwNDLotlh2g+PyDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvXjQvhA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4FE606A320;
	Wed, 18 Nov 2026 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvXjQvhA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56E31F000C4;
	Wed, 18 Nov 2026 20:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033202;
	bh=uno+4HRdTnVM2/YA7gwqyzSoBB0HwmGfiYIUeWST/LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvXjQvhAlikfWpH31W2fv9xhm7umoigNgXS4noMhNuwWE5K8IZZNukmcaxweFIpMl
	 6Ps6WPqT7sF4xF5exVpX4zrufjQXk7So4aJBH3k69fn43zBuEv8I2tn7RnNuofUuar
	 JaC8k6MajIjbQShVUZshBc0o1yrlTCrpUYQ70U/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Omar Sandoval <osandov@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1683/1756] block: remove redundant explicit memory barrier from rq_qos waiter and waker
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150116.696601002@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 904ebd2527c507752f5ddb358f887d2e0dab96a0 ]

The memory barriers in list_del_init_careful() and list_empty_careful()
in pairs already handle the proper ordering between data.got_token
and data.wq.entry. So remove the redundant explicit barriers. And also
change a "break" statement to "return" to avoid redundant calling of
finish_wait().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Link: https://lore.kernel.org/r/20241021085251.73353-1-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0150554a3f38 ("blk-iocost: publish hweights as one atomic value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 058f92c4f9d57..eb9618cd68adf 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -218,7 +218,6 @@ static int rq_qos_wake_function(struct wait_queue_entry *curr,
 		return -1;
 
 	data->got_token = true;
-	smp_wmb();
 	wake_up_process(data->task);
 	list_del_init_careful(&curr->entry);
 	return 1;
@@ -274,10 +273,9 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 			 * which means we now have two. Put our local token
 			 * and wake anyone else potentially waiting for one.
 			 */
-			smp_rmb();
 			if (data.got_token)
 				cleanup_cb(rqw, private_data);
-			break;
+			return;
 		}
 		io_schedule();
 		has_sleeper = true;
-- 
2.53.0



