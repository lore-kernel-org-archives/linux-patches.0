Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618856;
	b=hWbnilo/1uaCmciErXbTpuS7Dcxrib7T1NQHX90h+SSVhxRZVUhPbOAHtNkHB2+/Bmg+
	 Z2ajoYiitgQXoktsP082zERPwLcpziIWEaRLVepJH5z9a7rkzZLI/MUwvM3+LqM5n/ylu
	 VP5xw46ePdMCGBf8wvhdK0oR18anVXl8sN5dhU5kByRQX2KLIeFwQ0UwquoLtua3pHMye
	 aR7t3WnbEICq6yW3PZj9gnwwTWapE9VGmWjUPiip/7g3L9qvgYEKtofXaALFgWSw7G5aT
	 Fsk95Zk+XnwCare1Hlx/LcaLyw+DuycSmxX6u+iyYq1sTFKRjQ7rHEwAfeIFLsshmGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9E8pkj3RvCv+sGHJSAO7pRe/QnhzOScM+l1tYM0eeQ=;
	b=Zl2OmHL3Gqx4X5PUebNE+hfVvUNakEqdfu7XdNKJwgFo1ezgFb2dkneOOfTczV4ED6aD
	 AWK3oBs2vfnKazrVgED0t+S4UnLfkz5nFwMzrQkojoZBx2Mp8ZL3hxvCOm1CTASbGDlD2
	 QNlJfwRh0lHkpTd2ZBQttPtIWBlQBkFTWl0DzCN9RzjUGlO/oWMMFupVk+Hq/6PLnCg2f
	 8wAeqMp9lNh/96fE1waB7w70MzbjX2RQOSpP2lLsAlwRhl5e+5plhX9DL6HWyLGiRbjU8
	 9v66yUP+zmBxlorD8RlY06OYTIOzsgxil3aJeEy44AowckQZS6wHciJcoKQpntLiGUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aial8Kul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3CC606A321;
	Wed, 25 Nov 2026 15:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aial8Kul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9871F000C6;
	Wed, 25 Nov 2026 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618855;
	bh=u9E8pkj3RvCv+sGHJSAO7pRe/QnhzOScM+l1tYM0eeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aial8Kulx2jD/Pg/vFUr+7AfcskOcQJzy9jaobq3Ph53alczmgsv42KmyVch2BoWT
	 cHEpKn/2car14mIGNOM0gUv53ZWdMZMVqMpBHr6tT+rnl1Begva53Gec+dwXbfzJG5
	 H3AcH8D2wL/dhY1PHMb1B+NvgYMWlV6OKebT8wmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jesper L. Nielsen" <jln@pascal-audio.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0365/1005] net: ethernet: ti: am65-cpts: keep port and direction when matching PTPv1 TX timestamps
Date: Wed, 25 Nov 2026 15:28:23 +0100
Message-ID: <20261125143830.281779528@linuxfoundation.org>
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

From: Jesper L. Nielsen <jln@pascal-audio.com>

[ Upstream commit c4b75e64aa5b1adc75b4f1f251b5e3baa5b75b09 ]

The CPTS reports the message type of a timestamp event using the PTPv2
header layout, i.e. the low nibble of the first header byte. In a PTPv1
header that byte is the upper byte of versionPTP and always 0, so every
PTPv1 event is reported as message type 0, while
am65_skb_get_mtype_seqid() reads the PTPv1 message type from the control
field. To make PTPv1 match at all, commit 1b9e743e923b ("net: ethernet:
ti: am65-cpts: Fix PTPv1 message type on TX packets") overwrites the
whole value compared against the skb with the skb's own value once the
sequence ids are equal. That throws away the event type and the port
number of the event as well, so a PTPv1 skb matches any TX event with
the same sequence id on either port. For PTPv1 this defeats
commit a23c657e332f ("net: ethernet: ti: am65-cpsw: Use also port
number to identify timestamps"). The overwritten value also sticks for
the rest of the TX queue walk.

Since every PTPv1 frame reads as message type 0, the hardware timestamps
all PTPv1 frames to UDP ports 319 and 320, including Follow_Up and
Delay_Resp, for which no skb waits. With a PTPv1 master on both ports
whose sequence ids run in step (e.g. a Dante device with primary and
secondary network started at the same time), the unclaimed TX event of
Follow_Up N on one port is still on the event list when the other port
queues Sync N, and am65_cpts_find_tx_ts() tries to match before it
checks for expiry. Sync N then gets the transmit time of the other
port's Follow_Up N, and the master announces a preciseOriginTimestamp up
to one Sync interval early to every slave on that network.

For PTPv1 replace only the message type of the event with the skb's and
keep its event type, port number and sequence id, and compute the value
per skb.

Tested on AM62x with ti-linux-6.12.y and the port number commit backported:
without this patch every boot in which both ports started PTP together
(10 of 10) sent wrong Sync timestamps, with it none did (0 of 29).

The bug was tracked down, and this fix and changelog drafted, with the
help of an AI coding assistant (Claude). I reviewed and tested it on
hardware as described above.

Fixes: a23c657e332f ("net: ethernet: ti: am65-cpsw: Use also port number to identify timestamps")
Signed-off-by: Jesper L. Nielsen <jln@pascal-audio.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261103-am65-cpts-ptpv1-v2-1-e1f79ed1ba60@pascal-audio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 31 +++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 0d71147f3c291..ca885405fea0c 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -811,6 +811,28 @@ static struct ptp_clock_info am65_ptp_info = {
 	.do_aux_work	= am65_cpts_ts_work,
 };
 
+/* The CPTS decodes the message type of an event using the PTPv2 header
+ * layout. For PTPv1 that nibble is part of versionPTP and always reads 0,
+ * while am65_skb_get_mtype_seqid() takes the message type from the PTPv1
+ * control field. For PTPv1 take the message type from the skb, but keep
+ * the event type, port number and sequence id of the event so that an
+ * event only matches a packet of the same direction on the same port.
+ */
+static u32 am65_cpts_event_mtype_seqid(struct am65_cpts_event *event,
+				       u32 skb_mtype_seqid,
+				       unsigned int ptp_class)
+{
+	u32 mtype_seqid = event->event1;
+
+	if (ptp_class & PTP_CLASS_V1) {
+		mtype_seqid &= ~AM65_CPTS_EVENT_1_MESSAGE_TYPE_MASK;
+		mtype_seqid |= skb_mtype_seqid &
+			       AM65_CPTS_EVENT_1_MESSAGE_TYPE_MASK;
+	}
+
+	return mtype_seqid;
+}
+
 static bool am65_cpts_match_tx_ts(struct am65_cpts *cpts,
 				  struct am65_cpts_event *event)
 {
@@ -820,7 +842,6 @@ static bool am65_cpts_match_tx_ts(struct am65_cpts *cpts,
 	bool found = false;
 	u32 mtype_seqid;
 
-	mtype_seqid = event->event1;
 	__skb_queue_head_init(&txq_list);
 
 	spin_lock_irqsave(&cpts->txq.lock, flags);
@@ -833,11 +854,9 @@ static bool am65_cpts_match_tx_ts(struct am65_cpts *cpts,
 		struct am65_cpts_skb_cb_data *skb_cb =
 					(struct am65_cpts_skb_cb_data *)skb->cb;
 
-		if ((ptp_classify_raw(skb) & PTP_CLASS_V1) &&
-		    ((mtype_seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK) ==
-		     (skb_cb->skb_mtype_seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK)))
-			mtype_seqid = skb_cb->skb_mtype_seqid;
-
+		mtype_seqid = am65_cpts_event_mtype_seqid(event,
+							  skb_cb->skb_mtype_seqid,
+							  ptp_classify_raw(skb));
 		if (mtype_seqid == skb_cb->skb_mtype_seqid) {
 			u64 ns = event->timestamp;
 
-- 
2.53.0



