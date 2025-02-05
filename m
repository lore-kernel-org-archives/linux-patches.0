Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C941A7DA6A;
	Wed,  5 Feb 2025 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765952; cv=none; b=PhcuWBLzBDb+OnU6jvtY5rzxcfnEXSaz2MPFetVgIPz8bxDDksw+VY2rRTAwyasPb0PyHHKAv5q99Qh/jM3ypMgckwKOrDIJnhh0vLK5KA0MgZYJ3o8b+RyKrmiA5X/mBrd6oohu4YHNZYmyJVbRzrElB3iSmtyLp7N6uxTnk20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765952; c=relaxed/simple;
	bh=2t1KRYrpeRJ8c0Iz/qGe9jFuE74FSkMzeekSJ+QHgJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7nz22AYP8GQHt2OmEtxOt8MhsQsGiadVOj6cQegWtupVDzQlxGJE5Tj0dJik+/66aqHuwoBshTzG68OS7xQMI8Q85xcAhTX5i+zXP3PHbEHThdCE1tDLCTwE2yX91XFwKuDwICwwtd/dZS3EpEUuEB4ey7i8jqGXacl0bzYS8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/4wc3dD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/4wc3dD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BD9C4CED1;
	Wed,  5 Feb 2025 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765952;
	bh=2t1KRYrpeRJ8c0Iz/qGe9jFuE74FSkMzeekSJ+QHgJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/4wc3dD6LOVFPW7F/rjwSeTkbb5k4HMqfrwCpwiErUQhBfC0zMuwLWg7UsdjaMUV
	 AIOQsLcwNio4uZpkhmozacixmz1nhuXmZM0KS84ZOPOjKHk5oZbyx1WCzRcj5smUbj
	 hg4Q8f62kLrZdwlUgzZdT/rluC/eHRsDrENweWEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/393] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Wed,  5 Feb 2025 14:43:39 +0100
Message-ID: <20250205134431.792106521@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit f068ffdd034c93f0c768acdc87d4d2d7023c1379 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 20c8f2cba4536..822a750b064b2 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1281,7 +1281,6 @@ static int imx6_pcie_probe(struct platform_device *pdev)
 	switch (imx6_pcie->drvdata->variant) {
 	case IMX8MQ:
 	case IMX8MQ_EP:
-	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx6_pcie->controller_id = 1;
 
-- 
2.39.5



