Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704439;
	b=V1MRPDWd3rdlpMv+fcmVPhiQZck8ppTQm26yQgEIf6B66EEkmObN2ZygOY/qBf8sbyVj
	 hiK8IHvQeuTEoZ9JawlAPchrvlq2pNeSzHDdwLIMORUTlQa4CMLJEkQ1YZKADjU56JwfQ
	 ZF98x92MBYKyi47261cvuAAsLVl7zdjBPq/1+hpTCu7OTh8J9+qpBLuZkXgk6T2Y9sPj4
	 K3Dkp49h1EngM29uYrAOkq8rYQLJNML7h9IkatdjvgDLBxXObMFMVJS3/S5wAo88MOo8j
	 eH9FvwBJ6epKVroxuH6U9pHfHqU1sK0balHuiALNt+OTfXE3QE+B3VVSrfSOQw3yPpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xYN4rrrDm29r9Mh/WHd/FBlslY/o/DP2CAgvxCQPMYE=;
	b=5A8r5xP6ZqY8wL2FIetIQKVfJ9kKUjGkeWqIdbShC/1S/gDItYKU15LsuVFKPsl0sBA+
	 +2BpEtve5vqrk7SweMD3NXBUYccXXX8Lvs7/ca7oxeAJEMQpd8AveheRqrVi3a48rnwox
	 WqA9A/qhjK066qTmQAMRo+oEK/dVu6kPE+jXAdchXdUcJa4JxEsGotHofHvwRifhGwhnW
	 zD8fjmv7TFGORtsvM1uQuvHUMl5L8DnmDgVTiuIbk9zBeE6EGRz7xso6cVDX3eLuJ2z3e
	 C3v8GBAyb6ZPI280PT7apf+lPulTd4V9VObT+GpPY+YtptIGdz61LmSRarOYzy0Z9DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kI0EOYzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0883606A31E;
	Thu, 26 Nov 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kI0EOYzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D131F000C4;
	Thu, 26 Nov 2026 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704439;
	bh=xYN4rrrDm29r9Mh/WHd/FBlslY/o/DP2CAgvxCQPMYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI0EOYzWuucdnOSXRQ2aaBhaY5Yv3kTXx+f6fGXESbsQKhXfm+7+HCoAM1e6gpPwJ
	 /Okgsl3LH3NtL1UxhV5jGOWdOKVPp2wNmIYiovLtvZS8Euuz7TbezOVaXDSWD8p8Yi
	 mj28bQudggTDgmwL9NDKFOyz/3OpOpcP/WVQkJfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/265] tun: delete the flow entries of the moved queue on detach
Date: Thu, 26 Nov 2026 15:37:35 +0100
Message-ID: <20261126143613.769457279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d706c7fd6adee..5dd99581dfcbf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -683,7 +683,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		}
 
 		synchronize_net();
-		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
+		tun_flow_delete_by_queue(tun, tun->numqueues);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
 		tun_set_real_num_queues(tun);
-- 
2.53.0



