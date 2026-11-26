Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705289;
	b=I78UWrCL+jZieS0An11yQprtEYTZuzUIl2RV0eUeZLjaChUFsb1/DvLahGUt8gjoVf9X
	 17oV4B6aw5ut5sUkLdBxc9FD+hdJ+eJgeqmwyyq+Z22wIPz5DWqysEf/RxBHl2T8W9AEm
	 /Rc+JJlqpIa4C8/+5Qtnvb/gprpdAbPmwCoVgH1fMLkf+I3SKddQJxduqtMrvay8RjNtj
	 4tdCVxZXHtFW+gttFjrC+j4hxeik8AEV08tVjF4xHprXgf3l+eaHIlsqtHPFB2HQcSYic
	 bEOsvzWt79KVTMgNO7GnW9Q0ziHRmBnPnskFMt/F6hgCM8mk5+CiH1mUISumuC2+jZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/tBkdDF9wpRJVXYhS9FdQVt5pK6sU+pA4EfE4ZtQhEM=;
	b=YZWrZOjbJPM85o4+1RqUMqRPLFo22Fe6xvTGXHujchClihifgasJadw+8b/ElTqgthr0
	 do1nP0gQjyGlKMBrldXhUxpXeGN2JL6D15wlKDiJ/P8jATOe3CQzqryUY6XZJbwHZv2c4
	 ICvXyqyZJmqm9FxGtO6pj7IqnT9PDesK5FYjMmsXkSGWDbRu5altdMXZA8KQRDRXMG6Br
	 Meb+3/V3/ZCJoiUFficJJKLlyByanBGc1UWnCA4yHgA2ZoOrQ91frKXj0uPHzuzqOMuhm
	 3Lb0rDbU8q8Itq66Y5lCOEV8k4DbFGJZm2091AaGtjmiwW38PkvfA69ASW3fMniOhbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZXsavb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B74606A31C;
	Thu, 26 Nov 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZXsavb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F241F000D0;
	Thu, 26 Nov 2026 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705289;
	bh=/tBkdDF9wpRJVXYhS9FdQVt5pK6sU+pA4EfE4ZtQhEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZXsavb7U5I68FNNOz9pz5Y8Y68ngjpDqswJVm4PZ+C/XkIEkSs+87SVtt83SKiXj
	 t+3dfiZhb7NRTkTQC2yS/6zfs0urKCeCjmeojZW1nVVxAhyd1Jqt+M2BJecHUwhUNI
	 khfheeEni2nXXRdJKw0JFOnARU+uMM/7SMJEQc6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/319] tun: delete the flow entries of the moved queue on detach
Date: Thu, 26 Nov 2026 15:38:36 +0100
Message-ID: <20261126144010.087757198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 652cb1c638081..bde1063a21913 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -672,7 +672,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		}
 
 		synchronize_net();
-		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
+		tun_flow_delete_by_queue(tun, tun->numqueues);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
 		tun_set_real_num_queues(tun);
-- 
2.53.0



