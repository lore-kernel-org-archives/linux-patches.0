Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCCE748A;
	Thu, 12 Dec 2024 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017243; cv=none; b=jXqAd+x6qeAAVwZr9NgCal2UsHRqE3GF3lhpw2Gzfqe0suBQaC5Fd0eh/yPFdIj7AHx2+QXF658w54PVwYKGHuXgje8LjnUl5nIJ7FR5d7202wZIn7x9+VtR3QjKCUaVjfQWlzaHQigqZhHEWx/CRvm1h4+G84iZxkPh8NRmQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017243; c=relaxed/simple;
	bh=iRhQeSTcKZpg+uBngCsa6JD/riD0rqsZGG3AAQOff2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIIx/OaMBfDYzXOVyNmHba0tssloRL2rBVglgZINb40onbmpZwmAELHQMRvoYL5XMuTzDrbpQjkpiyLsycMx+rjs1KSPMsTAFxmpMcfJnDqUpUBIKbU0WQf9doNxhIe4/qaimtld33Mtz88pH8NRARoBPuds8SmqjAxrni47s2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjhdjM6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjhdjM6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313B7C4CECE;
	Thu, 12 Dec 2024 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017242;
	bh=iRhQeSTcKZpg+uBngCsa6JD/riD0rqsZGG3AAQOff2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjhdjM6Sd79HlSwsQQZwS2JHZ5wm0bdv5D53LeBcwCephlEaGSn323f3ZMXOQIy9m
	 uF6scx7x2SlAVtfw+k4+LrxXPmdeVZUnkC7/xPkjobfXQZjTY+rN3FvWn7wAH/6k2q
	 6p5Y7u5nGwe8XsNj0QOOirCAeOW8sll9qRj0RxHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.ntel.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/466] PCI: vmd: Add DID 8086:B06F and 8086:B60B for Intel client SKUs
Date: Thu, 12 Dec 2024 15:59:21 +0100
Message-ID: <20241212144322.254683876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmal Patel <nirmal.patel@linux.ntel.com>

[ Upstream commit b727484cace4be22be9321cc0bc9487648ba447b ]

Add support for this VMD device which supports the bus restriction mode.
The feature that turns off vector 0 for MSI-X remapping is also enabled.

Link: https://lore.kernel.org/r/20241011175657.249948-1-nirmal.patel@linux.intel.com
Signed-off-by: Nirmal Patel <nirmal.patel@linux.ntel.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 264a180403a0e..8a036d6b7d497 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -1100,6 +1100,10 @@ static const struct pci_device_id vmd_ids[] = {
 		.driver_data = VMD_FEATS_CLIENT,},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_VMD_9A0B),
 		.driver_data = VMD_FEATS_CLIENT,},
+	{PCI_VDEVICE(INTEL, 0xb60b),
+                .driver_data = VMD_FEATS_CLIENT,},
+	{PCI_VDEVICE(INTEL, 0xb06f),
+                .driver_data = VMD_FEATS_CLIENT,},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, vmd_ids);
-- 
2.43.0



