Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AB12F9483;
	Tue, 17 Jun 2025 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177241; cv=none; b=CoS2+343xS9xh+wyURHwQ6sjqssuaLAq+OaokbXT+cT/OH7JTI3Mj+UG0FMCG+MggLCOJXN5X30UcwsGPrAL28duI+b7+LolMHE240Yoo7/CT0bXK3BASnoOOeLmIPlaF8uqGCYPStiib0xXWQZmroZkE2PsR5h9UPsCFtlHuRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177241; c=relaxed/simple;
	bh=ef1vQEdwKmFjD6I1x9z/HUcpSx0xnydwrQEx0+mcIU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utqR1HvPOId1Gnw7QOub4IVSxhgWsqMzF61WD7ajDppOiga+cJuhWCl2mic52mRjsFC2vL+INoZcDqdKpZspXUnialWpTvcQ7nfK4pYlYZ0L0goWQqxMeWrCPsI/Saho9VlxOXdPzzRwmhB+ElQMTBE614ityyGHrC1nDT7wATY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy+0+Ps5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy+0+Ps5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA65C4CEE3;
	Tue, 17 Jun 2025 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177241;
	bh=ef1vQEdwKmFjD6I1x9z/HUcpSx0xnydwrQEx0+mcIU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy+0+Ps5lBfGWSq032DLVrAzQLnxME1xc5vwvTBq9cYoSs5UgP5jpuujnAxUioi1V
	 spWdCBP0wC6B9NRIdwM5TNotP4stO+/fh3mOUM1s/tdZncpm2sChGEERGeemae11Wo
	 TgwSB8IGXrieBzknqOVXbQ9aqN3N9ljWG9R7rbss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Marc Zyngier <maz@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Janne Grunau <j@jannau.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/512] PCI: apple: Use gpiod_set_value_cansleep in probe flow
Date: Tue, 17 Jun 2025 17:24:38 +0200
Message-ID: <20250617152432.256618642@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 7334364f9de79a9a236dd0243ba574b8d2876e89 ]

We're allowed to sleep here, so tell the GPIO core by using
gpiod_set_value_cansleep instead of gpiod_set_value.

Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Janne Grunau <j@jannau.net>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Link: https://patch.msgid.link/20250401091713.2765724-12-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-apple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index fefab2758a064..ddc65368e77d1 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -541,7 +541,7 @@ static int apple_pcie_setup_port(struct apple_pcie *pcie,
 	rmw_set(PORT_APPCLK_EN, port->base + PORT_APPCLK);
 
 	/* Assert PERST# before setting up the clock */
-	gpiod_set_value(reset, 1);
+	gpiod_set_value_cansleep(reset, 1);
 
 	ret = apple_pcie_setup_refclk(pcie, port);
 	if (ret < 0)
@@ -552,7 +552,7 @@ static int apple_pcie_setup_port(struct apple_pcie *pcie,
 
 	/* Deassert PERST# */
 	rmw_set(PORT_PERST_OFF, port->base + PORT_PERST);
-	gpiod_set_value(reset, 0);
+	gpiod_set_value_cansleep(reset, 0);
 
 	/* Wait for 100ms after PERST# deassertion (PCIe r5.0, 6.6.1) */
 	msleep(100);
-- 
2.39.5



