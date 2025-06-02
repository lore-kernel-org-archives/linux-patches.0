Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620A81DD543;
	Mon,  2 Jun 2025 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874425; cv=none; b=icw298CAvf2lxkUcW1aG3zRVR7HKT/wbtVgmqek4e4/1/vpjgg8Vq5QRLwEk5A2XHpTqiz7zwF/qDf318dNzsz9na86ddve5V60ruoScB8TATXV8dsXG2aL8Bheh1dPXBIYjv0LufWG5mF4yiB7RHgzSE+nEz8gQDxM0zNDMEE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874425; c=relaxed/simple;
	bh=+Xiuu+guafYM2m2/Fw0Bv+8JCxcRGqwZVbNHS7Q0vQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SzmbUOprsFpk6lppA5U45ZlnioeOXqf7oFkD2hR3vMWVBxYbtLVUs1utj7hHXniWiHwRL5nP5AX3+OO8XPOfSXvRZkrFIHcQbICt8LQc11GyELCY9mFr9DtzEE0ZiroojX230+7J5XGJZgxgtxSAny7y9CjFOA4qx/LZYit/yo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1KCTCmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1KCTCmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C59BC4CEEB;
	Mon,  2 Jun 2025 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874425;
	bh=+Xiuu+guafYM2m2/Fw0Bv+8JCxcRGqwZVbNHS7Q0vQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1KCTCmjuFN+rikxziWnQ0jYR8M0BTFhBnhTOIVAC4NaH69LnNIQBrRDquSfUefqS
	 D9G50HhQ3ECV/4oEn7VzxYGIxyN+XJq0lGQJ8vC+ftvZdG+bmhZgPCNlBoteLHtRRP
	 Y2xLxIjW7QmongP9c4M46ztr09YzuJcJG+vFm+ec=
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
Subject: [PATCH 5.4 020/204] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Mon,  2 Jun 2025 15:45:53 +0200
Message-ID: <20250602134256.294885139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1112,11 +1112,10 @@ static int imx6_pcie_probe(struct platfo
 			dev_err(dev, "pcie_aux clock source missing or invalid\n");
 			return PTR_ERR(imx6_pcie->pcie_aux);
 		}
-		/* fall through */
-	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx6_pcie->controller_id = 1;
-
+		/* fall through */
+	case IMX7D:
 		imx6_pcie->pciephy_reset = devm_reset_control_get_exclusive(dev,
 									    "pciephy");
 		if (IS_ERR(imx6_pcie->pciephy_reset)) {


