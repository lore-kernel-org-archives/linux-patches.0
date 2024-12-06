Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C631494A8;
	Fri,  6 Dec 2024 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497673; cv=none; b=Stwop2D9N3uU44lN9Nfygo5ROv7GNEWaLhJGeF88aoXtcPKPgB1ryYtCB8UM3yNa9zL3uM9o6uk6eMZe2ygPbLsfQZ9DulO19X9X5oQs/OdWveTapEN9YcYXQDZFmqyAzMWerKxuktVTArnQGn+tTzOK/GuQryW4GCUAMHUZgBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497673; c=relaxed/simple;
	bh=AJtrIZSU4z/TqDHDCvBVSd/8M4X1qMNYS3SA48skrwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpSvm7JpbtNHsKgV1+07GvgFS/pHwPnqirlX5IDgra1xB0jLyoFgn1j6GAaFelEmNpF9IQ7YkDE++dI33YKvgmlBx10vm8fw4DOUr/mc74DFSLWNsaN+J1UQBpFo2zfA21KU1yLjqcA1oyOAB2GCOtNSSQZmBLlOs05SG9sd18o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQzz1Gd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQzz1Gd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0EFC4CED1;
	Fri,  6 Dec 2024 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497672;
	bh=AJtrIZSU4z/TqDHDCvBVSd/8M4X1qMNYS3SA48skrwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQzz1Gd38Mu2VQYxgRXZC0PMwFXARydAVvLtLBgpCeY5kAzuwoZ9gDl2XSqGwp49O
	 /k/FqpkeqLwjHzc3W35p92biiHrlXSUzv2iGXPjTW6sb6LQfDWOlmoEdStTaBTP3jj
	 5r7LTEXxhz2skKGjWr2MGWHXXawZOGymzwqrktn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Ranostay <mranostay@ti.com>,
	Achal Verma <a-verma1@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 359/676] PCI: j721e: Add per platform maximum lane settings
Date: Fri,  6 Dec 2024 15:32:58 +0100
Message-ID: <20241206143707.369777661@linuxfoundation.org>
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

From: Matt Ranostay <mranostay@ti.com>

[ Upstream commit 3ac7f14084f54bff9c31573d1ed59d047a34fe03 ]

Various platforms have different maximum amount of lanes that can be
selected. Add max_lanes to struct j721e_pcie to allow for detection of this
which is needed to calculate the needed bitmask size for the possible lane
count.

Link: https://lore.kernel.org/linux-pci/20231128054402.2155183-4-s-vadapalli@ti.com
Signed-off-by: Matt Ranostay <mranostay@ti.com>
Signed-off-by: Achal Verma <a-verma1@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 2c87e7728a653..63c758b14314d 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -47,8 +47,6 @@ enum link_status {
 
 #define GENERATION_SEL_MASK		GENMASK(1, 0)
 
-#define MAX_LANES			2
-
 struct j721e_pcie {
 	struct cdns_pcie	*cdns_pcie;
 	struct clk		*refclk;
@@ -71,6 +69,7 @@ struct j721e_pcie_data {
 	unsigned int		quirk_disable_flr:1;
 	u32			linkdown_irq_regfield;
 	unsigned int		byte_access_allowed:1;
+	unsigned int		max_lanes;
 };
 
 static inline u32 j721e_pcie_user_readl(struct j721e_pcie *pcie, u32 offset)
@@ -290,11 +289,13 @@ static const struct j721e_pcie_data j721e_pcie_rc_data = {
 	.quirk_retrain_flag = true,
 	.byte_access_allowed = false,
 	.linkdown_irq_regfield = LINK_DOWN,
+	.max_lanes = 2,
 };
 
 static const struct j721e_pcie_data j721e_pcie_ep_data = {
 	.mode = PCI_MODE_EP,
 	.linkdown_irq_regfield = LINK_DOWN,
+	.max_lanes = 2,
 };
 
 static const struct j721e_pcie_data j7200_pcie_rc_data = {
@@ -302,23 +303,27 @@ static const struct j721e_pcie_data j7200_pcie_rc_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.byte_access_allowed = true,
+	.max_lanes = 2,
 };
 
 static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.mode = PCI_MODE_EP,
 	.quirk_detect_quiet_flag = true,
 	.quirk_disable_flr = true,
+	.max_lanes = 2,
 };
 
 static const struct j721e_pcie_data am64_pcie_rc_data = {
 	.mode = PCI_MODE_RC,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.byte_access_allowed = true,
+	.max_lanes = 1,
 };
 
 static const struct j721e_pcie_data am64_pcie_ep_data = {
 	.mode = PCI_MODE_EP,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
+	.max_lanes = 1,
 };
 
 static const struct of_device_id of_j721e_pcie_match[] = {
@@ -432,8 +437,10 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 	pcie->user_cfg_base = base;
 
 	ret = of_property_read_u32(node, "num-lanes", &num_lanes);
-	if (ret || num_lanes > MAX_LANES)
+	if (ret || num_lanes > data->max_lanes) {
+		dev_warn(dev, "num-lanes property not provided or invalid, setting num-lanes to 1\n");
 		num_lanes = 1;
+	}
 	pcie->num_lanes = num_lanes;
 
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48)))
-- 
2.43.0



