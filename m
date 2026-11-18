Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026706;
	b=SAuKrmeEnUR+bR8NF1OeeD1GV7Wk7JHuSWlfgA89BoFfePOirfW8clIU3celbHWADqD/
	 SO+kkcGrhCG0n2cJuxnAi5QjeEElnGQXqIV2V6TycIIR7qEL1tIVg38nDpacyS4QRJ3wV
	 nTYu+vaFhVul4HHAqi4046VJSfKJjT3DLGhFLKY3fpjEMqpVSYDAUzGYPcfbcBlDidGT+
	 8pIsNNsIKVH//wjAh3ynKTCxzM3RL0mku8PpyJL83rV6jiJbxHatwMCv7PdkZd9M4uP3Q
	 vTM0oQltinV6oqaCNhoP5nDqEfYrDc8eK3AKPFKRY02i0UjDEtMsolWE0Qtu3khF+VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDc1bzuLu4/E8I9dB4dZ5IDfQPgSRS0aLayCDxQpDqI=;
	b=c4+U/R6SHss0y2eKM62vL7WrjrjFXSEzKVCu5uTwZQh14Pd5GMUk8DwMW3emtzuZjDeG
	 YYFuZylOQEcwMpQNPtdy79aLZHDAKAUReE4qWyXSBKS8LPc548tdB6vQfxVZj0vDHNrFC
	 LaJ71BQ2Qk5IXv7I4z9owW4ilXQ5UwqYdAlV8HixAj5AA7C6XzAKRsGl1Lw3eu+L8bFu8
	 swRhK/8u9ytLqxVfKZZRvwUS7d0enyI7rpLz02I2phSai+krSZRLhDQClwuJK3Y2bKKd6
	 DeJ8eXAKO4HfGREiO9kzAi7aXvJiiWmr4K6I59VswEwLfC9kd/K+z4xv9fpJW98+peA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="weZzb1F/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAA606A31C;
	Wed, 18 Nov 2026 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=weZzb1F/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5C41F000C5;
	Wed, 18 Nov 2026 18:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026705;
	bh=dDc1bzuLu4/E8I9dB4dZ5IDfQPgSRS0aLayCDxQpDqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weZzb1F/60pQrb1wFHEiwGQwBPB8Ep5g6burG8PUUnjTS56oQYo31rEQ9iE4Hs25f
	 ZNldhWYkZcc84X1lMne+WEdgHbbDoz5sviv18pCtbjNuALkZ8CTHHnthN2KzKeY0Ku
	 4CUodL6B0QzslXv7x+smnAr1CgecV3m/+6m42KRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1530/2151] Bluetooth: btusb: Make btusb_recv_{event,acl}() take struct hci_dev *
Date: Wed, 18 Nov 2026 15:54:25 +0100
Message-ID: <20261118150217.561092996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 1ee552949b95f..509da5c2efcd6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1214,14 +1214,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
 	spin_unlock_irqrestore(&data->rxlock, flags);
 }
 
-static int btusb_recv_event(struct btusb_data *data, struct sk_buff *skb)
+static int btusb_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct btusb_data *data = hci_get_drvdata(hdev);
+
 	if (data->intr_interval) {
 		/* Trigger dequeue immediately if an event is received */
 		schedule_delayed_work(&data->rx_work, 0);
 	}
 
-	return data->recv_event(data->hdev, skb);
+	return data->recv_event(hdev, skb);
 }
 
 static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
@@ -1281,7 +1283,7 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 			}
 
 			/* Complete frame */
-			btusb_recv_event(data, skb);
+			btusb_recv_event(data->hdev, skb);
 			skb = NULL;
 		}
 	}
@@ -1292,13 +1294,15 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
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
@@ -1353,7 +1357,7 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
 
 		if (!hci_skb_expect(skb)) {
 			/* Complete frame */
-			btusb_recv_acl(data, skb);
+			btusb_recv_acl(data->hdev, skb);
 			skb = NULL;
 		}
 	}
-- 
2.53.0



