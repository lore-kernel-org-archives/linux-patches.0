Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019029;
	b=b21q8U1nc19MnViZwJCVCBGF9lOrKcxlfvNnQCaWRp3KHClAHR2lzUMlzhWHVfhWi4mP
	 n9dMJt+dAtB9RFy/6wCKMoi9ToE17t60EikkpEzs/zqnnTX2MPl9k6JApV+4QN30eA5Tx
	 PFVKSPrjhTyk75IYEtz0hJfVq4Rxmwgsi2/BPr7BMYU8QjUo1r2aDkQ8/Qtq1onN2IAhc
	 4fnuSp67ViE/4jbJ7AeyI8RSanY7T9nU3rCqIWrqh5PilSHujiTdB7xCjtjsJ+C+QWR/o
	 h9G+W9p7aj7K6MdafwVYHOkRDO+xIswVO5Rfa7dcC65BwyvUTF8R8JD+4o4/692g4hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FqWkb0sRNq3nHnqWP7/APxDpW1ehE6eaA1vkHLb87aI=;
	b=luV+khjjPFrXFY8xhBtiPoxnMSLx2MZBhiD1wcENY1A2FkZuocqPWIT6W0NNwhznzy2e
	 K64MTFqw8zv5J6Iilxyc0TZS6tW2/b4s0wPlWuk1ylAp8eM0pAn8P+tSV3RDyN8Elz+3t
	 R2yZEmrf+ldbPIeuTERnWwvA6YhzPH0ZpBVrcmT6Pzau42hytnRnluDXQX5je9geBCzC7
	 zmKHB0ysnaJ8d/DF1wo4wrVr+cwxmOBjvlYzhIQU2yGNiDAk8C47FmLQZR+oB3y0fRdwd
	 FGEBAzN1wbqwgkOaCLAxHp6+WCTMPz60tq6SFLu4e5uJE3xXOxVwIU7GJZMwGkJLrhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3E1mXKE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672E0606A320;
	Wed, 18 Nov 2026 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3E1mXKE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5401F000C4;
	Wed, 18 Nov 2026 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019029;
	bh=FqWkb0sRNq3nHnqWP7/APxDpW1ehE6eaA1vkHLb87aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3E1mXKEeNRHZYDD7QsDAdvNmxakKDfwnAUs4wVwegt/Kd7SO1l+UNDEIqYCQpZJK
	 0x2bGxjM7JiSdp/i3dEpLgJnQxPja05yU6kFIwNhSSJUukBLtlFPPp28fEvBuWqoc6
	 4WMLWSw9aVDBQdxz5DF2ieGI5WzuOylqvhEIY1hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eason Lai <eason.lai@mediatek.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1451/2651] wifi: mt76: mt792x: defer the MCU shutdown past unregister on USB
Date: Wed, 18 Nov 2026 15:44:51 +0100
Message-ID: <20261118150340.276343310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 3c334603f0ecd0ce3db05c068ba775e6e37b7c72 ]

The USB disconnect path abandons the MCU before it unregisters, so the
teardown commands that follow cannot be answered. The response parser
reads the silence as a timeout and starts a chip reset for each one,
queueing the work that was cancelled nine lines earlier and reloading
firmware onto a device being removed.

Shut the MCU down after unregister instead. MT7921AU on a Pi 5, eight
unload cycles per arm:

    unload         5.67 s -> 2.81 s
    MCU timeouts   8      -> 0
    reset queued   8/8    -> 0/8

Deauthorizing the port with the link up, to cover a surprise removal,
goes from 3.21 s to 0.33 s.

Fixes: 7910bd565d8b ("wifi: mt76: mt792x: quiesce USB paths on disconnect")
Tested-by: Eason Lai <eason.lai@mediatek.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260923172424.24021-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
index 850f6b2cfc4aa..5e19e64a9a009 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
@@ -502,21 +502,26 @@ void mt792xu_disconnect(struct usb_interface *usb_intf)
 		return;
 
 	set_bit(MT76_RESET, &dev->mphy.state);
-	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
-	wake_up(&dev->mt76.mcu.wait);
-	skb_queue_purge(&dev->mt76.mcu.res_q);
 
-	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt792xu_reset_work_cleanup(dev);
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mphy.state)) {
+		set_bit(MT76_MCU_RESET, &dev->mphy.state);
+		wake_up(&dev->mt76.mcu.wait);
+		skb_queue_purge(&dev->mt76.mcu.res_q);
+		cancel_work_sync(&dev->reset_work);
 		set_bit(MT76_REMOVED, &dev->mphy.state);
 		return;
 	}
 
 	mt76_unregister_device(&dev->mt76);
+
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
+	wake_up(&dev->mt76.mcu.wait);
+	skb_queue_purge(&dev->mt76.mcu.res_q);
+	cancel_work_sync(&dev->reset_work);
 	mt792xu_cleanup(dev);
 	set_bit(MT76_REMOVED, &dev->mphy.state);
 
-- 
2.53.0



