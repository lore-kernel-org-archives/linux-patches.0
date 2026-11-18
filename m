Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026708;
	b=BWe+TvybKodvqKjHVUfCNTkz5ZZvSKQhHKmW7N5pE3Eq2AFs7lYjz/6GXW2fhi6Diab7
	 Lv2PiGeJwGTPhsBOUiZkzvKtFZbU+QMbn9BIfFyfrCS5x7IMF8ZPh6ZcnSB8MiP42QOJl
	 KmiOlr1rWTM1xgi78P03HOK0IJTQ1ZIPa059QbXh2lNaXDGvj6n2QQshRCVWLq3EKtbjy
	 oIBPa0dNIg+08V3TTeM/0kFKdNTXiQTk72F/SsE8oYKRw3nglImUKOfga8NqpVV+PcwQt
	 /FXkgmn44T8OytK23kg1vCqXTxxQUaNbcpjRj8ww20A2TM2Dij6MGfVa8VtbHmi1uYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kojsyxm7pRYZldprCNbLIF/oQG7S9MlcYgTJS/JndZs=;
	b=UrVWKXvR4d+hkBsns8+1wDXgkSS5T4rE7Z10ogkQ/HGjAdano3G1L8gQZrVvNh59qVWb
	 EyuvKRw/ilDVtdBCIcngNPduo8P8eBv6hJWI2ziUJiyVt+LTvxReG/2+6CUmPvcDj/+KO
	 8HwNKB8zeHWs7DZC62vdhsZHHb2R3+nhpz9g14LejgWVLLGjg3tPMlnSc4kO7vyRVxDF3
	 rnDdunuu2u3s05ka0AerBUH/zrEDWZsjw0wWKRjoQeR10Gh1hAOKhGsR2WXGgpkyrOCC/
	 DeQ2W35/X/8TSLmbu1tQuJXQqDKPnbF82VoLRtYw2jqyZ+tHzqdrGYrfO9vdBm3RPEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oUcT/J8l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD9606A31C;
	Wed, 18 Nov 2026 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUcT/J8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2092F1F000C4;
	Wed, 18 Nov 2026 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026708;
	bh=kojsyxm7pRYZldprCNbLIF/oQG7S9MlcYgTJS/JndZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUcT/J8lfOsnckHYOX8lVbj/qYChNkJwrgkD604+K0baVRfSlvE9UUeRPB3mvanxK
	 QP0bYTLWj6GyDcFlY4KIzKLwz2ZQ2ymKDEzjexAK6qf5w9TWOu4KXOcgL56CQAN8wN
	 aG2aWa1QSLqwhcfl+SE5wja8I/m6rkqFpVGTwLps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1531/2151] Bluetooth: btusb: Preserve event and ACL packet ordering
Date: Wed, 18 Nov 2026 15:54:26 +0100
Message-ID: <20261118150217.595429129@linuxfoundation.org>
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
index 509da5c2efcd6..6143414711c5d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1217,13 +1217,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
 static int btusb_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
+	int err;
+
+	err = data->recv_event(hdev, skb);
 
 	if (data->intr_interval) {
 		/* Trigger dequeue immediately if an event is received */
 		schedule_delayed_work(&data->rx_work, 0);
 	}
 
-	return data->recv_event(hdev, skb);
+	return err;
 }
 
 static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
-- 
2.53.0



