Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B415B0EC;
	Tue, 17 Jun 2025 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178605; cv=none; b=P30aKNFZ019mQ6zL8Nyfzbg1UhwmyuBC1E1tLffnfkgOF01YL4j3rXilEcQUcuvdz/o2eB61UfpLKas2abcSukkw22UdBak2sKphIjCUh74zPN86TPItP2FTZ8VSUqNq9RhQJHiue3FRlkCjZgTSn/LlF0WXQ5mjCiGV8Itrmpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178605; c=relaxed/simple;
	bh=4tSUnrKwFhccExyKTenUWPhF5JjlAetq4jdpo6UwmQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMQMYZhHkbm/6Vx6iBgNSNPN5IBD5VikU/YMvDSF64eFQhHz99Geb6Lak/mgPbXRVECEbDb+rnvUSAoA92sFh6N/GIEY/kFYjpQJs1xvdJjOTXZqnF5V82SGv1iE97EmjDT48EALiSZVeuLMt6Fb2c9lVS1NUAuC90yhlTd5AUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdEpzxv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdEpzxv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D27CC4CEE3;
	Tue, 17 Jun 2025 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178604;
	bh=4tSUnrKwFhccExyKTenUWPhF5JjlAetq4jdpo6UwmQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdEpzxv35VGouP7mXeVbVy0I188ldHcdEXrS4Xb9IhcyqpxNtz0vPbkKa2L/9hVIS
	 GY11g1B5I8QXhvN+6kNrZ3Cnn4yDFUP02AogF6r8PCgsnKr6zAv+Bv9pD/EVwY5ZxN
	 X/7FzTSbx3jC7hkPGS9ytFvunGGJzattLq/xKqF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 497/780] PCI: rcar-gen4: set ep BAR4 fixed size
Date: Tue, 17 Jun 2025 17:23:25 +0200
Message-ID: <20250617152511.734846217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit b584ab12d59f646b9254b2b16ff197d612fd4935 ]

On rcar-gen4, the ep BAR4 has a fixed size of 256B. Document this
constraint in the epc features of the platform.

Fixes: e311b3834dfa ("PCI: rcar-gen4: Add endpoint mode support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250328-rcar-gen4-bar4-v1-1-10bb6ce9ee7f@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index fc872dd35029c..02638ec442e70 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -403,6 +403,7 @@ static const struct pci_epc_features rcar_gen4_pcie_epc_features = {
 	.msix_capable = false,
 	.bar[BAR_1] = { .type = BAR_RESERVED, },
 	.bar[BAR_3] = { .type = BAR_RESERVED, },
+	.bar[BAR_4] = { .type = BAR_FIXED, .fixed_size = 256 },
 	.bar[BAR_5] = { .type = BAR_RESERVED, },
 	.align = SZ_1M,
 };
-- 
2.39.5



