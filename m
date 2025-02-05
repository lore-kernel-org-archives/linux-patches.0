Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DA818C337;
	Wed,  5 Feb 2025 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767269; cv=none; b=uYlHXOs3+9a/3y8qzsPcSesi7dd8flY0qKT7YyHroWSg1RMqsTfQvVj7hW1Q+E4hzlH2DHZ0zDEibDD9+sRuivQ3Gmq1NR/T6+8yoiJb0awzyvSPD5ncikFmrl853kiGf6DGOXxinhrT4AW55+zwBRD2LXXP7cPWAjl62iadb1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767269; c=relaxed/simple;
	bh=+BSy60tVfdepAyAq8wqSG4y2xO6giMBnXKZFgz0/nZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUWIz9JA9vRD99JZG2M8832DyggWDoy6qOBCJFD3mm/oJFtWUCfDC/FhBbYYMl/UfUjg+DdjSJN8Di7Ss7Ay1fFrxCbzvRI1M9YZMw/t+lhn9Uw3YepXewBeb0tK+pPH36cad4RxUak0xK/K5NsMWJOsf0ZlDrltrEpDPC1z6Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jk6M0FX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jk6M0FX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90347C4CED1;
	Wed,  5 Feb 2025 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767269;
	bh=+BSy60tVfdepAyAq8wqSG4y2xO6giMBnXKZFgz0/nZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jk6M0FX/yBpmCeu84X6wouDluWyphmGBtaglv9FYtoNFYz/I5Q56EbQHTIEyKL6Yt
	 IB7ZLG+GHb0lylJUNek/lJUQMWis6UdugYGzRf8Rtj82dxAop+OltdY5p95iZ1pYmG
	 JjddkBXOcpAoLD90KpMDGYCSUH50csJ7DRgXXSRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/590] PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test
Date: Wed,  5 Feb 2025 14:43:07 +0100
Message-ID: <20250205134511.794439064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f51ebd6b45c9b..14b4c68ab4e1a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -361,8 +361,8 @@ static void pci_epf_test_copy(struct pci_epf_test *epf_test,
 
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



