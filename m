Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23464657AE;
	Thu, 11 Apr 2024 10:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831595; cv=none; b=iWuKhWIg/bEI2ffwOEDSWfB9U+1Fd2BgSK47KCTJxYXuAhGHS8uxSqhx0+huQHCHo2wwa3LSmolsak5dyA41z5fVdRphryNSPF3RwRiqZwHdXwjGouNZFjjzAMRFYjT6c4MiY0Sa9ygVkqH9nt3oRaiyHS1om7ACqH/DxW/c0Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831595; c=relaxed/simple;
	bh=EzI/2RN8CCntOVKBvX0pARwIIgrBOQ7ovyurLQWDcTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3/OWDZVb0EoNCOfOruoJ6mLdboHT20HrZVNalGwJfYviQgs+jwnjOW04QF0UvkuKA0AK4S6uDhSN4YnbFY2wg0K3J/oQXBY9fuvcoRgUS0hx/bRvdma6qdaWjYUl8OVCIMRvoVFJ2PTwlpXl4noP1LHjhs8Y4kWXg7I0/bfar0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swu3SJ4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swu3SJ4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD4AC433F1;
	Thu, 11 Apr 2024 10:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831595;
	bh=EzI/2RN8CCntOVKBvX0pARwIIgrBOQ7ovyurLQWDcTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swu3SJ4Dtgy2QyxUSbFbxtahXaYzo0jyCZ1AE1okAMZznndZBGX+XHlnW8QevHKqD
	 FZr3dDilCzV5VUuNRTHHX0NDFGRUWnTYeb7/q687ZZVtgzIBBM1tzjLNLpJfRRMFQp
	 qr8WGqtVV38YIYDjhpJzNwojsK2tvLybfAN38oKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/294] PCI: Drop pci_device_remove() test of pci_dev->driver
Date: Thu, 11 Apr 2024 11:53:42 +0200
Message-ID: <20240411095437.417954430@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 097d9d414433315122f759ee6c2d8a7417a8ff0f ]

When the driver core calls pci_device_remove(), there is a driver bound
to the device, so pci_dev->driver is never NULL.

Remove the unnecessary test of pci_dev->driver.

Link: https://lore.kernel.org/r/20211004125935.2300113-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 9d5286d4e7f6 ("PCI/PM: Drain runtime-idle callbacks before driver removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index c22cc20db1a74..dbfeb5c148755 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -444,16 +444,14 @@ static int pci_device_remove(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
-	if (drv) {
-		if (drv->remove) {
-			pm_runtime_get_sync(dev);
-			drv->remove(pci_dev);
-			pm_runtime_put_noidle(dev);
-		}
-		pcibios_free_irq(pci_dev);
-		pci_dev->driver = NULL;
-		pci_iov_remove(pci_dev);
+	if (drv->remove) {
+		pm_runtime_get_sync(dev);
+		drv->remove(pci_dev);
+		pm_runtime_put_noidle(dev);
 	}
+	pcibios_free_irq(pci_dev);
+	pci_dev->driver = NULL;
+	pci_iov_remove(pci_dev);
 
 	/* Undo the runtime PM settings in local_pci_probe() */
 	pm_runtime_put_sync(dev);
-- 
2.43.0



