Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063841;
	b=u4HUyfr8UvDgJ8xYEabqfYED37skL50jQewbALEwTkKApAabM8nXOpQatsAbOiPARQqk
	 5I4OA2QjoeyOUR/sl0WtMsuS07KgalaMRdsy6MUCnsCNQ3XEnIwqXBA8G1Umvgs+GI9QB
	 VsoDxcbgrPi2NmFVHVXGdfC39DAC7y7KNReybeU9hKKG0JPzHQSoYEeBUnfUAalmpgU+B
	 rCJJqryymKR9PgjwItNaE+EhCPBioCb1FdEqpJmHdYozbkmedOzUO3OoBtxo+WR6mLTld
	 /rlk7iDO3TH4ikFee+E3B1gegL1QFmrum2BDb0pNbLIelrlus7Qs+kXqoCq36scyIWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ES+sk11/9VNJIO1TfVKd7hl1WF3FgDbqGAI+OUpmLAs=;
	b=EUjB6wzBNzTe8Z0HvMRlpVBncTziuFOFA2g0h0mPiDITx+6F06BT9Tjg7hP5haEfj5c6
	 7PSpfpRDIsEQ38Jhm/g44tNGM7TlKcNLMFdgsVwmMq0/JB2iIDEnoBe/FjWjo9T3oZR+u
	 qd0swXtYGLRUJjpWzt1+VDDHVlLLO4pktouNWTCcw+8wQYM+5naaOZIpN9+CIY5id2D4l
	 LITd7jYD9MhjwXdwoXVzoeCSBf7aAua1kCouHFYiZAQRClBX47vPciRHDa94idl2N+yoS
	 40Bu+17ef8qDzn+aoJODJhMq58Na8bxTp1Zb3atyRpGhlSHfo9meKFe31O3hCoTq7/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iXVT/8pR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F4360A5BFE;
	Sat,  7 Nov 2026 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXVT/8pR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C561F0089F;
	Sat,  7 Nov 2026 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063840;
	bh=ES+sk11/9VNJIO1TfVKd7hl1WF3FgDbqGAI+OUpmLAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXVT/8pRGdqFeW0MS5T5uAOb/Kw1mF5wK5vG9a6mI5aLMKfZUYsBB0OIShGrzPnVX
	 ma+KXDRMN+Sx8nhULwtKDFaZLoHyFvc10UumAL3TPriB9Q0LGWngRLdessxBdzkoDm
	 ltV9Psak9gwDhpSLYn8YdZxhmvBUqo5gv1qAq6nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Zhenlong <dragonliu2018@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0053/1257] PCI: aspeed: Fix clk and PHY leak in aspeed_pcie_port_init() error paths
Date: Sat,  7 Nov 2026 08:39:09 -0500
Message-ID: <20261107134940.871663717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Zhenlong <dragonliu2018@gmail.com>

[ Upstream commit a54ac2eb6eca8baa86b89494b8a0d9439a0f72ee ]

aspeed_pcie_port_init() calls clk_prepare_enable() to enable the port
clock, but if phy_init() or phy_set_mode_ext() fails afterwards, the
function returns without calling clk_disable_unprepare(), leaking the
clock reference on every probe failure. Additionally, when
phy_set_mode_ext() fails, phy_init() has already succeeded, so
phy_exit() is also missing, leaking the PHY reference.

Add the matching clk_disable_unprepare() to both error paths, and
phy_exit() to the phy_set_mode_ext() failure path, mirroring the
cleanup pattern in pci-aardvark.

Compile-tested with gcc on arm64 defconfig using COMPILE_TEST.

Fixes: 9aa0cb68fcc1 ("PCI: aspeed: Add ASPEED PCIe RC driver")
Signed-off-by: Liu Zhenlong <dragonliu2018@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260816171633.15025-1-dragonliu2018@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-aspeed.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-aspeed.c b/drivers/pci/controller/pcie-aspeed.c
index 74b03a55643fa..ecb7562f84c01 100644
--- a/drivers/pci/controller/pcie-aspeed.c
+++ b/drivers/pci/controller/pcie-aspeed.c
@@ -761,16 +761,21 @@ static int aspeed_pcie_port_init(struct aspeed_pcie_port *port)
 				     port->slot);
 
 	ret = phy_init(port->phy);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(port->clk);
 		return dev_err_probe(dev, ret,
 				     "failed to init phy pcie for slot (%d)\n",
 				     port->slot);
+	}
 
 	ret = phy_set_mode_ext(port->phy, PHY_MODE_PCIE, PHY_MODE_PCIE_RC);
-	if (ret)
+	if (ret) {
+		phy_exit(port->phy);
+		clk_disable_unprepare(port->clk);
 		return dev_err_probe(dev, ret,
 				     "failed to set phy mode for slot (%d)\n",
 				     port->slot);
+	}
 
 	reset_control_deassert(port->perst);
 	msleep(PCIE_RESET_CONFIG_WAIT_MS);
-- 
2.53.0



