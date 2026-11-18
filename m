Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023858;
	b=r8OLCkhrh2JeEKLt18Bgu3gK31GCdzBpfPoGOZJ9UYjxV192bSm34fhsU1WWCg9pL/OS
	 ar7omnw2oV8ThilaWRvxYHN5ocQNgOJ7CrTcShj0cNVPvH8VuOg2v5PDqc5EEHps/LD4T
	 ZMSDG0CKoKhyp7O+7a52pA2YCb6B5cM/w6EAZ+eH/ICJnvWM64iY489Q1cJKv0Kaf/9im
	 30YPjC0yTq6cQ0zHIgP9IUUc9bkKUy9gwZhfS6nxx9Eoaim6s6f3MjyORrzsbO2/ZiJf5
	 w93c+E8zFZTHOPYDlBHhsaW7EaS5VtJWz7bDApQX0aFHv8InXsBaaBt+S+3+HVrvVDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQJbWyqOCGuSnge1/Zt/L/JxfJqb+XgAnYI8xdu36rc=;
	b=BJJGSkFuG9+fixNq+/dv9m9a5wqGkl+fgaNKDWKPiQ8Dt0d51ncBjuPH7vN017sbG64X
	 XYBovw9GsLtlj5cfVtlPqH++K1zbE73fKFc4rUhUaCGOGn764RBnOAGut9SWhoWm8ody1
	 KJBOKsvWUQ26pdXYukfrz/Sr2CIHyusEp+/3nYrhyiLdEV1ZL8N/iNntvgW+E8tM9fi3v
	 da3PvrjsmoXcMROURs2L/ApSQrgBW4KltE5D8ji4HVOWc9Ty9WsY4mgrRUFzGOayhkWH+
	 Mdn/omD4PI3ek5MF9ubGEGhhLqNj2bo7FPkHurQNSyLAIuY6fjYuLtoMRWiE85cytgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dh7l45ft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FBF606A31C;
	Wed, 18 Nov 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dh7l45ft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622821F000C5;
	Wed, 18 Nov 2026 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023857;
	bh=KQJbWyqOCGuSnge1/Zt/L/JxfJqb+XgAnYI8xdu36rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dh7l45ftZYX/LdA363ySTMrgoGU/e5NWwyKTZFQdxqu5M18b9vuCLAparU4sEnDOK
	 aOI1HXFhw8H+BGpflgSbAEBbsfUt+QPWlLktBgekqIMO79lnj2xR7bXZ3zlGca72Bf
	 /kqE8cIsBpohKAHGaV9iw9OWtRIG53VSo909PLi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0478/2151] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Wed, 18 Nov 2026 15:36:53 +0100
Message-ID: <20261118150139.424437446@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit f00eb0ff45793383d5a62db2d2aea63ada0ccdbd ]

Fuzz testing triggered a hung raid10d thread:

INFO: task md0_raid10 blocked for more than 120 seconds.
Call Trace:
 raid10d
 md_thread
 kthread

wait_barrier_nolock() speculatively increments nr_pending. If a
concurrent writer changes resync_lock's sequence, it rolls the count back
with atomic_dec_and_test(). The rollback currently wakes wait_barrier only
when nr_pending reaches zero.

freeze_array() can be waiting for nr_pending == nr_queued + extra while
array_freeze_pending is set. If the rollback changes nr_pending from 2 to
1, the condition becomes true but no wakeup is sent, leaving raid10d
blocked indefinitely.

Also wake wait_barrier when array_freeze_pending is set, matching
allow_barrier().

Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260817033340.418119-3-wozizhi@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 60c8b3414790d..18b5695345999 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -996,7 +996,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 
 	return false;
-- 
2.53.0



