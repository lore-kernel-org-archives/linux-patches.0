Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829736;
	b=CKHQ8dzP1QaaorOT6i7f6MyUqltlrHxSiccXa7Y7kEtg58YcepuAdwyJzzMLuMKvyKP7
	 072MkJ3/fMAbqdm7xG5DfI8wpalskRVGBoyFB1P+oDOANjPNTE94JRmrmKC0VlU9qgglu
	 s2iGohp4l5SqXJ9RK4wdZHYYM76p4mDh3vcfFG7oVQShm47P6o2G3eHJBD3zMznFuogYT
	 4aaIyprLFLfbOdRUuwH0+2Qg6hqCmwHg83x/ZXwfO+raTG9SkD5+5BpO9/tuTTvO8+I+7
	 /m7wfsPrj/zd7isgQy3sXxP1/XrNgwA/vqaIG2CUyDcfCCxiaeMFQ5bfMzXXyN3ZGlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33x9wtwxiBT/PbV7XfcSeCcJUukUGFtu3ij7a0pMM78=;
	b=QUCbNh7W1uF5sMGNJYb6ja+hObEsSjOOmOK26miv2VvwUdsUl1kqcjHcbKXMxDdAS/rq
	 gMBRzuO7+ZJhwFiRC2Ju847pIMoGiyPVjWLERRUFv3I2kCL7pP6gWDe6tZF8cK44rggxy
	 lcQRrtvjlJ6ItTEtckQpyQ5kELxUixEuCnHqOJ4yL/eUb9jNasGx/d48F2HJ1dlZi4GEW
	 6BA6ioyg6FYnT2w45uDonPd189iI2SqD7Vg3uEofFQO6ele9DVOHxBBJKJTZ1TeqAHUnE
	 JYrA4yHXpY42FJ8G9dAk5MAo9xeHf7uXMcWYWXfS05XQQ8PL0KiPut7HiJ0Ai/hnacg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bH6PR/MS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210E606CA04;
	Wed,  4 Nov 2026 22:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bH6PR/MS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E091F000C1;
	Wed,  4 Nov 2026 22:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829735;
	bh=33x9wtwxiBT/PbV7XfcSeCcJUukUGFtu3ij7a0pMM78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bH6PR/MSKP3u8oyOZl5OyO2lQfJJsb7b5mpDtp4loF7UUkNRQztVroVDlppqxLBd+
	 fwsU/ed/KZy/tQ0ZmNBQpFKuqjLsMXWbnLvOkZXYL34AVQOISag6JTjOiLEH6JEYIN
	 yDXFqyq8tD9+VmVgVd0qeSBkhDO7V7ghZJ9I6T4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0311/1005] wifi: brcmfmac: validate msgbuf flowring IDs before use
Date: Wed,  4 Nov 2026 16:00:44 -0500
Message-ID: <20261104211052.641872227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



