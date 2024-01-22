Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657C55B5A1;
	Tue, 23 Jan 2024 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974330; cv=none; b=B9fhsjSSXN+YaJHIsGURqcD7ItSCVIivVsyXGI5Jxny7cUsY8MMyGX5PPH9XKeJu9u87S+VQl1szlGBdHsK3Vqw2l40oewA/r/X0fkAB59AyQ/eZ6f0CXINQQ3rx0Y24Qh/cSaz98vSlEA8VkHpLLutpOKWYlUMXcCYU8Zvexmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974330; c=relaxed/simple;
	bh=ghL55uhOregF0OtdBzomylxIwCVsOp95o8N8lInDr1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1SaUdAKdByf5yvpFEEM67Pdoa4b1iobqCYegCs8FjEgQrYkHN47549Cda1YXZpSXX558rKypLMkHBgDQ4kw9zB/Z7zS5bABi3e23ryGqol8s6a3htY3szBcU64OsNfpKzWcxqfhpW+1IE+fBQEckdYG0ILvoNG/H/29EvrqZ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCe2seuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCe2seuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B9AC43394;
	Tue, 23 Jan 2024 01:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974330;
	bh=ghL55uhOregF0OtdBzomylxIwCVsOp95o8N8lInDr1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCe2seuF2m6Yv7fZb1TuHEbzc6VBrHlaIyKfoZOs9eITGkkZYx1dKSjQ/+D9pQSuE
	 Y7thvd3LJFCUAdxEtBf/6WJ1i84HNnj7KHSU6ifXYQ2IuTmiXzZETiPjDB8N2PS2iw
	 lDj+F936gCkgUOQNf5okvXA+8BDtXqCCOMwGv8CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/374] mlxbf_gige: Enable the GigE port in mlxbf_gige_open
Date: Mon, 22 Jan 2024 15:57:09 -0800
Message-ID: <20240122235750.655011515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit a460f4a684511e007bbf1700758a41f05d9981e6 ]

At the moment, the GigE port is enabled in the mlxbf_gige_probe
function. If the mlxbf_gige_open is not executed, this could cause
pause frames to increase in the case where there is high backgroud
traffic. This results in clogging the port.
So move enabling the OOB port to mlxbf_gige_open.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 181a0845a105..679415a64f25 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -132,9 +132,15 @@ static int mlxbf_gige_open(struct net_device *netdev)
 {
 	struct mlxbf_gige *priv = netdev_priv(netdev);
 	struct phy_device *phydev = netdev->phydev;
+	u64 control;
 	u64 int_en;
 	int err;
 
+	/* Perform general init of GigE block */
+	control = readq(priv->base + MLXBF_GIGE_CONTROL);
+	control |= MLXBF_GIGE_CONTROL_PORT_EN;
+	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
+
 	err = mlxbf_gige_request_irqs(priv);
 	if (err)
 		return err;
@@ -281,7 +287,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	void __iomem *plu_base;
 	void __iomem *base;
 	int addr, phy_irq;
-	u64 control;
 	int err;
 
 	base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MAC);
@@ -296,11 +301,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	if (IS_ERR(plu_base))
 		return PTR_ERR(plu_base);
 
-	/* Perform general init of GigE block */
-	control = readq(base + MLXBF_GIGE_CONTROL);
-	control |= MLXBF_GIGE_CONTROL_PORT_EN;
-	writeq(control, base + MLXBF_GIGE_CONTROL);
-
 	netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
 	if (!netdev)
 		return -ENOMEM;
-- 
2.43.0



