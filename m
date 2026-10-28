Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212333;
	b=cRz0DRiJswymzoud9K/jbT5pYqWndkPxPcbCBctU9YBPFI4OunHWvZ4Oc6L8wtwdmU2X
	 qhzUZPhhsjOz37ptEXPlWyez1lmOVnzf3KCso9x3Qc78QSVS70xXV+IZ5Uq+6dDB2+uW9
	 b/F04imZInav2ZNpiNdh7W+t+kE4EYdVcedBhUxRsF+SQX8TKPYgG3y+Niw0LXHMP8NmL
	 Cg0vG25YUz2Mv9AgVpuxvDiInOoIZiIPJ+Ak25ZUJ4uBqBtPFitB71lwQNoCi3oeeuZ+h
	 NV/UXgDRqIU8MG8JXZiQyHiAlz8WCC7L/RJRDLEhGtkCwubEdHG98cSPMRRrT/FY3mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Afv7JxhQIZncmkpTMwd9rteQLcIgwgOMRmOuyvhFXNk=;
	b=iEoM4aVgxXZqxgoLr8Cu6ee3hTVCPDeUdIicCs/YVG9SWR1WiG6D+Kbx1ycY1o4r+NM6
	 LQcHKlSu8gV9GO1wQrK4jr9j5CZ3LMWduqx385nb9gsVleNQkNqWnrzUdOC91qh2YBxQk
	 bs+jnyIrmAUQjygjYrYUUAEOKc+d2Kbji7mgB8AxCLM5M/OJw+eA0zPrntUJWY05MwkpI
	 ffg5Ca1QhaDpdMyeO/DVWp45+++8DM0o1SdwbD1DgV4G3VdBjtmSdHicU+fRfEmJ4Qmqz
	 UnVsTClHf5iFX3dRR2B2uckFA0Fgit2ahe/pMNjeSnuPalRF5Omld70Mje3uuz1MRWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAkOMENk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D4A606A31D;
	Wed, 28 Oct 2026 18:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAkOMENk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CF81F01825;
	Wed, 28 Oct 2026 18:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212333;
	bh=Afv7JxhQIZncmkpTMwd9rteQLcIgwgOMRmOuyvhFXNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAkOMENkKe2gennHItKpVBtXz4v+TKqTXfbGojZJa6H4dqF0ZlP4TxcXpuPl+E3H8
	 BdEESioH/w2Uex+zgOCU2YSuWHDqjbp7jFEg02FBzKXjQK+DO/Zz1Dix2B+/U2RXYu
	 lylJaAv/+5xPVXp2VVMMC8rL4Hk+91Go1ROhL/ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0118/1887] virtio_mmio: disable IRQ wake before free_irq
Date: Wed, 28 Oct 2026 17:36:54 +0100
Message-ID: <20261028170501.922877139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Xiong Weimin <xiongweimin@kylinos.cn>

[ Upstream commit d14d693adb055e98ca705822ba6daebc18602d9a ]

When the DT node has "wakeup-source", vm_find_vqs() calls
enable_irq_wake() on the shared IRQ, but vm_del_vqs() freed that IRQ
without a matching disable_irq_wake(). That leaves a wake reference
behind and can warn on later free_irq()/request_irq() cycles.

Record whether enable_irq_wake() succeeded, and disable it in
vm_del_vqs() before free_irq().

Fixes: 02213273f72a ("virtio_mmio: add support to set IRQ of a virtio device as wakeup source")
Cc: stable@vger.kernel.org
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260805032937.1606737-1-xiongweimin@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 7909d4aec8a6e..6395b8fba0050 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -86,6 +86,9 @@ struct virtio_mmio_device {
 
 	void __iomem *base;
 	unsigned long version;
+
+	/* True if enable_irq_wake() succeeded for the shared IRQ. */
+	bool wake_irq_enabled;
 };
 
 /* Configuration interface */
@@ -318,11 +321,17 @@ static void vm_del_vqs(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	struct virtqueue *vq, *n;
+	int irq = platform_get_irq(vm_dev->pdev, 0);
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
 		vm_del_vq(vq);
 
-	free_irq(platform_get_irq(vm_dev->pdev, 0), vm_dev);
+	if (vm_dev->wake_irq_enabled) {
+		disable_irq_wake(irq);
+		vm_dev->wake_irq_enabled = false;
+	}
+
+	free_irq(irq, vm_dev);
 }
 
 static void vm_synchronize_cbs(struct virtio_device *vdev)
@@ -445,8 +454,9 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	if (err)
 		return err;
 
-	if (of_property_read_bool(vm_dev->pdev->dev.of_node, "wakeup-source"))
-		enable_irq_wake(irq);
+	if (of_property_read_bool(vm_dev->pdev->dev.of_node, "wakeup-source") &&
+	    !enable_irq_wake(irq))
+		vm_dev->wake_irq_enabled = true;
 
 	for (i = 0; i < nvqs; ++i) {
 		if (!names[i]) {
-- 
2.53.0



