Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064323;
	b=bLRgzWubrdP3rEn15DCiI7OqkrGcO0zm/xEBkhKQPsyceSdwZvqUaxtuIB4qsQPpI4+i
	 ivKM7+XA7OjLRecmmtwTpAkcRV4wJnitrSBoGUENIDmzhlKenrxQljKcj3Kduoz3rsYiL
	 K2s6XE4Gs7SgR96R0j3Pb9PgWb6FjQo1/CYd1mG2HBBJ2m6LJiPGY/BeqNPdKzbiZ0917
	 P16Yg2sP70flVyi8Cno+V75e/b9IN9JMtfxsQ+Sr0Rob5apNkTtA0BVxdCErkvAHMMfhH
	 bkg1p2Iq8H9ISqqE+v+JZnIERQCY5sdl8SHGOlE+iV3jPfrz/07zZ9LgxXU9BnNw5WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37hqiT9NJhaYdHgs3cSADFRFJvrFjPt9DNr1oOmWM3s=;
	b=4Bx8zZQiAG2Syf3FW+CNG4sTAFxG+KCXM7GWOmglDDLgQTMqxcHlbwYEmhtqS0c/txPe
	 bvxS+rHpzbH1Alw6unYgcPBoVq2laAp4Of7Ygv7WwydXtgTInRtYMSuYLmJgfhbRBkPEH
	 9yB4I0qzSrhsfvhurat0N5X3U7spdsapsye5gGG1CvA2uD+6hBZe90CkEorS+9VbXHgv+
	 WG5G1Ut99zRBmMoJnPll7OyCj6XBj+PDftewb1fWHaZeW3CPQgJ8LAh+Z3Y2pJ6QtwYbM
	 Y2Trgy7SFYG1mNMwya+rW+p2p3/jQn/dkm5eCiHqJCOmvjI23g5iUK+27Iz+hMkLyFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czXF+MUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2892C606B880;
	Sat,  7 Nov 2026 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czXF+MUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CD71F0089F;
	Sat,  7 Nov 2026 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064322;
	bh=37hqiT9NJhaYdHgs3cSADFRFJvrFjPt9DNr1oOmWM3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czXF+MUvU8GbUS2QRLD9X718GLim5NfIMbnAUZhtj7whd4jlQgW7ZEJHBLXA0CoXn
	 LByC9o7apg3YKUXyGHGzACyS8tiYMfNoS/+KzfWQE4Isw6FMFQJutE0JJ4SAz/HIhs
	 VdZfJWGJ/eD3BAz0ss6ZkXXOLGaGKnIQQKIJv6iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0410/1257] media: tw686x: fix V4L2 device lifetime on probe failure
Date: Sat,  7 Nov 2026 08:45:06 -0500
Message-ID: <20261107134950.841561288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 5a4ab329c06e9..1e3079bb8bb45 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -241,6 +241,7 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 			const struct pci_device_id *pci_id)
 {
 	struct tw686x_dev *dev;
+	unsigned long flags;
 	int err;
 
 	dev = kzalloc_obj(*dev);
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



