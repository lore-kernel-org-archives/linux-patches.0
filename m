Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622075;
	b=07Qwh4QmZ143AINgOEQBjvhgzsyL8ti28Iw4wrEI2h739KAh8AiGdeiKxtQQLn0vGZON
	 x4E8Ap7xmhDQ8AbTjaiiLX3Dpulvmw0A9Y5dfvSsGAiDTGTZMdoAYlAaB3LR/Jbz1Gv9l
	 UzLE97/3Gb4BWMyZxDQ1yej4ls2yr5EkOj3FD6fHwKPE8THvdgKMMQ2DjFO8K6tkCLYJw
	 NuYcYkYMDokaKKknqBxYrN3GPy82pIPRjYxD7M1A5xh8lQ7N1BKjIpZdhUfD4ysnpsk2s
	 W8rkXkumo4/HLh38eYBgWjPWsjXcenh6npHjlv+Oh26yGW/4KjggLgfu4VVr+CNy6yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=McR3D9SHHjzbbnOW6HgosaBFvA6fPt4KRX+rLfFEBjE=;
	b=DRYN4x0/Vsz0ZsPoU26PAtj17/7BXlXTrcFbKZrWgAy29BPPB7cfkhK2Fjl98XE94SMc
	 EUzqGNRZuBrOwaSO4KJR5iDbnBWZ2GctOkUSdGRyyxd7lix4PA2xujeU7s/Aks5mjdMEF
	 SE1VitBTO4e9Met1K89RJGfya4hhliSSWsNhpy6bbkWIibJDDnTFsT2Wc5zApbWxMSn2/
	 z/7nw15dsozSFm8NeCYmVztkR3ieADYBXvQ9U0W2GeJDz2GPUfAyLP4wgJLaCGf/oY3fT
	 MnFJGTbjcV8pGtAI/B0apqlzDysMD6OsTYn2/sD4oxENeL1Vrd1Mixokbl9BuCsjIwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gdvj0o16;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF8D606A32D;
	Wed, 25 Nov 2026 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gdvj0o16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1881F000D1;
	Wed, 25 Nov 2026 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622075;
	bh=McR3D9SHHjzbbnOW6HgosaBFvA6fPt4KRX+rLfFEBjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gdvj0o163BQ/d4UHkXXB7rYJwoSZn1yIyJX1e3CYgPl4pFMZ4K55zSbodVvE/rSJG
	 ETkJ37DgIPNRsghQ+xkpQETdfnEfRLk5Eem8bRJZvwWgkNfPynCPkJGxMCIZ2KhFfi
	 BblrAsKHQDoJdun+5J8BSOTnQfFZPTTcVHMnPTKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 422/990] tun: delete the flow entries of the moved queue on detach
Date: Wed, 25 Nov 2026 15:29:49 +0100
Message-ID: <20261125143831.982680236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 51b598d53f5bf..d7780a0069218 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -607,7 +607,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		}
 
 		synchronize_net();
-		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
+		tun_flow_delete_by_queue(tun, tun->numqueues);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
 		tun_set_real_num_queues(tun);
-- 
2.53.0



