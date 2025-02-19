Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028441DF743;
	Wed, 19 Feb 2025 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956512; cv=none; b=bGNliBaJA5eSj1uxTAuDH5t9Vs2f2j+mVqTsSed3ENyiFJbF3l8J51KeBzu9clQEMZhKBgHbWbhk8bBpoXXM6ZUUsFJ7BY5OHvxkZd2ZYEv2KD4sR9mB2lH7VkAwv2eQX9LKyxnw1/CRcyC+kmOX+F+yjBtvPXv9zo1L/mg/P+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956512; c=relaxed/simple;
	bh=TuZvBSzX3c/Fkp28SDqDLU9nhigYT24zZQbAUc6hFwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCa7V0Elxmz+EjxQ1hkMnAYvts86EBBiSbwaPUp2gFJWW1SwPCPaws1/NwLMb1lHHPcwyzC2wKNaC04kShsO6U/+dHoCvou9CuvMVpuRaQJDX5OG3mxN/Fo070G3W3d+EtFScicJpQYpbkK+I0hUnmGhbgapginlhQlNhWn0ohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ted0frG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ted0frG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D6CC4CED1;
	Wed, 19 Feb 2025 09:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956511;
	bh=TuZvBSzX3c/Fkp28SDqDLU9nhigYT24zZQbAUc6hFwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ted0frG5twfwmD7sqiNZj89jMI3PhvJGx5/gSO2d+xnONR5vTTo1xpE5L5c015i7O
	 qYW1qf7jiYGPOCxICeOlBAungt0VCqf0g0R0r9XUON6mlbI64MDWvh/yxrstmUId26
	 nQocvqY/YSKtYZUhFlJk3Py20N7AJni/cuy5BYEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/578] PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test
Date: Wed, 19 Feb 2025 09:23:27 +0100
Message-ID: <20250219082700.946278502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 235c2b197a8de2887f13990094a3343d2392155b ]

Currently, if DMA MEMCPY test is requested by the host, and if the endpoint
DMA controller supports DMA_PRIVATE, the test will fail. This is not
correct since there is no check for DMA_MEMCPY capability and the DMA
controller can support both DMA_PRIVATE and DMA_MEMCPY.

Fix the check and also reword the error message.

Link: https://lore.kernel.org/r/20250116171650.33585-2-manivannan.sadhasivam@linaro.org
Fixes: 8353813c88ef ("PCI: endpoint: Enable DMA tests for endpoints with DMA capabilities")
Reported-by: Niklas Cassel <cassel@kernel.org>
Closes: https://lore.kernel.org/linux-pci/Z3QtEihbiKIGogWA@ryzen
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 950fe67f2d3cc..bcf4f2ca82b3f 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -373,8 +373,8 @@ static int pci_epf_test_copy(struct pci_epf_test *epf_test)
 
 	ktime_get_ts64(&start);
 	if (reg->flags & FLAG_USE_DMA) {
-		if (epf_test->dma_private) {
-			dev_err(dev, "Cannot transfer data using DMA\n");
+		if (!dma_has_cap(DMA_MEMCPY, epf_test->dma_chan_tx->device->cap_mask)) {
+			dev_err(dev, "DMA controller doesn't support MEMCPY\n");
 			ret = -EINVAL;
 			goto err_map_addr;
 		}
-- 
2.39.5



