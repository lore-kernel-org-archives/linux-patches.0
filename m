Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031911;
	b=Woj0zkJTZKZilBqjrhFVShyRslzYzhbv5UqKLa+2b3Fvpo3NfZ66z3FP02GMXIoDxgo6
	 L0L9PQ1OGOaq9xJ+PmS4OjAo8CL6zVaxBe9i2pmSDCx9NOSMg6OBw3JzBJLc1T4YOcARY
	 BW6ZRlG6oBjGOQC2L4VZdtPjcuhl2mHTZ5x5qmo3+Sb50nlkgqRQhdAROMFXagbcSKS5C
	 /5nPQS4eQHCaBnyvnpY279bnjq7GZTIlvYP6BG6gu5jV3TcCTEG/JVTcYlMo8dciJHR0P
	 WdEEf7jXx9nd5+hqe4W2kZTHWf12OlhxCicKrV6kvH2iZeKfAc1WDOzfKD6DIZd+PQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=coP22R2Otbn4wV/LOxHK1hCqpPUEO4tdhuIhCF4+i20=;
	b=o8KongbQOpZn0K2219oxpQO3JkG4zdEe7nIPldLQzP7gm/LNESXH9/LNMxYPMudL9nw/
	 NqfgOFh7Bouk3jIDC7W9/ouWcwQbLrgnmLxWEGMz7rRZDgbsIpeYRVkvj9eyKHMEdF92T
	 34KT6UxTEvyNYXqJlJRT2RBWHiOwTo7rPK+C/Os5dr+ysXJH2//gUCGnQ+fKjTiaGPpgp
	 AUmq2zmfi42svBZAv5BTxPjVy56Ds7jzwOMNtWxuqxd+1LYSH7BntwjkeVzAnj6rBUYml
	 yfofhH3rW7YZq0cZoAvYAnpZztolaelqVuftRncvEswJq2mT2UZ0ThkRMXOXKlkN10w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q56pz7Xd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136FE606A32C;
	Wed, 18 Nov 2026 19:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q56pz7Xd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AABF1F000C5;
	Wed, 18 Nov 2026 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031910;
	bh=coP22R2Otbn4wV/LOxHK1hCqpPUEO4tdhuIhCF4+i20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q56pz7XdjVkeTDlekwXetteyUpXyT96IZm/nP7Ij95v8Y/5XcyWc76S6874Wf6NrX
	 8a3JWhajTc+k7S+QuZDE1+/wEhOovD0vV0JrZQq2sNBiEqm3u+SrdHCNw+CbkuACjU
	 JIp6PwqYc1UvMsOt+psbieN92Z2zFzKCmjv9f0K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1224/1756] Bluetooth: btusb: Preserve event and ACL packet ordering
Date: Wed, 18 Nov 2026 15:55:51 +0100
Message-ID: <20261118150058.553713061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 50cbf9d821bac..6142546c387ee 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1210,13 +1210,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
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



