Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053794;
	b=Rxpm3OLjSsmLTUzzeZMDtKswZmWR7ZiXu2XHSPHryxuJf9Nam2Htm4/U3Dl52/qQD8QX
	 EyMwu46PScqBno1JlvC0C3DNxP/7i47idY45Z902VwvL3gkLggAZHl3li8Kb+9VoOIx9J
	 CREdwKF1YCijBpvO9iMOgY0MTKb8R0NhKjTOgsNCCQhNtTITQh5zrLSDY8ZuUe3YPW0kP
	 hef0agrgYNwmFgtrG397Qm7V6CqrPZWgctfX05UfeXwVtxpgN4QC+E4yG4SYARht1/Bhf
	 zqz7B8botdAvNTJXAog45P4XoDI2et1hpaIBwEW8CJPGJqpb1aM/N4AXF2wjlPhYuJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0Cr4gEuyK9OkWWoUooTARmlZay5tFYYTszczrf+V18=;
	b=QuW0LoAxB7YJWGqdldlG/M6Hl0H5+7vtbVwvPTTX8z9YVIW8zkb5XDuBHQaQ82q22DBG
	 wTDU2O3EmIRNJ/te+rGgeaSnJtafq5+JDdfeOGU+hp9F5M6pu8thitmfCBZkf1VBWm5ES
	 fRViYjeAHSaI1+7kQ/bai0AJLYiNo/RwNpUIMf+WwcahrnyRywb/kLiFJLmVynn0KoJVj
	 enFBES+MYe7hxMz+vXNkgaEm17NOSQBfls3vznI953fr+twC246MzsdBNtTbAlylo7wlt
	 4uUzaUFbV/8xwsEsPWFw78GfvWQC3XgtNaC8bMSbz/53qLz1tg0/HLkH+nxlnBaPFFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QDv/BsiV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FE7606A31C;
	Thu, 19 Nov 2026 02:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDv/BsiV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EB71F000C4;
	Thu, 19 Nov 2026 02:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053794;
	bh=D0Cr4gEuyK9OkWWoUooTARmlZay5tFYYTszczrf+V18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDv/BsiVIV6JDSX6CguBZlSTlf5T/0BtBeGb4OfV7+/tqqPCOrXGM/wrNr7AD5Wy1
	 48rwNvX6ulLn4pJfxkpTyGm1ljea10l0pIiO5Y2SZVqdMEl38ItXsgah5jrNBQAHxb
	 GpuF9Qrc7eAYDkQMqVr16n7MbD6PhZKotmnraK48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1045/2214] PCI: rockchip-host: Do not attempt 5.0 GT/s retraining
Date: Wed, 18 Nov 2026 15:45:21 +0100
Message-ID: <20261118150054.138447506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 2a1e6c382fb7567679c07bd6a7060fefc7a5edc9 ]

Drop the 5.0 GT/s Link Speed retraining from Rockchip PCIe Root Complex
Mode Operation, so-called host driver.

The reason is that Shawn Lin from Rockchip has reiterated that there may be
danger of "catastrophic failure" in using their PCIe with 5.0GT/s speeds.

While Rockchip has done so informally without issuing a proper errata, and
the particulars are thus unknown, this may cause data loss or worse.

This change is corroborated by RK3399 official datasheet [1], which states
maximum link speed for this platform is 2.5 GT/s.

[1] https://opensource.rock-chips.com/images/d/d7/Rockchip_RK3399_Datasheet_V2.1-20200323.pdf

Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reported-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/all/ffd05070-9879-4468-94e3-b88968b4c21b@rock-chips.com/
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/68f6353e3a2ea4914de36c42b6906e41282adad3.1781622998.git.geraldogabriel@gmail.com
[ sashal: Adjusted deletion context for the retraining block using PCIE_RC_CONFIG_LCS and lacking target-speed setup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index d2fbf73ddd648..1e39795ecfac7 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -338,22 +338,6 @@ static int rockchip_pcie_host_init_port(struct rockchip_pcie *rockchip)
 		goto err_power_off_phy;
 	}
 
-	if (rockchip->link_gen == 2) {
-		/*
-		 * Enable retrain for gen2. This should be configured only after
-		 * gen1 finished.
-		 */
-		status = rockchip_pcie_read(rockchip, PCIE_RC_CONFIG_LCS);
-		status |= PCI_EXP_LNKCTL_RL;
-		rockchip_pcie_write(rockchip, status, PCIE_RC_CONFIG_LCS);
-
-		err = readl_poll_timeout(rockchip->apb_base + PCIE_CORE_CTRL,
-					 status, PCIE_LINK_IS_GEN2(status), 20,
-					 500 * USEC_PER_MSEC);
-		if (err)
-			dev_dbg(dev, "PCIe link training gen2 timeout, fall back to gen1!\n");
-	}
-
 	/* Check the final link width from negotiated lane counter from MGMT */
 	status = rockchip_pcie_read(rockchip, PCIE_CORE_CTRL);
 	status = 0x1 << ((status & PCIE_CORE_PL_CONF_LANE_MASK) >>
-- 
2.53.0



