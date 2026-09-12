Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB78309EEB;
	Sat, 12 Sep 2026 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229072; cv=none; b=P8w14mG0X+p0oSTdSlcsLM+0NpWBYPbKz1Op3MFviJyJAQfW2Q3ed6DT0JsZyuK+3SWcoGN/JpxNRQoslR7YbkbBa06oivffejOu0lOAcX4JTNHYTGCX2LtQfqUYJY10Q6U6wW6i7trZSH0BOcogl+XKetcLVMEr34rLvRxQgV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229072; c=relaxed/simple;
	bh=PLcoCWCmBYtqaaQ4oZDewBH4Nc63QUfy+kjiHsShncs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuNeruxpL2H7LwniMpaz0aP/qZr+1DmwZ9GvGWA7P+ARSd7Iosbn+HVA+NWK6cBpRQgB39ZXU16bXpYR+7g7xSNUise0t3/tWCC3C2Rae6FY7VSiTFq96R4wPNDTQOcxrhSbtRhHnVIpqjVNJk8decLGfBFH3NoG7yohrMqP/pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4eVUCVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4eVUCVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD48A1F000FF;
	Sat, 12 Sep 2026 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229070;
	bh=eM8CmIyd+487mnvVcJAezGcK3tcD+YjPPYjTytjWzuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4eVUCVygXEMfd4ZpWs3zy/3gwVVa1toPMulLNfblXLjg6KDarUDoiUxOKGVc7jKg
	 XD5wptMAOwa3t8XJ9yMtqYpDaYoNipyQts2IXwDvB0rPwzlJX8r8pnJMMEL2NaLrNJ
	 GPA3l5IEGD3THYM6T+tMLH5rSWjw/m3fftZWrVTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0508/1191] dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe
Date: Sat, 12 Sep 2026 08:53:56 +0200
Message-ID: <20260912065559.654835373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1350a36fddd9..bbd4d44bae220 100644
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



