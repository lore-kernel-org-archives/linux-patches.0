Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029604;
	b=cYh4UJLLeyQ/40Koa+jeenzwKRJUr4gLk+oeJ082/SVahVBZ4MycYxBj03H/ZNYk/va6
	 j8sv7KTWpfEZPTvwzMNPTTpfu63R3DKpOq0c96nkNbibcGL4+I64RjoMsr2OdnD6b9zU3
	 ++Ep+a+rGgE9TjMJGWloPvC9VR2p76BCWTwlbnzkF4TVxXLG+62rNkKwrPnGQdoTe0YRs
	 1SQcGpXha8EHXqTPbhhakwyuB+IqU2RIjaKeeShZGExKZCkR21lZTeiUl8wRtxA75rbcf
	 LVZAHfTzsX20fgj3GCog7GomaU/HYWfA5RHXxRuxsRwCiBVeqvTYLcyf4hODu5cgsWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B3XkAAXoQKmGWLM8EveozkxRdcimENiOm6EXrxpjoBY=;
	b=LpV8Nb2JILV8umhHT9fBzm3jTb9ZW41F9VEgzKEt5MIqyq2PbPat5CbD887FurOjWm8T
	 Cb3Cj60o1250ckSWBOHSxxyVs8dBLov/9w4CXGJuIk71Wg5iL/sYQwGvxgrtIgBdLBOw7
	 U7Z8p0oMlicDJ0+DJruic9Jkwty1kkTbiG54j2zfX5jS/Bj5CGLMBuBPqWgIJb362Mh9I
	 CNaOkhyiPOHOMvHnYdsepPYF9PYWmGQ2uiNMyZpy6JVAiXAQ/7vcJR1Jq33nXapzSp3pJ
	 rvTShz18mTtzaSBAjZvPgBpS/5+xmv9GjjQrKM/Kf/j81Dy3Rmd6s3zSoskX65wk7wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nyJ2sLu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6914F606A33D;
	Wed, 18 Nov 2026 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nyJ2sLu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B827D1F000C4;
	Wed, 18 Nov 2026 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029604;
	bh=B3XkAAXoQKmGWLM8EveozkxRdcimENiOm6EXrxpjoBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nyJ2sLuVbVf/7xL/0gSmaRAVCBQLMguKlGHuFaR+xAXQipTgj6A9fKryQvbzCSkk
	 MWjTek0rxRSAtCrRVO7GM8UQmlUHkYvYRLhRYoOQ6MWD2CDF9CNIFZy1LCQreoJfLV
	 y8VM/ElaTeLtM+99kD71NTIhW2SOzjNaDdzf9g4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0408/1756] phy: hisilicon: hi3670: Fix OF node and device reference leaks
Date: Wed, 18 Nov 2026 15:42:15 +0100
Message-ID: <20261118150024.998556283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1499f3d3407f5310731bcdf324387c321258fd75 ]

hi3670_pcie_get_resources_from_pcie() leaks two references:
1) The OF node returned by of_get_child_by_name() is never released.
2) The device returned by bus_find_device_by_of_node() is never put.

Fix both leaks by calling of_node_put() right after
bus_find_device_by_of_node(), and put_device() after dev_get_regmap()
when the temporary pcie_dev reference is no longer needed.

Fixes: 73075011ffff ("phy: HiSilicon: Add driver for Kirin 970 PCIe PHY")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260219163843.1571-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/hisilicon/phy-hi3670-pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/hisilicon/phy-hi3670-pcie.c b/drivers/phy/hisilicon/phy-hi3670-pcie.c
index 0ac9634b398da..6903148367dfc 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -565,6 +565,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	}
 
 	pcie_dev = bus_find_device_by_of_node(&platform_bus_type, pcie_port);
+	of_node_put(pcie_port);
 	if (!pcie_dev) {
 		dev_err(dev, "Didn't find pcie device\n");
 		return -ENODEV;
@@ -579,6 +580,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	 * right regmap. So, let's use the named version.
 	 */
 	phy->apb = dev_get_regmap(pcie_dev, "kirin_pcie_apb");
+	put_device(pcie_dev);
 	if (!phy->apb) {
 		dev_err(dev, "Failed to get APB regmap\n");
 		return -ENODEV;
-- 
2.53.0



