Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020213;
	b=WbfMuwWPh90y5uQDl8wfhVy2gURMu06vRlyiXBN3uu2dDbbR8zSywhBtbxU10F44lyxY
	 /lX0NPXgyaBgVFUQGmgfFIuwMY+LZSylzVUt/w7/XYfIyDv3Q+5xIOKtkCKzNSK1Hen3G
	 QI5LcxmcXnU9H3/n/0aZNmWWBWz+t2qXM0YbTHUJZZRkMCt9ruz080J0aJaVpsY1ArK/Q
	 fALkAGZYXI8v2qAWuubiFc0tPF1UFCthV0LM6k4mjRheIgwy+DE5rZYLFFe97H28TzGIs
	 o+WeJ0MLZz8Ylx8QZN3QZibEKZMECspehwPl+0bd1/DaymrlnvRA5MRyvv6RtWw1VeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0K2DmvMSgCOrhqWR97skm3Gqe4w69FNNbXdYyWvnnI=;
	b=GFKQrTu3HF+MKz6736UKL/040c3FQ6XoXF44hKg71vbA2+QpqcYwid4vqKY+cLlUJEK9
	 HPrr/9s3ga2HN2MEqji27Xbu06eN+Obtv2bbtJhtJLexsuKG8ThSbZmFGkq6nphHGKHPw
	 NjyHMFpjahZtaafk5J4dDfhcdXaiwNhG2kqJzsB3BgZQNx1TZqbLB+tq9XtBvKhBRgp3w
	 UuAHcbY6ovrsA4WdTiCR9uPhg3NdjMYpWgVA/LdyngsPj7ScOqZsNImlkzmWUnH2+XehQ
	 wNPheAYkvDzL5n0Mj7WauKX/+gjYZiI8p6oVuCqNua7GHVPLRt+7UABPC400JYExLHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsswbtaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E831606A31C;
	Wed, 18 Nov 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsswbtaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA2C1F000C4;
	Wed, 18 Nov 2026 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020213;
	bh=y0K2DmvMSgCOrhqWR97skm3Gqe4w69FNNbXdYyWvnnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsswbtaIM7lrs9Xmpvi/2FjdS5d1VHZ8i++6wvPm6y6/vxO3kzOrVkG/SUKVfwpxO
	 Bqu6KJ6RhsQON+aIGocnTtlsyVQnGow440UxLmiLgq5kd++dCbRNYHzi7hYCiJjAos
	 Kreh6uXDfdA416S/3hjwJwuWeirnAkyfgED2NUrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1870/2651] Bluetooth: L2CAP: take chan->lock for l2cap_chan_add/ready/del
Date: Wed, 18 Nov 2026 15:51:50 +0100
Message-ID: <20261118150354.286313754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3d9a32094347c..f64568cb51169 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -971,7 +971,8 @@ int l2cap_chan_check_security(struct l2cap_chan *chan, bool initiator);
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
index 47f0449588ea1..60720a8cce826 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -703,7 +703,9 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 void l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 {
 	mutex_lock(&conn->lock);
+	l2cap_chan_lock(chan);
 	__l2cap_chan_add(conn, chan);
+	l2cap_chan_unlock(chan);
 	mutex_unlock(&conn->lock);
 }
 
@@ -4136,6 +4138,8 @@ static struct l2cap_chan *l2cap_new_connection(struct l2cap_conn *conn,
 	if (!chan)
 		return NULL;
 
+	l2cap_chan_lock(chan);
+
 	l2cap_chan_set_defaults(chan, pchan);
 	chan->ops = pchan->ops;
 
@@ -4144,10 +4148,13 @@ static struct l2cap_chan *l2cap_new_connection(struct l2cap_conn *conn,
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
 
@@ -5130,6 +5137,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		goto response_unlock;
 	}
 
+	l2cap_chan_lock(chan);
+
 	bacpy(&chan->src, &conn->hcon->src);
 	bacpy(&chan->dst, &conn->hcon->dst);
 	chan->src_type = bdaddr_src_type(conn->hcon);
@@ -5163,6 +5172,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		result = L2CAP_CR_LE_SUCCESS;
 	}
 
+	l2cap_chan_unlock(chan);
+
 response_unlock:
 	l2cap_chan_unlock(pchan);
 	l2cap_chan_put(pchan);
@@ -5353,6 +5364,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 			continue;
 		}
 
+		l2cap_chan_lock(chan);
+
 		bacpy(&chan->src, &conn->hcon->src);
 		bacpy(&chan->dst, &conn->hcon->dst);
 		chan->src_type = bdaddr_src_type(conn->hcon);
@@ -5385,6 +5398,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		} else {
 			l2cap_chan_ready(chan);
 		}
+
+		l2cap_chan_unlock(chan);
 	}
 
 unlock:
-- 
2.53.0



