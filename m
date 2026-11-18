Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058337;
	b=HtAq+CTiQ31YVEalmX6PbtyHCsVTknzU5mIvGLnhguLj+iBibtO2Z3nfIApBh6ssnpk5
	 ++u8KqEyKtxQIgAn0+Pdc9KHLnQj0v5gA1rgSbBUueX+dKwYA5lYfbiJkXPc8D5ODKm2s
	 pTs0H+AzzkALMYuI5P/petbhoMlHC8lQXPgJuxnDZO5o+mWkhq0PFev4Jlxlld6l5Z4I8
	 94oECgcm/oEbLijG1NInSeXNiny3ySc64liws/lmXuAAcLdjw6mpqj0cyg1qPx2IHeXC/
	 cFZ2LuPofZG4p3T1Z0fPNJI/iGCZo/7zzr+yf8LtQCfas18XSihZs2u4SJBvvDzGAOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qU6MnUEUagcX6BHcqRpPWxV+kvtsls/Y7lII4+In4cI=;
	b=q3ZdUkYNTLdVuCsNZW5Hu31n/noM/oICJpf+2QqTUkmx+/nQSC2wDRbP56/kKTBQ14Vk
	 PHsExXbkWm8sdN11KDK+F6qztkogarZPzhYdlcBnkMHg85ZdO/JRgxM+b2Th43ZbuCuSR
	 Q1HVqlvWdDgzhMOvM1efCn/XX0EEWGF9FY8QZUDsb8w/6TeDZkKkzRPlbGN9P0fyOYP/e
	 TR/M+rTPy26JlgWHfXu0aUpnkHDkanZoZ6CuPCsg9p9qaHfqFu4UvSYE3nZ08oaePs1FS
	 0mSeyD0jKHWcSetzIfxlR2GYa1Jq63XSQY2Ed+80qcZyhe7s/PnGTxOeF8wekhaSRtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UTyb32/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCAC606A32A;
	Thu, 19 Nov 2026 03:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UTyb32/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7B21F000C4;
	Thu, 19 Nov 2026 03:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058337;
	bh=qU6MnUEUagcX6BHcqRpPWxV+kvtsls/Y7lII4+In4cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTyb32/EqtIpAAbKvw1jvW1eVHQ04d6IeakyQOcc8FXgUwS8xH00XoGGX3Tf67cFE
	 l/6wNY1mzfN1MnQsb6eCy11Yg/r7+YA4MQCzok8UzNLkJrDC6RZglXMUOJNXFFPTMs
	 K652KV8ZuQpBgzfFMyPi4lRNqGo5hT2GsoRpopJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0451/1848] media: tw686x: fix V4L2 device lifetime on probe failure
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118145933.356494597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a25a0dac4aeb..796f979113c56 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -241,6 +241,7 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 			const struct pci_device_id *pci_id)
 {
 	struct tw686x_dev *dev;
+	unsigned long flags;
 	int err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -349,6 +350,15 @@ static int tw686x_probe(struct pci_dev *pci_dev,
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



