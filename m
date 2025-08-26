Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861D726FDBF;
	Tue, 26 Aug 2025 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213830; cv=none; b=sWjAuQHI16MQumbXcNjjmSj1kUpfpjReroUaXM+yt2x/T+zy6QxkGf96QV9Sscx5Dp2B+Qx6M+o5cqj63yIEaa+mRWI3VwRlZgeNW7zkS1zkpFGY1gRcB8xhUnV2HgH8/6gWRMiNretLfQe2Us2jX90hMc3DnUqCtXL/qEnrNWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213830; c=relaxed/simple;
	bh=OCWqdV8RXyeyZpiEiDgmFQHyD4+j70WI3TYpPAbxGSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbvO2haGvU9hkYP64bY2I8BUgA2iNbYr2vEzn357ZiqFg0qhSZ0l8hZsmgV7dbnaacPqvZwzReVLkWpuMIoc65L9zvEX9YRWH3hyV/0A8qmg/ODTc3ocXGPFqYqNx6IQXjCM0T112TS3W5rB5QvwTzPIX3/OQ56aU92ogrOenf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE4VbeMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE4VbeMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1537EC4CEF1;
	Tue, 26 Aug 2025 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213830;
	bh=OCWqdV8RXyeyZpiEiDgmFQHyD4+j70WI3TYpPAbxGSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FE4VbeMk8EpFtWdVcE4yMbATbvArDRZqlhx6eSLCUd6ZOiAQ4KYP6z/eyxvfpWGXL
	 jevdwj8QMf3LMHrJXXpb7jTyUQqtO5JTb2J5d19a8aIW4LqRvJD3H1gOBhDstwmkC/
	 KB6VcSLtQqNiIRHCqNI1bUpUSa6p2Dvd8oKeU3y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 496/587] PCI: imx6: Add IMX8MM_EP and IMX8MP_EP fixed 256-byte BAR 4 in epc_features
Date: Tue, 26 Aug 2025 13:10:45 +0200
Message-ID: <20250826111005.599433958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 399444a87acdea5d21c218bc8e9b621fea1cd218 ]

For IMX8MM_EP and IMX8MP_EP, add fixed 256-byte BAR 4 and reserved BAR 5
in imx8m_pcie_epc_features.

Fixes: 75c2f26da03f ("PCI: imx6: Add i.MX PCIe EP mode support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[bhelgaas: add details in subject]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250708091003.2582846-3-hongxing.zhu@nxp.com
[ Adapted BAR configuration to use reserved_bar bitmap and bar_fixed_size ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1043,7 +1043,10 @@ static const struct pci_epc_features imx
 	.linkup_notifier = false,
 	.msi_capable = true,
 	.msix_capable = false,
-	.reserved_bar = 1 << BAR_1 | 1 << BAR_3,
+	.reserved_bar = 1 << BAR_1 | 1 << BAR_3 | 1 << BAR_5,
+	.bar_fixed_size = {
+		[BAR_4] = SZ_256,
+	},
 	.align = SZ_64K,
 };
 


