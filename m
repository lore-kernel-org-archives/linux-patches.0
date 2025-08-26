Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5DE2F83C1;
	Tue, 26 Aug 2025 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207234; cv=none; b=tmQPDUBN5LwPlSqTrh3lhghgjAe8Zl4ivLWqveCuWinLzgJ+7o1OB/oaDxA3mxj/Pv68X0c3NquS1Fn9DB2ZqUV6aLCWXNnocscc0IZHdwD8hpNRvIRh8xUdsWVhy4aZ4P1mUaTFPDXLMmrr9Qq8GMeaRoY+DR2LA7kh+KkEcAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207234; c=relaxed/simple;
	bh=PWU7hhBphaKkMudw3M5gpUttTlO1EJs9bsIEg2iOStI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTGb4vW5kdn+DbYkbN/gWP/lXr0deS+WQ7L2ta1iQEzaibHIa6B40KLwLUNAfWU88f3v8Z1htTutxNmtc2KCmZ9qjO7kqThcHrx39IDoktc6g3bhBpRKxEes2v7ovFZbGvh2JdT3VSVgWBiDX84JxkVRhRMGCzfff2ZrtbCpoOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzMqw8CO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzMqw8CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5093C4CEF1;
	Tue, 26 Aug 2025 11:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207234;
	bh=PWU7hhBphaKkMudw3M5gpUttTlO1EJs9bsIEg2iOStI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzMqw8CO405rapvaP7sevshi7iD1IbLskHuQoKbTP/e2XaQTe+v3uF8fcn949Vxlm
	 3OkGJ601Db8ABNstSI1RZtu/qr8+m6MtK2YIZaut/YxMumV7L5Uoqx47YLT0ukwTXR
	 hp/kY8Eu41KPuPqi5kTIVJnHaKswVUmxthS/bn3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.16 102/457] PCI: imx6: Add IMX8MM_EP and IMX8MP_EP fixed 256-byte BAR 4 in epc_features
Date: Tue, 26 Aug 2025 13:06:26 +0200
Message-ID: <20250826110939.897728169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit 399444a87acdea5d21c218bc8e9b621fea1cd218 upstream.

For IMX8MM_EP and IMX8MP_EP, add fixed 256-byte BAR 4 and reserved BAR 5
in imx8m_pcie_epc_features.

Fixes: 75c2f26da03f ("PCI: imx6: Add i.MX PCIe EP mode support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[bhelgaas: add details in subject]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250708091003.2582846-3-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1385,6 +1385,8 @@ static const struct pci_epc_features imx
 	.msix_capable = false,
 	.bar[BAR_1] = { .type = BAR_RESERVED, },
 	.bar[BAR_3] = { .type = BAR_RESERVED, },
+	.bar[BAR_4] = { .type = BAR_FIXED, .fixed_size = SZ_256, },
+	.bar[BAR_5] = { .type = BAR_RESERVED, },
 	.align = SZ_64K,
 };
 


