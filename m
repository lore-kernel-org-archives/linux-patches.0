Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B011A29A;
	Wed,  7 May 2025 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643656; cv=none; b=b7/bfTIjmQeweVARW7UWOILzrZlVG+o8rIlSATt2EX5Ly2A5qzlbGYRsdrAhAI3odWGylpivc3ye6QBRIplsNMJJtmIU212hslxymKvcbRFe3PSb5fHHqQJEI1IZNkmZ0opFY3doGn68wDyWo+JEw7d0IozBJPb/fOWab3aZY8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643656; c=relaxed/simple;
	bh=JMayWtIKxoJTD5ZJOl7vDXPCPoqK8cftIK2PiKnejmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pja/c8R3/8y+1T1v+9Fmv36aZr3QnLiwuYIA+cPY+b/CbB3wop0/6DFCWPj95dSLQTLjlxF7wyng/7werZW/yKMEJk0TB7l/SMilxEx837kQHruk8LQgi5QMAuAipeEkT3XTUa1+5q6ndnqqrImVKS6IF15xkHO3lHXzYYyMRZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKaK/O9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKaK/O9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284DCC4CEE2;
	Wed,  7 May 2025 18:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643656;
	bh=JMayWtIKxoJTD5ZJOl7vDXPCPoqK8cftIK2PiKnejmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKaK/O9M27bXQPKYaRhR4JsOhfUCS21/6KpJ7B2oUi1KbaVqQBLCOlQTJ9JBEhL/s
	 ZNWCMoPFBucx4AryNxNIF2V/fQScLhka1Xotqp0lYIKGZkAorn+iHAHWiJyCcYhdFm
	 LPZpHoQtUxJhYC3vq/Xwx/Uy+VoY2miirOIdVtXI=
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
Subject: [PATCH 6.1 73/97] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Wed,  7 May 2025 20:39:48 +0200
Message-ID: <20250507183809.926851989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1172,11 +1172,10 @@ static int imx6_pcie_probe(struct platfo
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


