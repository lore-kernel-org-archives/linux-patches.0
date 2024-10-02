Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B558C1CDFBC;
	Wed,  2 Oct 2024 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876644; cv=none; b=PMtQ+YCS/QqpWNdO4kRTKf1QKzeXB/SIF6Q1zkEwLpSfdfk3+1DqJE/dUR2oQ8lJ+Z77S/TKXquK4sKh7p2McJa6X6JnJ3Een1yZFFVpIdS+/pe7NDhnzlhNpO3U0Gzbqu+L95wVMTmeIXaD4Tls79PwzkFvj5SUdn4tdxdrlXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876644; c=relaxed/simple;
	bh=qF/0IO0RT7Ewp0ux4PFGeX7gBRuucEPuFML6Uj2/jHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oTaBVMUi2z43QFemhNx1XRFEayDwhZmcshxnuEPGezECKXxpFNuzRr3zU7GGxD91ybMABTgyO8XdNmOg38/NXVSFchOQGGHSOiwrtIaczIX+1yz7SwTsV9TWylnjpxGGTXdP4jaN557HgB+7FTNSFS+H8OWnJOFevLRi/n1Drh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/HVKZAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/HVKZAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6DBC4CEC5;
	Wed,  2 Oct 2024 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876644;
	bh=qF/0IO0RT7Ewp0ux4PFGeX7gBRuucEPuFML6Uj2/jHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/HVKZApU58DtD92qX5mmhJvoVffDDDNjrzNuDz9/DgJVtinf9dQTMceHz2tBathR
	 n1pSa5X70PfJ0AQYf5h2WU1eeRebB3vrxUqiK5gATjEHgCLp7nGfZfIwYjGkeQiyIg
	 8En0316lqxJFuFbkDRwEu1t7jQXxwOmChk39QHfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.11 514/695] PCI: dra7xx: Fix threaded IRQ request for "dra7xx-pcie-main" IRQ
Date: Wed,  2 Oct 2024 14:58:32 +0200
Message-ID: <20241002125842.999659510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 03f84b3baba7836bdfc162c19288d5ce1aa92890 upstream.

Commit da87d35a6e51 ("PCI: dra7xx: Use threaded IRQ handler for
"dra7xx-pcie-main" IRQ") switched from devm_request_irq() to
devm_request_threaded_irq() for the "dra7xx-pcie-main" interrupt.

Since the primary handler was set to NULL, the "IRQF_ONESHOT" flag
should have also been set. Fix this.

Fixes: da87d35a6e51 ("PCI: dra7xx: Use threaded IRQ handler for "dra7xx-pcie-main" IRQ")
Suggested-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/linux-pci/20240827122422.985547-2-s-vadapalli@ti.com
Reported-by: Udit Kumar <u-kumar1@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -850,7 +850,8 @@ static int dra7xx_pcie_probe(struct plat
 	dra7xx->mode = mode;
 
 	ret = devm_request_threaded_irq(dev, irq, NULL, dra7xx_pcie_irq_handler,
-			       IRQF_SHARED, "dra7xx-pcie-main", dra7xx);
+					IRQF_SHARED | IRQF_ONESHOT,
+					"dra7xx-pcie-main", dra7xx);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
 		goto err_gpio;


