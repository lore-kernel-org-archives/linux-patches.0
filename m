Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042255;
	b=5TWY4tAgx34jvIHPVi6v9nudpK1c4a1BHj11Oen4f8StpNVIORCr+Ybuoi0DFH986aED
	 B64T9ZWNbSCLnMmLAIfRlJnZd/Qc9wJOkotvsUQ7Rz/EG710slaBbds/isZqJGpd34P/u
	 UsBQlYOFExGYZU/z6BFuTTgOZnE+QkLRJk/eeZHgA0Qt/6KzlHZfS20jPl9DeqI5wrOlH
	 ImP+UNs6trkNkypvE0PAyxHRCUSZm7dgf1rsu5HDcX74JBRDpjRHOrctCKhEoXh8vh3vP
	 VpurpH0UvgIqnXc31i6nO4zYW3KVHvVFkLZpSUfnq/+Q+UdrUY19c55WvqxiMegCmZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqvcrzzrBPICY01uF2I+Vk/x+5UbeqeZgHqt/Xr34R0=;
	b=gKS3r1bdQFblZF7PuwwSEyUtDSvay4aciapm7b+ip0r79XPg6nj+QzeFgRiEH+WTLEel
	 g56BmjcPuxYUNa4pwN1zfeOnRHYpb/vEfGFs9wNHX1uRZzKmrla3qOuJwyK9sR5c3lkEI
	 eqpW//nq4nM0I6dFXOzElO667srFOoYIkm9dzE+GPiHHnM9UFZ3Xqg0HfIB+TlLjh+zI4
	 7PfdQ2araDyGQqRD+W3D3InTThTFeT6G7UE4BGdSemyiMpt47+/FWskbaQ1SxpMarQzSL
	 0Q2zxwSp4xYZsao2++BspxhUUVk8r0FLvj5TRsWP83UmI9ojqmOYRPQ80sKD4zqBvXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q3wxNeu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02BC606A320;
	Wed, 18 Nov 2026 22:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q3wxNeu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A7A1F000C4;
	Wed, 18 Nov 2026 22:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042254;
	bh=jqvcrzzrBPICY01uF2I+Vk/x+5UbeqeZgHqt/Xr34R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3wxNeu7Wb+fU4/we7dKDXAhCvNLmbgyebjMoNa+aYDTtzTIymBrQn4Sa7HZaFe3Q
	 kOUSHoYWE2tZkurZ79NhEo9+5R0Qw17vXmf1704EScCdXAnYpl7HnHv6z5dU2NWzBr
	 Gg2IPSRmlmRojwtqzn6br52UNxYP61O1zY1pNpTs=
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
Subject: [PATCH 6.6 3104/3318] ocfs2: initialize status waiters before publishing them
Date: Wed, 18 Nov 2026 16:02:06 +0100
Message-ID: <20261118150453.113892528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5535fb8412433..0a325e2fae7d5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -301,6 +301,11 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
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
@@ -311,9 +316,6 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 	if (ret < 0)
 		return ret;
 
-	init_waitqueue_head(&nsw->ns_wq);
-	nsw->ns_sys_status = O2NET_ERR_NONE;
-	nsw->ns_status = 0;
 	return 0;
 }
 
-- 
2.53.0



