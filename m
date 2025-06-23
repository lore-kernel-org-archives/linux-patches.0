Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30428219E0;
	Mon, 23 Jun 2025 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712756; cv=none; b=NqdDhSCapkJMzCrC+L6OibDf2CE8Gpqq00F394jYsbJvxb2b9o96GPjT5NP0Oue7oQPgR/8AAP8D7TfI6wUPhW//ZA+aVguQQWtOiN65Bcs8rMTIUiMv49GS74x5XIBE0bfCwIayAyL1hCRIRdxGDqkHvhgclifHSHU8lywuxHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712756; c=relaxed/simple;
	bh=CKx+Hb3Td+bELceguDVxpsykqo1GAefXT/cNEgyfz6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5sGLl6WmXFQYOUhpPhICEL0DyeoxjsL6C7FgMVEk1UIqp/eYvoV+/ukyI+HZJuE9IQ5GHJ6XJ/cqEkNpYFqERaVdr+SoA19BNYR9awr3L7lgOomU8x/t7MC0aLVpl+V+uwtU2lTfku+BAuE31Co74d3iQ3JuthZOunCzemCGI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ag/XibzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ag/XibzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6E7C4CEEA;
	Mon, 23 Jun 2025 21:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712755;
	bh=CKx+Hb3Td+bELceguDVxpsykqo1GAefXT/cNEgyfz6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ag/XibzW/2JaE2VgfQTW7zi5/a2VMnX8eA4oCN8bUDh/K1dBSDqa1sTtRC/vYrsdI
	 jaGUuRPziqsumEVEXk/tiBZ8+3UpJqGAyi1F36NDHN/jTVF1WGHYooCAxXF9C9Hwro
	 /ombnYFwNCD7PYRtds1h1whWefvjIE1L8LXLxUI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/411] PCI/DPC: Initialize aer_err_info before using it
Date: Mon, 23 Jun 2025 15:04:10 +0200
Message-ID: <20250623130636.185117099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a424b598e6a6c1e69a2bb801d6fd16e805ab2c38 ]

Previously the struct aer_err_info "info" was allocated on the stack
without being initialized, so it contained junk except for the fields we
explicitly set later.

Initialize "info" at declaration so it starts as all zeros.

Fixes: 8aefa9b0d910 ("PCI/DPC: Print AER status in DPC event handling")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://patch.msgid.link/20250522232339.1525671-2-helgaas@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index ab83f78f3eb1d..cabbaacdb6e61 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -263,7 +263,7 @@ static int dpc_get_aer_uncorrect_severity(struct pci_dev *dev,
 void dpc_process_error(struct pci_dev *pdev)
 {
 	u16 cap = pdev->dpc_cap, status, source, reason, ext_reason;
-	struct aer_err_info info;
+	struct aer_err_info info = {};
 
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_STATUS, &status);
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_SOURCE_ID, &source);
-- 
2.39.5



