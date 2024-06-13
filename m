Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B341448E8;
	Thu, 13 Jun 2024 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281107; cv=none; b=Qw9jKhqP/8gVuco0SUcj8dI/Xh2zWNxoClwQq6aVaJ+RfYko0DnfPhlX9yRAolzBTPhAdMbOhv9b19eQOhefxkppGQ1+SZoL0bhrsZ6amcLGJ7I2e0A1h3RWRoAaC7u/LXrsOAVk4btM5tUCZ0MOJy9AlxoiQWuHsNpWWr1nQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281107; c=relaxed/simple;
	bh=PNtJAblXpweOU7H6/G4sGK+5QMEI3WoukRMwJeq3Y8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VteRVI6tjamQ67jqtdGikJYC7J0Uq6bY0RDvxei1SdqWEKS8k9LEwN2njMC4C+UmgQa/CDPKawrk7emO2ea337WZ0NzSM3FdGXoXKzG/YCK2VPxEYfzl4HJ+UFEEsi8qLxPkKb6zmStJOOnUMY40hEPDtEhixaoe7QHMnSV1twA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fx1t1k1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fx1t1k1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D8C2BBFC;
	Thu, 13 Jun 2024 12:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281107;
	bh=PNtJAblXpweOU7H6/G4sGK+5QMEI3WoukRMwJeq3Y8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fx1t1k1hWFsyo3vTLX3nakhirX0tmEVpMgIl846sH5CrSzmHi/+9RCCJ4JuC/C8AS
	 bHZz+VfWEnPlxvYSQaOKfgRL0ISPy51AHHOXgSrWDKkEIZDxhsGQJ+Y2s/TVR1jjnv
	 /lWFPvjm6VnHWa0njMgOKCf1n8jRyMXCsKUfMKac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/317] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu, 13 Jun 2024 13:32:41 +0200
Message-ID: <20240613113253.100034216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index db506e1f7ef4e..0f065ba844c00 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -594,7 +594,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



