Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D539187FED;
	Tue, 30 Jul 2024 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356666; cv=none; b=DrtYzEjsEq7jnOP1fXBc4EhMsiEr0pc0B/hR8UHNAvjw23Q2bbzrMRSMkIWgd7OupMhfZR5pWZYMzhrfc+0h+jdr8gAY+q6FlZ9P0SKbhtqQgbobXZJ2Vp2iQnUouCWtj2vRCj5EzD6TdjruRL5SOqWY7EAm7eEZQnlUdMlTytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356666; c=relaxed/simple;
	bh=o1GADJyBo0Z9lfEpgztHBP8GTA9ttMoZjBkEFuPSaww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEk1J5X2xhwZXP+gRote0DFpd9yb4tUOv88iHeBSH/5QVVG+59Y720+WDYbBEnv2ki45ClrueAPlc+qnXYvRHn0BHXIjJpcbEYtlT0Y9d8g3icu1HQe8uQ2yKXJB5frs3DoJVwEa5GukwPStQ3xCFv8QPm6kmwOa/t3ugvgIsh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDewoVnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDewoVnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59E8C4AF14;
	Tue, 30 Jul 2024 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356666;
	bh=o1GADJyBo0Z9lfEpgztHBP8GTA9ttMoZjBkEFuPSaww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDewoVnkyPhIsY41u2kdeWJyI1k2/zRQAzp42eu35/a9wDWGUWW7dzyXYx1AJn0hx
	 wuZut9Qy8qxKy3DQY9sHr3AflFHDnbK9+6p6ufDAVo3o44joSDlOpe46CLhFOM0bgC
	 GvL1z48YK23O2z5MOMdOyY32Av5ZO8C2A4QV1Uj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/440] PCI: qcom-ep: Disable resources unconditionally during PERST# assert
Date: Tue, 30 Jul 2024 17:47:30 +0200
Message-ID: <20240730151624.337401186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 912315715d7b74f7abdb6f063ebace44ee288af9 ]

All EP specific resources are enabled during PERST# deassert. As a counter
operation, all resources should be disabled during PERST# assert. There is
no point in skipping that if the link was not enabled.

This will also result in enablement of the resources twice if PERST# got
deasserted again. So remove the check from qcom_pcie_perst_assert() and
disable all the resources unconditionally.

Fixes: f55fee56a631 ("PCI: qcom-ep: Add Qualcomm PCIe Endpoint controller driver")
Link: https://lore.kernel.org/linux-pci/20240430-pci-epf-rework-v4-1-22832d0d456f@linaro.org
Tested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index 1c7fd05ce0280..f2bf3eba2254e 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -446,12 +446,6 @@ static int qcom_pcie_perst_deassert(struct dw_pcie *pci)
 static void qcom_pcie_perst_assert(struct dw_pcie *pci)
 {
 	struct qcom_pcie_ep *pcie_ep = to_pcie_ep(pci);
-	struct device *dev = pci->dev;
-
-	if (pcie_ep->link_status == QCOM_PCIE_EP_LINK_DISABLED) {
-		dev_dbg(dev, "Link is already disabled\n");
-		return;
-	}
 
 	qcom_pcie_disable_resources(pcie_ep);
 	pcie_ep->link_status = QCOM_PCIE_EP_LINK_DISABLED;
-- 
2.43.0



