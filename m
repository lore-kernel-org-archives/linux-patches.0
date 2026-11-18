Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022556;
	b=osssI0L5kMP18BCflrODnttDOwrJNK1il7kbHxhw0inOVsP6Z4Go7nTi0kDR2PVtRyz8
	 BgjaiMdEcY2yQecCoerLiHLy3OnvQQjiZyjZTLPRYLMi0nB9G5Yjn1B4SPY2wJ/f3R+1k
	 N8rDB4TdjBT0bRiYDbnBQJhVg6TpbwlteMAGQ4gK7YJTjJIsaSITNyJDz6/yzjKpoQX1r
	 gyoK7LOgcJQsjMGgTMsn2UtTRW6PotcYh4ttSyTBJcdYkU+B+R10zp18UHZ0dhh5SG/9+
	 vNrfmSckiTuzWa/S37X0Yyn9qTkSllanEKUBZjIM2A8Qkim7+vPmPX0UnwA0zK5DZbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JFIQWIg5mI4/9ZQwkmbh6lXC29YBbRgHW3KCFEeG8dQ=;
	b=2tsqw7dk1vE42HKkgFfeJQ2cXRDYyOjYkK1y5o6PXQa85xIQ48ahickOU3K7qSNVJqqD
	 TkLDimfATmFaRgwWhHAonuQThNMtStEqXjyP8E2XltDuxbMj3uGJhX1UXKd9uhV5iVr3Z
	 agltg5pQZ2cXVugMUHXUS894z5qH1HjWbf23J6Focciw/IzPkaR/DW4uc1yTnmkS+ymN7
	 0j1ptqAiRyC2gGgEL8FIm6j66C4M3svTV/a/x+YQsdWVGEHkTcSjNePekHYWqKm4zyOtK
	 2pQqC+s1EafCpA7ywL27yImDuhneknNfrBE/px7excDU04GI0Mcm5OckW8yaK637kkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2XJsl5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62732606A325;
	Wed, 18 Nov 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2XJsl5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22B31F000C4;
	Wed, 18 Nov 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022556;
	bh=JFIQWIg5mI4/9ZQwkmbh6lXC29YBbRgHW3KCFEeG8dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2XJsl5bnjsjl0LErn33RJyX3zGatf9Z4e7PYa2qvW4/Ax/v0OLbVmJPM8/gxDGnM
	 htkvqnimeZQIMLZAHc0g+WQbK3AfIrLL1k4giDQxxVZhVgN8HwuyazV0XEkSpvJ9oh
	 2btjoatHwbACOWuENuCbLgYOydx/RwI4cI8y+UBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufan Chen <ericterminal@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0048/2151] io_uring/eventfd: reset deferred signal state
Date: Wed, 18 Nov 2026 15:29:43 +0100
Message-ID: <20261118150123.477233461@linuxfoundation.org>
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

From: Yufan Chen <ericterminal@gmail.com>

[ Upstream commit 04fe9aeb4f3c0999e6715385664c677469dfd8f4 ]

Recursive eventfd wakeups must defer io_uring eventfd signaling because
eventfd_signal_mask() rejects reentry from eventfd wakeup handlers. The
io_ev_fd ops bit tracks an outstanding deferred signal so that the same
rcu_head is not queued twice.

That bit is only set today. Once the first deferred callback runs, later
recursive notifications still see the bit set and skip queueing another
deferred signal. This can leave new completions without a matching
eventfd wake after the first recursive deferral.

Clear the pending bit before issuing the deferred signal. If the wakeup
path recurses while the callback runs, a new signal can be queued for
the next RCU grace period while the current callback keeps its reference
until it returns.

Signed-off-by: Yufan Chen <ericterminal@gmail.com>
Fixes: 60b6c075e8eb ("io_uring/eventfd: move to more idiomatic RCU free usage")
Link: https://patch.msgid.link/20260503175710.37209-1-yufan.chen@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/eventfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 7a57dd88304a6..89b6e0f67e559 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -43,6 +43,7 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 {
 	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
 
+	atomic_andnot(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops);
 	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	io_eventfd_put(ev_fd);
 }
-- 
2.53.0



