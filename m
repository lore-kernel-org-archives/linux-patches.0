Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618992;
	b=xB6lZQlAyINsctisXwSDSUR4kENCAaavgw6fsVKeIF74u0d+PJOJThiElp+ow4n7Tjxk
	 CllYvPtei6yAMGmpFhykjK8EC83v14L2wWl68lHuKddQRKdLKgaLodOxjbppHli3wB6Lw
	 WPpbqRJQbTcgd3PMdyTeqNeFyJj4QrkFRlouJrDf38eyaNsteA0S4G4rROmbLX3Nbv+G/
	 /XOGhC7l6ArUN+v3fNUSgAFU0DO9e2mqS0n+bcZs8MRvEyxrpGjQErSVt6Uj94G8o42xk
	 uAxaas1UyZUDXsb2et7vbToW6EusoIjQgxcvXCwiR5sIjvCEg1pGToiLQ4H0djfrSRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0oObxqExa4qOLhtfn8R4q3uq5OLorOi5UZS/kvizqY=;
	b=AFVaBH9L+t2Pc5v9M9/DlgMh05jPIbgRsCOKUZyrzewy2pv+lEAl/Y4/1xLNb+377fkm
	 BqypHZs7bVAvlWvngA8SqhmULMbMVUwPazqnIXX/7utH/ZRoDlCkXHKLDUFezxD4xKNgA
	 cDJVpkzIG29RcNLcatq8ennx8juv4zAZyZtDkWiQppjXO+s6RC3ONqhVAK120Sj8Pq7St
	 nmVyjDfrxJmCUAROHFU+cU18UgDgoW8IaA2YfuaOutxvFGR+i7XFCNAghCTQJgYMQ0qHv
	 wTgseG5XvjBzm8Lc3EtYLXOOlqjMYpRjnMxS2RkW0uQeK0+NvRTA0aIVWekuUr5bSrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=InTQ3pzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B24606A31E;
	Wed, 25 Nov 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=InTQ3pzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0521F000C4;
	Wed, 25 Nov 2026 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618991;
	bh=D0oObxqExa4qOLhtfn8R4q3uq5OLorOi5UZS/kvizqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InTQ3pzy4tJ50etc7nx62Pvo4lrJOlFcyi32pU695lN8OEjQ3WFjq4tF+wMMjMsCE
	 LgfJTQgwmzcHJLFdzw8bcgGMZxzFOZC7Dqr7b4qN2+udAzgeY7PekdRJ/LvNw5dpNd
	 NAZZh0V/c0WfT/PGI945EpKjf6ciNeWmYr+l4VEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Valla <francesco@valla.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0452/1005] spi: virtio: move teardown to .remove()
Date: Wed, 25 Nov 2026 15:29:50 +0100
Message-ID: <20261125143832.336951253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 96cdaf1b3697b..bbc1edbd3b006 100644
--- a/drivers/spi/spi-virtio.c
+++ b/drivers/spi/spi-virtio.c
@@ -319,10 +319,8 @@ static int virtio_spi_find_vqs(struct virtio_spi_priv *priv)
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
@@ -351,21 +349,26 @@ static int virtio_spi_probe(struct virtio_device *vdev)
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
@@ -419,6 +422,7 @@ static struct virtio_driver virtio_spi_driver = {
 	},
 	.id_table = virtio_spi_id_table,
 	.probe = virtio_spi_probe,
+	.remove = virtio_spi_remove,
 };
 module_virtio_driver(virtio_spi_driver);
 
-- 
2.53.0



