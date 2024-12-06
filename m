Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D8F53A7;
	Fri,  6 Dec 2024 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497685; cv=none; b=ZZXjG/Cb7Aoz8Ceisj2YBYNnnscQ4TY3YkbYWPRgJj4tF3mEfx1ZC0xRnsWJQwVNruw3P1PYE1B344BQY4c17foKwKl8bV2deuQGusvcnnV9Se0xLRoyXUsZYM3k0+rGi9HHfADrheN96QPnmnF7YCHFjZ46ToDunM2nUU+qFyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497685; c=relaxed/simple;
	bh=a5L2LjRv9nMLWwGm+Ei/EjbL2XiwjDiT4Lc4SHAb2Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ly48Emj1khPgTgEXN8iJmrVX6MVsiy9va+PAo74vntXJLrnfF1blMhe/7I3WF+8J8egeuN9PpQULO654sj6s9swe+ueO+FX9NpLvdGVq9aunJAJwOq2nkJNDHeazCqGyP4Am/JJ3ln91zb2EfROSyHNjcIUEj4vA8WCxM/2fDEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7qWOc2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7qWOc2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7BBC4CED1;
	Fri,  6 Dec 2024 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497685;
	bh=a5L2LjRv9nMLWwGm+Ei/EjbL2XiwjDiT4Lc4SHAb2Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7qWOc2xDAT5w+S2P7U9BaP2r8KATzlen526byAVOcbresYOHqbrRhimzNPYXFySn
	 66VvPkieJ8duU026qY6LOYDumEDbDhBo5eyVoky8wWelsrQLYESVUfiuRuUTOxnmGN
	 vJlaCRwFQEsn5BDlCrBlKdqazlI07lq69lgW+zqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 363/676] PCI: j721e: Add reset GPIO to struct j721e_pcie
Date: Fri,  6 Dec 2024 15:33:02 +0100
Message-ID: <20241206143707.524547245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 645597856a1d9..82f8c3a701c2f 100644
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
@@ -488,6 +489,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 				dev_err(dev, "Failed to get reset GPIO\n");
 			goto err_get_sync;
 		}
+		pcie->reset_gpio = gpiod;
 
 		ret = cdns_pcie_init_phy(dev, cdns_pcie);
 		if (ret) {
-- 
2.43.0



