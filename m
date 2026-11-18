Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041624;
	b=a9qXFNZxU6+K/CF2DYXFKLZpqqz4DuiFsETj/vaTOxEVQ0LwaU7cIAlX5Ri7GYPdQ9CE
	 41BSn3+avAao4yyDwc1iJ7SrOpyHZGuGNaR6jxMM7tI9HsmKimgE0EV3ebGyXmX/rtrb+
	 6IDca3OkxLAkYYgi2nDaFHywAAjGJ/XWkrWxHaZo5bKA42Lh/Ih24hj05p4TVgcEzdwPt
	 SaL+Zh9H20otKDIBV87P4rqmWzhmkaIchSGeekY6z94iuNA2RTkuYsKs937p7J5K9CwlJ
	 HzUUbBxRwX2HIbWK4kymy24WMBcvf9OWDpoVj0VQJp9Bd+5QcMvSxMga3ZWmXDRcFcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cpXvEgR92P4oDeR4sL8jy6orD+lAbeDim6C3x2NJX6o=;
	b=CC5vwOaWVdwf0MrhQu7GvW6EdoZjdHu3NR5PHAr6PBnNt2yhlIVG1v73g/DxQ+yoNffC
	 awJY3bKuG3l195KBu31X4MZ/No1HSYPmzGRAkwf6B5MrFRJ2g+8BnEBC1zoutYq18keKf
	 HIzdCtD3jaw0+FIbObAFOd3T1BdUbiO6BJTbeELzxOSd5LJLuikozJPW2chIeCvOtw5X7
	 lon0XMoEcsJ3zdB4Zlai002F35x/hvja8kQK0P4po+R5zNNnb8tbUlLNJmyt5bI0rQA8f
	 QNPVxp7RvP9bIPd/rIH98Uk09LCfxdgfj7P4e7hlDv7W3tWbTo4sLGe4QuewkfsmkWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCgi7EGT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CD606A6C0;
	Wed, 18 Nov 2026 22:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCgi7EGT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26791F000C4;
	Wed, 18 Nov 2026 22:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041624;
	bh=cpXvEgR92P4oDeR4sL8jy6orD+lAbeDim6C3x2NJX6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCgi7EGTBOo2+O+76Bg8+0pd8NNpJ8df5Ou1hvzMhuprr5Ur9cqlq51xihOlwWdhX
	 dZp8KldPfcMFoB+eidh3bSKHblLJtHzcKY0L7xONcUEen1DJHZWS3AXdeTaw50FdAg
	 wsdyzH/GniYFGNcyGh2K4CUD437TWW0wZCSPyYAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2879/3318] Bluetooth: btusb: Make btusb_recv_{event,acl}() take struct hci_dev *
Date: Wed, 18 Nov 2026 15:58:21 +0100
Message-ID: <20261118150446.906259552@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit d6d15018c8e1527841e39a6a80c60997e594ca70 ]

Both helpers currently take struct btusb_data *, which is private to
btusb.c, as parameter type as below:

  int btusb_recv_event(struct btusb_data *data, struct sk_buff *skb)
  int btusb_recv_acl(struct btusb_data *data, struct sk_buff *skb)

To allow vendor USB-transport-specific source files to share them as
well, change the type to struct hci_dev *.

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: fa96916cfd05 ("Bluetooth: btusb: Preserve event and ACL packet ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 80411a09d8682..3500e74eb0389 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1159,14 +1159,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
 	spin_unlock_irqrestore(&data->rxlock, flags);
 }
 
-static int btusb_recv_event(struct btusb_data *data, struct sk_buff *skb)
+static int btusb_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct btusb_data *data = hci_get_drvdata(hdev);
+
 	if (data->intr_interval) {
 		/* Trigger dequeue immediatelly if an event is received */
 		schedule_delayed_work(&data->rx_work, 0);
 	}
 
-	return data->recv_event(data->hdev, skb);
+	return data->recv_event(hdev, skb);
 }
 
 static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
@@ -1226,7 +1228,7 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 			}
 
 			/* Complete frame */
-			btusb_recv_event(data, skb);
+			btusb_recv_event(data->hdev, skb);
 			skb = NULL;
 		}
 	}
@@ -1237,13 +1239,15 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 	return err;
 }
 
-static int btusb_recv_acl(struct btusb_data *data, struct sk_buff *skb)
+static int btusb_recv_acl(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct btusb_data *data = hci_get_drvdata(hdev);
+
 	/* Only queue ACL packet if intr_interval is set as it means
 	 * force_poll_sync has been enabled.
 	 */
 	if (!data->intr_interval)
-		return data->recv_acl(data->hdev, skb);
+		return data->recv_acl(hdev, skb);
 
 	skb_queue_tail(&data->acl_q, skb);
 	schedule_delayed_work(&data->rx_work, data->intr_interval);
@@ -1298,7 +1302,7 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
 
 		if (!hci_skb_expect(skb)) {
 			/* Complete frame */
-			btusb_recv_acl(data, skb);
+			btusb_recv_acl(data->hdev, skb);
 			skb = NULL;
 		}
 	}
-- 
2.53.0



