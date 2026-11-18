Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041627;
	b=XFc7Zqx30O7GG/s1tFi9PmSEgV1kaL09I+qHdvBTqemCS7UL16sZCOrfUqk2fdbsm6KN
	 uMtDTSAxyDQGFesg+X6n26W2OH4oGV3v+KxaYke4QQYRg29IxPVzRD1bKcpP5dCQBRRX4
	 lf7oOnZiSLmcxrhWJ+eC4sXl8eT+sR+4uVHstPBbB5qye8P+M5+Q6/FyfXbQy6rc+SXz6
	 tcl6DhwniJfeMVAwqrfe7XsIANY05aiWmH/tmUMRUqAyA91RFstl6ncTRMRcVbC7tW6kd
	 8kiS7qUfTFlrnYdLvHpvKVWSFhakZRjSPfIGLntdwLUEfx56viKbFHuWYg8lF8hryHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=klzSXalb0dtE3lMFSWtDZ+C3+GtnijGwtjerg1qxLg8=;
	b=LahZPV4S8I1LukzA8Ywh6qimqFnbXdlUK8eHpt1Zal69yywExgU8sx+Ex/vw8WZQvnY3
	 /ZkNjOwT54y4MpPWag/F57ir8OlPeHyicrWSuDjHU80fb5nrnvJeLeYnJe1aBKP460wQZ
	 UAXsONwBiyj3C85sUVZSxvWsNQ9H0nD2mupJpxso8Eq8pzDApXf4nk1jI0nENtcJyRYJH
	 8FbvqpELbqlXr3aJoGp3F3y8oLObKQNRwIBOfVZm7ONZWGdeZeYzOfmg9nR2Gf3p6yXSi
	 38WPPCLH3FjHEzueqUrRnE+T8OvZ32gQ/gYCkfWG2fkC1OMzrvou9cOuIWjYaqfHWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5doMHpr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC3606A6C5;
	Wed, 18 Nov 2026 22:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5doMHpr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725121F000C4;
	Wed, 18 Nov 2026 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041627;
	bh=klzSXalb0dtE3lMFSWtDZ+C3+GtnijGwtjerg1qxLg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5doMHpr6Am+SCfU2CvM7ATt4kXSG42uy3qbtAYSdykPLqo8mmOYWEBgVUBlyMNC3
	 JmdFTwJ57mqZL4umOpjQSwCBtuO3IV9p/OQK+pVcuRsqdY0R+n72rjjouNaHaazj1v
	 fRA997huVV5Km6MbrwdZ6h2LGgKTaQvZ2l1suEbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2880/3318] Bluetooth: btusb: Preserve event and ACL packet ordering
Date: Wed, 18 Nov 2026 15:58:22 +0100
Message-ID: <20261118150446.934929832@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit fa96916cfd05ceb1c26af0b2ea73daf5481cad2d ]

When force_poll_sync is enabled, commit 800fe5ec302e ("Bluetooth:
btusb: Add support for queuing during polling interval") defers ACL
delivery to the RX worker. The event path currently wakes that worker
before delivering the event, so queued ACL data can reach HCI first.

Deliver the event before waking the worker. This preserves the intended
event-first ordering and the event callback's return value.

Fixes: 800fe5ec302e ("Bluetooth: btusb: Add support for queuing during polling interval")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3500e74eb0389..38dbc3ba83e62 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1162,13 +1162,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
 static int btusb_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
+	int err;
+
+	err = data->recv_event(hdev, skb);
 
 	if (data->intr_interval) {
 		/* Trigger dequeue immediatelly if an event is received */
 		schedule_delayed_work(&data->rx_work, 0);
 	}
 
-	return data->recv_event(hdev, skb);
+	return err;
 }
 
 static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
-- 
2.53.0



