Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045219;
	b=uaUNScXY7/SJEidVB0df9k5UXiDTP5iyoN5VJt6aZMIbXhGZSMgbGNXqcaBmtBa/xm0B
	 /ab/XVK2L9fJoutkWbgWOIUvMu3Q51mXYIywzKxUq0/fkxhWiuRx8kWt1mvcj8BfNZZfd
	 UyvSRM+/W71Ha/bQ+SNaBy3qaJiS2yowUcee2Mo5HYTWTf8/O/+YMwL7szDK7hc0jRDJg
	 +bO3bqdQ+5BgMSSMYBuGW+VLwVr837ZyuyfTS3XuQPav1uAc2G8BI1sDk5QXBZ5lEizh6
	 511DAeu8eYkwrRb+nOpYv3ZP1yqLwI9MiBwAb4huhhtQw9CZOFXHio3LLvwsJJs84Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bt4HmxQSx3UCSC3i0hvf5w71i/BhpPcbC56/aeJfX9g=;
	b=yXLfxvzb8rJxfrsYQ0Y0Oq608AzpE8Z7NJWgWwGg0v1299br3qvYWSHC5GlSbirLLzwP
	 76iHRQujW18Ej0Q9ENQ0w/m/tRHlvEFfzBuxK+2Sku1mzqjKYxs/Sq0b0b0n9JgWnkUaJ
	 9yaushw/gpwKL9TNC9eDMfxaTEPtxIsoteA4p3iQzOXb93uUd3xzxhyKcfCW7FlkqQRMq
	 Roa9isOMFJQ2uPm3cgDMKRrtqHyVtrCg7ujTYl1440VfUfyx9H1d5f6UuzKKFLDvnwOgn
	 pX3EsrLxkfH6s93fRm2nVKNesKZXgYEn83dioKNyK6AqojxqSNr6vYwKmXfkqHQ74HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xM3Kuc0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15782606A325;
	Wed, 18 Nov 2026 23:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xM3Kuc0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6865B1F000C4;
	Wed, 18 Nov 2026 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045218;
	bh=bt4HmxQSx3UCSC3i0hvf5w71i/BhpPcbC56/aeJfX9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xM3Kuc0emrUPgMxwtBjqBPyoSIiuKFjEePDtB+RA9PbHL72XxvHxpJ94ncGqvISpG
	 IGWPBoobWpVzUNLRnX/mNkJ0O8obrPtZB6F6rHZpCYZG2SZTIl/5lcNGtT+MG9nPXK
	 mlq2wzZEAN+0Y27PpwGBKDxbyu50X05dnxUfVmUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0846/2857] media: tw686x: fix V4L2 device lifetime on probe failure
Date: Wed, 18 Nov 2026 15:31:20 +0100
Message-ID: <20261118150232.035628567@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ce6c6dd632b3b4a2c2bfc9efd8f656f4d2137dbd ]

tw686x_video_init() registers the V4L2 device, which initializes its
reference count. Successfully registered video devices take additional
references to the V4L2 device as well.

The probe failure paths currently tear down the PCI resources and then
free the channel arrays and the tw686x device directly. This bypasses
the V4L2 device reference count and the tw686x_dev_release() callback.

If a video device still holds a reference, its eventual release will
drop a reference to the already freed V4L2 device. Even when no extra
references remain, directly freeing the device bypasses the lifetime
management established by v4l2_device_register().

After cleaning up the PCI resources, check whether the V4L2 device was
registered. If so, mark the hardware unavailable and drop the driver's
V4L2 device reference, letting tw686x_dev_release() free the backing
objects when the final reference is released. Keep the existing direct
free path for failures that occur before V4L2 device registration.

This issue was found by manual code inspection.

Fixes: 704a84ccdbf1 ("[media] media: Support Intersil/Techwell TW686x-based video capture cards")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw686x/tw686x-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index c53099c958ca8..dc6a2cc433d3a 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -241,6 +241,7 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 			const struct pci_device_id *pci_id)
 {
 	struct tw686x_dev *dev;
+	unsigned long flags;
 	int err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -352,6 +353,15 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 	pci_release_regions(pci_dev);
 disable_pci:
 	pci_disable_device(pci_dev);
+	if (dev->v4l2_dev.dev) {
+		spin_lock_irqsave(&dev->lock, flags);
+		dev->pci_dev = NULL;
+		spin_unlock_irqrestore(&dev->lock, flags);
+
+		v4l2_device_put(&dev->v4l2_dev);
+		return err;
+	}
+
 free_audio:
 	kfree(dev->audio_channels);
 free_video:
-- 
2.53.0



