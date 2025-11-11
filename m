Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BE42D97A4;
	Tue, 11 Nov 2025 01:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823592; cv=none; b=sZwmB10J53oribTNUg+RiLjE/HqJ1t190fHnyo3IyAmub69hS56lBh1TdEkO02sB1mPKUzBYz5OEufQxM2QD7aPsFXW0elHteLcY1dJUmS3osrt/RFxb4twtcfqcZHXCaTGzuqkF+UERay9XpI6wKmCx3W8OFlUJ6t6Df8tzV0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823592; c=relaxed/simple;
	bh=XOubr4celDijVYJI5wh0BcWyxe40dhTHW50kzXHsNXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExFEZ+4V4vCezw4Cm+byw3OlbCkSD8qfh8+YOOH06GYJJGDvBhn20i/df//YzyHi/kDE2sZdRQs3aqUJzymxAaMA7faf/b75F/93lUOSXFDG1/srSliH1/xpS2npgR8R0t5S1hKvGIPZxacicjKbhBWukMk5JJcd6agcm8XYoPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOpXXOrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOpXXOrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6C9C116B1;
	Tue, 11 Nov 2025 01:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823592;
	bh=XOubr4celDijVYJI5wh0BcWyxe40dhTHW50kzXHsNXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOpXXOrBQcbauadhP6N/UpRROxvQysBTl/iN/KYO9AFUYHqyGSAlpvmqc3xBA6aIb
	 qE05zUmrgoZbT+2bE4kA6Z5PQ/hu5muX3eXcHihZHLBbhM0kNCjf8e7X40NwTOfg3P
	 ryF9Qg6Y/9z+hMvuF85GeYSHg5/6RyFkFrIldCeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/565] dmaengine: mv_xor: match alloc_wc and free_wc
Date: Tue, 11 Nov 2025 09:42:18 +0900
Message-ID: <20251111004533.222904364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a33e3b667d2f004fdfae6b442bd4676f6c510abb ]

dma_alloc_wc is used but not dma_free_wc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20250821220942.10578-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 184813766cd15..33716794d50e2 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1013,7 +1013,7 @@ static int mv_xor_channel_remove(struct mv_xor_chan *mv_chan)
 
 	dma_async_device_unregister(&mv_chan->dmadev);
 
-	dma_free_coherent(dev, MV_XOR_POOL_SIZE,
+	dma_free_wc(dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
 	dma_unmap_single(dev, mv_chan->dummy_src_addr,
 			 MV_XOR_MIN_BYTE_COUNT, DMA_FROM_DEVICE);
@@ -1163,7 +1163,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
 err_free_dma:
-	dma_free_coherent(&pdev->dev, MV_XOR_POOL_SIZE,
+	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
 err_unmap_dst:
 	dma_unmap_single(dma_dev->dev, mv_chan->dummy_dst_addr,
-- 
2.51.0



