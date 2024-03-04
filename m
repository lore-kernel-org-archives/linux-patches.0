Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833E1EB5A;
	Mon,  4 Mar 2024 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587922; cv=none; b=thvVFEq66ZkDc9rRGFUP+dg1l/kaVGodxUVjBbJHc+qy+AdDnR7bpGtsZwjlD2WMhoPsNuAWpfFEeIQSp03ZFatgP+WdPFvwJNh6P9ze5lncR6+XHNvIMq/3X6+rd8LBVq1qKA9JcBJm0/X77viaiqGgMUKQLrEkNMmo/JmWkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587922; c=relaxed/simple;
	bh=qbNhJ4nVaLUAyTyAG3ZtIyxjMt1fVN1QMOd8c4UlZJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIqWSSdC/1ca4EEMmePGqJPgIMAOLCN/H5zmegtEKoBk2AYUHRmvqS09l/pP8yRh8MOaouaYsS5itvCGyDxEiyrGw6bWunD51AozcrdvC1KfstWX2OhCCwukzl9JamS48HcwZYGwY0ee3K5rkOciMtDGeKF0MciOMMjEVIJ8R8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9lY2SSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9lY2SSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC62C433F1;
	Mon,  4 Mar 2024 21:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587922;
	bh=qbNhJ4nVaLUAyTyAG3ZtIyxjMt1fVN1QMOd8c4UlZJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9lY2SSjtWS+UzcpT3x5WgYFS4cYqsiwDwIMVVQb7cYYy1DMzmR4IshPO8EhHzKwz
	 ANqTlU5pPczySLeCczepnWMv1g3gRH2yF/B2sycj5FYV8A+AiaAOcQvV1Ui6TM4mrO
	 z+FRFAg84psNQLHv2SVDrHj6MvnbM/JnSog2UrPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 141/162] phy: freescale: phy-fsl-imx8-mipi-dphy: Fix alias name to use dashes
Date: Mon,  4 Mar 2024 21:23:26 +0000
Message-ID: <20240304211556.222834175@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 7936378cb6d87073163130e1e1fc1e5f76a597cf ]

Devicetree spec lists only dashes as valid characters for alias names.
Table 3.2: Valid characters for alias names, Devicee Specification,
Release v0.4

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 3fbae284887de ("phy: freescale: phy-fsl-imx8-mipi-dphy: Add i.MX8qxp LVDS PHY mode support")
Link: https://lore.kernel.org/r/20240110093343.468810-1-alexander.stein@ew.tq-group.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c b/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c
index e625b32889bfc..0928a526e2ab3 100644
--- a/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c
+++ b/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c
@@ -706,7 +706,7 @@ static int mixel_dphy_probe(struct platform_device *pdev)
 			return ret;
 		}
 
-		priv->id = of_alias_get_id(np, "mipi_dphy");
+		priv->id = of_alias_get_id(np, "mipi-dphy");
 		if (priv->id < 0) {
 			dev_err(dev, "Failed to get phy node alias id: %d\n",
 				priv->id);
-- 
2.43.0



