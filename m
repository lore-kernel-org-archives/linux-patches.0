Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2B038424C;
	Sat, 17 Oct 2026 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258035; cv=none; b=FESf1V+fAhu6DpIcDfWI8I6/H4OdOP36fvC1SDmMI5qTJomzxzltJX/WDG7Tjs+9Tc0wd5MGoRC8ZgMCF5tZBMudsK/EAEB54FsxG+zV8mJhlNwbvGutJEXe+9O+G6hMK/J+oEviAMUq1FRk7zJiqErH228obgFpCEjp4po9A8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258035; c=relaxed/simple;
	bh=K6RI65qvU3L6+gMM41j/wMGLkObGDPNYYq4BcZarElc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuF67/rUdil9WGV8PiM1F0Z+sG6+kzmxTlzMtcIyQYfPzOYo4LyJSR09suVI1fhJEcYr76OUgkmU/h+L0TI0GJ2UQAmIsupkjLyR/JeOuTw26+pY2kVS4Eng4IgPD4jwSRYibHYKPH6XeDNS+Vq1Y9jYLKl0mSGZDGu2XGoSaGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvkWNJLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvkWNJLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5A31F000C4;
	Sat, 17 Oct 2026 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258033;
	bh=1+pQ1MpBdm9xN93eMYCa9S8IqE3PvVqVHVlXwaPnOjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvkWNJLSBe+Bbh7ZCEqksWkyMDU7P7bk0+Qc4b72hYmJGiqJ0NaF7jPfLEPjywrIQ
	 TsaAoT3Zfy5Lt0HWUezLKKxlrX1hYrj3KIPX8Q5Yq2+BNPPkDRygay13WO35HMBZ/7
	 0jAmiMiX95Gg3tOdaUHHeFqeuTMMo8/UNSMamWf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0748/1674] virtio: hookup irq_get_affinity callback
Date: Sat, 17 Oct 2026 17:50:20 +0200
Message-ID: <20261017160450.304452676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit c7f63c5d13925c97a4ae9908bd933ab197872161 ]

struct bus_type has a new callback for retrieving the IRQ affinity for a
device. Hook this callback up for virtio based devices.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20241202-refactor-blk-affinity-helpers-v6-3-27211e9c2cd5@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8bd2fa086a04 ("virtio: break and reset virtio devices on device_shutdown()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 70dba7235cb0f..eb8b17b3caec3 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -340,6 +340,24 @@ static void virtio_dev_remove(struct device *_d)
 	of_node_put(dev->dev.of_node);
 }
 
+/*
+ * virtio_irq_get_affinity - get IRQ affinity mask for device
+ * @_d: ptr to dev structure
+ * @irq_vec: interrupt vector number
+ *
+ * Return the CPU affinity mask for @_d and @irq_vec.
+ */
+static const struct cpumask *virtio_irq_get_affinity(struct device *_d,
+						     unsigned int irq_vec)
+{
+	struct virtio_device *dev = dev_to_virtio(_d);
+
+	if (!dev->config->get_vq_affinity)
+		return NULL;
+
+	return dev->config->get_vq_affinity(dev, irq_vec);
+}
+
 static const struct bus_type virtio_bus = {
 	.name  = "virtio",
 	.match = virtio_dev_match,
@@ -347,6 +365,7 @@ static const struct bus_type virtio_bus = {
 	.uevent = virtio_uevent,
 	.probe = virtio_dev_probe,
 	.remove = virtio_dev_remove,
+	.irq_get_affinity = virtio_irq_get_affinity,
 };
 
 int register_virtio_driver(struct virtio_driver *driver)
-- 
2.53.0



