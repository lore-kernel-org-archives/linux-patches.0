Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D50A1FC0EF;
	Wed,  5 Feb 2025 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767225; cv=none; b=R9u9FeVOwtOEbPFVbAOc2jhM+NBlKg8v71jaTuShk5EdaJ/s/fIPbtpPwbKaGcfgte/yWkOJbBybTivr+ul2I9HE5BWOB5v9ayM6A24/xhJqvZLMDSaPgC4IdMuNvOvvTUAB34TV+1FVle2289Zr390Jf2Y+gl5s0d81o4AXJZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767225; c=relaxed/simple;
	bh=vY0UNt7kkwYb1NyMHZxmDacTyuY8bpWejtj2lM20F/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2iW1Wkpx/Ej1jB+yDegA5Nnq/7ZUIe2sM3EHPqThwtD3IcObPGHIoEJuJkaujaKhdpLTVsNsHCAdDUPzE3M5WHqGzzzyvSt59f3+yJQOKxpkilim18+uzjTH0o7S0nN4CkgLyAafCILhm8JaX4dotkkoxmVfrKKAVSs/Q6DP5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/7knL3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/7knL3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2BFC4CED1;
	Wed,  5 Feb 2025 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767225;
	bh=vY0UNt7kkwYb1NyMHZxmDacTyuY8bpWejtj2lM20F/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/7knL3pEmX2NXiNi36MPmTmTCCo+RpcLlZaZmaFVBLxIS9amqMEl/ZLVBuAbLudQ
	 UNYXjU0SJL4K7poRlm9gtdsgFDdWLFNwKGjXwFRN18NfGRNy1DqJ84qamRcbmpj7Wb
	 4sdQ+USCht8A4bjaybALE36LXdNhx8whvRSFJ7qo=
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
Subject: [PATCH 6.12 426/590] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Wed,  5 Feb 2025 14:43:01 +0100
Message-ID: <20250205134511.562868350@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d61e7c472082..22bf21846b79d 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1393,7 +1393,6 @@ static int imx_pcie_probe(struct platform_device *pdev)
 	switch (imx_pcie->drvdata->variant) {
 	case IMX8MQ:
 	case IMX8MQ_EP:
-	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx_pcie->controller_id = 1;
 		break;
-- 
2.39.5



