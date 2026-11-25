Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619072;
	b=IpzEUMZ7c8/qbfgsMzHqDOWSNAuF7SCr/rRJ2iUQ7GoT4wsqHai6Emll11FQWGVGjvW7
	 lx0nvM6ZSS2t4TxJKXHIbAuhPbSULCUdjMsqO403VrtTJiNmxn8XVDpx77j5cZ47KwqVT
	 Cdp3JMTiYSXGU6Felnx4l1P4NT7+7G3le/lKc7zDpOHUTjdw+WZYzbDagHihEfHXYTtwq
	 TV7HTQ11znKOrj1Lg0uSPCX2x+aopDhUUK6of9iXITGHBTOxWemp+0ngLB+Lm3hTdAmum
	 WvJo9njxdiyIqI7UDM++ZX2S8iFxpEFcBaZHrZBtFsyEpUzy6acMJo6GFKA7+TF9Ntw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jSMOVGCCeS6R1d7dLcW26bytAnXzWD6Vt2HcnLZcmR4=;
	b=5RoCKftbnO25X5tfBmTuVZmiFLqEFn24QJjTcTxRpcnXAS7Nl6RWpVIm5qR0M6/5fpaw
	 OyFEQLzUQkY/8K7e4xKJXgCXHgEc7DTgpKO76v6q+qW0c7WYmvXMd0QIbhkTvPkk1q6nO
	 9LZkiAZU6XfK6FO1yS8K17t+vNljCIZJj1M6/e9uUxh97mDM5GqRA04SFAS8h683QJ3Ho
	 BNg/9utzZhF9oyXq0z6hvk6WURzNKxbUPtzJbmBZ8KbHdVTWGiM6oB3nGETZqex2cghpz
	 X+2XlUNhuNnYbpARu7ZyhGpSSwHrvMVqvm7BvKJgUhFVJ7oWO7eo9i+7qeh/tVnqvoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYHC2dtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ED6606A326;
	Wed, 25 Nov 2026 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYHC2dtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D70C1F000CF;
	Wed, 25 Nov 2026 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619072;
	bh=jSMOVGCCeS6R1d7dLcW26bytAnXzWD6Vt2HcnLZcmR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYHC2dtkT4bGpjpYvfC+bRf9wdnvp8h6SIw3nwwOC0Oq/YaBsr/K2sYCC0x53jexY
	 pWw4LPSjV7YC6H8qctyDjiev5rYTsvz6ltuI8TtW83kRO9DKjfo1zSu9In1m0/hHZX
	 rBkE1ooSNouzARem34wNzWahkR1nvMMwkZGIBdQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0480/1005] tun: delete the flow entries of the moved queue on detach
Date: Wed, 25 Nov 2026 15:30:18 +0100
Message-ID: <20261125143832.992869113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Umang Pokhriyal <umangpokhriyall@gmail.com>

[ Upstream commit 4cc0a3f897074cea28dae38f1cd9bb230dae5d86 ]

When a queue is detached, __tun_detach() moves the last queue into the
freed slot and decrements tun->numqueues. The flow entries that point at
the old index of the moved queue, now tun->numqueues, are meant to be
deleted, but the call passes tun->numqueues + 1, an index that never
exists, so nothing is deleted.

Until those entries are refreshed by a write on their flow or age out,
tun_automq_select_queue() returns an index past the last queue, and
netdev_core_pick_tx() sends every such flow to queue 0 and warns:

  tapq0 selects TX queue 3, but real number of TX queues is 3

Found with an LLM while testing how a VMM detaches tap queues when a
guest lowers its virtio-net queue pairs. With four queues, 30 flows
learned on queue 3 and queue 1 detached, all 30 went to queue 0 with the
warning; with this patch they are spread by hash and no warning is
printed (3 runs each, in a guest booted on net).

Pass tun->numqueues.

Fixes: 96442e42429e ("tuntap: choose the txq based on rxq")
Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261104174240.138491-1-umangpokhriyall@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dfdc4b5bd27f8..3cb2c87fa8137 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -615,7 +615,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		}
 
 		synchronize_net();
-		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
+		tun_flow_delete_by_queue(tun, tun->numqueues);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
 		spin_lock_bh(&ntfile->tx_ring.consumer_lock);
-- 
2.53.0



