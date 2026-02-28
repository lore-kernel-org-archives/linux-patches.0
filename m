Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5238D33FE27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301183; cv=none; b=UiGsdL7n3nR+U11W8U0SvSmEqfx6cSi1YMpCmw+KMSMz+2BT3326TEJpP4tHtbkSiExWfw2g44u7qV/XtY6KbcVielV0FdKO5y8XGapgxG5gkJlLZvJ94smaZ9e5JY0stPl4wKFTme5xLlt62Kc1VAjav0KTvY6ib09LwTIWn8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301183; c=relaxed/simple;
	bh=SM+8f0dD5G61vgDflTT3RjavNNfWhyG34UbWfjqKWDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqEUb293S1RX6wsgL4ZHRPa2Qwc16+JSJe6nyQ0YIQmac6g21SgiSr6j+o4/gclwEqps7XQEkBvQ2DeUIWdol2QH47ewdfDEKJ1mcDuLwFYpJDsANfP7ol+Kz+0UEO5vRTsfzEacdYVsd7R8thFLA4HpQeKtbPvY1qtsTtlS/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqcoj+53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqcoj+53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB00C19423;
	Sat, 28 Feb 2026 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301183;
	bh=SM+8f0dD5G61vgDflTT3RjavNNfWhyG34UbWfjqKWDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqcoj+53UuhJW7wcAMagaM39RaK7d4iQPY+7Ux1AKVfAqk/CzNSfGCuX0LwFugiA+
	 QI4PKd/R0BW7xnG7HvGlrEmXSa5eiINIaQ9MbT/C7G97jt1uCQoTVo/u/V0l2KpRB7
	 XDAKoABGr4ZphO1wzEoBNXN3KmEjkP1t1buEfQ/r49kKT6MnQVPhCbN6XlzuO5tgld
	 EYs4iMMY3rmnToor8XEa+eXw11jXCcLBJcoiseAmd9HFQBdKSpH2t/VbYeYHkkEesR
	 LkUL/kZssndq/+ubsfR9I1S1eqPOmM+tgRu9c+YvcqBfZhXAMqmbD7on5RjbHfVRGV
	 NzI2ezF4K8mGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 352/752] phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature
Date: Sat, 28 Feb 2026 12:41:03 -0500
Message-ID: <20260228174750.1542406-352-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 27ee0869d77b2cb404770ac49bdceae3aedf658b ]

Disabling PHYs in runtime usually causes the client with external abort
exception or similar issue due to lack of API to notify clients about PHY
removal. This patch removes the possibility to unbind i.MX PHY drivers in
runtime.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260120111712.3159782-1-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
index f6cac4c049c43..bd37b6cb69cdc 100644
--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -711,6 +711,7 @@ static struct platform_driver imx8mq_usb_phy_driver = {
 	.driver = {
 		.name	= "imx8mq-usb-phy",
 		.of_match_table	= imx8mq_usb_phy_of_match,
+		.suppress_bind_attrs = true,
 	}
 };
 module_platform_driver(imx8mq_usb_phy_driver);
-- 
2.51.0

