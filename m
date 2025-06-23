Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0E1C5D46;
	Mon, 23 Jun 2025 21:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714441; cv=none; b=DhsUWdOzRDyNCoWpCW3Q4TdFtXYzK/STpqDvm9tojEdP3sqBJH4WZ+mJERNMu6OWv4Rr9f44LzmFNRlqu1TtNxPttcnuXj0Jl2tWvoa42kvyk+M4UCm3CcRXhKcGafdHY9G4jg4bHs4v58cAb/SrmiCY7263Lp6ZgJfRl+B93YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714441; c=relaxed/simple;
	bh=B0gJw+YoxNb2CXkEnrws+u9t4oiIb64Be1mJwCkY2/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wnk6W/yVt6tztw38wSt2u1ALNJeYQp2RZpz8jOh3Qd+6vBrphAlOfoSW0pZ+0aynpFMTkAB9fCcy0FVabQZv4OcCMRXHB9vLNLVF10cI1eAylRbAtoSUEKvdbrf0ZGw+n6db1fBf4NvFjLeWE9s1XufN/h59VPeE38cdpql16Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmmpM5US; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmmpM5US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0893C4CEEA;
	Mon, 23 Jun 2025 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714441;
	bh=B0gJw+YoxNb2CXkEnrws+u9t4oiIb64Be1mJwCkY2/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmmpM5USSep83JEassT1nK9TB5KEnjdZhXsYoixy3lUQAKBp9s+V/GiziaXKb7i7S
	 xrH43K6FMlzP9USINxWjO8bYcTFMy8NrqrnXKxmaxrumKTp1sxGbTc9A0WUYy4F5qa
	 nlLca+NwJyKXb19ZA9qv6S2A9Pdk1d7tMK3a9SlE=
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
Subject: [PATCH 6.1 152/508] PCI: apple: Use gpiod_set_value_cansleep in probe flow
Date: Mon, 23 Jun 2025 15:03:17 +0200
Message-ID: <20250623130649.021609787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2340dab6cd5bd..487d01f6b4f56 100644
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



