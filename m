Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043372;
	b=R/nlaa6E1v06GB19Ca5ci/weQsJBZc4ClgtSB7PnddGr4UyGGVsJ9mc+K3TeBy8oNqcK
	 F33vDJNirDY9iW+k11T3MyTdj5ODuJekn6kROnibogAGUASvyoCe073N5OO79HyKnPreA
	 X+PrXCjpWWNlcmbkM+/5Q+TS4CfFdZAWgW6PZMq+K42N+IOn4GcFYwfk2P6Oy04SSdXeO
	 kxSb2xDh1YF0F6pLHd2DFEQbb4zmcc2fOExg+iwlxu5BSXFP0d5+Bo+eB+30SpHhEGfYz
	 Ll0KcbekRlwGs9pllwfio6sjro9yLFQQ7YcQO8tYPgV4njKJ5Pk/WOZvZ56iCCxy/VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ojkwr24EvnJjepz8ClCoh861LaCD35xZhHZaiPzid7A=;
	b=EamLw0CKczmPBSigFb0J1nQjoBV7DeUMcIxr11npob3b0KaWynT4xlmNzbOXbGeGhEFw
	 OqSfphe19bQ6KG5xXtwSlR2y0fQQDLLxvdebhhq18Qr3JbcuyrkxN++esuvx9V7pBmnTw
	 Z2w1xo3aewdaYQixQv6Qiw1ZxjT3duRMJm3KCZKGHZqLO9fV+Lrkfz5OXaTgXR3H6zC6S
	 F+S43otXkMlA5JUGvV2WSAKZfzbUS73nmyTUT7ZgQ45yI0mr2DYW4fbN2OLsg0xxZRc1K
	 ycuukzjpoJfx0Mg9nnSSALTgtRglsUqBzpXOO+NdKv5uxpfpLsBk1kO18AWxsMqJ0lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BEJ0+z5a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C7C606A31C;
	Wed, 18 Nov 2026 23:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BEJ0+z5a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F61F000C4;
	Wed, 18 Nov 2026 23:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043372;
	bh=Ojkwr24EvnJjepz8ClCoh861LaCD35xZhHZaiPzid7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEJ0+z5ampJjcP390nEfeyrrgTPcoSJxZ2FxFfn7FSDjyDxqKAZacRQsj8YBlHjec
	 H74OS5eQaYtw7QY3Ck020LsswC2TBRdmNZSwO5HTbTUyTDebPmy9o7vxdCEh2pCU83
	 pzG3uVu8U+8o8svojW3F6tFHw5wXSdiCZ4PeTvxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0186/2857] wifi: brcmfmac: validate msgbuf flowring IDs before use
Date: Wed, 18 Nov 2026 15:20:20 +0100
Message-ID: <20261118150208.045329259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 32856f39fefdc75bd253cab999f996750628648e ]

Firmware messages carry flow_ring_id values which brcmfmac converts
to an internal flowid by subtracting
BRCMF_H2D_MSGRING_FLOWRING_IDSTART. The resulting value is used as
a bit index in txstatus_done_map and as an array index into
msgbuf->flowrings and the flowring state.

Validate the firmware supplied flow_ring_id before using it. This
prevents flow_ring_id values below BRCMF_H2D_MSGRING_FLOWRING_IDSTART
from underflowing and rejects values outside msgbuf->max_flowrings.

In the tx status path, complete the packet with an error after
removing a valid packet id so the skb is not leaked when the flow
ring id is invalid.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260723055618.550834-1-pengcan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 46 ++++++++++++++++---
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index de47d6b7e02b2..f850e64108c41 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -561,6 +561,28 @@ brcmf_msgbuf_remove_flowring(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	brcmf_flowring_delete(msgbuf->flow, flowid);
 }
 
+static bool brcmf_msgbuf_get_flowid(struct brcmf_msgbuf *msgbuf,
+				    u16 flow_ring_id, u16 *flowid)
+{
+	u32 id = flow_ring_id;
+
+	if (id < BRCMF_H2D_MSGRING_FLOWRING_IDSTART) {
+		bphy_err(msgbuf->drvr, "invalid flowring id %u\n",
+			 flow_ring_id);
+		return false;
+	}
+
+	id -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	if (id >= msgbuf->max_flowrings) {
+		bphy_err(msgbuf->drvr, "invalid flowring id %u\n",
+			 flow_ring_id);
+		return false;
+	}
+
+	*flowid = id;
+	return true;
+}
+
 
 static struct brcmf_msgbuf_work_item *
 brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
@@ -881,17 +903,23 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 	struct msgbuf_tx_status *tx_status;
 	u32 idx;
 	struct sk_buff *skb;
+	u16 flow_ring_id;
 	u16 flowid;
 
 	tx_status = (struct msgbuf_tx_status *)buf;
 	idx = le32_to_cpu(tx_status->msg.request_id) - 1;
-	flowid = le16_to_cpu(tx_status->compl_hdr.flow_ring_id);
-	flowid -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	flow_ring_id = le16_to_cpu(tx_status->compl_hdr.flow_ring_id);
 	skb = brcmf_msgbuf_get_pktid(msgbuf->drvr->bus_if->dev,
 				     msgbuf->tx_pktids, idx);
 	if (!skb)
 		return;
 
+	if (!brcmf_msgbuf_get_flowid(msgbuf, flow_ring_id, &flowid)) {
+		brcmf_txfinalize(brcmf_get_ifp(msgbuf->drvr, tx_status->msg.ifidx),
+				 skb, false);
+		return;
+	}
+
 	set_bit(flowid, msgbuf->txstatus_done_map);
 	commonring = msgbuf->flowrings[flowid];
 	atomic_dec(&commonring->outstanding_tx);
@@ -1238,13 +1266,16 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	struct msgbuf_flowring_create_resp *flowring_create_resp;
 	u16 status;
 	u16 flowid;
+	u16 flow_ring_id;
 
 	flowring_create_resp = (struct msgbuf_flowring_create_resp *)buf;
 
-	flowid = le16_to_cpu(flowring_create_resp->compl_hdr.flow_ring_id);
-	flowid -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	flow_ring_id = le16_to_cpu(flowring_create_resp->compl_hdr.flow_ring_id);
 	status =  le16_to_cpu(flowring_create_resp->compl_hdr.status);
 
+	if (!brcmf_msgbuf_get_flowid(msgbuf, flow_ring_id, &flowid))
+		return;
+
 	if (status) {
 		bphy_err(drvr, "Flowring creation failed, code %d\n", status);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
@@ -1267,13 +1298,16 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	struct msgbuf_flowring_delete_resp *flowring_delete_resp;
 	u16 status;
 	u16 flowid;
+	u16 flow_ring_id;
 
 	flowring_delete_resp = (struct msgbuf_flowring_delete_resp *)buf;
 
-	flowid = le16_to_cpu(flowring_delete_resp->compl_hdr.flow_ring_id);
-	flowid -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	flow_ring_id = le16_to_cpu(flowring_delete_resp->compl_hdr.flow_ring_id);
 	status =  le16_to_cpu(flowring_delete_resp->compl_hdr.status);
 
+	if (!brcmf_msgbuf_get_flowid(msgbuf, flow_ring_id, &flowid))
+		return;
+
 	if (status) {
 		bphy_err(drvr, "Flowring deletion failed, code %d\n", status);
 		brcmf_flowring_delete(msgbuf->flow, flowid);
-- 
2.53.0



