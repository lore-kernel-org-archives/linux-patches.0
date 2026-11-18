Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058208;
	b=g9jjij3MeahtwNBvujjXBiNPHV27EE2JDzEHqKetKVDErTgjJr8E1ewuGJIx+RQjz3vM
	 8d129dkg6wv8ZsnnpuTuoZafMdliBhuQy1hVSSW1xjGs29hMAGt1p7JyuvBdLZWIEgNeM
	 IwFrFyoBtTdZoLsPsd/22ZRSS0whaU5iQm0qtSK+vBkTgnz7FCoLZ9nIklZXkacou9IY9
	 Oz41JIu/77UV16+B0Xq6KMXMOtd2GiKDYx3L0TaIRZUqc2wldLIb02gpBXo1F73Qqjpm0
	 VUjsOVVA04blsHjOVUs5NgW4LCxSVF7EBncb6YJY3qb/YCKiR8Yuj7gNvmG0xKP71XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wIMM5O5iXWJFFC6zVRZuFO8Ne4ysxUR8jVnBANXHYvs=;
	b=Ucd8WNu764AjbAAvsqpYzunU6C5Bp8K7tsaSFhhaG78dYyzlCrcs0qxTWFQuhZlLJlXD
	 TC52kUDH2isoewUa6I+PkgpuyiLC9hXSGz4dDC+9jMQeCFNOWWiU8lajuYMKxb8hL4Eff
	 p44yj+0I0HHXf0ESiUbmCE8VQsFHDWooZZXZxUmOgbJeM8mTaY/nR0RUZuUljDncLY9zT
	 j8bb/Ib/h147JhG7nPFSScAsX2qdzpOK9gIjycXqKQFT+l0SXefvH34y3pQkaM1RTXBpc
	 gLYZRLHboPjTxd93Tprx6xt9wzqtdmye8y/nWVQASxFbrw2PXHOFmUGUCXiIPxpvYZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQkzI1O+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8793606A320;
	Thu, 19 Nov 2026 03:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQkzI1O+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A191F000C4;
	Thu, 19 Nov 2026 03:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058208;
	bh=wIMM5O5iXWJFFC6zVRZuFO8Ne4ysxUR8jVnBANXHYvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQkzI1O+k83F+NBaNZ56DbZGDwbx+dkt7B1dXy+x3THBx8crVU3WExr8ttaFN/qEn
	 L7e5Ftnj+LnQ9S6810TGfhzbDp5qhOpSCHn72CX6nLOawn2LmhCtYkzUKpEiXcksjF
	 k9PPwpmgrhPR/LzgEi6X0nS7DKraeGwXZXWAvcL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0405/1848] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118145930.813892313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 41742e35268d6a45161b187f51f42bc2ade14d0d ]

If cpuhp_state_add_instance() fails in raid5_alloc_percpu() (e.g., the
startup callback raid456_cpu_up_prepare fails due to an allocation
failure), conf->node is never added to the cpuhp instance list and
its pprev remains NULL (from kzalloc initialization).

When setup_conf() then jumps to abort, free_conf() calls
raid5_free_percpu(), which checks conf->percpu (non-NULL, since it was
allocated before the cpuhp failure) and proceeds to call
cpuhp_state_remove_instance().  This calls hlist_del() on the unhashed
node, which dereferences node->pprev (NULL), causing a kernel panic.

Guard the removal with hlist_unhashed_lockless() so that the cpuhp
instance is only removed if it was actually added.  The lockless variant
uses READ_ONCE() for the pprev read, which is safe here because the
actual removal is synchronized by cpuhp_state_mutex inside
cpuhp_state_remove_instance().

Fixes: 29c6d1bbd7a2 ("md/raid5: Convert to hotplug state machine")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Link: https://patch.msgid.link/20260827080341.112296-2-ghuicao@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 82b94abc5df3e..b862f91f128fc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7078,7 +7078,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



