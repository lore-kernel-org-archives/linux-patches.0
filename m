Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4C01D04A3;
	Wed,  2 Oct 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875286; cv=none; b=T9akHsCoVFWNbzxDMIpI8wUhdmRGl/bDMkxgeq6HXUkCXZy0K4XtC9oVg1R23TilMHotNO/Y8+cpmXHNSs6sbumpQvgM49x/BoTMTq2DvtSykAEOC0J01ta3QgsVBef8ncP48IKt6zsvU+1e3hJjTQthNNYbHXnR4CenAVEIdAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875286; c=relaxed/simple;
	bh=wqz/IgMOk5D00+Z+w7T6Q5FuWQKrUw1eHdS0nLoYktk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQf+OWkSw9CchKwnuup4DKUISQJkhHFlohPjfzmzChuwrdkOZmVYEZZPDTjNS6dWtj5yQfrH76/K6qfLA7b+FCmxbq4i+4Vv16vB/gUMf4t50Y2g2FU1scZzyedMn0jPWYy3PnZTBEKf0GIr7Aeot+X/eDDKzTao+ePsWKDSc1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q30Md7TP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q30Md7TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8221C4CECF;
	Wed,  2 Oct 2024 13:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875286;
	bh=wqz/IgMOk5D00+Z+w7T6Q5FuWQKrUw1eHdS0nLoYktk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q30Md7TPy/JsTtN1O+fuqjuuNxPSJ8fl+PUZOu9rhro/64orRUTkZhNT6OhAwu9Qe
	 Ys5cCrzMH2pCbYQpsFu1w+TauOlCOplNign7EMDXjteU1vdaHPBGNnpkz0BNENRsws
	 vuU9GaJ2PHROkTs4Bqv96lN2xP9H0QycJXebMKgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
	Gia-Khanh Nguyen <gia-khanh.nguyen@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 019/695] virtio: rename virtio_config_enabled to virtio_config_core_enabled
Date: Wed,  2 Oct 2024 14:50:17 +0200
Message-ID: <20241002125823.259359376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 0cb70ee4a6ee6b0a4b0e0f70a64a094c6fe05944 ]

Following patch will allow the config interrupt to be disabled by a
specific driver via another boolean. So this patch renames
virtio_config_enabled and relevant helpers to
virtio_config_core_enabled.

Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Gia-Khanh Nguyen <gia-khanh.nguyen@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20240814052228.4654-2-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c392d6019398 ("virtio-net: synchronize probe with ndo_set_features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 22 +++++++++++-----------
 include/linux/virtio.h  |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index bc1f962e483b9..6b692b0fa578b 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -127,7 +127,7 @@ static void __virtio_config_changed(struct virtio_device *dev)
 {
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 
-	if (!dev->config_enabled)
+	if (!dev->config_core_enabled)
 		dev->config_change_pending = true;
 	else if (drv && drv->config_changed)
 		drv->config_changed(dev);
@@ -143,17 +143,17 @@ void virtio_config_changed(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(virtio_config_changed);
 
-static void virtio_config_disable(struct virtio_device *dev)
+static void virtio_config_core_disable(struct virtio_device *dev)
 {
 	spin_lock_irq(&dev->config_lock);
-	dev->config_enabled = false;
+	dev->config_core_enabled = false;
 	spin_unlock_irq(&dev->config_lock);
 }
 
-static void virtio_config_enable(struct virtio_device *dev)
+static void virtio_config_core_enable(struct virtio_device *dev)
 {
 	spin_lock_irq(&dev->config_lock);
-	dev->config_enabled = true;
+	dev->config_core_enabled = true;
 	if (dev->config_change_pending)
 		__virtio_config_changed(dev);
 	dev->config_change_pending = false;
@@ -316,7 +316,7 @@ static int virtio_dev_probe(struct device *_d)
 	if (drv->scan)
 		drv->scan(dev);
 
-	virtio_config_enable(dev);
+	virtio_config_core_enable(dev);
 
 	return 0;
 
@@ -331,7 +331,7 @@ static void virtio_dev_remove(struct device *_d)
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 
-	virtio_config_disable(dev);
+	virtio_config_core_disable(dev);
 
 	drv->remove(dev);
 
@@ -443,7 +443,7 @@ int register_virtio_device(struct virtio_device *dev)
 		goto out_ida_remove;
 
 	spin_lock_init(&dev->config_lock);
-	dev->config_enabled = false;
+	dev->config_core_enabled = false;
 	dev->config_change_pending = false;
 
 	INIT_LIST_HEAD(&dev->vqs);
@@ -500,14 +500,14 @@ int virtio_device_freeze(struct virtio_device *dev)
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	int ret;
 
-	virtio_config_disable(dev);
+	virtio_config_core_disable(dev);
 
 	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
 
 	if (drv && drv->freeze) {
 		ret = drv->freeze(dev);
 		if (ret) {
-			virtio_config_enable(dev);
+			virtio_config_core_enable(dev);
 			return ret;
 		}
 	}
@@ -557,7 +557,7 @@ int virtio_device_restore(struct virtio_device *dev)
 	if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
 		virtio_device_ready(dev);
 
-	virtio_config_enable(dev);
+	virtio_config_core_enable(dev);
 
 	return 0;
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 4b16844c6bc29..de6d3cc176d96 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -118,7 +118,7 @@ struct virtio_admin_cmd {
  * struct virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
  * @failed: saved value for VIRTIO_CONFIG_S_FAILED bit (for restore)
- * @config_enabled: configuration change reporting enabled
+ * @config_core_enabled: configuration change reporting enabled by core
  * @config_change_pending: configuration change reported while disabled
  * @config_lock: protects configuration change reporting
  * @vqs_list_lock: protects @vqs.
@@ -135,7 +135,7 @@ struct virtio_admin_cmd {
 struct virtio_device {
 	int index;
 	bool failed;
-	bool config_enabled;
+	bool config_core_enabled;
 	bool config_change_pending;
 	spinlock_t config_lock;
 	spinlock_t vqs_list_lock;
-- 
2.43.0



