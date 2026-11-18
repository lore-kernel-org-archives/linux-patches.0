Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053435;
	b=HGytCO2UbiMbp3kTDOn42QgnJVXS1lG+NrUj5cd26Dxz3ngKk6mtV3X6G2FALfo+kSIG
	 4JuTAo7+Erxt/RfxziT5/AGxh8IDosUiyUBJfAQqyndH6SmDLOqRn49wBgLa8y1c87wRg
	 c0297uZEahHdasMSzHNJCUquxTSk/Y61hbpfoMybovAH4pqIX12U3iyUrei8Q0P1qL2Zf
	 gXwIFQ8daoROYuYony7J+wQr8hGrQk62xS9MzrYzfmdljINVvEOg2aky+qJR1r+Sehvtw
	 Pw+TWUeqmXd8SG6NChQ/95U+EW5hpKvgV7BUCvTGPMQdamjq64XpYa1baqoR2v258Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBkKJ1b8Rx3m2YOTRoAp124Dvsqbqghvxph3bqj2naA=;
	b=NUbF6i5vZ7xnzfBKsp9LBUHEJ9qPaOkbcHltZKsNRn66arKuVM0ww8q3x+7z9uo7AePk
	 RdFf95P6bBVk8uUkDNU/2O0Vd8PYvbTfdS+9+Lbnl9vYrx6W3h6HfRppL+Y7k8vVD2VWV
	 5DzKYcf6MG9f9jTTk6OKjdO7UQb0zjM6GqAxTyVnJ6OUb6FlIf3tFXOanC2MhkpefUGoW
	 ELuoB91NHJEGUzhTwtNkRXaltZkmwfF0QV1sOKN21JY5VK7UkjTiYDhiA+jl2COp4PVwM
	 FTIka32KI+oR4eLmWwzW21wZuKRo62UV7XG+mOW8LHUn1d7iiGOTyfLGShGpxAVmxhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUxfTd7U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FFD606A31C;
	Thu, 19 Nov 2026 01:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUxfTd7U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B906D1F000C4;
	Thu, 19 Nov 2026 01:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053435;
	bh=PBkKJ1b8Rx3m2YOTRoAp124Dvsqbqghvxph3bqj2naA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUxfTd7UqBZ3CJLYjJr3An/x7ykg5ByJ7CDsQ48Ait+heoSYK9D80Eq2sTPxHbVY/
	 L3/UY2yJbmtbDB+bRdNaSPWZZU9eaog07rjKHEBqUtt54HTmvJWFJE9gqJgiKcB+gh
	 IqBkmKRyyaZ0dTw/9zVyv9EOjolghEuF/23DX6Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <sgzhang@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0919/2214] net: count last skb of each sk_backlog pass in __release_sock()
Date: Wed, 18 Nov 2026 15:43:15 +0100
Message-ID: <20261118150049.104491179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Zhang <sgzhang@google.com>

[ Upstream commit c4e4056b21355356f6a95bcdf03a850edd9f49e7 ]

Running 500 concurrent TCPv6 streams (neper "tcp_stream -6 -T 1 -F 500")
on a 2-core Cortex-A53 (CONFIG_PREEMPT_NONE=y, HZ=1000, LATENCY_WARN)
triggers resched_latency_warn() in __release_sock():

  [ 3655.311821] sched: CPU 0 need_resched set for > 100006892 ns (100 ticks) without schedule
  [ 3655.311889] Call trace:
  ...
  [ 3655.311944]  resched_latency_warn+0x7c/0x88
  [ 3655.311958]  sched_tick+0x1c0/0x418
  ...
  [ 3655.312578]  net_rx_action+0x238/0x438
  ...
  [ 3655.312641]  do_softirq+0x4c/0x90
  [ 3655.312651]  __local_bh_enable_ip+0x84/0x90
  [ 3655.312663]  local_bh_enable+0x1c/0x28
  [ 3655.312674]  __dev_queue_xmit+0x4a8/0xb00
  ...
  [ 3655.312782]  tcp_v6_do_rcv+0x240/0x5f8
  [ 3655.312793]  __release_sock+0x9c/0x188
  [ 3655.312806]  release_sock+0x150/0x168
  [ 3655.312817]  tcp_sendmsg+0x4c/0x70

__release_sock() can loop past 100 ms without calling cond_resched():

- Each outer-loop pass drains sk_backlog, but "if (!skb) break;" runs
  before "++nb", so a pass of B skbs only adds B - 1 to nb (0 for 1 skb).
- With 500 TCPv6 streams and NAPI sharing two Cortex-A53 cores, runnable
  tasks keep TIF_NEED_RESCHED set on CPU 0.
- During spin_unlock_bh() and TX softirqs (__dev_queue_xmit() ->
  local_bh_enable()), tcp_add_backlog() coalesces arriving pure ACKs into
  a single tail skb.
- Repeated 1-skb passes never advance nb or call cond_resched(),
  triggering resched_latency_warn() after 100 ticks.

Restore the do-while loop and drop "if (!skb) break;" so every skb
increments nb across passes and calls cond_resched() every 16 skbs.

Reproduced the issue and verified the fix on two 2-core Cortex-A53 hosts
(CONFIG_PREEMPT_NONE=y, HZ=1000, LATENCY_WARN, latency_warn_once=0) with
a userspace reproducer over /dev/net/tun:

- CPU 0 runs a TCPv6 sender and a second runnable task while CPU 1 writes
  pure ACKs to /dev/net/tun (~30k TCPBacklogCoalesce/run), sustaining
  1-skb sk_backlog refills in __release_sock() for ~400 ms (ftrace).
- Before: CPU 0 stayed unscheduled in __release_sock(), hitting
  resched_latency_warn() 293 and 275 times on the two hosts (> 100.9 ms).
- After: cond_resched() yielded CPU 0 inside __release_sock(), with
  0 resched_latency_warn() hits on both hosts.
- Also observed no regression with the workload from
  commit 16c610162d1f ("net: call cond_resched() less often in
  __release_sock()"), "super_netperf 4 -H srv -T,10 -l 3000 &".

Fixes: 16c610162d1f ("net: call cond_resched() less often in __release_sock()")
Cc: stable@vger.kernel.org
Signed-off-by: Ray Zhang <sgzhang@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261101075145.698399-1-sgzhang@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 860b8d3cfb9c0..b81f198ca61c8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2725,7 +2725,7 @@ void __release_sock(struct sock *sk)
 
 		spin_unlock_bh(&sk->sk_lock.slock);
 
-		while (1) {
+		do {
 			next = skb->next;
 			prefetch(next);
 			WARN_ON_ONCE(skb_dst_is_noref(skb));
@@ -2733,12 +2733,10 @@ void __release_sock(struct sock *sk)
 			sk_backlog_rcv(sk, skb);
 
 			skb = next;
-			if (!skb)
-				break;
 
 			if (!(++nb & 15))
 				cond_resched();
-		}
+		} while (skb);
 
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
-- 
2.53.0



