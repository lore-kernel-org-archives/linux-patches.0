Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622098;
	b=fvg1uL90IBfDOstnTVXI0keYO3+m39RmDhlAXrdySo5lxr3c+OjA1Yl2C+yQ2wHJ+Zw2
	 ChGrNIxD485vYOqu5VTrrCbU7UxpcGxi+cS7vZNNk/Qz0MM4TfW26MM0nXHZHw2PJUcuH
	 N35JtWA0y/80PtOMe2ZWxTrEvAr8D2f/FO8qZOC2I7cZk+IVeHqmrBBuCigOrzdK7Cv1a
	 YuH+Aok0bH0XMkB1QrYnntFxh+OHmuIH51R0H4JQyCT+SiwbiT+f0e48XQn6/AAYeLQW2
	 mUFhCuSWeX3CUAKEULetnRTzIfxlAXgA47R6ZS/bbhwTsiFYWjuZyGf4JLsoOrqhQhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GE0tzxOU41PFzIJTFWHC85vVZb6MtUV+P/mcY6X9Udg=;
	b=gt9cWzSSslpJXIcMK3OQZSINvUs/lSWTnkHUiHcVHFJxDGAgSfvYOd//VeiT3hIvXX7M
	 kBSM+vcP8UNWmkZ5juTggjmYgEOfP2jF++9P/ksrxyPmVJQvX8TTf+2CxmGBiCzPAyumi
	 +j6+MvTKpAsYlK6khEcvwGKgmu+FP1wOHjIrcQ7Eyt0gn6RR/fBiHa2MOH6Hwd2brhtgY
	 /eCcmAgKA6Hs2K0BFvUkTreH70G8YjOJiTwbO/8rK8J81FR7ENLeB4aN8zOvPRz3RnL/e
	 eaYtTDzBWfa4CMzK04Rhh5K6JP9j+YUbZgTN9GcEQ2Q/Gy7u+4a8bk/4u8stKNhSKXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0NeXIp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A80606A323;
	Wed, 25 Nov 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I0NeXIp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479F31F000C4;
	Wed, 25 Nov 2026 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622097;
	bh=GE0tzxOU41PFzIJTFWHC85vVZb6MtUV+P/mcY6X9Udg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0NeXIp+MTUsrIuy7FCYpuxYkbIzLH81ovblOQXFILh0a5tdDWvTlAG87Mfgv9Bu/
	 pVaxdApKj7S6TwbSkdYXcypT/p6tkSMgcMiA8V/VTZ0NTnMUT1tcp0rn30sLJZTjo8
	 1XhzQYkSzkhd78hY86JuNBcCCjEiHrkRSTXvxQKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Valla <francesco@valla.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/990] spi: virtio: move teardown to .remove()
Date: Wed, 25 Nov 2026 15:29:30 +0100
Message-ID: <20261125143831.539680588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Francesco Valla <francesco@valla.it>

[ Upstream commit 9060f5ba658c9b0a7332be55b3d8abfc2b08618b ]

The .remove() callback is not marked as optional for a virtio_driver,
and thus a missing one is a bug. Moreover, the virtio framework expects
a driver to reset the device it controls during teardown and explicitly
checks for this reading the device status and WARNing in case it is
still running. Any devm cleanup action gets however called after that
check, leading to the WARN_ON condition to always be true for
spi-virtio; thus, an empty remove() is not an option.

Move the cleanup actions to the .remove() callback of the driver and
adapt the surrounding code to the new behavior.

Fixes: f98cabe3f6cf ("SPI: Add virtio SPI driver")
Signed-off-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20261108-spi_virtio_remove-v1-1-fda5f0996290@valla.it
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-virtio.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-virtio.c b/drivers/spi/spi-virtio.c
index c92ea19881183..acf9039839547 100644
--- a/drivers/spi/spi-virtio.c
+++ b/drivers/spi/spi-virtio.c
@@ -320,10 +320,8 @@ static int virtio_spi_find_vqs(struct virtio_spi_priv *priv)
 }
 
 /* Function must not be called before virtio_spi_find_vqs() has been run */
-static void virtio_spi_del_vq(void *data)
+static void virtio_spi_del_vq(struct virtio_device *vdev)
 {
-	struct virtio_device *vdev = data;
-
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 }
@@ -354,21 +352,26 @@ static int virtio_spi_probe(struct virtio_device *vdev)
 	if (ret)
 		return dev_err_probe(&vdev->dev, ret, "Cannot setup virtqueues\n");
 
-	/* Register cleanup for virtqueues using devm */
-	ret = devm_add_action_or_reset(&vdev->dev, virtio_spi_del_vq, vdev);
-	if (ret)
-		return dev_err_probe(&vdev->dev, ret, "Cannot register virtqueue cleanup\n");
-
 	virtio_device_ready(vdev);
 
-	/* Use devm version to register controller */
-	ret = devm_spi_register_controller(&vdev->dev, ctrl);
-	if (ret)
+	ret = spi_register_controller(ctrl);
+	if (ret) {
+		virtio_spi_del_vq(vdev);
 		return dev_err_probe(&vdev->dev, ret, "Cannot register controller\n");
+	}
 
 	return 0;
 }
 
+static void virtio_spi_remove(struct virtio_device *vdev)
+{
+	struct spi_controller *ctrl = dev_get_drvdata(&vdev->dev);
+
+	spi_unregister_controller(ctrl);
+
+	virtio_spi_del_vq(vdev);
+}
+
 static int virtio_spi_freeze(struct device *dev)
 {
 	struct spi_controller *ctrl = dev_get_drvdata(dev);
@@ -422,6 +425,7 @@ static struct virtio_driver virtio_spi_driver = {
 	},
 	.id_table = virtio_spi_id_table,
 	.probe = virtio_spi_probe,
+	.remove = virtio_spi_remove,
 };
 module_virtio_driver(virtio_spi_driver);
 
-- 
2.53.0



