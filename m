Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037277;
	b=HyKHpv/ipj2XS11Wjps94Zik7iZ58WXUYR4SDoBZa9IyGY0xUNrmuWH9iQULWe+AHBwT
	 QAlSqfCb2QTZh4ObbI45xp73pmSYjtH6S40v2bd+bXF74y7SnYongtUA4I9EKS3gcef19
	 S4eFYYoSETk7GRlpCM6oa4y90vJ6ua1UB18tOTQ+SYLGMOZRl/VUjgEdadyen9OIZu247
	 y9aQxW9hROTAhISiaOj3U8X0l8+ykeQAZ7q0SLohTOWNYjzE/Pt1R3KEypphs/sP7gudW
	 iUERjbzMTWBN1/2p/mHwuTEHQOQ1sjqQU6hGh9CuYcR2aA5EveWPaqy0W1UtmFOKphA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WJd23hyUKmw8s4Z7+7YZz3ZAofEJv3BFa2vH/oe9Ghg=;
	b=GFM6OR/xomojMZBtM/3PpEWSZVsdzvF1ffos90UX4H6oBzylMOiNKssihOK5PMuoB7B/
	 jnkOMTsL9MYjRcSSdrxVQq267ZkTLoNegHQrRh5HsoHHK/tnbO3B2ZHJVPAqmnl1todN4
	 QcxO6WPRU427PcgXhF5UQ/e3rvkRqrn2YC/VUkX3etJe0UdJCWU5MQAWQaveb1LVILZBs
	 +8rvVhE+Ig9aIhzS3ywSvdGM0CdHXhLQvmBpBYTzZK71csbN/FCPEGuiR6szotZZhMunn
	 +1Kk22ksZ2ojz0ZqyRhHkyKEN72Rn9p8tBIjEvTh0jPYxgAtvViXZ4Isi5SNQiZgUrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdIqgvdD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC1606A32A;
	Wed, 18 Nov 2026 21:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdIqgvdD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16661F000C4;
	Wed, 18 Nov 2026 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037277;
	bh=WJd23hyUKmw8s4Z7+7YZz3ZAofEJv3BFa2vH/oe9Ghg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdIqgvdDyc40uF/YsuR4HQs7xHQ6JCMMTNEQIbSAUYovfyKMZJvM9ahPiX8s4l4Vj
	 ArKukMvX55oKmduD/UQ5DS+m5QsR3wWCvosED/i0EMdS5dl2fKX4bAN2OQq4jtvvF5
	 4cAYqXjArVPe2qdZrsLq5YPmqalPhdw8GpR6iork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1352/3318] pppoe: delete session hash entries by pointer match
Date: Wed, 18 Nov 2026 15:32:54 +0100
Message-ID: <20261118150400.975217921@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit b5b8c81836e2bec7b444dfa2b14fd14e912e9d63 ]

pppoe_connect() copies the requested PPPoE address to a socket before
attempting to insert the socket into the session hash table. If the
tuple already exists, __set_item() returns -EALREADY, but the copied
address and ifindex remain set on the failed socket.

Closing that socket then deletes the existing socket's hash entry
through pppoe_release(), preventing it from receiving further session
traffic. An unprivileged process in the same network namespace can
trigger this through a duplicate connection attempt.

To avoid the accidental delete, pass the pppox_sock to __delete_item(),
and unlink only an entry whose pointer matches the requested socket.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Link: https://patch.msgid.link/20261020092118.47416-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Resolve conflict, and remove const qualifier of pppox_sock to match
  hash_item(). ]
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 63c94ad88e565..1bdcedb5ce1a6 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -194,18 +194,16 @@ static int __set_item(struct pppoe_net *pn, struct pppox_sock *po)
 	return 0;
 }
 
-static void __delete_item(struct pppoe_net *pn, __be16 sid,
-					char *addr, int ifindex)
+static void __delete_item(struct pppoe_net *pn, struct pppox_sock *po)
 {
-	int hash = hash_item(sid, addr);
+	int hash = hash_item(po->pppoe_pa.sid, po->pppoe_pa.remote);
 	struct pppox_sock *ret, **src;
 
 	ret = pn->hash_table[hash];
 	src = &pn->hash_table[hash];
 
 	while (ret) {
-		if (cmp_addr(&ret->pppoe_pa, sid, addr) &&
-		    ret->pppoe_ifindex == ifindex) {
+		if (ret == po) {
 			*src = ret->next;
 			break;
 		}
@@ -255,11 +253,10 @@ static inline struct pppox_sock *get_item_by_addr(struct net *net,
 	return pppox_sock;
 }
 
-static inline void delete_item(struct pppoe_net *pn, __be16 sid,
-					char *addr, int ifindex)
+static void delete_item(struct pppoe_net *pn, struct pppox_sock *po)
 {
 	write_lock_bh(&pn->hash_lock);
-	__delete_item(pn, sid, addr, ifindex);
+	__delete_item(pn, po);
 	write_unlock_bh(&pn->hash_lock);
 }
 
@@ -599,8 +596,7 @@ static int pppoe_release(struct socket *sock)
 	 * protect "po" from concurrent updates
 	 * on pppoe_flush_dev
 	 */
-	delete_item(pn, po->pppoe_pa.sid, po->pppoe_pa.remote,
-		    po->pppoe_ifindex);
+	delete_item(pn, po);
 
 	sock_orphan(sk);
 	sock->sk = NULL;
@@ -651,8 +647,7 @@ static int pppoe_connect(struct socket *sock, struct sockaddr *uservaddr,
 	if (stage_session(po->pppoe_pa.sid)) {
 		pppox_unbind_sock(sk);
 		pn = pppoe_pernet(sock_net(sk));
-		delete_item(pn, po->pppoe_pa.sid,
-			    po->pppoe_pa.remote, po->pppoe_ifindex);
+		delete_item(pn, po);
 		if (po->pppoe_dev) {
 			dev_put(po->pppoe_dev);
 			po->pppoe_dev = NULL;
@@ -703,8 +698,7 @@ static int pppoe_connect(struct socket *sock, struct sockaddr *uservaddr,
 
 		error = ppp_register_net_channel(dev_net(dev), &po->chan);
 		if (error) {
-			delete_item(pn, po->pppoe_pa.sid,
-				    po->pppoe_pa.remote, po->pppoe_ifindex);
+			delete_item(pn, po);
 			goto err_put;
 		}
 
-- 
2.53.0



