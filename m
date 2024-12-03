Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E5E1DA3D;
	Tue,  3 Dec 2024 15:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239140; cv=none; b=f1cQCzXGkZVJqR8Z1o92ILuoQtAQK5bMtrO326S8Rvzq8sTUjlHBxWtvpYTDWelCIENUXwjvDmZDx+bI7Sp9o9Sp9LGp9JOzllEfnOjbXHlhIJMzZCug2d54X99DoWWtqcOfWsb+T5SOB9jWaDnGPYtQ3XQq644xTNlxVQNIdw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239140; c=relaxed/simple;
	bh=JDU+aB5kvJEkMj/BLRvuEC6mFAcU+cD/HUmllz0L3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FY1Gczi3MqpfLIWMpALq7HKThXdGszcdP6jhHM7obiwEM4E0V1AzLwsICs0lhmtz5y/XSh0kXCmlfO2en32GXPu3BoAtte/Thi53+g+OZRc1DZmhYFakTlliS1kgLgzqphmqrmzlaQgpiV+m3bZUj/40CS2sMTjUQn2Q2EX3ayw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oF/ePl9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oF/ePl9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22636C4CECF;
	Tue,  3 Dec 2024 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239140;
	bh=JDU+aB5kvJEkMj/BLRvuEC6mFAcU+cD/HUmllz0L3r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oF/ePl9vycnW4ifWZq5O4SK1e3U9SeNjUrWAyxx1beW9xAKOw8pSDMRpzsOP7EWUh
	 4ntTIJHaqLZn1apYFUaS4UcgC8BWqEZFpeMCsl4BE/e+LR7gEP4XEU8LVK6aiVdBAT
	 3H3RR1OQ38nE7guorZZZI7IrQCE7Mx66frayRI9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 517/817] PCI: j721e: Add reset GPIO to struct j721e_pcie
Date: Tue,  3 Dec 2024 15:41:29 +0100
Message-ID: <20241203144016.075413643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit b8600b8791cb2b7c8be894846b1ecddba7291680 ]

Add reset GPIO to struct j721e_pcie, so it can be used at suspend and
resume stages.

Link: https://lore.kernel.org/linux-pci/20240102-j7200-pcie-s2r-v7-4-a2f9156da6c3@bootlin.com
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 85718246016b7..d676a4ed57803 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -52,6 +52,7 @@ struct j721e_pcie {
 	u32			mode;
 	u32			num_lanes;
 	u32			max_lanes;
+	struct gpio_desc	*reset_gpio;
 	void __iomem		*user_cfg_base;
 	void __iomem		*intd_cfg_base;
 	u32			linkdown_irq_regfield;
@@ -510,6 +511,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 				dev_err(dev, "Failed to get reset GPIO\n");
 			goto err_get_sync;
 		}
+		pcie->reset_gpio = gpiod;
 
 		ret = cdns_pcie_init_phy(dev, cdns_pcie);
 		if (ret) {
-- 
2.43.0



