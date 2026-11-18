Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061970;
	b=4SbKNJBDoWUPOc6fL3RBMeoJhSMq/YOQcR6p8bd3J/wEnPM3Ai+sHc75eO9VvmxbOmCn
	 3a3SjMxoe9hX0gTvoja8NCtOx0KRQl1rBcQ5haE0Fbq1FHN6brAHV76FDsohDNylxwBKy
	 ++jhqbKHVy0ZSieeQrn3ZMU60oPg+PUIcDd3fGn9VUIN1pteghlxz5J88awn7ZOE+xm1F
	 9MhY5MumoTu2UC9M0WQkyGcPvvDRlz3K5jXN78QeDFa+tNQI5iHJNyiXbdDJSj2rs0Sui
	 8FKiYH+CAe3ZtkiD2tSf87tmAJfVJyT7E9m25kOaQswDf1C1eC6ttY7fxZ61RpQkcMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4i6/6d6ksX7rSWeF7r7W3bvJ/hqpb6iV4AaXOMjhQx8=;
	b=z9wwpg+EkL7IP1FxIljasObehJ7h2usxnN+KwcWHnnW7IyPzfTN4AEp0y7pMWuPm/knl
	 ZPJ+/GKtOIWI5x6eRLR+jeU55bpaQqAIHzNZlLY9z0YG3BqqRk0ebAyZFuronvrjGQpaH
	 qUjp2TvnfJQVe0ECkRsNFsA/HEdCMKNAmMKazqHxl1deyv+X7WXfm7/WtpL4/+1lh2BlU
	 wRwwBjXwRwy0SjEos7GhS4Z6RZfkFSzlKsbuHPXFq2y6775xWsTGPhHBz/aFCsguL0QnJ
	 N08vK78T1cmdg7YQ4CiR17plajVACWYFhmk29krZiNobedYdOOuen2V0obZjwLC6KuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxp8Tmmh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32233606A320;
	Thu, 19 Nov 2026 04:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxp8Tmmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8601B1F000C4;
	Thu, 19 Nov 2026 04:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061970;
	bh=4i6/6d6ksX7rSWeF7r7W3bvJ/hqpb6iV4AaXOMjhQx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxp8TmmhrHfh/ZYzNgaV00UKKlae6YHvitLmO52cHpHPhfrQgtTdULKcxsEwjpfbz
	 W7PftkpoUdKRWRxTpiTunje06tWGwTauVmyo1BMm5uyX6Z2XvsEWOmtUAfhNQ4/TNU
	 VCbOGbucIF+V9/6yFggiccoxGuG6EzV+P9p3wzME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1744/1848] ocfs2: initialize status waiters before publishing them
Date: Wed, 18 Nov 2026 16:03:02 +0100
Message-ID: <20261118150032.527728841@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit f6bfa6c458288d72948af95391b205f3eb775721 ]

o2net_prep_nsw() publishes its stack waiter in nn_status_idr and
nn_status_list under nn_lock, then initializes the wait queue and
completion status after releasing the lock.  A concurrent disconnect can
find that waiter through o2net_complete_nodes_nsw() and call wake_up()
before the wait queue has a valid lock and list head.  The sender can also
overwrite a completion status with its initial value.

Initialize the wait queue and status before publishing the waiter.
nn_lock then orders publication against completion, and no reader can
observe a partially initialized object.  Leave the IDR allocation and its
failure handling unchanged.

A controlled case-modified test kernel used a synthetic connection to
enter the real send path and overlap publication with disconnect.  The
candidate completion and wake-up code were unchanged.  Its Oops includes:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:__wake_up_common+0xa0/0x1f0
  Call Trace:
   <TASK>
   __wake_up+0x36/0x60
   o2net_complete_nsw_locked+0x222/0x370
   o2net_set_nn_state+0x917/0xea0
   o2net_disconnect_node+0xd0/0x190
   o2net_validate_control_write+0x454/0x500
   full_proxy_write+0x11f/0x180
   vfs_write+0x25a/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0066-v1-437a0422801b292a2879@gmail.com
Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index e02b32e91b048..1a61c2b6dc046 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -295,6 +295,11 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 {
 	int ret;
 
+	/* Initialize all completion-visible state before publishing the waiter. */
+	init_waitqueue_head(&nsw->ns_wq);
+	nsw->ns_sys_status = O2NET_ERR_NONE;
+	nsw->ns_status = 0;
+
 	spin_lock(&nn->nn_lock);
 	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
 	if (ret >= 0) {
@@ -305,9 +310,6 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 	if (ret < 0)
 		return ret;
 
-	init_waitqueue_head(&nsw->ns_wq);
-	nsw->ns_sys_status = O2NET_ERR_NONE;
-	nsw->ns_status = 0;
 	return 0;
 }
 
-- 
2.53.0



