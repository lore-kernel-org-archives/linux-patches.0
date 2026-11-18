Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052414;
	b=ZXS375i+YmUCDQ2ayBaWFlwzo4y0MkDrtXgQ8I3wq7MraOa5KBOqxN+HQsOk44qGzXX9
	 ST3GPipG0rF9bf778t9HvOaSJIkkEYMX0NiotUJn9TKvXhYxvxxSqZYVIl/1v4aFEwjCo
	 rJgisFPtrXBhS5QXTk50Nfxznviz2AsfEB1wmNhB2Fkmxsoh/X6UlnLXhIAo5lp7dNWIX
	 QY1WbRfRUfwrqLRP025DZrIhCeMfEsLfUBzxurjRgiUXsf6SOFYskNJERDRIS4c2Ei9UX
	 Czd3lxPWBxEaWN4doh8jb25dIZeEcIgeqpm0Q9OR7kFM8Q1/0arnA3ifUh+vCufKHzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5A+XPmYtMSs9bAnti6wY1nTN0ULNiN5I37GFNsTZcQ=;
	b=p5d2Yr9oXGv6zvF9lbj+4OC4bckjRDhY/0lIy7ADqy2dO1HvGWIgYZfmTs/zVORcXxUL
	 ELvulDgRVnRr9rHE2TyiY4PyqGuPRmsB4i8CCfvH63aQCozi5La1OLd+K7d1dFUZ4MS85
	 eqQVUOSBdSgj+zVzuLRlnY5eaoFDKTJe0T3UsRoIG0w7pAMk09/OyrvHMGs8ndUg/PuhY
	 Kg+d90XLRT8GpV01xm1XOYmwLx6nFZEMebrTHd7iZjbHK3RFGLnBj8taAfYhy5GYWY4Q0
	 VRAAFF43+bHPy2bCfxp1lnvVQ2Ob1O3v37vHvgq5oiOtMBVp9DjUFbgZNWXG6o57qWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2JdKur5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5805F606A320;
	Thu, 19 Nov 2026 01:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2JdKur5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF2D1F000CA;
	Thu, 19 Nov 2026 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052414;
	bh=J5A+XPmYtMSs9bAnti6wY1nTN0ULNiN5I37GFNsTZcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JdKur5lM0TfPRznqt32qBpY5AzLODCptOGb9yxlCkLkWgS0DTHSpJbB1PUpoIysR
	 lxhqaiksPSKAmHqvAzUic9JdGrsFfkHiiTvfoh197EEq/PQR208sRNLaqPlfgVGsLm
	 uhhxZpeVWck445Q2FMS9efERQa5wTAPo9oPZI2I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0554/2214] media: tw686x: fix V4L2 device lifetime on probe failure
Date: Wed, 18 Nov 2026 15:37:10 +0100
Message-ID: <20261118150033.183485237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 384d38754a4b1..a5e9985701ff4 100644
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



