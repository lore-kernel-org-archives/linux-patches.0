Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102DA288CB0;
	Wed,  7 May 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643384; cv=none; b=gla6Jo1t8R2uegiyo2Qioon4iCglq4gP+TBLAiS1gmAg9N+3BeASyuDy00WOEpR5IhHbljlLKb7ggDqetKF9vtSwshvj5xVz2bEwaacBeKXy9IIyJsqNQHoRY40bNmUJ9x3yL/j4k9Q+fNyxvC1pNxTFAF7uWF+32IPkNJHbtmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643384; c=relaxed/simple;
	bh=rWGb8EnwQxwu/sHWp8nNpoliZzexxqmRQ6AFtS+mhfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GzRKpKsbfnwSuJ30bBUHjKp6HVBA1Prik+VsmSl+b1yArrWUzaVZMREMyMpPV5G2/pio8oz/Cu9X0Cnd/b+cGSVZyxShPmFwd7GYgUi6VUgqjc3V/73JgEcj62i1yUbPMHBCv8EfTJLecS+AfbMm0y/iG3NNPlvxUumNbJcIA3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aK/ei0FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aK/ei0FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C12C4CEE2;
	Wed,  7 May 2025 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643383;
	bh=rWGb8EnwQxwu/sHWp8nNpoliZzexxqmRQ6AFtS+mhfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aK/ei0FUDahyPuk1DfIFQFNL410G7LyH1S2FntjmFZB7AiK35GDprTkYryFpOrw5y
	 AOwzSuq54zhUDXkcnKf3GCIshno+qhXmxe16/zPIpjGrImTd/7NMvPVYjeZsqIUp12
	 a1pwHgLq9NcKy0gZCkUZWyHXSP3YTY7yrPG3KWTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Ryan Matthews <ryanmatthews@fastmail.com>
Subject: [PATCH 5.15 42/55] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Wed,  7 May 2025 20:39:43 +0200
Message-ID: <20250507183800.737373628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

commit f068ffdd034c93f0c768acdc87d4d2d7023c1379 upstream.

The i.MX7D only has one PCIe controller, so controller_id should always be
0. The previous code is incorrect although yielding the correct result.

Fix by removing "IMX7D" from the switch case branch.

Fixes: 2d8ed461dbc9 ("PCI: imx6: Add support for i.MX8MQ")
Link: https://lore.kernel.org/r/20241126075702.4099164-5-hongxing.zhu@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
[Because this switch case does more than just controller_id
 logic, move the "IMX7D" case label instead of removing it entirely.]
Signed-off-by: Ryan Matthews <ryanmatthews@fastmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1070,11 +1070,10 @@ static int imx6_pcie_probe(struct platfo
 		if (IS_ERR(imx6_pcie->pcie_aux))
 			return dev_err_probe(dev, PTR_ERR(imx6_pcie->pcie_aux),
 					     "pcie_aux clock source missing or invalid\n");
-		fallthrough;
-	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx6_pcie->controller_id = 1;
-
+		fallthrough;
+	case IMX7D:
 		imx6_pcie->pciephy_reset = devm_reset_control_get_exclusive(dev,
 									    "pciephy");
 		if (IS_ERR(imx6_pcie->pciephy_reset)) {


