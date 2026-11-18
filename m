Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041616;
	b=RunoKDisXliXwuc22qNI55jPWoZPYs5Qx0Q1uG0IV3gFax/+bHu0+0xapJeRlAtFoqQE
	 ZxUrDTfgFYdreK1YLMf3Ym/cHH3M/tui6Z5JwosXpmQvKW3MnjdKQb59eF75iMIQe+81r
	 QApUXmnoNibOAUCnSN7i+nbGzcaFvsTkYXKjhM30aAP+Q82ZR8LTZo61Ia0PcqIqOG26H
	 UT1IBxRsrA9iKPZKJKz+nCXZHidl3vDGrCqQHKrOYRvuyydhuv8YQqxuO/DkKk2FyqgPV
	 orPQ/TEj8l6qowCEpkVkUqbIARM5NJFe7f7TsOo58MRG9k1S4c24NAzqRNF9HLQ/izg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7Qh8nQapYnbgqNhME6bLJS/k9YDF+FHmPXQ6p41wWs=;
	b=fVN3E9n2uzjB2g+hE0VOeo6aLxTHF0JnYQk5pibHwZCZ/hRhTalGNcxDfUzXXOZHq3Js
	 SdCLk68POwjYoOaI2XLnEd8CWuiUyC4iYACmQtKsppLN38GDEvZ8Owv7JaikBzRcYIq4X
	 1HopyzUt4rj+dNAokYnONZeca2pZhClUN33nKi8n9V2Gz/dhcIzSVDF7rkrWMje8HflI/
	 2LBOhevLYJww9T712P9IG6dHyzfmreyO5uPK8IC8TMHII56BZErFfNb3OLdktOebt+75s
	 /PWc9vT9bv71xVzT9fnfRPQuI97nJXX50cI/0Ip509hoEfspUY8bS5Z82VVYHYxZZjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=meR7YU6+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35111606A31C;
	Wed, 18 Nov 2026 22:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=meR7YU6+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC951F000C4;
	Wed, 18 Nov 2026 22:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041616;
	bh=s7Qh8nQapYnbgqNhME6bLJS/k9YDF+FHmPXQ6p41wWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=meR7YU6+G0YphwLK5MVKRfwP5tw4WIshuvjabDapZwloMbHJYn7lRjix1elOs8XCm
	 lsiQABQLCqFF/8yw8K1Dgv8Bfe5dBTmfaxkoEs8uYlNWTjTjgXcQUKo32SfbZ2/RWU
	 HsGB0quW+EJRWJgMBo9M0YcqK4NaISWPNCuVt2S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2876/3318] Bluetooth: L2CAP: take chan->lock for l2cap_chan_add/ready/del
Date: Wed, 18 Nov 2026 15:58:18 +0100
Message-ID: <20261118150446.827716975@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 385c0829e09e7a6380ae67998ac6ef6f4dfd5303 ]

chan->lock must be held for __l2cap_chan_add as eg. calls to
l2cap_chan_close assume chan->conn writes are guarded by it.

It must be held for l2cap_chan_del() due to
l2cap_sock.c:l2cap_chan_conn, l2cap_monitor_timeout, etc.

Similarly it should be held for l2cap_ops::ready (assumed in 6lowpan.c).
Also teardown usually has chan->lock held, it should always have it held
to have the same locking context.

The lock is not correctly held by l2cap_core in several places.

Add the missing locks for l2cap_chan_del/add/ready(), except in
l2cap_ecred_rsp_defer() which needs separate fix as it needs lock
nesting.

Fixes: 6fef032af009 ("Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/l2cap.h |  3 ++-
 net/bluetooth/l2cap_core.c    | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 767df6d832c81..f7f60d64933b7 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -967,7 +967,8 @@ int l2cap_chan_check_security(struct l2cap_chan *chan, bool initiator);
 void l2cap_chan_set_defaults(struct l2cap_chan *chan, struct l2cap_chan *pchan);
 int l2cap_ertm_init(struct l2cap_chan *chan);
 void l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan);
-void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan);
+void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
+	__must_hold(&chan->lock);
 typedef void (*l2cap_chan_func_t)(struct l2cap_chan *chan, void *data);
 void l2cap_chan_list(struct l2cap_conn *conn, l2cap_chan_func_t func,
 		     void *data);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 070211b7a9094..036c880cc4e53 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -706,7 +706,9 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 void l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 {
 	mutex_lock(&conn->lock);
+	l2cap_chan_lock(chan);
 	__l2cap_chan_add(conn, chan);
+	l2cap_chan_unlock(chan);
 	mutex_unlock(&conn->lock);
 }
 
@@ -4086,6 +4088,8 @@ static struct l2cap_chan *l2cap_new_connection(struct l2cap_conn *conn,
 	if (!chan)
 		return NULL;
 
+	l2cap_chan_lock(chan);
+
 	l2cap_chan_set_defaults(chan, pchan);
 	chan->ops = pchan->ops;
 
@@ -4094,10 +4098,13 @@ static struct l2cap_chan *l2cap_new_connection(struct l2cap_conn *conn,
 	if (pchan->ops->new_connection &&
 	    pchan->ops->new_connection(pchan, chan) < 0) {
 		l2cap_chan_del(chan, 0);
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return NULL;
 	}
 
+	l2cap_chan_unlock(chan);
+
 	return chan;
 }
 
@@ -5065,6 +5072,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		goto response_unlock;
 	}
 
+	l2cap_chan_lock(chan);
+
 	bacpy(&chan->src, &conn->hcon->src);
 	bacpy(&chan->dst, &conn->hcon->dst);
 	chan->src_type = bdaddr_src_type(conn->hcon);
@@ -5098,6 +5107,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		result = L2CAP_CR_LE_SUCCESS;
 	}
 
+	l2cap_chan_unlock(chan);
+
 response_unlock:
 	l2cap_chan_unlock(pchan);
 	l2cap_chan_put(pchan);
@@ -5289,6 +5300,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 			continue;
 		}
 
+		l2cap_chan_lock(chan);
+
 		bacpy(&chan->src, &conn->hcon->src);
 		bacpy(&chan->dst, &conn->hcon->dst);
 		chan->src_type = bdaddr_src_type(conn->hcon);
@@ -5321,6 +5334,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		} else {
 			l2cap_chan_ready(chan);
 		}
+
+		l2cap_chan_unlock(chan);
 	}
 
 unlock:
-- 
2.53.0



