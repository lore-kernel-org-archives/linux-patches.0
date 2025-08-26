Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DB317332C;
	Tue, 26 Aug 2025 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208430; cv=none; b=QhxiQWya31WI2MvdRCRkcq+ZhOEys6qzj8Zt3rlZTKb1tnx7WcIWWuG25GQrL4nE6KoaFILKtaAIha+lnDeVrMLpZsQVieIrmV8mHNrK9dKvwFWoJbnbWhRYsJ4t+uRIAVXZbo3fA2VLcVHUozTuMcgbGJPDzLpAmmc2mW0drMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208430; c=relaxed/simple;
	bh=KfMzINjpr75HnO+R8AtsD8/11Krp55b98VmIl6VJ2do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqZEEZbLjrS4QeZZh0z0q1YCFpLIR+PbGskI7CIhRC6vNi/jDY1Oh8yZ7lF6gjW5CRYflxWRFsHuAcJjNaKOnuXIg9qUTQVAHUDaijDr7tw70l4bjUuYvLjSHJS9ina2Nkvub4+Fz/nSCBLlMSvSv3BjeAbaNBk1HFCu/qagPMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSgdY9p9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSgdY9p9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A26C4CEF1;
	Tue, 26 Aug 2025 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208430;
	bh=KfMzINjpr75HnO+R8AtsD8/11Krp55b98VmIl6VJ2do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSgdY9p9MmRz/idzUDu3L2EtXcG0HHzj0FPlXOzt7ONXyXvvRSnSZ2F9QLUNQVCrK
	 Hb2RqB8Wn5GtMrINXxsL5A62/Fm8QcxEh7B82rXzxbDJHzgQUvcg74RhxIcXCmap/f
	 MfKa6NsPA1XDltwtxPgQkdayQp5hrDNI+uVKxpGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 077/322] PCI: imx6: Add IMX8MM_EP and IMX8MP_EP fixed 256-byte BAR 4 in epc_features
Date: Tue, 26 Aug 2025 13:08:12 +0200
Message-ID: <20250826110917.508754450@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -1097,6 +1097,8 @@ static const struct pci_epc_features imx
 	.msix_capable = false,
 	.bar[BAR_1] = { .type = BAR_RESERVED, },
 	.bar[BAR_3] = { .type = BAR_RESERVED, },
+	.bar[BAR_4] = { .type = BAR_FIXED, .fixed_size = SZ_256, },
+	.bar[BAR_5] = { .type = BAR_RESERVED, },
 	.align = SZ_64K,
 };
 


