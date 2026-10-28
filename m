Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216455;
	b=1h84R3L4/6F8gc0eZaWvPZqDiCZClSo6goncLe8v5Vr5brpznKnTFC3zRBWUw6gFqhSJ
	 3AewcFVGKHOMnydiYsZ4OVVMjSNrmp8xtbGLD+2pjajEtXL0hYja6JIHqZj7Mqe4WXxar
	 2d7pue/e5PfnULEjtv34eEhlx/cjEGt/4VRBLaNu/2J6s6rBAvRXl7n5MtNpxRpHCCDAO
	 DmW7iXkjBuDI+XaRfMlPE1SJ53mVFqsdFtTSrjmZr0ynAl4X580NV8gy1un7q9NTseGSh
	 DZPIriyTU2V4QU6Emn+CSyjY0OPlsTgFWMoKnfS/QWbCT8ikcB3Q+57W5GytTW+wypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T1mR2/QmZld1b//D3rSdQLXi0kP65d1KjbXmfijYY+U=;
	b=uhkq5HSQkc3Fhh3vyzwviLc2IRh1p0AAu8ptjejo+uE1kIt/MtD+UJcXvFiir6d8D15r
	 hs78nst5pYaddBRz1Hmce8Z1qNc0hJpNWGKesb6/KpKuice2vLfUsRfZL3cG9je7ZzkoK
	 o7JOTKG2iwHV+nww8Ha+TfB+Xgp46CBu7jzz+5nRJ3IEHaifdrUYAos4cER/NbWeD+5Gv
	 +wmQQzLqbrMcO9iSD7LK4aHPqbKK2RjImTGHjdgUypBYGjLqw7Uuy5qk2VeouwdD6tYJn
	 pQrb3xxytba7Rv3cWxZ3E414hHrX8xk0DqbEdPOxVNICvKJ+hRFuEj8onwFXRx+vnKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2p1yF+PE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F6606A326;
	Wed, 28 Oct 2026 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2p1yF+PE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B2D1F01825;
	Wed, 28 Oct 2026 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216455;
	bh=T1mR2/QmZld1b//D3rSdQLXi0kP65d1KjbXmfijYY+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2p1yF+PEGdjT7Onw4pDLpZcBGGwuLsRQUSySlmVZkLDBXlyTHuzLxpvy/xaAlU138
	 FUsXkKpyX0DDpDAafgVtiLDdlTea53GVsa0Kg4Rx28dC8xzBPCpTAHvkMf+aUP58jF
	 H9QZmaYyyRNgJH/z5G+eyGb8SOQ7wCohu7etk5AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Valentina Manea <valentina.manea.m@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Steve French <sfrench@samba.org>,
	Christine Caulfield <ccaulfie@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Guillaume Nault <gnault@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1563/1887] Treewide: Stop corrupting sockets task_frag
Date: Wed, 28 Oct 2026 18:00:59 +0100
Message-ID: <20261028170535.032741387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 98123866fcf3fe95a0c1b198ef122dfdbd351916 ]

Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
GFP_NOIO flag on sk_allocation which the networking system uses to decide
when it is safe to use current->task_frag.  The results of this are
unexpected corruption in task_frag when SUNRPC is involved in memory
reclaim.

The corruption can be seen in crashes, but the root cause is often
difficult to ascertain as a crashing machine's stack trace will have no
evidence of being near NFS or SUNRPC code.  I believe this problem to
be much more pervasive than reports to the community may indicate.

Fix this by having kernel users of sockets that may corrupt task_frag due
to reclaim set sk_use_task_frag = false.  Preemptively correcting this
situation for users that still set sk_allocation allows them to convert to
memalloc_nofs_save/restore without the same unexpected corruptions that are
sure to follow, unlikely to show up in testing, and difficult to bisect.

CC: Philipp Reisner <philipp.reisner@linbit.com>
CC: Lars Ellenberg <lars.ellenberg@linbit.com>
CC: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Josef Bacik <josef@toxicpanda.com>
CC: Keith Busch <kbusch@kernel.org>
CC: Christoph Hellwig <hch@lst.de>
CC: Sagi Grimberg <sagi@grimberg.me>
CC: Lee Duncan <lduncan@suse.com>
CC: Chris Leech <cleech@redhat.com>
CC: Mike Christie <michael.christie@oracle.com>
CC: "James E.J. Bottomley" <jejb@linux.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Valentina Manea <valentina.manea.m@gmail.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Howells <dhowells@redhat.com>
CC: Marc Dionne <marc.dionne@auristor.com>
CC: Steve French <sfrench@samba.org>
CC: Christine Caulfield <ccaulfie@redhat.com>
CC: David Teigland <teigland@redhat.com>
CC: Mark Fasheh <mark@fasheh.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Latchesar Ionkov <lucho@ionkov.net>
CC: Dominique Martinet <asmadeus@codewreck.org>
CC: Ilya Dryomov <idryomov@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>
CC: Chuck Lever <chuck.lever@oracle.com>
CC: Jeff Layton <jlayton@kernel.org>
CC: Trond Myklebust <trond.myklebust@hammerspace.com>
CC: Anna Schumaker <anna@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 33930840b5f0 ("sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 3 +++
 drivers/block/nbd.c                | 1 +
 drivers/nvme/host/tcp.c            | 1 +
 drivers/scsi/iscsi_tcp.c           | 1 +
 drivers/usb/usbip/usbip_common.c   | 1 +
 fs/dlm/lowcomms.c                  | 2 ++
 fs/ocfs2/cluster/tcp.c             | 1 +
 fs/smb/client/connect.c            | 1 +
 net/9p/trans_fd.c                  | 1 +
 net/ceph/messenger.c               | 1 +
 net/sunrpc/xprtsock.c              | 3 +++
 net/xfrm/espintcp.c                | 1 +
 12 files changed, 17 insertions(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 309d7bb028db2..c3dee6265ca31 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1030,6 +1030,9 @@ static int conn_connect(struct drbd_connection *connection)
 	sock.socket->sk->sk_allocation = GFP_NOIO;
 	msock.socket->sk->sk_allocation = GFP_NOIO;
 
+	sock.socket->sk->sk_use_task_frag = false;
+	msock.socket->sk->sk_use_task_frag = false;
+
 	sock.socket->sk->sk_priority = TC_PRIO_INTERACTIVE_BULK;
 	msock.socket->sk->sk_priority = TC_PRIO_INTERACTIVE;
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 008534aad0a18..26971f58c684c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -520,6 +520,7 @@ static int __sock_xmit(struct nbd_device *nbd, struct socket *sock, int send,
 	noreclaim_flag = memalloc_noreclaim_save();
 	do {
 		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
+		sock->sk->sk_use_task_frag = false;
 		msg.msg_flags = msg_flags | MSG_NOSIGNAL;
 
 		if (send)
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 19aed2125a18b..996940c972cd1 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1655,6 +1655,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 	queue->sock->sk->sk_rcvtimeo = 10 * HZ;
 
 	queue->sock->sk->sk_allocation = GFP_ATOMIC;
+	queue->sock->sk->sk_use_task_frag = false;
 	nvme_tcp_set_queue_io_cpu(queue);
 	queue->request = NULL;
 	queue->data_remaining = 0;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 56ade46309707..050a0ca92bc07 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -742,6 +742,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_reuse = SK_CAN_REUSE;
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
+	sk->sk_use_task_frag = false;
 	sk_set_memalloc(sk);
 	sock_no_linger(sk);
 
diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index d6dbd038af67b..ba9e7c616e129 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -315,6 +315,7 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 
 	do {
 		sock->sk->sk_allocation = GFP_NOIO;
+		sock->sk->sk_use_task_frag = false;
 
 		result = sock_recvmsg(sock, &msg, MSG_WAITALL);
 		if (result <= 0)
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 3248fc147442f..4ad492d035dd1 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -677,6 +677,7 @@ static void add_sock(struct socket *sock, struct connection *con)
 	sk->sk_write_space = lowcomms_write_space;
 	sk->sk_state_change = lowcomms_state_change;
 	sk->sk_allocation = GFP_NOFS;
+	sk->sk_use_task_frag = false;
 	sk->sk_error_report = lowcomms_error_report;
 	release_sock(sk);
 }
@@ -1705,6 +1706,7 @@ static int dlm_listen_for_all(void)
 	listen_con.sock = sock;
 
 	sock->sk->sk_allocation = GFP_NOFS;
+	sock->sk->sk_use_task_frag = false;
 	sock->sk->sk_data_ready = lowcomms_listen_data_ready;
 	release_sock(sock->sk);
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 0f6c2e3e79258..20396e1aacd25 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1604,6 +1604,7 @@ static void o2net_start_connect(struct work_struct *work)
 	sc->sc_sock = sock; /* freed by sc_kref_release */
 
 	sock->sk->sk_allocation = GFP_ATOMIC;
+	sock->sk->sk_use_task_frag = false;
 
 	myaddr.sin_family = AF_INET;
 	myaddr.sin_addr.s_addr = mynode->nd_ipv4_address;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index fd74814bdc84a..cb1bf349411d8 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3115,6 +3115,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "Socket created\n");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
+		socket->sk->sk_use_task_frag = false;
 		if (sfamily == AF_INET6)
 			cifs_reclassify_socket6(socket);
 		else
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 1c42360ff3e67..ed7e96c40948b 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -875,6 +875,7 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
+	csocket->sk->sk_use_task_frag = false;
 	file = sock_alloc_file(csocket, 0, NULL);
 	if (IS_ERR(file)) {
 		pr_err("%s (%d): failed to map fd\n",
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index db2794d50bdb9..3009df467c8dd 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -446,6 +446,7 @@ int ceph_tcp_connect(struct ceph_connection *con)
 	if (ret)
 		return ret;
 	sock->sk->sk_allocation = GFP_NOFS;
+	sock->sk->sk_use_task_frag = false;
 
 #ifdef CONFIG_LOCKDEP
 	lockdep_set_class(&sock->sk->sk_lock, &socket_class);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 74689050038a2..5315872f6a9c8 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1889,6 +1889,7 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_write_space = xs_udp_write_space;
 		sk->sk_state_change = xs_local_state_change;
 		sk->sk_error_report = xs_error_report;
+		sk->sk_use_task_frag = false;
 
 		xprt_clear_connected(xprt);
 
@@ -2089,6 +2090,7 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
+		sk->sk_use_task_frag = false;
 
 		xprt_set_connected(xprt);
 
@@ -2257,6 +2259,7 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
 		sk->sk_error_report = xs_error_report;
+		sk->sk_use_task_frag = false;
 
 		/* socket options */
 		sock_reset_flag(sk, SOCK_LINGER);
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index b98fa2887c864..a35a170c39201 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -491,6 +491,7 @@ static int espintcp_init_sk(struct sock *sk)
 
 	/* avoid using task_frag */
 	sk->sk_allocation = GFP_ATOMIC;
+	sk->sk_use_task_frag = false;
 
 	return 0;
 
-- 
2.53.0



