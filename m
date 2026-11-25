Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619527;
	b=V2u4+u/chF6vozOTJX2XkwT4FuvMneav5RoxmOxgaqWM+mDBJtNM1falCOwXfIUkGM1p
	 iGAT/ZAV8588SMtWZBAAb39DxCLNnm7ewb9teCkIBOxVznKVQYXK2IEItwMScVlGp4lAj
	 RulTOxN9iH5Lt/aWBhBazyfIDsh4lBAet/UgdoyVzTRKzNFLb4Mi+HbPrp7l8SnxSUJxI
	 MvBJgtkAI0wOtomjyImTilZxosDCYFGI576Rzi0eKm9q0otxjb6lqIWgvQQaWbCMPPcRW
	 BxxktXUUJ6OpZc30QddDKN7fdbcA22B4RVwnutumWf1GILfikUx15MR18jhzccFZPXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHhNZVs4xwq50r0etVrOXR3rO58ISRxUDdC2nHpZL5E=;
	b=dEo2SR3lKec0To2zTLUFdacCqh1fZ/3GqsX9UQ5A10h8/llZZMswkgaucYszLwcVarFJ
	 EiLMBbDHprFocau8C/G8pTrY63A495Bp29IDR5E3p8DKwp9xZj7Ar9oDglzdxYgqc8cAV
	 vjb7hxByYiATEFY5K0PCY6XPM3+2lN4GwqQmGAXaGfMNFY0S3BDRI5CBojVpR5HrrxwDD
	 L+ojF223+hrROfn1CbI/F7jBQH/MfPJR7RjPXs8SuDuc7wbKz++3RkKYjK9RpCo3ZBNYo
	 jVzpPZ/ORT7KcwzLQrGmiNfk3RDCXFxcQaEVZ8POqdkbubRbaguNrci6B5cXO/HFVHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULx8TWwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036C1606A321;
	Wed, 25 Nov 2026 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULx8TWwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FF51F000C6;
	Wed, 25 Nov 2026 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619526;
	bh=BHhNZVs4xwq50r0etVrOXR3rO58ISRxUDdC2nHpZL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULx8TWwj4eaYQbR1vcggB5fETuP6WNOX40Rhpu7nUoP1uPcJEMDMJ7ncqRYxeE/dE
	 HtOwV9S73kO2hCThryYhHFceeRtv6UBLZWWn4OSCf7zvOS735jw/E0qBGpt6c6j9O/
	 Fyh01iJCIz4IL0cyuELiwzzwofDhSVQJiV2/btcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0625/1005] net/smc: fix link group ownership in handshake abort
Date: Wed, 25 Nov 2026 15:32:43 +0100
Message-ID: <20261125143836.388439853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mahanta Jambigi <mjambigi@linux.ibm.com>

commit e227b511582828c5a6513f70fc6a71211e5efbf0 upstream.

An aborted first-contact handshake can hang the handshake worker on the
socket lock it already holds, reset the clcsock of a socket that has
fallen back to TCP, or corrupt the alert-node lookup when the handshake
retries with the same connection.

The abort leaves a connection registered in a link group that another
context has already unlinked for termination: smc_conn_free() skips the
unregister when lgr->list is empty, so the alert token and alert node
stay in lgr->conns_all. If the handshake retries another device or SMC
version, smc_conn_create() creates a second link group and
smc_lgr_register_conn() inserts the same alert node into it: the token
loop is skipped, rb_link_node() links a node that is still in the old
tree into the new one, and a second sock_hold() is taken where only one
sock_put() will follow. The old group's terminator then keeps returning
that node from rb_first() and can kill a connection that now belongs to
the new group.

smc_lgr_cleanup_early() also starts a second termination of the link
group that is already being terminated, which takes lock_sock() on the
socket the handshake worker holds; if the termination work wins the race
instead, it later kills the freed connection and aborts the clcsock of a
socket that has fallen back to TCP. Making the unregister unconditional
also lets smc_conn_free() reach the delayed free work on a claimed link
group, where the lockless freeing check can arm it after the owner has
cancelled it.

Always unregister the connection, claim a link group for termination
once under lgr_lock, keep the link group alive across the abort, and arm
the delayed free work only under the same lock and cancel it
synchronously before the teardown. Drop an already freed connection in
smc_conn_kill() without running the connection and socket teardown.

Fixes: 2a0674fffb6b ("net/smc: improve abnormal termination of link groups")
Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early()")
Cc: stable@vger.kernel.org
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Link: https://patch.msgid.link/20261106130457.1092203-1-mjambigi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c   |   11 ++++---
 net/smc/smc_core.c |   78 ++++++++++++++++++++++++++++++++++++++---------------
 net/smc/smc_core.h |    6 ++--
 3 files changed, 65 insertions(+), 30 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1009,14 +1009,15 @@ static void smc_conn_abort(struct smc_so
 {
 	struct smc_connection *conn = &smc->conn;
 	struct smc_link_group *lgr = conn->lgr;
-	bool lgr_valid = false;
-
-	if (smc_conn_lgr_valid(conn))
-		lgr_valid = true;
+	bool lgr_valid = local_first && smc_conn_lgr_valid(conn);
 
+	if (lgr_valid)
+		smc_lgr_hold(lgr);	/* lgr_put below */
 	smc_conn_free(conn);
-	if (local_first && lgr_valid)
+	if (lgr_valid) {
 		smc_lgr_cleanup_early(lgr);
+		smc_lgr_put(lgr);
+	}
 }
 
 /* check if there is a rdma device available for this connection. */
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -80,16 +80,21 @@ static void smc_ibdev_cnt_dec(struct smc
 
 static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
 {
+	spinlock_t *lgr_lock;
+
 	/* client link group creation always follows the server link group
 	 * creation. For client use a somewhat higher removal delay time,
 	 * otherwise there is a risk of out-of-sync link groups.
 	 */
+	smc_lgr_list_head(lgr, &lgr_lock);
+	spin_lock_bh(lgr_lock);
 	if (!lgr->freeing) {
 		mod_delayed_work(system_percpu_wq, &lgr->free_work,
 				 (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
 						SMC_LGR_FREE_DELAY_CLNT :
 						SMC_LGR_FREE_DELAY_SERV);
 	}
+	spin_unlock_bh(lgr_lock);
 }
 
 /* Register connection's alert token in our lookup structure.
@@ -679,19 +684,34 @@ int smcd_nl_get_lgr(struct sk_buff *skb,
 	return skb->len;
 }
 
-void smc_lgr_cleanup_early(struct smc_link_group *lgr)
+/* Claim a link group for termination. Only one context can succeed: the
+ * lgr is removed from its list and marked freeing under lgr_lock.
+ * Returns false if @lgr is NULL or another context owns it.
+ */
+static bool smc_lgr_claim(struct smc_link_group *lgr)
 {
 	spinlock_t *lgr_lock;
 
 	if (!lgr)
-		return;
-
+		return false;
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
+	if (lgr->freeing || lgr->terminating || list_empty(&lgr->list)) {
+		spin_unlock_bh(lgr_lock);
+		return false;
+	}
 	/* do not use this link group for new connections */
-	if (!list_empty(&lgr->list))
-		list_del_init(&lgr->list);
+	list_del_init(&lgr->list);
+	lgr->freeing = 1;
 	spin_unlock_bh(lgr_lock);
+	return true;
+}
+
+/* The caller must keep @lgr alive for the duration of the call. */
+void smc_lgr_cleanup_early(struct smc_link_group *lgr)
+{
+	if (!smc_lgr_claim(lgr))
+		return;	/* another context owns the termination */
 	__smc_lgr_terminate(lgr, true);
 }
 
@@ -1279,10 +1299,12 @@ void smc_conn_free(struct smc_connection
 		if (current_work() != &conn->abort_work)
 			cancel_work_sync(&conn->abort_work);
 	}
-	if (!list_empty(&lgr->list)) {
+	/* The handshake can retry another device or SMC version with this
+	 * connection, so it must never stay registered in an lgr it left.
+	 */
+	if (!list_empty(&lgr->list))
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
-		smc_lgr_unregister_conn(conn);
-	}
+	smc_lgr_unregister_conn(conn);
 
 	if (!lgr->conns_num)
 		smc_lgr_schedule_free_work(lgr);
@@ -1517,6 +1539,15 @@ static void smc_conn_kill(struct smc_con
 {
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
+	if (conn->freed) {
+		/* The connection was already freed, e.g. by a close or
+		 * a handshake that fell back to TCP. Do not abort a socket
+		 * that is no longer part of this link group.
+		 */
+		smc_lgr_unregister_conn(conn);
+		return;
+	}
+
 	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
 	else
@@ -1564,12 +1595,20 @@ static void __smc_lgr_terminate(struct s
 	struct smc_connection *conn;
 	struct smc_sock *smc;
 	struct rb_node *node;
+	spinlock_t *lgr_lock;
 
-	if (lgr->terminating)
+	smc_lgr_list_head(lgr, &lgr_lock);
+	spin_lock_bh(lgr_lock);
+	if (lgr->terminating) {
+		spin_unlock_bh(lgr_lock);
 		return;	/* lgr already terminating */
-	/* cancel free_work sync, will terminate when lgr->freeing is set */
-	cancel_delayed_work(&lgr->free_work);
+	}
 	lgr->terminating = 1;
+	spin_unlock_bh(lgr_lock);
+	/* The lgr is claimed, so no new free_work can be armed; wait for
+	 * one that is already queued or running.
+	 */
+	cancel_delayed_work_sync(&lgr->free_work);
 
 	/* kill remaining link group connections */
 	read_lock_bh(&lgr->conns_lock);
@@ -1580,7 +1619,11 @@ static void __smc_lgr_terminate(struct s
 		sock_hold(&smc->sk); /* sock_put below */
 		read_unlock_bh(&lgr->conns_lock);
 		lock_sock(&smc->sk);
-		smc_conn_kill(conn, soft);
+		/* The connection may have been re-registered in another
+		 * link group by a retried handshake in the meantime.
+		 */
+		if (conn->lgr == lgr)
+			smc_conn_kill(conn, soft);
 		release_sock(&smc->sk);
 		sock_put(&smc->sk); /* sock_hold above */
 		read_lock_bh(&lgr->conns_lock);
@@ -1594,17 +1637,8 @@ static void __smc_lgr_terminate(struct s
 /* unlink link group and schedule termination */
 void smc_lgr_terminate_sched(struct smc_link_group *lgr)
 {
-	spinlock_t *lgr_lock;
-
-	smc_lgr_list_head(lgr, &lgr_lock);
-	spin_lock_bh(lgr_lock);
-	if (list_empty(&lgr->list) || lgr->terminating || lgr->freeing) {
-		spin_unlock_bh(lgr_lock);
+	if (!smc_lgr_claim(lgr))
 		return;	/* lgr already terminating */
-	}
-	list_del_init(&lgr->list);
-	lgr->freeing = 1;
-	spin_unlock_bh(lgr_lock);
 	schedule_work(&lgr->terminate_work);
 }
 
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -301,9 +301,9 @@ struct smc_link_group {
 	struct delayed_work	free_work;	/* delayed freeing of an lgr */
 	struct work_struct	terminate_work;	/* abnormal lgr termination */
 	struct workqueue_struct	*tx_wq;		/* wq for conn. tx workers */
-	u8			sync_err : 1;	/* lgr no longer fits to peer */
-	u8			terminating : 1;/* lgr is terminating */
-	u8			freeing : 1;	/* lgr is being freed */
+	u8			sync_err;	/* lgr no longer fits to peer */
+	u8			terminating;	/* lgr is terminating */
+	u8			freeing;	/* lgr is being freed */
 
 	refcount_t		refcnt;		/* lgr reference count */
 	bool			is_smcd;	/* SMC-R or SMC-D */


