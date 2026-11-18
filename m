Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022109;
	b=YIvlEzKOK+s9odLSDZSQU2Of7HNeLzVorJqceEQJjSRvU/V1z4h8SbVL9rEmmq0KjIse
	 WGcYq6JavrA+8flfNBOBSrx138ydDzS6pbn/1B4T+AmKrRJDIQ6naZpBOM+KZJBVU4r0L
	 hSENBr00pxJmHqEMxAfKpGVv9f8XBB9GGaf+19i8DKMAKn7FY/c+BhcuaJeyRyZStWuS5
	 ++sYLOJ6cSE+lZFsUiDtfuFVMiHpstHNlZlZuxkoOyy/mlFRO11593cUwr4TvERAhbKPl
	 JNcFptF1CXIlny2hflMXSqnUOkvSCTYX/CW6J0I7QhWlYiWpFMUZdO1PvgMhRCbV5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vZq4RxU0WT3LvTMfmHqkXfV+HiE/H51A6siT/w9te0g=;
	b=pWDDOq+Frr4aSTub27AH9CYKl3wnQn3FrWAdWKvTU4DLx2cBgrotvEeoyBx0P9WYU3rN
	 mnD+R+kZtW2B3Q/g3FUw8oWMJFhR6z9NE8BVKaD8mTqHVkt2pjfEjFErajO/kYLzHr6KH
	 1TJBrMyYD9kXbcEiPgGc/dHx127G4GYRpGRgCqBgS0aO9ymBgcMeyjeQcExgDBz2Q/gKI
	 QaQYekGag3CtcxiCDWUctpsQWjPzXZYx93lXn//ZMBCzdRfkTONTHVmslu6DcV9gV81Nj
	 OipfprKipHAF1TBsYf8BRKyZYzCFglj9ErAZ9aVz6F50m4KvKPSAdiw8lw4UJRE6uRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNTN0Q53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A5606A32A;
	Wed, 18 Nov 2026 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNTN0Q53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2861F000C4;
	Wed, 18 Nov 2026 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022109;
	bh=vZq4RxU0WT3LvTMfmHqkXfV+HiE/H51A6siT/w9te0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNTN0Q53IxzPzzRGMWUSDnGnfJgUufKTOqYLaaCxRXEBqY/RyvLV4yJ/x9og6Pvqa
	 aV4LZL0UFvcjE5q2pZORXZv7GAs71wxUidJG27WTQuIxn4BaVDT1FeCuT2hiGb+/iV
	 LbhKxpu1lf8iUiOh2DdK6Hju/r9G8HWFH9BrIAcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2546/2651] blk-iocost: free struct ioc after a grace period
Date: Wed, 18 Nov 2026 16:03:06 +0100
Message-ID: <20261118150416.183987856@linuxfoundation.org>
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

[ Upstream commit 05ce1df3756773862c056ca8698f8ec4cdd7fe98 ]

ioc_qos_prfill() and ioc_cost_model_prfill() take ioc->lock from
blkcg_print_blkgs(), which since commit 56cc24f59c14 runs under RCU only.
That covers the policy data, which is freed after a grace period, but
not the ioc it points to: ioc_rqos_exit() frees that right away, and a
concurrent read of io.cost.qos locks freed memory.

Free the ioc with kfree_rcu_mightsleep().

Fixes: 56cc24f59c14 ("blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-3-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index d6fe74adf62f7..98d960b15a075 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2908,7 +2908,8 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
-	kfree(ioc);
+	/* blkcg_print_blkgs() gets here from a pd with only RCU held */
+	kfree_rcu_mightsleep(ioc);
 }
 
 static const struct rq_qos_ops ioc_rqos_ops = {
-- 
2.53.0



