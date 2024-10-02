Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC021EA80;
	Wed,  2 Oct 2024 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880255; cv=none; b=UcYpABh/gP+RIPChKDcaZ/pdtd3+KdkUUXtHlsFk+UlhznvjsNxXJOlW1j3ddal+Nv/gHNug56Ru1eRePvqz1SlQa2sKKXwcCmd8Wb7mZvadvpHOe/w9AmuqK0ocED2N4+9b/lKpPlWSp90/EMnbE2ibPgbgh9Hk77q8pqay5cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880255; c=relaxed/simple;
	bh=RT+qv1Htruml9opTYKkdxRmoR63Lj8fRPLEq2MMwo+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEXJFjWviTIxpJzAULjqHv11NQ41w0QuaJ9aFPdMJsKcA63fsxJj0e+sruFZLWXSoqqBJ8nQAm2YYrJ/jKhNjVQNi7640PI9Zw6fmTr95raSP7Dz2k2DZdOX9oEqVIugMutnHB1bguJyMc3uUeI2uqeGGweolX0zlHN+pDsQPKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESDgUc+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESDgUc+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4C0C4CEC2;
	Wed,  2 Oct 2024 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880255;
	bh=RT+qv1Htruml9opTYKkdxRmoR63Lj8fRPLEq2MMwo+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESDgUc+CWNWbfOeG4spoNAiosjWs1XOlfxZ6cEG0psFDcuBtz6YsNa7JsBO6dTrrv
	 pjnvJRA3jftVOf18hdfeJXX4qBRXQ3cu+p7N187nSbp2gNzw1ONkKgsKHhmAHI/fQl
	 nO2va9n96gerhNCEVLk4ddstidkPjFvHb7k4AHhQ=
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
Subject: [PATCH 6.6 395/538] PCI: dra7xx: Fix threaded IRQ request for "dra7xx-pcie-main" IRQ
Date: Wed,  2 Oct 2024 15:00:34 +0200
Message-ID: <20241002125808.026436406@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -841,7 +841,8 @@ static int dra7xx_pcie_probe(struct plat
 	dra7xx->mode = mode;
 
 	ret = devm_request_threaded_irq(dev, irq, NULL, dra7xx_pcie_irq_handler,
-			       IRQF_SHARED, "dra7xx-pcie-main", dra7xx);
+					IRQF_SHARED | IRQF_ONESHOT,
+					"dra7xx-pcie-main", dra7xx);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
 		goto err_gpio;


