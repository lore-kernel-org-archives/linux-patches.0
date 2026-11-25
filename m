Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621287;
	b=g+ej234fHG0vgdRmW70Zyl7PH6PW1iSLmB1YaoFxqUMooeVUGQLnd80aHqzyBueVOsHg
	 gkmK93LeaexqCtwjFYcXRzQSgpM/O0cVOE6/Pxt89vguoFRYQi/isjxqldjwXNIomwkDM
	 yf4Q5y8xnHPvXUKbo4ZguXf/TDA7MYefgMVIx5XvD0NrWI7gOrQmp9X9GP5ZzoCV1Qtxj
	 cxMIK9qu5PueRpAAImfTBTrh3oHfTIl2e8jgT920B+WLC3U5umIul7B5gI94YXxHJg7bM
	 zA6w9cRl3GmG2DoQopdE0YI+OUG6RJG28E3T7nXnnIE3A+TN3nMJniw5IVoME8bKC5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NuOfJv39rYUJf7iACobkJo/2sYzVsMznBzMuLMg2XLg=;
	b=RjggRYnVK43NxUpORZm+02u5WRRhDYoM7ZEsVcp5+oIvfnWNV4TGsK7H1A87M46UYprq
	 S9COcfED4mIlzQvbwG9TroQhoGLhw5V6mLThKuVCjWmDBczbguZKvfIshmggkFp67G4Kr
	 6pAfc2m4Johs6eLGeMKQbe+KEbNEQNB3H1PkoNmQAIN6mKBbmGiQd2xOLIAaBa7JbzfjJ
	 SiWSAur61b/Z0YRRkjTVqF9j68AACaBUJUY5CNjI+eFrlthEMRsVt7+28R72ORElgDHCv
	 5ct42PWEOzH59YeCoT9j9i/Iu+thbKaesgkG2daL0AbIwXLoYWF3amJxsrTyQYikwew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwDVBGU9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C249060A5BC7;
	Wed, 25 Nov 2026 15:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwDVBGU9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587E91F000EE;
	Wed, 25 Nov 2026 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621286;
	bh=NuOfJv39rYUJf7iACobkJo/2sYzVsMznBzMuLMg2XLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwDVBGU9h4KUQBGF59RkQYC1n/T6aPnJEZqkno98DlDbL1AsZthmCbisG1FN8lAqN
	 iaZ2i6M4cHervnkerlcbqctw5Y8pDpzqFCewve6Li6EK8EUxAQt81XwPbPFtKjuOEQ
	 85VE25djjb7DAE8hfGA7IJWrQ4Ir97LsV4t2cJwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Wenlong Tian <ot_wenlong.tian@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/990] Bluetooth: btmtk: bound the ISO payload length by the controllers MTU
Date: Wed, 25 Nov 2026 15:25:46 +0100
Message-ID: <20261125143826.284082194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit d015faf684129a276f2137ad2e11c6c985294648 ]

btmtk_recv_isopkt() bounds the Data_Total_Length reported by the
controller with skb_tailroom(skb) < hci_skb_expect(skb). That keeps the
reassembly inside the skb, but it enforces no protocol limit: the head
allocation is rounded up to the next kmalloc bucket and skb_tailroom()
reports what the bucket can hold rather than what was requested, which is
several hundred bytes more. An oversized length therefore passes, and the
parser keeps pulling bytes out of the following transfers to fill it,
swallowing the real ISO packets they carry until the frame is handed to
hci_recv_frame().

The controller reports the largest ISO_Data_Packet_Length it will send in
LE Read Buffer Size [v2], which hci_cc_le_read_buffer_size_v2() keeps in
hdev->iso_mtu. Once that is available, bound the length by it and size the
receive skb to hold that much plus the 4-byte header. HCI_MAX_ISO_SIZE is
kept only as a fallback for the window before the command completes.

Keep the skb_tailroom() test as well, because a fragment started before
hdev->iso_mtu was populated sits in an skb sized for the fallback.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Co-developed-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Co-developed-by: Wenlong Tian <ot_wenlong.tian@mediatek.com>
Signed-off-by: Wenlong Tian <ot_wenlong.tian@mediatek.com>
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 51b55eceba5f1..1518b93f4676d 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1168,8 +1168,15 @@ static int btmtk_recv_isopkt(struct hci_dev *hdev, void *buffer, int count)
 	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
 	struct sk_buff *skb;
 	unsigned long flags;
+	unsigned int iso_mtu;
 	int err = 0;
 
+	/* The controller reports the largest Data_Total_Length it will send in
+	 * LE Read Buffer Size [v2]. Fall back to HCI_MAX_ISO_SIZE while that
+	 * command has not completed yet.
+	 */
+	iso_mtu = hdev->iso_mtu ? hdev->iso_mtu : HCI_MAX_ISO_SIZE;
+
 	spin_lock_irqsave(&btmtk_data->isorxlock, flags);
 	skb = btmtk_data->isopkt_skb;
 
@@ -1185,7 +1192,8 @@ static int btmtk_recv_isopkt(struct hci_dev *hdev, void *buffer, int count)
 			if (mem_is_zero(buffer, count))
 				break;
 
-			skb = bt_skb_alloc(HCI_MAX_ISO_SIZE, GFP_ATOMIC);
+			skb = bt_skb_alloc(HCI_ISO_HDR_SIZE + iso_mtu,
+					   GFP_ATOMIC);
 			if (!skb) {
 				err = -ENOMEM;
 				break;
@@ -1219,7 +1227,13 @@ static int btmtk_recv_isopkt(struct hci_dev *hdev, void *buffer, int count)
 				break;
 			}
 
-			if (skb_tailroom(skb) < hci_skb_expect(skb)) {
+			/* Reject a length the controller said it would never
+			 * send. The skb_tailroom() test is kept because a
+			 * fragment started before hdev->iso_mtu was populated
+			 * sits in a smaller skb than iso_mtu now allows.
+			 */
+			if (hci_skb_expect(skb) > iso_mtu ||
+			    skb_tailroom(skb) < hci_skb_expect(skb)) {
 				kfree_skb(skb);
 				skb = NULL;
 
-- 
2.53.0



