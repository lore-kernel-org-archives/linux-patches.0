Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045046;
	b=0zwL7jTCJwSLL1MOOfiYx73NgIxgZV4fHLmjt7bQ00KRj/n51ecIQ88Xi7IymRPVfM8T
	 m8MRAABIzRTVg8zxodpe6LWW0JghCTmo3cXegocHbRRsK7XwEQTBzBiSOZ4W/PEn4LlbT
	 w3U2uh1SsaC1rDUzD4ZfFjZgW2yE+pdRRVbVmtLXO9v6QRE76QpJyi9wH+VFfvgyevOOy
	 k8UUejdLXQQ1aUtQ2Vzm5kCjDbjJSvrGa/oulyhGj/FNnBNpIugG6YR0lsu8K24cTQCnd
	 4fx8g1KMAjDKGf9eXPCx6aUvGFfrh6oVHInByMc3kUONz/G6r/X7lA8c+K3XeqWgSOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dg1zxhfeaq+eCRYcv8787ZabvfP2mZnYaxmyPJYJGac=;
	b=UuS5KEBuOuA+7ETvuHCmU3AMSn0J9e7Cc/0DLvRYYZTUmEPL1ibyGg/g9MZ1JmcJvfwO
	 Zb1fso6sTn/p4smm4D77BYYWGXsrRiW+CnRphRptqN9UukVXTG++xy+SlFA6jFs75LiLc
	 HXTsevMU7qSmZ+FhRX68vZvDi11Ac6D1B51xZTuLBmkgf3G2pUDU19oJ/FtD/sT+E/CrF
	 cXOpIJ6stDZmZMD3xGqAPkL5pu/zSUx8ZjXPylK9BhssESIaZ0ZhoHr21Kt/XW55H5htA
	 i6m4utSA2brp66UDOHLMvOxHStyeUBOfixCcOysb/ckOmjhQSWH0V9/xkEuWITegBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXC+BVcG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95796606A325;
	Wed, 18 Nov 2026 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXC+BVcG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB771F000C9;
	Wed, 18 Nov 2026 23:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045046;
	bh=Dg1zxhfeaq+eCRYcv8787ZabvfP2mZnYaxmyPJYJGac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXC+BVcGcBoncxiIM6CtDxSbmpnaRpTugpC7cuQ6qf8707x405Vq98S9K1wYJK3yz
	 0Bgh+r/vdYS/egwVV2q/LaHfPHHzHgsdvx5eFGmRZ3UrZJzXxaQNuTdNTtpeiOQw17
	 yCnYMXUr2Q7TlmFNgJy/zFAyQ9gpDwfBQ5O5ZmCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0781/2857] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Wed, 18 Nov 2026 15:30:15 +0100
Message-ID: <20261118150229.689976747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 94b38c4fe5a88..a9cb7cedd6053 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7409,7 +7409,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



