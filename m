Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064741;
	b=1h/3Au8HF2WARIbIWnJfa0y9oI1jIG3F4faWQBp55a4BTIxz5MwjWVfVTPBg1iPVErEq
	 Of0f/m3ISp9bWnEji/ohaiHY0aiuHLew4Khu01bCFHsr1GCQ0cmg/uwH6kL7Uh55ocBmN
	 2pukLYlPTuXOt04siLWilav7PQtKnkN9Kpagvf0zkQD9eu3tVYZOvB0MfPlzjT/V4u7Kt
	 PmYHyOATX34+Gxlbfab/8RpzKPTJvYQGxQ1CkOjKzKZ/j+dj9k2L5sdpfHt65ZGAX5+uS
	 fhAA6HYKSckILMJcqtGjas3G5Z+wvwY1k3A/SmvUoWeMGMM5fw87CCvGcK4haf51/xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfjNtvhxjU+B7Jjh0JlqHeKVG+gwP220EW/6OpVQIXk=;
	b=RFJAhU4AAcYRNHdla4Gv83PWdrSw4vFxddlutGLoLH0BasDcZVFNVoBOf73om9VsCwr0
	 PdMj3fXlMXtVu2PNl3o1igfwlpM4bMMP0fvdVUMWn1YegX8LZsIdFdqDQsIeMuHZSXSfd
	 AFGXempajn6rcX007d+rqWfvtg+EG/a21KwalAwuaKdVaHGAodR9iHSYnqmMAZvwRqpGx
	 X1gVERye6kygnOBn8oLY8MsBVbOcT8pVucgwCxhGDrgP3jSydNPgx+dLEMBwPjye9ZADK
	 Zi/nizuga0nk7VUwwC+8Yg3fgYz7qqyUrzogZupk1TskIeaRcpiJrL2/y0A6W8CyQbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JODnX5u1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C7A606A9DB;
	Sat,  7 Nov 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JODnX5u1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC4C1F008A1;
	Sat,  7 Nov 2026 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064741;
	bh=YfjNtvhxjU+B7Jjh0JlqHeKVG+gwP220EW/6OpVQIXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JODnX5u1u73vCBvP8WRHPaFpu4jD2rdgnwrFSCulhhFCiLwplsbohYmsDlrqOH8/J
	 e62FZGldBMQ2T2G8oR9TADHDu64GvJT2WW/QEnEobyZGTglYGjpRhd5CfXT1dvHnAQ
	 fHeRFhovm93uGjnzhw0SVVkRPeKjpgY+Pb0LDl2M=
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
Subject: [PATCH 7.3 0717/1257] PCI: rockchip: Drive at 2.5 GT/s, error other speeds
Date: Sat,  7 Nov 2026 08:50:13 -0500
Message-ID: <20261107134959.063855226@linuxfoundation.org>
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

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 84d08ff902f1ec01177fef1a21a38934927f5aee ]

Configure the core to be driven at 2.5 GT/s Link Speed and ignore any other
speed with a warning. Also drop the 5.0 GT/s Link Speed defines from
Rockchip PCIe header.

The reason is that Shawn Lin from Rockchip has reiterated that there may be
danger of "catastrophic failure" in using their PCIe with 5.0 GT/s speeds.

While Rockchip has done so informally without issuing a proper errata, and
the particulars are thus unknown, this may cause data loss or worse.

This change is corroborated by RK3399 official datasheet [1], which states
maximum link speed for this platform is 2.5 GT/s.

[1] https://opensource.rock-chips.com/images/d/d7/Rockchip_RK3399_Datasheet_V2.1-20200323.pdf

Fixes: 956cd99b35a8 ("PCI: rockchip: Separate common code from RC driver")
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reported-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/all/ffd05070-9879-4468-94e3-b88968b4c21b@rock-chips.com/
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/7421df7a7b7778ee99363cccfdfabbfa8aa6ab5e.1781622998.git.geraldogabriel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip.c | 14 ++++++--------
 drivers/pci/controller/pcie-rockchip.h |  3 ---
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index 8d78ab1b31f0f..45cc888ac5537 100644
--- a/drivers/pci/controller/pcie-rockchip.c
+++ b/drivers/pci/controller/pcie-rockchip.c
@@ -66,8 +66,10 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 	}
 
 	rockchip->link_gen = of_pci_get_max_link_speed(node);
-	if (rockchip->link_gen < 0 || rockchip->link_gen > 2)
-		rockchip->link_gen = 2;
+	if (rockchip->link_gen < 0 || rockchip->link_gen >= 2) {
+		rockchip->link_gen = 1;
+		dev_warn(dev, "invalid max-link-speed, limited to 2.5 GT/s\n");
+	}
 
 	for (i = 0; i < ROCKCHIP_NUM_PM_RSTS; i++)
 		rockchip->pm_rsts[i].id = rockchip_pci_pm_rsts[i];
@@ -147,12 +149,8 @@ int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
 		goto err_exit_phy;
 	}
 
-	if (rockchip->link_gen == 2)
-		rockchip_pcie_write(rockchip, PCIE_CLIENT_GEN_SEL_2,
-				    PCIE_CLIENT_CONFIG);
-	else
-		rockchip_pcie_write(rockchip, PCIE_CLIENT_GEN_SEL_1,
-				    PCIE_CLIENT_CONFIG);
+	rockchip_pcie_write(rockchip, PCIE_CLIENT_GEN_SEL_1,
+			    PCIE_CLIENT_CONFIG);
 
 	regs = PCIE_CLIENT_ARI_ENABLE |
 	       PCIE_CLIENT_CONF_LANE_NUM(rockchip->lanes);
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 3e82a69b9c006..b5da15601b585 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -42,7 +42,6 @@
 #define   PCIE_CLIENT_MODE_RC			HWORD_SET_BIT(0x0040)
 #define   PCIE_CLIENT_MODE_EP			HWORD_CLR_BIT(0x0040)
 #define   PCIE_CLIENT_GEN_SEL_1			HWORD_CLR_BIT(0x0080)
-#define   PCIE_CLIENT_GEN_SEL_2			HWORD_SET_BIT(0x0080)
 #define PCIE_CLIENT_LEGACY_INT_CTRL	(PCIE_CLIENT_BASE + 0x0c)
 #define   PCIE_CLIENT_INT_IN_ASSERT		HWORD_SET_BIT(0x0002)
 #define   PCIE_CLIENT_INT_IN_DEASSERT		HWORD_CLR_BIT(0x0002)
@@ -197,8 +196,6 @@
 	(((x) & PCIE_CORE_PL_CONF_LS_MASK) == PCIE_CORE_PL_CONF_LS_READY)
 #define PCIE_LINK_UP(x) \
 	(((x) & PCIE_CLIENT_LINK_STATUS_MASK) == PCIE_CLIENT_LINK_STATUS_UP)
-#define PCIE_LINK_IS_GEN2(x) \
-	(((x) & PCIE_CORE_PL_CONF_SPEED_MASK) == PCIE_CORE_PL_CONF_SPEED_5G)
 
 #define RC_REGION_0_ADDR_TRANS_H		0x00000000
 #define RC_REGION_0_ADDR_TRANS_L		0x00000000
-- 
2.53.0



