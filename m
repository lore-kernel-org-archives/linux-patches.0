Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829748;
	b=GEzZE3QNyxFTExRiGseDaONmTeqzjQqPqR68dOL2CN0XAMmERK7b3N/cqnszmDQ+mdPY
	 7L2dxfPkEX6LKSpQj2HbVVRRZ7ltbhR8YPX6QE8vRx8nsVKt94volR+eczD+An78k0x5R
	 adhPRgEppMyGeYFpoM7yEDwqn0edbjY976n6tn4CH/YM96UFD5ZGmyCCesJXHy+5hrtQm
	 J60XQsWP8umuo+NL9LrhgABO9xx2eAFKA5Z/YITR23qbxEZDcRGsvtiWKv6iRB3pSkAe3
	 WLfzEt3wmIoVtO/gK6seW8HNexrSPplBe/hFh3N5raEYvMLUp7Ye8mJEURYvzKxv2kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=c30PaNa26GBrobCQwqfgjZ2hGrgsY1CfC28KpmhsNao=;
	b=RiWB0uFSR/mlwD9/GoQrGEFBOEWW8PqLW7MrpBNeFNpOTRB2UiCsPc+65GkKGqTpUcU5
	 WMETEUT5efmuNdgsaZQOx46AqvT7qIRljsfFlGojR9xjRTT/qZ/9Xvks84rSwEZAnH2UI
	 SnzN7eiPWwHwXpHOg4FMRWW4AhndXSYfy249FTRFp9knBJhG4hrtsOHtbd9HHj7KIzJnl
	 SrBtB9HkAW1ShyXPsB1lCvnD9llghLsH8DAiVLZIsjZj3rU6Igs6RHIbWuj1JCxs+BkH8
	 WZeY7Dlrkl+qSqZcNwCRV5FqEhV/GSFvBldaXQ9On9jjyetlF7PjEP8KnzOysEUJzNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J32YnNl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C7F606BA25;
	Wed,  4 Nov 2026 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J32YnNl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9235C1F00A22;
	Wed,  4 Nov 2026 22:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829747;
	bh=c30PaNa26GBrobCQwqfgjZ2hGrgsY1CfC28KpmhsNao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J32YnNl0t04HryL6U/LREfZflB6AjqJqPtBj27b1EQotpIZj+01BqWr2HiQ3Z3fdJ
	 4z06H2FBA7bUtL8sdYjmjKxVWIOW/xuddgtuN1Ak9J2diGXSzJ3AP6V3Tw4mE0NN2E
	 KnJKGp6wMcVeDHQYAkTNhRuvQEi8QQssfecAtTCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0319/1005] net/rds: hold the socket while an rds_mr references it
Date: Wed,  4 Nov 2026 16:00:52 -0500
Message-ID: <20261104211052.880204571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 9079adef042c1e7a6141dcdfd3041acd30607297 ]

Each rds_mr stores a bare back pointer to the socket that created it
(mr->r_sock) but takes no reference on it.  When the mr is destroyed it
references the rs. Hence, provisions must be made to avoid the rs
being destroyed before all mrs referencing it have been destroyed.

The MR itself is refcounted, and in-flight messages legitimately hold
MR krefs that can outlive the socket: rds_release() drops the rb-tree
references via rds_rdma_drop_keys(), but a send completion arriving
afterwards drops the final message reference from the CQ handler and
ends up in

  rds_message_purge()
    __rds_put_mr_final()
      rds_destroy_mr()   -> takes rs->rs_rdma_lock

dereferencing a socket that may already have been freed.

Oracle UEK fixed the same use-after-free ("rds: Add proper refcnt when
an RDS MR references an RDS Socket") after seeing crashes of the form:

  PF: supervisor write access in kernel mode
  _raw_spin_lock_irqsave+0x4a/0x6a
  __rds_put_mr_final+0x2c/0xe0 [rds]
  rds_message_purge+0x13c/0x150 [rds]
  rds_message_put+0x39/0x54 [rds]
  rds_ib_send_cqe_handler+0x147/0x3dd [rds_rdma]

To fix this, take a socket reference when an MR is created and drop it
when the final MR kref goes away.  The reference cycle is broken by
rds_release(), which always runs rds_rdma_drop_keys() on close.  So the
socket reference held by an MR never prevents release, it only delays
sk_free() until the last MR user is done.

The hold sits next to kref_init() at both allocation sites -
__rds_rdma_map() and the on-demand-paging path in
rds_cmsg_rdma_args() - so every MR owns exactly one socket reference
from the moment it becomes kref-managed.  For that to work on the ODP
path, its get_mr() error handling is converted from a bare kfree() to
kref_put(..., __rds_put_mr_final), with r_trans_private cleared first
since it holds an ERR_PTR there; both sites then tear down through
the same path and a future error-path change cannot silently leak or
double-drop the reference.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: port to net-next (sock_hold/sock_put in place of the UEK
 rds_sock_addref/rds_sock_put helpers); also balance the reference on
 the rds_cmsg_rdma_args() ODP path and unify its error path with
 __rds_put_mr_final(); update commit message]
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-3-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/rdma.c | 14 +++++++++++++-
 net/rds/rds.h  |  5 ++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 37695056756be..062c12d9318e9 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -117,6 +117,7 @@ void __rds_put_mr_final(struct kref *kref)
 	struct rds_mr *mr = container_of(kref, struct rds_mr, r_kref);
 
 	rds_destroy_mr(mr);
+	sock_put(rds_rs_to_sk(mr->r_sock));
 	kfree(mr);
 }
 
@@ -243,7 +244,11 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 	kref_init(&mr->r_kref);
 	RB_CLEAR_NODE(&mr->r_rb_node);
 	mr->r_trans = rs->rs_transport;
+	/* The MR can outlive its socket: a socket reference is held
+	 * until the final kref is dropped in __rds_put_mr_final().
+	 */
 	mr->r_sock = rs;
+	sock_hold(rds_rs_to_sk(rs));
 
 	if (args->flags & RDS_RDMA_USE_ONCE)
 		mr->r_use_once = 1;
@@ -762,7 +767,12 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 			RB_CLEAR_NODE(&local_odp_mr->r_rb_node);
 			kref_init(&local_odp_mr->r_kref);
 			local_odp_mr->r_trans = rs->rs_transport;
+			/* The MR can outlive its socket: a socket
+			 * reference is held until the final kref is
+			 * dropped in __rds_put_mr_final().
+			 */
 			local_odp_mr->r_sock = rs;
+			sock_hold(rds_rs_to_sk(rs));
 			local_odp_mr->r_trans_private =
 				rs->rs_transport->get_mr(
 					NULL, 0, rs, &local_odp_mr->r_key, NULL,
@@ -771,7 +781,9 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 				ret = PTR_ERR(local_odp_mr->r_trans_private);
 				rdsdebug("get_mr ret %d %p\"", ret,
 					 local_odp_mr->r_trans_private);
-				kfree(local_odp_mr);
+				local_odp_mr->r_trans_private = NULL;
+				kref_put(&local_odp_mr->r_kref,
+					 __rds_put_mr_final);
 				ret = -EOPNOTSUPP;
 				goto out_pages;
 			}
diff --git a/net/rds/rds.h b/net/rds/rds.h
index a4816da162930..dcbc4610735d5 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -299,7 +299,10 @@ struct rds_mr {
 	unsigned int		r_invalidate:1;
 	unsigned int		r_write:1;
 
-	struct rds_sock		*r_sock; /* back pointer to the socket that owns us */
+	struct rds_sock		*r_sock; /* socket that owns us; counted
+					  * reference, dropped by
+					  * __rds_put_mr_final()
+					  */
 	struct rds_transport	*r_trans;
 	void			*r_trans_private;
 };
-- 
2.53.0



