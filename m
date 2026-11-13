Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590870;
	b=fxPJFPEi8LZpj8vl98HFolrC/6Sogt3FS+Eqr3HC6vDAN/0pYpkGQZxUk+7uV5e1PELN
	 TGJ8TjZs4BZjbEL46FkYKJFaSJeqSRhj27yX6jy6Q4uEzY86jIlBTawja6hemeWL5wKTS
	 B1LZdpUpdJlHlExLmQCyhA6Dml2ca5Ns4SrskdOlvlyrggTM2Gu2r/iZKeA6BieZwDMhA
	 AaYj+UKi/YpImAgRDSNgqSodulxEhLSLm3t4hK5HHxCM04dbFfgU975VSe4lC4BfuTWMv
	 cVXU+WcgqcXir8dacXCTvh+WLg38qWJwIDQKq1Q8Xut3oqLo2lijlkspUWL3mWJFqJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=auGQMaPhnvz/DkXoEdqfvbI6iqoJ2jVDP5VD49Xuz28=;
	b=rhX8SZpt1LUX4dfAP+DcJVQdvlGe3MkZ5UD5wGtaZsLKJ/KRIEc7AfJw7tFYM92Hl/IB
	 TF7tuelfhxzkk5Vi9MhGfxK1ybX9DNiuTaI2wqi6GILlHTHlMZQqjCQXpv6nvns9kKr6m
	 vut+0QU6vO+8T2KebJaH+FbvzkehHM81jDhEEY8RGMMGZA4zRkudGl7HbS8TDocL3IV2U
	 bGT+F/PTw3Kg+M7TK2Y3cR/0cVtK3ztcTQLgemGUvruXe4D9GBvSgKtV07P+4UxgHt5jb
	 RgxCyNguo0wox9q+oS+nhIqclYNBkqQlqglY+IvdVcuAC7Zo8z/zE3Fmm1hDidPAOJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSJis7WR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37D606D4A5;
	Fri, 13 Nov 2026 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSJis7WR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0651F000C5;
	Fri, 13 Nov 2026 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590870;
	bh=auGQMaPhnvz/DkXoEdqfvbI6iqoJ2jVDP5VD49Xuz28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSJis7WRR9tHDT1f/0hM1FvN7HknY6GtBvhXWrssTWKKxm6qiRfWFWpwdpXgfnP8g
	 4vv001kpjHjLXRSF1+Dp/OggythcdeF9pVSRw3lcp2HWugYy+Bt41NP0XF0OfHuE5T
	 P3vDTMUSPr6w0wn8W7bzls2YxGx5d3FJNUmGcswo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/670] pppoe: delete session hash entries by pointer match
Date: Fri, 13 Nov 2026 10:43:52 -0500
Message-ID: <20261113153813.811931602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8ff2024dde604..293b6fb1c1e98 100644
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



