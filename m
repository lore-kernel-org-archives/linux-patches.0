Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FEF2DFF08;
	Tue, 17 Jun 2025 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175910; cv=none; b=k1aSA9gRo0Q+9V5sWWZ7DKoXfozfkDH48nXbqOnorlEgWwWEcRUcw1FrF1AVUu0hq+8BFz7+zLZa6zc8xn8qyBFa1yt+VYMCRvCRjvPKPQUyxinmfS1VcZxLfCfJnvLOpJxn5qXC5E7dNKO4q6eBB28d0o5fkCWh+SdcbSF1EwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175910; c=relaxed/simple;
	bh=g+kq3EyNLYyxWOrwfnPHJ7WuyE4VXp5XioulviOrc1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY9plAhmjcsJzjzGne9588+hMsfAwNXjuUIXZNnJ2iWJWjXyEQtw9+UQLixWrO34Eh/HOgU/tIcCDQ4OXw6rznTfF4WGbhrbQl4pgX74qhbMn1sWn3zL2rR7YNi7zLsgZZ1yu8YCHV8OC7fBA6J1TJtVx7Mner54mpvmUC1xcIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJM4wb8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJM4wb8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2241AC4CEE3;
	Tue, 17 Jun 2025 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175910;
	bh=g+kq3EyNLYyxWOrwfnPHJ7WuyE4VXp5XioulviOrc1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJM4wb8YZuxU3FcUxi9wyRC+gI/wO8bjJoHr21TWwYNrCzD8grPHI601+II053mHZ
	 DqNajKTfxuD8i8GGOc+L8uB+4Stj/pGWeSPX3oMgtfMTvXmbP38LOoyWr7Gm8rpZyn
	 UbyxX0YH2ClVrZ50SfI4c0HEmDEgnV0WaTET1bks=
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
Subject: [PATCH 6.6 224/356] PCI: apple: Use gpiod_set_value_cansleep in probe flow
Date: Tue, 17 Jun 2025 17:25:39 +0200
Message-ID: <20250617152347.220321015@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f7a248393a8f1..7e6bd63a6425e 100644
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



