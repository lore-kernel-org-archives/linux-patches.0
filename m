Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031891;
	b=u4Ad/CzoaQB0FSKo6xIsVvogm71XK6sFf7VsYirYp2Dic4SHs7suhQjzWJWjKTO8/36K
	 XgFGtVO6PrXZUinhyb0kl1foTeEehjTkKkwRiqDd/lumsOSiHf86eo/LMyhP7ZzRqgl5w
	 BZB3nap+JP6rCVTo94P/zY92/hOg+j3U3uDGjGaPmKDiKt0koXuROJ5ihQgytU1e9XdJ4
	 b69N3+zHRGx0ynzsvFxp6sxFfG3/3aEVbpTxLQFH8aUwnAYfx+JkcJvJCsuKY6Xt/cOtG
	 0IxV6a6kVIrX9+BkQ8YjMJGOKDvla7xTElp1i18YnBZF3v++x8p/JozwDuIrQy8SyZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ftqovqMSASi65Lldh5PrcVYqkjQOXcoDh/TlaP0DE2Y=;
	b=A2tuSTsOT87NW024QnIwYH4jEEQiEdPJTL+b0LYnVDkHIgIYj+TPxjAhSgA88ELyiUyi
	 Mso7cNGRPYrbS6022qnejgfsiQn1xiSGTv4WmezMrFvFU0XR1iqGE/R5+Zm39x6/C7LVX
	 Ix0tDNTrjWR5dWm5arqc1BknaoqVzVFhSfkYPb1U4L0GFTlkuiu4RNBNfjSQVR2mPB1zC
	 AnzJLNZo8epF0S9nBZOHqq/3lbICpYHb64o7vVCYjlciVQRMmTkOm3AJTyyqOlPLD/xV0
	 eQEmtRe/7guQFh4VydFd630c7C2TR/zRU3kMb1TfQ53uGfSB8mYzzVYAJhFXBrt9Idw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7YElOu2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66F606A325;
	Wed, 18 Nov 2026 19:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7YElOu2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE6C1F000C4;
	Wed, 18 Nov 2026 19:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031891;
	bh=ftqovqMSASi65Lldh5PrcVYqkjQOXcoDh/TlaP0DE2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7YElOu2KZOFaN2O6bpELIGGhL3XN01l2X8GQejtvLz5B1mp1jOmKOkakX02g9cAH
	 C8FWtnQYAhQhLrzHYMxq1m5yAM1Gxpud3Im3Pn8P6dn4bMXGUoh1CmynYK95PoTMQn
	 EkNvjKkuwjC4+jk3tbMBenwmg2NMxADveBPquKX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1218/1756] Bluetooth: L2CAP: take chan->lock for l2cap_chan_add/ready/del
Date: Wed, 18 Nov 2026 15:55:45 +0100
Message-ID: <20261118150058.279656406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index f5f91373022f0..76931a189701d 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -973,7 +973,8 @@ int l2cap_chan_check_security(struct l2cap_chan *chan, bool initiator);
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
index 514abca6ed88c..53e784ad51237 100644
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
 
@@ -4103,6 +4105,8 @@ static struct l2cap_chan *l2cap_new_connection(struct l2cap_conn *conn,
 	if (!chan)
 		return NULL;
 
+	l2cap_chan_lock(chan);
+
 	l2cap_chan_set_defaults(chan, pchan);
 	chan->ops = pchan->ops;
 
@@ -4111,10 +4115,13 @@ static struct l2cap_chan *l2cap_new_connection(struct l2cap_conn *conn,
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
 
@@ -5112,6 +5119,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		goto response_unlock;
 	}
 
+	l2cap_chan_lock(chan);
+
 	bacpy(&chan->src, &conn->hcon->src);
 	bacpy(&chan->dst, &conn->hcon->dst);
 	chan->src_type = bdaddr_src_type(conn->hcon);
@@ -5145,6 +5154,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		result = L2CAP_CR_LE_SUCCESS;
 	}
 
+	l2cap_chan_unlock(chan);
+
 response_unlock:
 	l2cap_chan_unlock(pchan);
 	l2cap_chan_put(pchan);
@@ -5335,6 +5346,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 			continue;
 		}
 
+		l2cap_chan_lock(chan);
+
 		bacpy(&chan->src, &conn->hcon->src);
 		bacpy(&chan->dst, &conn->hcon->dst);
 		chan->src_type = bdaddr_src_type(conn->hcon);
@@ -5367,6 +5380,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		} else {
 			l2cap_chan_ready(chan);
 		}
+
+		l2cap_chan_unlock(chan);
 	}
 
 unlock:
-- 
2.53.0



