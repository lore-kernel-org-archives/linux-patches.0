Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F84F35A3B6;
	Thu, 12 Mar 2026 20:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346457; cv=none; b=SXS2fwylbj225vDoHqEyuxLco6DdwAFtWSX2bEAuposkhFrhrqAK39g1Mzia+ufcT63a7C3+ZaHN+/KCgp0fqAxGN5zUbPHnAoVbEPVJh7nPJHmGRGuJz5QNCX+/WQ2OcVinenm25pV/+FN/ZxXi9W9K+ALiGlZcPYfpFyXkjK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346457; c=relaxed/simple;
	bh=ZZOioaStvFHkxyfEkFAsTd2s4E0hGRPTsrOmr0RDY5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+MmIc4OjzL9t/yFJqY82KoK80vothaajbB4FFuE/zSkwPicyodlbzhkvgmVHhrQ/6TShcdZVePp06smEjlWgP/Xhznmurhg1TTKoeRvL05c+O1d1rbSgfBtqAtJh6cXiWxj6XOTejcJQNUy146Ko6FeEHyApZ4x1MDMrOI/usg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0Lt61BQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0Lt61BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF00C4CEF7;
	Thu, 12 Mar 2026 20:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346457;
	bh=ZZOioaStvFHkxyfEkFAsTd2s4E0hGRPTsrOmr0RDY5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0Lt61BQ3TXy4lPl+32M5sLbPNWfOncrADRk0oSlcfXO5XohtmcnUP3PYOdt/Cb6d
	 6xG1RZRdrApdFudVJ7JS3uahizxJPhz8KCB2vQWXo/pRFcT1DmLb2Q3+huOKoFtkiL
	 R/f3SJNvr39U5IwlYXH40mkGXbAO3dHmtSj2jojI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/265] PCI: qcom: Dont wait for link if we can detect Link Up
Date: Thu, 12 Mar 2026 21:07:13 +0100
Message-ID: <20260312201019.866430679@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

[ Upstream commit 36971d6c5a9a134c15760ae9fd13c6d5f9a36abb ]

If we have a 'global' IRQ for Link Up events, we need not wait for the
link to be up during PCI initialization, which reduces startup time.

Check for 'global' IRQ, and if present, set 'use_linkup_irq',
so dw_pcie_host_init() doesn't wait for the link to come up.

Link: https://lore.kernel.org/r/20241123-remove_wait2-v5-2-b5f9e6b794c2@quicinc.com
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: e9ce5b380443 ("Revert "PCI: qcom: Don't wait for link if we can detect Link Up"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 5d27cd149f512..0205c18d95a01 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1696,6 +1696,10 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcie);
 
+	irq = platform_get_irq_byname_optional(pdev, "global");
+	if (irq > 0)
+		pp->use_linkup_irq = true;
+
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
@@ -1709,7 +1713,6 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 		goto err_host_deinit;
 	}
 
-	irq = platform_get_irq_byname_optional(pdev, "global");
 	if (irq > 0) {
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						qcom_pcie_global_irq_thread,
-- 
2.51.0



