Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C4A340D90;
	Sat, 12 Sep 2026 14:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223660; cv=none; b=IsGS1eVsmQxQSdD/L4zXXSBYMGyV8objPUCaH7BFfhJomQ2bnqqJO1HOCR7xLL12JjTH+UYRdLhmcLs6bGBTm2AOjo6wL2BbAsTeQIMU7rUsH3B3kU5caL0SbgQ1S+cQuPLVjaqayIWyX0LnTxIB3RI+pYw08bFyMTczssaO9rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223660; c=relaxed/simple;
	bh=lOXoInklDnfQnfR0BPiHEW7V40nfO0HhXgYXcWg7Iz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9GIFELWvWe/e1CigBunfkDl17xq3FGSjDIhvvIcvgXtMaWCfl38CU4DIf2c2Yf4lAtsVorLNfHl7sVKfPFpJJ3LqD1UZO3dAj85I9GnVQF0N2Lhk9zhbZulvem/1OCa7KIgE9i6dyIroPeJtb2Sg7Y+zDqgOOl3LKX1bVnC6iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nrZdB5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nrZdB5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131B11F000FF;
	Sat, 12 Sep 2026 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223658;
	bh=9mOik0Cb7HEQlCMVk8U/JYI6I1Jg4JP+csi7qO5QuS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nrZdB5bG0rGbLIIqMl6foqYutljpstDrakfZxRIFFJ1C3CZCu6My4Ql55NnJhksa
	 jvXjBcL81LsSxJjlYZQFiGiK3v4vfY3ut9D+QRAB96Wmb9bSUdAGTszTOxI24NdKd0
	 bWrfKXnRFl8aFkMy+d0L9TrkbqrIxIDAN9XRDyis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takuma Fujiwara <t-fujiwara1@ti.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0834/1424] PCI: j721e: Fix incorrect max_lanes for J7200
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065625.986874281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takuma Fujiwara <t-fujiwara1@ti.com>

[ Upstream commit 7147a7bfce47acd48c3738130bf0bd692bfd80de ]

The PCIe Controller in the J7200 SoC supports a 4-lane configuration.
However, j7200_pcie_rc_data and j7200_pcie_ep_data incorrectly set
.max_lanes = 2, limiting operation to fewer lanes than the hardware
supports.

Set .max_lanes = 4 for both j7200_pcie_rc_data and j7200_pcie_ep_data to
match the hardware capability.

See J7200 Technical Reference Manual (SPRUIU1D), section 12.2.3.1.1
for further details: https://www.ti.com/lit/pdf/spruiu1d

Fixes: 3ac7f14084f5 ("PCI: j721e: Add per platform maximum lane settings")
Signed-off-by: Takuma Fujiwara <t-fujiwara1@ti.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20260721155743.3347659-1-t-fujiwara1@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 753a4c615781f..1db430b00890b 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -374,14 +374,14 @@ static const struct j721e_pcie_data j7200_pcie_rc_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.byte_access_allowed = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.mode = PCI_MODE_EP,
 	.quirk_detect_quiet_flag = true,
 	.quirk_disable_flr = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data am64_pcie_rc_data = {
-- 
2.53.0



