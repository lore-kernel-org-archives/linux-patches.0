Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216447;
	b=BV0ZjHqMGrBidUT8foaRnhTgZKi+3ol8mTUXlMKWtf6ddtvoyXEAprcWFvaowouK6YdM
	 Ing0jNixL6xb0uSw25FKNQXbZI5FeOUTk+TwzImaQzVSpB+F8FDzjO4qeTM7H6b4nWDFl
	 TYIG+xwhrXTn8Qam6d3ncxFkaxyoT7VhxY+O1Udi5wQ8DyXEh058e6hLxfKhygx6s4Qq8
	 ugNGDtFB67K2kdrvNrGGIrjEGZuJI9rYu/N2TAIzIaVGTBO3hC17AWcvv3llAvfTk96JR
	 QDRmLi3DwZXvInNndC3HFSj681tXt3m4aH/EhSJaDegiWwpW63eoZyGKhQf+5RlRkFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrvUVpMSxvM3VK33APQrnJd5kokoEX/egQqBngLPvVQ=;
	b=b2l9azufdI085eeVPpCAmE/0Xaqc/J3XULb/rpgp2bfn2tHWeJE1W5s4JWyU1S4aslIV
	 azhJWLtO5idbX4lpGd9Z8EFxxwdHjfktRF+cVux0g5JyT+un/8dQGl+8mP8NPFqY9W2kJ
	 QRQcqc6BN996JZNzLwkMD7KG918+LxK0j78Zk3qR3fs7S5cSbmnXx8hCr9mwmCwOeFIgz
	 AkO5rsJ3HqHBJD/u6lGb4SHr4XTj5EnqEoINB/+uZgTNRV/+c4fvGBRg0ZEMTqY7rik+5
	 JC7KMH19tWgymfB9mcznMuwQAi7MmM2xJ2tgotMgVr7TUEr0yaDVA6pC3NuZrSwWYEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bySbOgBL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48FD606A335;
	Wed, 28 Oct 2026 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bySbOgBL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127471F01828;
	Wed, 28 Oct 2026 19:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216446;
	bh=LrvUVpMSxvM3VK33APQrnJd5kokoEX/egQqBngLPvVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bySbOgBLiUYu3O6phjBujCnAgIoOthfzkHc5SVVB4pHnLd0Lqcgr+mx+ao1GowUgG
	 R08oab8eUe7p3mQeDmWlr4Rr2PhH8OLQALo95YTy+7OByESTn6zMzlaFPetosstOLH
	 lg4O3gCaJxW148+hD+zOvtj3TKqcqKwp81Z/22qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1560/1887] fs: dlm: remove socket shutdown handling
Date: Wed, 28 Oct 2026 18:00:56 +0100
Message-ID: <20261028170534.963745622@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4f567acb0b8622fe265aac4b0037a03ef544ba24 ]

Since commit 489d8e559c65 ("fs: dlm: add reliable connection if
reconnect") we have functionality like TCP offers for half-closed
sockets on dlm application protocol layer. This feature is required
because the cluster manager events about leaving resource memberships
can be locally already occurred but other cluster nodes having a pending
leaving membership over the cluster manager protocol happening. In this
time the local dlm node already shutdown it's connection and don't
transmit anymore any new dlm messages, but however it still needs to be
able to accept dlm messages because the pending leave membership request
of the cluster manager protocol which the dlm kernel implementation has
no control about it.

We have this functionality on the application for two reasons, the main
reason is that SCTP does not support such functionality on socket
layer. But we can do it inside application layer.

Another small issue is that this feature is broken in the TCP world
because some NAT devices does not implement such functionality
correctly. This is the same reason why the reliable connection session
layer in DLM exists. We give up on middle devices in the networking
which sends e.g. TCP resets out. In DLM we cannot have any message
dropping and we ensure it over a session layer that it can't happen.

Back to the half-closed grace shutdown handling. It's not necessary
anymore to do it on socket layer (which is only support for TCP sockets)
because we do it on application layer. This patch removes this handling,
if there are still issues then we have a problem on the application
layer for such handling.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 33930840b5f0 ("sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 127 ++++++++--------------------------------------
 fs/dlm/lowcomms.h |   1 +
 fs/dlm/midcomms.c |   6 ++-
 3 files changed, 27 insertions(+), 107 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index cefc930c2e429..2151579094255 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -65,7 +65,6 @@
 
 /* Number of messages to send before rescheduling */
 #define MAX_SEND_MSG_COUNT 25
-#define DLM_SHUTDOWN_WAIT_TIMEOUT msecs_to_jiffies(10000)
 
 struct connection {
 	struct socket *sock;	/* NULL if not connected */
@@ -79,14 +78,11 @@ struct connection {
 #define CF_CLOSE 6
 #define CF_APP_LIMITED 7
 #define CF_CLOSING 8
-#define CF_SHUTDOWN 9
-#define CF_CONNECTED 10
-#define CF_RECONNECT 11
-#define CF_DELAY_CONNECT 12
-#define CF_EOF 13
+#define CF_CONNECTED 9
+#define CF_RECONNECT 10
+#define CF_DELAY_CONNECT 11
 	struct list_head writequeue;  /* List of outgoing writequeue_entries */
 	spinlock_t writequeue_lock;
-	atomic_t writequeue_cnt;
 	int retries;
 #define MAX_CONNECT_RETRIES 3
 	struct hlist_node list;
@@ -94,7 +90,6 @@ struct connection {
 	struct connection *sendcon;
 	struct work_struct rwork; /* Receive workqueue */
 	struct work_struct swork; /* Send workqueue */
-	wait_queue_head_t shutdown_wait; /* wait for graceful shutdown */
 	unsigned char *rx_buf;
 	int rx_buflen;
 	int rx_leftover;
@@ -157,10 +152,6 @@ struct dlm_proto_ops {
 	int (*listen_validate)(void);
 	void (*listen_sockopts)(struct socket *sock);
 	int (*listen_bind)(struct socket *sock);
-	/* What to do to shutdown */
-	void (*shutdown_action)(struct connection *con);
-	/* What to do to eof check */
-	bool (*eof_condition)(struct connection *con);
 };
 
 static struct listen_sock_callbacks {
@@ -244,11 +235,6 @@ static struct connection *__find_con(int nodeid, int r)
 	return NULL;
 }
 
-static bool tcp_eof_condition(struct connection *con)
-{
-	return atomic_read(&con->writequeue_cnt);
-}
-
 static int dlm_con_init(struct connection *con, int nodeid)
 {
 	con->rx_buflen = dlm_config.ci_buffer_size;
@@ -260,10 +246,8 @@ static int dlm_con_init(struct connection *con, int nodeid)
 	mutex_init(&con->sock_mutex);
 	INIT_LIST_HEAD(&con->writequeue);
 	spin_lock_init(&con->writequeue_lock);
-	atomic_set(&con->writequeue_cnt, 0);
 	INIT_WORK(&con->swork, process_send_sockets);
 	INIT_WORK(&con->rwork, process_recv_sockets);
-	init_waitqueue_head(&con->shutdown_wait);
 
 	return 0;
 }
@@ -774,7 +758,6 @@ static void free_entry(struct writequeue_entry *e)
 	}
 
 	list_del(&e->list);
-	atomic_dec(&e->con->writequeue_cnt);
 	kref_put(&e->ref, dlm_page_release);
 }
 
@@ -837,56 +820,10 @@ static void close_connection(struct connection *con, bool and_other,
 	clear_bit(CF_CONNECTED, &con->flags);
 	clear_bit(CF_DELAY_CONNECT, &con->flags);
 	clear_bit(CF_RECONNECT, &con->flags);
-	clear_bit(CF_EOF, &con->flags);
 	mutex_unlock(&con->sock_mutex);
 	clear_bit(CF_CLOSING, &con->flags);
 }
 
-static void shutdown_connection(struct connection *con)
-{
-	int ret;
-
-	flush_work(&con->swork);
-
-	mutex_lock(&con->sock_mutex);
-	/* nothing to shutdown */
-	if (!con->sock) {
-		mutex_unlock(&con->sock_mutex);
-		return;
-	}
-
-	set_bit(CF_SHUTDOWN, &con->flags);
-	ret = kernel_sock_shutdown(con->sock, SHUT_WR);
-	mutex_unlock(&con->sock_mutex);
-	if (ret) {
-		log_print("Connection %p failed to shutdown: %d will force close",
-			  con, ret);
-		goto force_close;
-	} else {
-		ret = wait_event_timeout(con->shutdown_wait,
-					 !test_bit(CF_SHUTDOWN, &con->flags),
-					 DLM_SHUTDOWN_WAIT_TIMEOUT);
-		if (ret == 0) {
-			log_print("Connection %p shutdown timed out, will force close",
-				  con);
-			goto force_close;
-		}
-	}
-
-	return;
-
-force_close:
-	clear_bit(CF_SHUTDOWN, &con->flags);
-	close_connection(con, false, true, true);
-}
-
-static void dlm_tcp_shutdown(struct connection *con)
-{
-	if (con->othercon)
-		shutdown_connection(con->othercon);
-	shutdown_connection(con);
-}
-
 static int con_realloc_receive_buf(struct connection *con, int newlen)
 {
 	unsigned char *newbuf;
@@ -978,19 +915,8 @@ static int receive_from_sock(struct connection *con)
 		log_print("connection %p got EOF from %d",
 			  con, con->nodeid);
 
-		if (dlm_proto_ops->eof_condition &&
-		    dlm_proto_ops->eof_condition(con)) {
-			set_bit(CF_EOF, &con->flags);
-			mutex_unlock(&con->sock_mutex);
-		} else {
-			mutex_unlock(&con->sock_mutex);
-			close_connection(con, false, true, false);
-
-			/* handling for tcp shutdown */
-			clear_bit(CF_SHUTDOWN, &con->flags);
-			wake_up(&con->shutdown_wait);
-		}
-
+		mutex_unlock(&con->sock_mutex);
+		close_connection(con, false, true, false);
 		/* signal to breaking receive worker */
 		ret = -1;
 	} else {
@@ -1253,7 +1179,6 @@ static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 	kref_get(&e->ref);
 	*ppc = page_address(e->page);
 	e->end += len;
-	atomic_inc(&con->writequeue_cnt);
 	if (cb)
 		cb(data);
 
@@ -1454,20 +1379,6 @@ static void send_to_sock(struct connection *con)
 	}
 	spin_unlock(&con->writequeue_lock);
 
-	/* close if we got EOF */
-	if (test_and_clear_bit(CF_EOF, &con->flags)) {
-		mutex_unlock(&con->sock_mutex);
-		close_connection(con, false, false, true);
-
-		/* handling for tcp shutdown */
-		clear_bit(CF_SHUTDOWN, &con->flags);
-		wake_up(&con->shutdown_wait);
-	} else {
-		mutex_unlock(&con->sock_mutex);
-	}
-
-	return;
-
 out:
 	mutex_unlock(&con->sock_mutex);
 	return;
@@ -1667,16 +1578,8 @@ static int work_start(void)
 	return 0;
 }
 
-static void shutdown_conn(struct connection *con)
-{
-	if (dlm_proto_ops->shutdown_action)
-		dlm_proto_ops->shutdown_action(con);
-}
-
 void dlm_lowcomms_shutdown(void)
 {
-	int idx;
-
 	restore_callbacks(listen_con.sock);
 
 	if (recv_workqueue)
@@ -1685,9 +1588,25 @@ void dlm_lowcomms_shutdown(void)
 		flush_workqueue(send_workqueue);
 
 	dlm_close_sock(&listen_con.sock);
+}
+
+void dlm_lowcomms_shutdown_node(int nodeid, bool force)
+{
+	struct connection *con;
+	int idx;
 
 	idx = srcu_read_lock(&connections_srcu);
-	foreach_conn(shutdown_conn);
+	con = nodeid2con(nodeid, 0);
+	if (WARN_ON_ONCE(!con)) {
+		srcu_read_unlock(&connections_srcu, idx);
+		return;
+	}
+
+	WARN_ON_ONCE(!force && !list_empty(&con->writequeue));
+	clean_one_writequeue(con);
+	if (con->othercon)
+		clean_one_writequeue(con->othercon);
+	close_connection(con, true, true, true);
 	srcu_read_unlock(&connections_srcu, idx);
 }
 
@@ -1899,8 +1818,6 @@ static const struct dlm_proto_ops dlm_tcp_ops = {
 	.listen_validate = dlm_tcp_listen_validate,
 	.listen_sockopts = dlm_tcp_listen_sockopts,
 	.listen_bind = dlm_tcp_listen_bind,
-	.shutdown_action = dlm_tcp_shutdown,
-	.eof_condition = tcp_eof_condition,
 };
 
 static int dlm_sctp_bind(struct socket *sock)
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index acaf1b0b3885b..3e8dca66183b8 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -34,6 +34,7 @@ bool dlm_lowcomms_is_running(void);
 
 int dlm_lowcomms_start(void);
 void dlm_lowcomms_shutdown(void);
+void dlm_lowcomms_shutdown_node(int nodeid, bool force);
 void dlm_lowcomms_stop(void);
 void dlm_lowcomms_init(void);
 void dlm_lowcomms_exit(void);
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 42d54196e766f..553cdb3780372 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1416,11 +1416,13 @@ static void midcomms_shutdown(struct midcomms_node *node)
 		pr_debug("active shutdown timed out for node %d with state %s\n",
 			 node->nodeid, dlm_state_str(node->state));
 		midcomms_node_reset(node);
+		dlm_lowcomms_shutdown_node(node->nodeid, true);
 		return;
 	}
 
 	pr_debug("active shutdown done for node %d with state %s\n",
 		 node->nodeid, dlm_state_str(node->state));
+	dlm_lowcomms_shutdown_node(node->nodeid, false);
 }
 
 void dlm_midcomms_shutdown(void)
@@ -1428,6 +1430,8 @@ void dlm_midcomms_shutdown(void)
 	struct midcomms_node *node;
 	int i, idx;
 
+	dlm_lowcomms_shutdown();
+
 	mutex_lock(&close_lock);
 	idx = srcu_read_lock(&nodes_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
@@ -1445,8 +1449,6 @@ void dlm_midcomms_shutdown(void)
 	}
 	srcu_read_unlock(&nodes_srcu, idx);
 	mutex_unlock(&close_lock);
-
-	dlm_lowcomms_shutdown();
 }
 
 int dlm_midcomms_close(int nodeid)
-- 
2.53.0



