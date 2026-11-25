Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624319;
	b=4OThMzMlRUWRPL6OtSsBPBkq5Jdi8wsknnpBuW6x8mFz0kj93nPsdFAsKwAIbc2RERRu
	 B6DSHDCgalVOf9LyJO6jVmqiJl0QyaPj8gEtZK25xy4IKl5Z4Zlcbjuy+JKMtTiYwoy6L
	 5G/ksw0koH/M5kni/ROxHZUUHu4EXEN3FEPvpgtyPyA9TOwf2HmMHTtbu6ZcdXT1hCv1y
	 T31k6sV4BXkERCS4WdVh/U3V+Am0rPVxLPAp+SNzOTSXsqP+1sbb7OG1pACyecVpdN4z+
	 XjLORc7jeYttXpL17jszzq7k6teq7RIhxhLkHM998zgUr+PUcHKAjW+8yHqM0TPgDSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lAnvDBYX6yhTBnWJHCcGA3T857+ZAxFEur8XxUSCAoo=;
	b=e5EuKYCgZYCoWtgkbM9WxYV4lc1y+1DoqrDdq3a8y3mZnofEG60JNBSOS8aGLpHMY9A4
	 M6afmSaH8CUBowO7tAriNG1FwrzVQ4xGEzZ6ESVqrnosiC8VkNoBPDqgEMzbfO3K5lfI6
	 nT2/jEEQTsR4zZIdcJBSPf90ScawnqSkZq+k/fRhdymG4+T3uR/25Oo/G2aSUv3VEDF6n
	 h5vfpXyuqgb/iaBFxnePPz9GaXttOiYUGjbvZbnfMxOLjMw8ekl354pzLJrKMmGOQIa1o
	 n7kTqtj/GESsMlEsw5iYjbqyjy3WTQxVgnQANBXrVLDu/OljuoRzwBo0ihlb4m+sbog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXFtADaK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E3E606A33E;
	Wed, 25 Nov 2026 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXFtADaK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7801F000C4;
	Wed, 25 Nov 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624319;
	bh=lAnvDBYX6yhTBnWJHCcGA3T857+ZAxFEur8XxUSCAoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXFtADaKd9sZ8t/R5j0SgWy1S71zEu2FowRgcz+rqXqORYVDBqzPwdKXsqLbjxr8m
	 shPA/lBl8Q+kBHIwDu+416tT1x8D2JsQyGqOGBdBZS+5yu3kyoVwHKu+S9g2Z1FtBW
	 gb6IKGUBu7tB6IS5DgnnvbuXgT5kVhp/rv4NkHZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Wenlong Tian <ot_wenlong.tian@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/816] Bluetooth: btmtk: bound the ISO payload length by the controllers MTU
Date: Wed, 25 Nov 2026 15:28:23 +0100
Message-ID: <20261125143852.784063249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 212177d7773ee..c1a73ace94938 100644
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



