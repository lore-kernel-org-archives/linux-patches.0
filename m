Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19A3D9525;
	Sat, 12 Sep 2026 07:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197374; cv=none; b=ZCXwg7l6yNBGZZ4lI6cAP4+UNKFA3wxETynQROjM4TWLHYDnxGCBUXVKaXSg/HWxpdgD92wR5kXVUezYuhuHeR3+JMblXcuF52iTw7mY7ehPLAdAPiOQfPoC93QW8syqsf27r7Bo8QIvAEpDUXq8OFSNCf+4Eqc45Y7bNI5dKgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197374; c=relaxed/simple;
	bh=9t7ZJLQcNnP6YCfSM9OWkeGr4RCfQSpKC529/e3MuT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+ImbYGdUbaA2+oU7qxq4kFb1JxH8oC21mLR+XLuimgcKJ4NNCut6B7T679c7LE6L2zvKRhjWbM1n5JhHjvMVlPFXf77gHsxcBnM26bk17WnGVhiwm5tzNfZ9ppnD6QesfX+W3DA1EtHM5Ke79S1CVWx4tf3fd0r9tWalMUNSF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJbXHfUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJbXHfUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E191F000FF;
	Sat, 12 Sep 2026 07:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197372;
	bh=p+BUKKLx5e/1VcfMNeMUEa51tCFIWm11/y+AzApEgpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJbXHfUjJ1tx2yqPHPVOjfb/YJl4GiwCFngTN2QujZ4iCNQQh4E7PLioKQVyOcuDy
	 iiMugNt7AnoAbhnsc3L/1b1Qp5qy370xTWuEESl3q7F7KxeWKtCkm8QJTjkRzE5fOb
	 z3hLYXvpvbCeFIu4CMxtb4MbcsEnTVel+jiioZ5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0161/1815] dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe
Date: Sat, 12 Sep 2026 08:31:51 +0200
Message-ID: <20260912065652.789211884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit cbabdd6ce1b313b5877c7fbb2f5e2f7936564d2f ]

Out of memory situation on driver's probe is expected to be reported to
the driver's framework with a proper -ENOMEM error code.

Fixes: e9f08b65250d ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260630144214.4080302-1-vz@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hisi_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index 28bf818f9aa63..c751a2e49e6dc 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -983,7 +983,7 @@ static int hisi_dma_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hdma_dev = devm_kzalloc(dev, struct_size(hdma_dev, chan, chan_num),
 				GFP_KERNEL);
 	if (!hdma_dev)
-		return -EINVAL;
+		return -ENOMEM;
 
 	hdma_dev->base = pcim_iomap_table(pdev)[PCI_BAR_2];
 	hdma_dev->pdev = pdev;
-- 
2.53.0



