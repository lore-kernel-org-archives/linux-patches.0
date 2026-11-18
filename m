Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049826;
	b=VwusWg0IlvUEYNkwv3dYTlId7V61DbArfCGNz6mqFfL8JB8IW8O0zWxmUvnXa+7OZMs0
	 j4jzHL5vFNDY7bqJbeR2BIxWTr/H/JmVw0mPsPGQm3Y0G+SBw/oT45om4YKxhP/vFvrzI
	 SWjZbaz+OJv1LnKacUxL9XPMZYIuN0nlSKiHJauHryfWFbulvXzDTjItMF+C6E4mGEFRx
	 dKWZ2VfXI8VCnvast7gyvT//b16K3LZhHK6DxYg11Olh9YDXhek9ca+M3fcn/8hvzp5QZ
	 1s8LowZWN3fhZgWs1hGj2y4Lpda3RbuF0Spt1ts+Ag1+hvxZekJUfMwQcMLPo6Fz0cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5pN+oIPGOQLFyHb2bCDUIV/SyqxS7et800jrMyqW4aw=;
	b=sb/ObY+voCpTn5UOVPJ0kgNs3aEA+gAVPvme8bn8FUoVDW0pmzhTwcCjNz8rx7ObMqXA
	 3juXptD7mb/P9dhP2LFbZaOdQ7KqFHlEh2xgrx+cmPCDRsxB/3AKISk2ps+ITacBNuvKC
	 Gaxq8sWRvWXB4m3JdB9qNXGP3N0wFRSGcQOQfxQyhdCYTbhLa9PkGUldtg5VxYfdnukiF
	 HgRQUf1+KXTeGvBHpf2RYa52+q9XfpHbXQbPnjstuTdTONMHNaM10aEpczLAIAleRYIQ4
	 bDVQeNx1+9GQp/37ATmarafxf1H45i1bE1Xg0ytP7axUjmFzw8cu8/5AkwjjVFSt/bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zm9r5WRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD53E606A320;
	Thu, 19 Nov 2026 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zm9r5WRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7651F000C4;
	Thu, 19 Nov 2026 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049826;
	bh=5pN+oIPGOQLFyHb2bCDUIV/SyqxS7et800jrMyqW4aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zm9r5WRZ9ZuuPgeyQi07Kgt0Kd1yzafGJziehUuK82iyCJbWIDJQARclar4eHns6m
	 pW6byIxHdiV58q4zoCdIh+KyIE8CxQ6Mw7HrCe8SeK0utWZjkdL/YADvqmcxxcGLF1
	 qjdwuGTbFDA/Vy2rCb7pADcqm97KVwSms7/gUlF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2488/2857] Bluetooth: btusb: Make btusb_recv_{event,acl}() take struct hci_dev *
Date: Wed, 18 Nov 2026 15:58:42 +0100
Message-ID: <20261118150331.147777932@linuxfoundation.org>
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
index 5ed1a89c090bc..433998d65f5bb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -974,14 +974,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
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
@@ -1041,7 +1043,7 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 			}
 
 			/* Complete frame */
-			btusb_recv_event(data, skb);
+			btusb_recv_event(data->hdev, skb);
 			skb = NULL;
 		}
 	}
@@ -1052,13 +1054,15 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
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
@@ -1113,7 +1117,7 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
 
 		if (!hci_skb_expect(skb)) {
 			/* Complete frame */
-			btusb_recv_acl(data, skb);
+			btusb_recv_acl(data->hdev, skb);
 			skb = NULL;
 		}
 	}
-- 
2.53.0



