Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041738;
	b=zk0877y62e4RIwK45KilPjiLflBwfE4wP/v8iX0UHH/EN1jd498bVEvJRE2cPSSKuEfM
	 qjlO2sv7HvYR4/C1XD4EakeO+/JTlN/iAqOBeJ7l8vEbDAPD/+XhYJ85qLr93ilnQ5UHc
	 Zos8nnLGgLVqImfDvaxK8bGjeRdTOI1dXalFX/gizcjEb+6B38nrD8mXSq6dVjeAyyPLo
	 C1f4/5W8kkRB2ry2kV5y2ZKHTF+1GSP0uFy45+MCAmtR5GmDeQM85z8GqDaGbF5ZzL8mU
	 chTx1PdKD8iqWiR0Fq+9ZQUJbzzLyfQ8xuF9Umzu/wLM2uCoWksZIrY32avrbB0NzAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gL2g2XMJDfACtF4T3x3pwyVf041XtKI7TZDcMlOuMy8=;
	b=QYqRP6KASfcZIHvVsaKEEdE/DpIxx8EjBPlnceYEXmEVhV4tk3DgCMqZaPqM9LOPQQAD
	 O6J+90U3KRdRBfb5QHugE5xqMhiZB0yC3ZXapGZHLjO2slRaFh/fymjXUkL5zl2qauNOk
	 zWhPfrE+rjDuH7TbMbRmMV9ZRz+YIs3kuqcWdU7AInQVISCUwqTAn3xFBLQVgb6Wgsv9a
	 U/Q1PZvdsq/9+5DaQM5yFPJtCTzDdb+VzTTLfWZwPll1sXwMjYrTd72+WFskR9t1AkDfN
	 og5HpdPBQ0jnq2AyLzgMd3U3jUG7GQHS+F2aODVL7wlJqb3Z9u7q47IDnNDlb3bgcww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atZPTVLJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936B6606A31C;
	Wed, 18 Nov 2026 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atZPTVLJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD961F000C4;
	Wed, 18 Nov 2026 22:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041738;
	bh=gL2g2XMJDfACtF4T3x3pwyVf041XtKI7TZDcMlOuMy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atZPTVLJRTediHL2LME1yPwoK25/3GVb385Bf9hOj4Gqu7ONaPKK3WO0CYdjkYc+U
	 Wg7hmix2wgfhsxY8I8VZxc3BKbPM/Jmb4XfhuS6GqQ4TBo0hRQqR7FPoicybGa5Aor
	 EcMn2iuu9YeOs/4c9critxvTGECM0d+WjCRiBtFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2920/3318] RDMA/rxe: Let destroy qp succeed with stuck packet
Date: Wed, 18 Nov 2026 15:59:02 +0100
Message-ID: <20261118150448.016178837@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 1a633bdc8fd9e9e4a9f9a668ae122edfc5aacc86 ]

In some situations a sent packet may get queued in the NIC longer than
than timeout of a ULP. Currently if this happens the ULP may try to reset
the link by destroying the qp and setting up an alternate connection but
will fail because the rxe driver is waiting for the packet to finish
getting sent and be returned to the skb destructor function where the qp
reference holding things up will be dropped. This patch modifies the way
that the qp is passed to the destructor to pass the qp index and not a qp
pointer.  Then the destructor will attempt to lookup the qp from its index
and if it fails exit early. This requires taking a reference on the struct
sock rather than the qp allowing the qp to be destroyed while the sk is
still around waiting for the packet to finish.

Link: https://lore.kernel.org/r/20240329145513.35381-15-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 56a27df6cedd ("RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 42 +++++++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_qp.c  |  2 +-
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 2bff70ef2f706..1f0f5d077c453 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -345,25 +345,44 @@ int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 
 static void rxe_skb_tx_dtor(struct sk_buff *skb)
 {
-	struct sock *sk = skb->sk;
-	struct rxe_qp *qp = sk->sk_user_data;
-	int skb_out = atomic_dec_return(&qp->skb_out);
+	struct net_device *ndev = skb->dev;
+	struct rxe_dev *rxe;
+	unsigned int qp_index;
+	struct rxe_qp *qp;
+	int skb_out;
+
+	rxe = rxe_get_dev_from_net(ndev);
+	if (!rxe && is_vlan_dev(ndev))
+		rxe = rxe_get_dev_from_net(vlan_dev_real_dev(ndev));
+	if (WARN_ON(!rxe))
+		return;
 
-	if (unlikely(qp->need_req_skb &&
-		     skb_out < RXE_INFLIGHT_SKBS_PER_QP_LOW))
+	qp_index = (int)(uintptr_t)skb->sk->sk_user_data;
+	if (!qp_index)
+		return;
+
+	qp = rxe_pool_get_index(&rxe->qp_pool, qp_index);
+	if (!qp)
+		goto put_dev;
+
+	skb_out = atomic_dec_return(&qp->skb_out);
+	if (qp->need_req_skb && skb_out < RXE_INFLIGHT_SKBS_PER_QP_LOW)
 		rxe_sched_task(&qp->send_task);
 
 	rxe_put(qp);
+put_dev:
+	ib_device_put(&rxe->ib_dev);
+	sock_put(skb->sk);
 }
 
 static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 {
 	int err;
+	struct sock *sk = pkt->qp->sk->sk;
 
+	sock_hold(sk);
+	skb->sk = sk;
 	skb->destructor = rxe_skb_tx_dtor;
-	skb->sk = pkt->qp->sk->sk;
-
-	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -384,12 +403,13 @@ static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
  */
 static int rxe_loopback(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 {
+	struct sock *sk = pkt->qp->sk->sk;
+
 	memcpy(SKB_TO_PKT(skb), pkt, sizeof(*pkt));
 
+	sock_hold(sk);
+	skb->sk = sk;
 	skb->destructor = rxe_skb_tx_dtor;
-	skb->sk = pkt->qp->sk->sk;
-
-	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
 	if (skb->protocol == htons(ETH_P_IP))
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 9e3ee76ef71ec..3e791485fb819 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -245,7 +245,7 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	err = sock_create_kern(&init_net, AF_INET, SOCK_DGRAM, 0, &qp->sk);
 	if (err < 0)
 		return err;
-	qp->sk->sk->sk_user_data = qp;
+	qp->sk->sk->sk_user_data = (void *)(uintptr_t)qp->elem.index;
 
 	/* pick a source UDP port number for this QP based on
 	 * the source QPN. this spreads traffic for different QPs
-- 
2.53.0



