Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755D822331B;
	Thu, 12 Dec 2024 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018493; cv=none; b=YJVMU9GL8VooXTRGEHWwQyIWttEQRlXrM9ovS6V+KUnigTQ13JE0ewmswne1HLFldpZi7xarbRKyHkonJ4ogegKUHuircFh1blf1GnHLa6c5B/sDPnCG9YKZ1aQmoKp1Ba7XlBP4AlwaR/ja6qLcTTsDeszXK8qPxLvn1dNWlPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018493; c=relaxed/simple;
	bh=ZCgWOwUW1iuRzWTEfMPkSxwj5CBdrLZDLcz0O4CfrFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jy6GvDMLL9jfK3EBoiwYKYeEX7F40rY7nC4hhW/4sqWqQFPELknEhpLkGSLuU+1InkZd9q5jjVnQDl8LBNtZvGalokhcdEMd5rk4ooRRR7YZxqAkTXggVq9zgWlqh64NOdPwc7Gv5trvwhSG5uD2KM3hFE/1MO3fYhgHnOBQZ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8omhO6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8omhO6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF78BC4CED3;
	Thu, 12 Dec 2024 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018493;
	bh=ZCgWOwUW1iuRzWTEfMPkSxwj5CBdrLZDLcz0O4CfrFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8omhO6dKfVuDWlxHpPwjyYDhWjygmmZRelob9oHarXmawE3J5E/zRxbdNnb5AVPT
	 67X5RkwWn8CccH7kwc6Em/gKejShYZmeM2XsqnJIcQs1bSOH0HPBWDX6rgqMHBTYpE
	 LfePObdcQDxIlVzvuKM8zEzN9PgYe5HwRcUwijAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.ntel.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/356] PCI: vmd: Add DID 8086:B06F and 8086:B60B for Intel client SKUs
Date: Thu, 12 Dec 2024 16:00:10 +0100
Message-ID: <20241212144256.068765237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6ac0afae0ca18..ade18991e7366 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -1114,6 +1114,10 @@ static const struct pci_device_id vmd_ids[] = {
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



