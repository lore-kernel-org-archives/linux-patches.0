Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179E02144C1;
	Wed,  7 May 2025 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644948; cv=none; b=hvqM+ka8QFQUzAMIqqLFwQc2MBCYUGpvHN7rdXHDsg6aulMoGC1dV6U9BtYtJHXxRb3kBrAhnsL7C+hQKlf2886O4AOewJ7EYmup8O9nci7KMYZXhiPUqj4QUyvlwmssHBvNFZGyzqrgZfV5C6A3HFFtgMIJcqlXvWEXpO6pkCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644948; c=relaxed/simple;
	bh=e1A9VCU9nrNXFUJ87A+igwHYsxHOuVwkN2rSZmFWShs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKWNwRkn8Asme/pGGqkSAH9B+lU65ffs0lAy2FmdWYDbVnLZ0OWY80sR5I7U3vU9RZW5X78UsyInqJchQ1T0QfggyG7FaEW24ih1b3RvmXv426fmUa+zZBwMQnh2M/cY9KrMSoUZRFFkV4nt4P3wN5o47JPatG0lc9oezXR3QgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uu+E3CUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uu+E3CUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CF0C4CEE2;
	Wed,  7 May 2025 19:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644948;
	bh=e1A9VCU9nrNXFUJ87A+igwHYsxHOuVwkN2rSZmFWShs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uu+E3CUSoKcgkPRWMRugZ+pUtEvuZ9hVIcLxVEznKIDj1BT9eTmk0KcGue44gsqDO
	 2wvKpIPGJwAJUQrfCafp+QSScMXkYV4Xxn3WbID5X6lbp8bViZ/GYy/1/5NsJIGpsx
	 1UT4GMK7E+E2fIUFjJlPKVuqz2xy5PuwTJKy+AoY=
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
Subject: [PATCH 6.6 044/129] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Wed,  7 May 2025 20:39:40 +0200
Message-ID: <20250507183815.326275687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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
[Because this switch case does more than just controller_id
 logic, move the "IMX7D" case label instead of removing it entirely.]
Signed-off-by: Ryan Matthews <ryanmatthews@fastmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1281,10 +1281,10 @@ static int imx6_pcie_probe(struct platfo
 	switch (imx6_pcie->drvdata->variant) {
 	case IMX8MQ:
 	case IMX8MQ_EP:
-	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx6_pcie->controller_id = 1;
-
+		fallthrough;
+	case IMX7D:
 		imx6_pcie->pciephy_reset = devm_reset_control_get_exclusive(dev,
 									    "pciephy");
 		if (IS_ERR(imx6_pcie->pciephy_reset)) {


