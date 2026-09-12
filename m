Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC93364038;
	Sat, 12 Sep 2026 09:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206403; cv=none; b=AM7FWuy8skvOasiMDyQ9ueZ9dgOUYEz4RGmdsrt0HEJOd1+YxqKj/xwMo3fBSgvXmBtCGifW5kiWz7Sj2RmqhvloTS4+vYfGGf/aDI9h4rR84NMZogmGUsW4JmoYg5b7bMHWv5W1YTDfX5BE2iCx/nr5qCA6cZll1/vrfaNBmW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206403; c=relaxed/simple;
	bh=rkb3lRCcVArRj6oUfAwXy0lZosXGfaJIN4nnEoGCvm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gjk1gFT7kgqe8QdeJ4iIy5qjp3f7kcEIO0U3mM4QwsALF7qijpz9a+yRfY6mKc9P6Xo7q4fdABBs4m0Nz4mbmKUxGkyZ7fHBiRCXULAy/kX2N/e+AbfFdKI15SWObNNyQqCzMoH1i5IBmkBiVU/Sg61nVPmzz6c407vGL18n6/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIypxUWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIypxUWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA9A1F000FF;
	Sat, 12 Sep 2026 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206401;
	bh=Q+qs18sVik34JKcXbWTpgIrYDsKH9nbdQZGP3bCMMgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIypxUWh0bL6ClfrO0TiOj0xfEVhjcSv3Mccryh+yvFOsP7aDJQnrnjIupYAaq+Zm
	 8PSrWqfi6Pv24YqH+svCFTte3krnNKV2o8RX57ujDOD3ySwwSlpiSkzQH0w71j5fS4
	 ip1S520RpYw0qvn8dSiirAgrB2h+Si0D4wsigUQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0183/1518] dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe
Date: Sat, 12 Sep 2026 08:39:12 +0200
Message-ID: <20260912065627.630756060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 25a4134be36b7..ede094e0d0905 100644
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



