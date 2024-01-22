Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323204E1D8;
	Tue, 23 Jan 2024 00:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969962; cv=none; b=AR1d6YZb1M4wkN92EUFchTCKOK7l81jlOemJ5BNJQTysymw6gTMDW3/CLoCmdONLk/IIBbTyuDVASPuvtigMIpQPC0d4uP6mVEdVwBnxvbas7slZkyCy5T/+XN5Q5rX4A2FJ8gVirz9ZIOuybGQUmq8DvRtFNC08r/1hPs2rgwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969962; c=relaxed/simple;
	bh=nmOjP350GccWzXwJzLdvdMOu/RNAOATdx7zqOxWT0cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CLiGj8EVlIsphLlptJsGDQKsXWWxtrp2eh3vxz79sLBQpyg+NT6W1p0tIVJpq15QXRsKtIqZfp1yOFOBR3Z5LrdtklWJUXjlmFEJxgcZ9ntT3LKHAB1U4TMLNTEHpgZnVfiAYPqcLSock39oxHTbRWhC0b0WyjGRMqfkOw6RpMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5CocNdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5CocNdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738E5C433C7;
	Tue, 23 Jan 2024 00:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969962;
	bh=nmOjP350GccWzXwJzLdvdMOu/RNAOATdx7zqOxWT0cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5CocNdrqyL0tcJtzudPLCaVKtufYOEAk7iiRAwogIY8FuTpj4mAymlQYXGrkmeUf
	 XnZxSNsRhx3kPMmXsTGuJzpcuWfUuQSnhWf9XsIit7s1p6BUdxEZ2yAO8pTyKPHWnM
	 kw50tM3BsuU2kXImocCi22EFNdOSQ8AHNFC8qmaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 540/641] PCI: epf-mhi: Fix the DMA data direction of dma_unmap_single()
Date: Mon, 22 Jan 2024 15:57:24 -0800
Message-ID: <20240122235835.025690061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 327ec5f70609cf00c6f961073c01857555c6a8eb ]

In the error path of pci_epf_mhi_edma_write() function, the DMA data
direction passed (DMA_FROM_DEVICE) doesn't match the actual direction used
for the data transfer. Fix it by passing the correct one (DMA_TO_DEVICE).

Fixes: 7b99aaaddabb ("PCI: epf-mhi: Add eDMA support")
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Link: https://lore.kernel.org/r/20231214063328.40657-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-mhi.c b/drivers/pci/endpoint/functions/pci-epf-mhi.c
index ec5f4a38178b..6dc918a8a023 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -405,7 +405,7 @@ static int pci_epf_mhi_edma_write(struct mhi_ep_cntrl *mhi_cntrl,
 	}
 
 err_unmap:
-	dma_unmap_single(dma_dev, src_addr, buf_info->size, DMA_FROM_DEVICE);
+	dma_unmap_single(dma_dev, src_addr, buf_info->size, DMA_TO_DEVICE);
 err_unlock:
 	mutex_unlock(&epf_mhi->lock);
 
-- 
2.43.0



