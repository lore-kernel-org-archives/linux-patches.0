Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064008;
	b=Bn7dCiQcKwA+ylJrFkY0caIw4eDgHc+goGn4p1vD106mxkWow+kdpww/P8WQRKlSAyd8
	 I1vBSk3JcaD2r7jam0fkxarf4vR6x182wCnQDlFR1Jm2B9CW33/hJA80kjZfaoNQ8d7wT
	 9+JPF8Wxyzolp5wBtAwkkSyPmk5l4tA5X9T3qclGLdOATuSCp/O90x0eT6CSLeK9c59Ne
	 upwHYcQv/nlGBG3I9Ta58l+eR1UYx28DkQwOkIA2yZNvT0aPkYH+ucpNzv7tE0BLtKjTs
	 Ix3CK9vq8X+cwkGWfbpasD0RaL6664Wew/RQ+jEvMQwICLsuFWJDTn0i1F0NyRNCbmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mOLDRAF/40izTIIPbFszGTJQgiUnGs/0OIO/v/w7GA0=;
	b=lN/XyVtVMDOg1/gpCEHbVs1BYyRXyRg4vfcCR2bws39qpwXZayO4Ltzsr6hrP9Hner3K
	 CvoauJQP95eGgZQrBA593npcZJyqIawDGuOLU09DtDypsU8kKmvVUzfsHekMZC6JhJtpl
	 wvNtbC2ffe3Qpmgd6udEw5CX8ARJVRsn2ajCMy/1mhv6B9HmOcwUkKIpVS8yJ6IlNuzYE
	 Zs0B6kaGXqzbu3cuPmI7zrGAJJ5L2VVaX25DLQO0Tw2RqENLNrXkJir7SamdiG+bo4dCk
	 gxQVSJIfZLXMn5IIGewbHq7E6pcOCkTI2URoU84YajtIcc+nQ7dCAkWLmLchG/nvsqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zV0r4wnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C0A606EE9E;
	Sat,  7 Nov 2026 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zV0r4wnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08801F0089F;
	Sat,  7 Nov 2026 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064008;
	bh=mOLDRAF/40izTIIPbFszGTJQgiUnGs/0OIO/v/w7GA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zV0r4wnrFOQ4pIZxHHaWhx7X8Lief8d5F8WZzSSt1LkieeuQ8E3sM1Hw0eF+isVjm
	 BFyTNiHRKujOs3mRMMjhsDYHMgH4KQKmIZqRkaozuvNMyeX+LXYkeA69x9sJOo1m8X
	 l8n/DqPhJG4NZfuBqLS9Tvuj2uC6Tuptt4FKcVWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0187/1257] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Sat,  7 Nov 2026 08:41:23 -0500
Message-ID: <20261107134944.620898230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e5838bf516e38..bc5f4b048eeda 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7539,7 +7539,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



