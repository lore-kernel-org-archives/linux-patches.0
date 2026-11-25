Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624986;
	b=YL0wM+Hc4Alswftx+UqiK/+GoXEXXWL5q8DdLotcfCApRkrFWZBDsbFAWTuiNXuPaJoX
	 idvi8WaknHX2XEatxnSdcA4hKGIrppmAC0u9QzA4R5VuiuWqYZTNzw4CrbuG2p1F5ULlS
	 uFOKavNa1626uWBJ4QD4VqR1rVj6qfpfMz6zfo13QF+79L5cIkkmKx6+3UO8Hlz2/JacS
	 aRhRyRly4HRjorvIkTEzGEaOWDoo0fHpxItoj95O1BgncTp02OcyUC0limbf2mQDR+22r
	 GzbwfkJsNuMo80TWZFmKgpNtxR55NzFoa4Zgh2DoEG/wNAyZ3feEOpHrqINzfkm0eSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SDWS6qNY/H016uozujlpI9i8LfKLu4rKDiER3Djt3Q=;
	b=GG1ukfSFy5brLe4fUo1u9X+zdJHoo6Dnjz/CnzqbymXjEGYPSspQa0a7RQf9KJRTG3py
	 9DKLgs300W0X6kDQhnZEHctxdHCfx59vc/OE1MT6c8wDBznoV0Blivi1OCaj1CB6WGN0Q
	 +eazOWdLr2b1g2tMVOnChJVT01mGu4GzMdHpsLdHvtuS/U1OAIiL+km8/l0IrIc066Psd
	 dHWkVUngYNgAJf7J0lHxtMRsjjo88jckSWpKi2XnWpM/Ct6H7XJ17KafB9e5aP/m4jW23
	 O3l2icvIVfxqfAcpLha8caD8HG7H/w50JrqRtHtInBQDEHg7z89ADeWYpWjHZbdqmdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UZL/ir+o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965E2606A31E;
	Wed, 25 Nov 2026 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZL/ir+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CF41F000C6;
	Wed, 25 Nov 2026 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624986;
	bh=1SDWS6qNY/H016uozujlpI9i8LfKLu4rKDiER3Djt3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZL/ir+oKaGQAswsenPLIaNswkpYWWCCA0Avjvhb7B4V/TXbPBlrKpelx7WbA47nC
	 oYgI1NJxtw8lug+VqB0eTM6mYkfcqhRh1xJqqoGaURGENftFR03pW8xszQD6rOzeVt
	 45YTDWlBdFGQOoC0RCDOZA2skzhY52K//FPR9q30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/816] tun: delete the flow entries of the moved queue on detach
Date: Wed, 25 Nov 2026 15:31:12 +0100
Message-ID: <20261125143856.701994707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 461b02721aab9..2ae337ff384e8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -671,7 +671,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		}
 
 		synchronize_net();
-		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
+		tun_flow_delete_by_queue(tun, tun->numqueues);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
 		tun_set_real_num_queues(tun);
-- 
2.53.0



