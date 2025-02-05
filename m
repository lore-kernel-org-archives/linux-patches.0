Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE8F21345;
	Wed,  5 Feb 2025 15:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768088; cv=none; b=FOG/YKs4O0gbKuwl3WfLViJT5IAXvWp0nx4Ctq6jRy4P71Ws1c7BncL5CCB1kO7tIainnE9R4HYMHrlPIbO2EifDnPfl8CgP0NYR4/82eSx1rVQ4wV1tR3ymuRF4Ww2WBtKhM/veKMnEWtbMBE6kp+F1P+eJ9pwPGICdObVRRjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768088; c=relaxed/simple;
	bh=rvHGMpk1xMx4u/7e4CeSdKe+W2iVTGhs6mznBlK3BAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd/nIEfSVXwuRovS0sRLUnp+ycH6LZyZEQJXizLVs5BlJBV4piGNvCNIW/SSaIHZuaDPJhEyChj6oPur7PHEJ2f2MFjx4G36AEe/4/R4Mx8mAnAFtii3tkUls+ZDFl1mfBhF3N1HUlwPV7COJ8rmZT2sSefzttQ4rIwbfek1HBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivl7jx17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivl7jx17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA0EC4CED1;
	Wed,  5 Feb 2025 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768087;
	bh=rvHGMpk1xMx4u/7e4CeSdKe+W2iVTGhs6mznBlK3BAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivl7jx17EHTXIyZaVHb+6q0TXyURC8r6vZB0qBFDGDqiLy6bpJYlhCFe4iA5O6xWh
	 nEtwwHTcLN04Y1qBxfqwbOAr8jtRwN3Xj5pwJbNzLxY9VVNwyid3a8cqWA7y7Yd7Y2
	 pfYLQiybrqQTHcdsCfQflOmq3MFz2g/hU6B+YwYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 471/623] PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test
Date: Wed,  5 Feb 2025 14:43:33 +0100
Message-ID: <20250205134514.237349061@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index d90c8be7371e0..b2fdd8c82c438 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -328,8 +328,8 @@ static void pci_epf_test_copy(struct pci_epf_test *epf_test,
 	void *copy_buf = NULL, *buf;
 
 	if (reg->flags & FLAG_USE_DMA) {
-		if (epf_test->dma_private) {
-			dev_err(dev, "Cannot transfer data using DMA\n");
+		if (!dma_has_cap(DMA_MEMCPY, epf_test->dma_chan_tx->device->cap_mask)) {
+			dev_err(dev, "DMA controller doesn't support MEMCPY\n");
 			ret = -EINVAL;
 			goto set_status;
 		}
-- 
2.39.5



