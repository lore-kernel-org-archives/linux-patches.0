Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC9371D1E;
	Sat, 12 Sep 2026 19:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242312; cv=none; b=fX51ZjvGDbPISSpi6GTUQkDe2BK1v7pUVMtT31jeS9miOobS91goZNiK7tTQwMnmbJNap43HkNfkjW2LPZNK8cv4m98oaoz/GsIvO45YuOl4hneOjvqQa0wHWXOyrZrmWJWL6t+TDsR0BELJiFFTKZfgdTDFMN+Kn0dSmpeZCqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242312; c=relaxed/simple;
	bh=Bc5wSw+MepKHW2tAXSsVKFNvOQ4URIMjZgtxbj2F1lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mb9g7YA6Qz7XA/4y7f/jd6NMgzY8BvYhBADHfG5BEA7F/6Iz3gwmPDuofvPACs4yMBigg15Szc07AvtntG6IBm9LDigZJqSC9NZH4jIewp8Zi+0OqZBS2AmCleE6RaLzTTgS27wNu73swylCN/kl08AdVx0cQVEtLHN2hWfrfCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6Wcao/o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6Wcao/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0261F000FF;
	Sat, 12 Sep 2026 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242311;
	bh=N53+9eB1jZA9F/ZRyMmNikOIbF2jzMVsMERjNrlIH/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6Wcao/orxfpRj47lPKPHyg2XcouOwK2LM3yBjmdQipcyFcZhIeFXxN5U+VmJvq0Q
	 +5FOTq8GO31D/zmPDxOrJaTpyXaB46ghdzL4T3pH9eLxOeztxva2MVnItJK500sZbV
	 C2leUXr1yQ58HsczTRSjgtCiqgSykbSKVak5vWLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/798] dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe
Date: Sat, 12 Sep 2026 08:59:48 +0200
Message-ID: <20260912065525.411884305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f16513673100..4c82a94fa7aa4 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -535,7 +535,7 @@ static int hisi_dma_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hdma_dev = devm_kzalloc(dev, struct_size(hdma_dev, chan, HISI_DMA_CHAN_NUM), GFP_KERNEL);
 	if (!hdma_dev)
-		return -EINVAL;
+		return -ENOMEM;
 
 	hdma_dev->base = pcim_iomap_table(pdev)[PCI_BAR_2];
 	hdma_dev->pdev = pdev;
-- 
2.53.0



