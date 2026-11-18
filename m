Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049829;
	b=JdnuEu4JAz3LfTUuRT5f+DGRcMzNOdG1jg9KKthOlgi1F12qVpjQR+Jgw+liM2mA/0Na
	 BySa7IaDJVxRUit6JJ1jC8ivzR7iP6l/QPZ+G5D0ugVSpkliX2+o64WWpMU90a8G3SnfK
	 0Hi+vaak5382li9hCYV/UUztyvSsjKNbcOWZ7sq6cYk57bMBMnK7VxlO6s+HtrXLaiKhX
	 2GWKTa/JS8xdyZADt1AyyD4jPJhWgPI/PEd2aMvVruQdaS6bK+f2a3cqnvxUElL3iDJmw
	 ZwLKTg4p5BH/irWmaMaV3ROBJVvqkH6Gt/3Q/PrHD9oiyTAQ8bpDvznx74cem4JnV9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4JnSBKvWPkkkkRWUF+6dNnhKjaqmiZIwv7RZkCnM0bA=;
	b=YoAqTQj28O1GElwXTJe4NC8tiKemLnCtVrU+dr4vKulHvc9F35NkFkkYSwAEi2RX9tUu
	 8agcAWGin1nFV6TmNrdXYqGxmbzPIr2evs6l0GKaRRJa/l23lp5CmtN8Q0hgz8xXVpJf6
	 9lWnBmGu5KhX9DN/z+QumV4WU7HNv7KWCMF8JFlQ4vA8bLm2d2PQCxa7zJWAuVYJmqEdK
	 Mjz8ULpUvQSSrISMTAqoloGl8e7doX4PSO0j/2rREqdDtjxhtj/sjELhqYp6h1FJYg4eT
	 cZG5MtbkMr29ls3X7WxCVbpyjdeO9ttKMZV7CKAdzQgPi8u0riWoGsvhXhThflbAqyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kN7T8JJa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773A3606A31C;
	Thu, 19 Nov 2026 00:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kN7T8JJa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7351F000C4;
	Thu, 19 Nov 2026 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049829;
	bh=4JnSBKvWPkkkkRWUF+6dNnhKjaqmiZIwv7RZkCnM0bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kN7T8JJalL9D4Sptakchg5e2k8wAJb5zEsc1y7Y9IkMm8j+MbnYpi9oehdg63aEZH
	 MdCyiPXZ8FBIJGTXjJZjCg/+cPtazdjIxz5nH8F6vnSc7oiko0lMxNtph/0OQQh1sU
	 44ZUgTwgfS3Aj789v1SM6RdeUWLRqPE/5F20IcSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2489/2857] Bluetooth: btusb: Preserve event and ACL packet ordering
Date: Wed, 18 Nov 2026 15:58:43 +0100
Message-ID: <20261118150331.183968363@linuxfoundation.org>
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
index 433998d65f5bb..5599f77dc6efd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -977,13 +977,16 @@ static inline void btusb_free_frags(struct btusb_data *data)
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



