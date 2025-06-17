Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A984D2F9480;
	Tue, 17 Jun 2025 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177228; cv=none; b=nbZ+tAGHShubb/hGgTigL1BTOwCy4pQMzqK0Ulj8ml6AeUxAZW1cVjSaDDiRoLOL2y8Fh0eQmpl+3Fd7M6MVk2Gdc37E86fqm2EbFVThe13wT5MpuS+d2aVbjef4lZgaao/p7jdC9QRyIhi3c79oZDmz3sNrdyJrpdvskDjcB+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177228; c=relaxed/simple;
	bh=T6IMXamBOQEFsoBEANpuAEU100gSmyVfIrn0VwGeANk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptiT+EyrQSwsl8cxMzQqDLJIUi4DmPW+DHf9ixSc9+mgqkxl2WjX6dRsCvJ+z3Aql9JIzYJWXcvDl1IHwpmJNdQ8qUsVuiGwqo9DafDNSgBWuZhyxPvNEuXGtYWCKHQDFVHT7x8+PCyDNSBHcAPCJewDFQxmGJ1b/kwTXcBt9Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD00eDQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD00eDQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50FDC4CEE3;
	Tue, 17 Jun 2025 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177228;
	bh=T6IMXamBOQEFsoBEANpuAEU100gSmyVfIrn0VwGeANk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD00eDQG4DiArHETJfIxbrTWQXAwX58tooRRvL6pCiVSleSxEJyXz2xLuiANAhygp
	 mBTOlVaHwXV9zvGXCbS+v6rgTVw60b7XmycIkkoQnbYRm9ulwz2II3MrgkeX+aDda6
	 HOjuZZe2Dy+b6jNfB58Pyv3+QL8SW8YRKgIh34Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/512] PCI: rcar-gen4: set ep BAR4 fixed size
Date: Tue, 17 Jun 2025 17:24:36 +0200
Message-ID: <20250617152432.167775942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit b584ab12d59f646b9254b2b16ff197d612fd4935 ]

On rcar-gen4, the ep BAR4 has a fixed size of 256B. Document this
constraint in the epc features of the platform.

Fixes: e311b3834dfa ("PCI: rcar-gen4: Add endpoint mode support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250328-rcar-gen4-bar4-v1-1-10bb6ce9ee7f@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index 3a5511c3f7d97..5d77a01648606 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -403,6 +403,7 @@ static const struct pci_epc_features rcar_gen4_pcie_epc_features = {
 	.msix_capable = false,
 	.bar[BAR_1] = { .type = BAR_RESERVED, },
 	.bar[BAR_3] = { .type = BAR_RESERVED, },
+	.bar[BAR_4] = { .type = BAR_FIXED, .fixed_size = 256 },
 	.bar[BAR_5] = { .type = BAR_RESERVED, },
 	.align = SZ_1M,
 };
-- 
2.39.5



