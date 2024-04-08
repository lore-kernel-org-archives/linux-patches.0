Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330392E62C;
	Mon,  8 Apr 2024 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581533; cv=none; b=hxBhV0+JOKvAveRXUB4Xt0zfJ77bTCOn19qqv4MwIkswhPB9RdFeK5LkN2QAQ9Sqiime3haOzUg7qLAf5UPOMSvUjzNNGIYJKSIBkWBlbs3YW/xCx11sklOtTsQAbF/OU2Brrxf4BF9rR+nkcLn381h/dDIc7qW2Bg1B//Y02b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581533; c=relaxed/simple;
	bh=xI9oVSEsmPvkHLgZ8S83pLZQ37/F6s69sPoaKDYD3cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPUEfkv4WShYA8lDalxbN/oy454cPT3JNZAa6vejZpIvXd1TtbKZpwX0OvJKli+oj6g6LiChmh/GRKok+YyqHW/oGImZ2iGa4Wma7jpwUOyfQdypjXiEPoC2JHSNn25Jwc0ah2DhvxhBnpkcOQCBug8Nf86OGGAl+TV0XTTTu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18CDhu0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18CDhu0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1751C433F1;
	Mon,  8 Apr 2024 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581533;
	bh=xI9oVSEsmPvkHLgZ8S83pLZQ37/F6s69sPoaKDYD3cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18CDhu0/yej2XgInecisEsjbAQKbm8V7oZrDQPvZfKZqENY/xeVfmldslBuAafg2k
	 c+bt3BMGbpFQJG7VBhxJTnPkLnAwS1GpkU1OulHQg+7LkXTS9Slie7Qqp4IkCZkBdC
	 vcOc0kpjmPMXUNWpVBZSnxfQ7Q0zwwx0DYDAc5SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/690] PCI: Drop pci_device_remove() test of pci_dev->driver
Date: Mon,  8 Apr 2024 14:48:46 +0200
Message-ID: <20240408125401.690881394@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f44c0667a83c6..3a9c49b0d05b0 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -459,16 +459,14 @@ static void pci_device_remove(struct device *dev)
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



