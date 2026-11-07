Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065219;
	b=Zt4h/or4e/i4JryslP8UaRRQgPhRVUYIQJLEqrlrHEX2E40iRS5DNfnsXDIF8yRejCka
	 DZesaf+lo/RyFgRwJYV5Diei789sFpFzI/NUH+1fuYANrAPFMmHT0HxXmqkjCXzrHQXaL
	 bjPgr8oWx4fWeIrSxr0nOZOaojpsjtBjnx3OvMc+imgnDUNN1YW4Q5mu8hmKPHhFJaCFT
	 1ZkPVFW9yjNRbDOrhyv+DaCSafZsLBGEz5H0m5IQMRZve8c8C7zLmuILQLTSJDA5c/GFH
	 c1gofsdA9nX+JzW4fA/PIqjLhyMdw8PIV+VJd5cBb+K1MdnURUz96U1E/zwUVa73GIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RFgpxMYf9Q/H6x2agZQzmrPTOo8Ys6OveuEK1MTDXdw=;
	b=I1j4iZRgx+7GWTz71Iu3I/Ul7ryC7PDkgF6U7Blyr8envaJMFJs0b5RjZ0UdfmUe8ILy
	 03wfysrW25qXI+ONA+X4rdKMJgr12qT7Nac4oc/Kax3J04C2W2aM5n9nSu8r8nQztY3jk
	 7eU+qd479CKsU3gYiQY0L52IUN+YyFrfyl0PVVnoDaWhDIYm/4LbbgokWqFBJtPe+Q5m7
	 EBizUGg+Wcqg0KPpPEuEXGWy2y53XjvlqrT2z4CJsFSwj/gcktEqKAjZ9gcxJjprOQtbV
	 9teAzNc2xXyBhpSapVTP1HkoxYwKl6aKK860fcP92DrfINFrYkVl+ZWRNCZy4lT3k2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ke48Jd2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39112606D801;
	Sat,  7 Nov 2026 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ke48Jd2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF231F0089F;
	Sat,  7 Nov 2026 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065218;
	bh=RFgpxMYf9Q/H6x2agZQzmrPTOo8Ys6OveuEK1MTDXdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ke48Jd2JZv7xd5Mrpsm0xAVPGipq72xJQUusLXUrT3AEoc2tVTYOYFwdvdncvAYxZ
	 5VmYZXwbOdg2q1Ev9Y0aNeGDa2nceUiyx4YPrVU9AsvI4rWr8D/JP3y1Y5YlcUm61G
	 1Il1ObeTkK0D9KXnw32/mKJ9Pkoo9XY8ij3TDh2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1012/1257] pppoe: delete session hash entries by pointer match
Date: Sat,  7 Nov 2026 08:55:08 -0500
Message-ID: <20261107135007.288686921@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index bf7414b46a260..ee0e318d6a2a4 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -194,18 +194,16 @@ static int __set_item(struct pppoe_net *pn, struct pppox_sock *po)
 	return 0;
 }
 
-static void __delete_item(struct pppoe_net *pn, __be16 sid,
-					char *addr, int ifindex)
+static void __delete_item(struct pppoe_net *pn, const struct pppox_sock *po)
 {
-	int hash = hash_item(sid, addr);
+	int hash = hash_item(po->pppoe_pa.sid, po->pppoe_pa.remote);
 	struct pppox_sock *ret, __rcu **src;
 
 	ret = rcu_dereference_protected(pn->hash_table[hash], lockdep_is_held(&pn->hash_lock));
 	src = &pn->hash_table[hash];
 
 	while (ret) {
-		if (cmp_addr(&ret->pppoe_pa, sid, addr) &&
-		    ret->pppoe_ifindex == ifindex) {
+		if (ret == po) {
 			struct pppox_sock *next;
 
 			next = rcu_dereference_protected(ret->next,
@@ -236,11 +234,10 @@ static inline struct pppox_sock *get_item(struct pppoe_net *pn, __be16 sid,
 	return po;
 }
 
-static inline void delete_item(struct pppoe_net *pn, __be16 sid,
-					char *addr, int ifindex)
+static void delete_item(struct pppoe_net *pn, const struct pppox_sock *po)
 {
 	spin_lock(&pn->hash_lock);
-	__delete_item(pn, sid, addr, ifindex);
+	__delete_item(pn, po);
 	spin_unlock(&pn->hash_lock);
 }
 
@@ -570,8 +567,7 @@ static int pppoe_release(struct socket *sock)
 	 * protect "po" from concurrent updates
 	 * on pppoe_flush_dev
 	 */
-	delete_item(pn, po->pppoe_pa.sid, po->pppoe_pa.remote,
-		    po->pppoe_ifindex);
+	delete_item(pn, po);
 
 	sock_orphan(sk);
 	sock->sk = NULL;
@@ -621,8 +617,7 @@ static int pppoe_connect(struct socket *sock, struct sockaddr_unsized *uservaddr
 	if (stage_session(po->pppoe_pa.sid)) {
 		pppox_unbind_sock(sk);
 		pn = pppoe_pernet(sock_net(sk));
-		delete_item(pn, po->pppoe_pa.sid,
-			    po->pppoe_pa.remote, po->pppoe_ifindex);
+		delete_item(pn, po);
 		if (po->pppoe_dev) {
 			dev_put(po->pppoe_dev);
 			po->pppoe_dev = NULL;
@@ -672,8 +667,7 @@ static int pppoe_connect(struct socket *sock, struct sockaddr_unsized *uservaddr
 
 		error = ppp_register_net_channel(dev_net(dev), &po->chan);
 		if (error) {
-			delete_item(pn, po->pppoe_pa.sid,
-				    po->pppoe_pa.remote, po->pppoe_ifindex);
+			delete_item(pn, po);
 			goto err_put;
 		}
 
-- 
2.53.0



