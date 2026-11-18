Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059625;
	b=D97d8ismfsKODgKgoIPEpArLFVf51LzH0U8ZfSooevSHhCfbnP+YdItLnR0SOepRZYLz
	 f826Q+MFNCE7wUqeCWx2MWxOGELnzMwf9J74jEo5WFzazT/4fWLuSx1RngPic60TGGq3+
	 N0dSBYXHavDm7WJ9xJ79bfw0wJbT/0Q5784uZau6SN75GzVTwtokB8q4ICxMc74E2LQT3
	 fjAuYepjEAj8oxXMiB4GCwtLMU7zaYAUHBXLdaTQxwezXvsurBvZoN40HbhrN84QCy18K
	 U261mtNQcmcLtnjVIAq2QByNSMcfdFUfX2kNHKVgakLK9YtOgf8N4d2Bii/9imXLt6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyH9xYtVZzigtk4NGbjNwD4AzAGEz+/dLmkioiz/Llk=;
	b=PG82HsDIxqXf1Cu5Uwk6+eMkYmaZsdVk5QldsxR/IBSSWyrHOjYvi6i/iJpAXwQbHkC1
	 QoKR1seOK/F+zx1z9J1L17dURLJAj94ihmLM9u5NJYzook0WlQ8RqjE+JvYizOMj484IC
	 PaK+tE+5EUYOh1S8G8yYgfoeI2KWhblph5ksHx3ooFcWip9gGTnkhQMyz/X+Me3nutfkx
	 aUOj4B03IuVJl9hb7ZUvL/T4M2puPdM1xx2nUXePsyBlHRhouXXoBdBwN9tT9xxxEkY0K
	 zFKXSg4ei0X56yiPsol9KTUKPm3cOW0ezDQ7rgtKB7yeWgzxjmICkZ3jD9Sa8/J7l3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYfD3TZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC807606A33A;
	Thu, 19 Nov 2026 03:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYfD3TZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C551F000C8;
	Thu, 19 Nov 2026 03:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059625;
	bh=wyH9xYtVZzigtk4NGbjNwD4AzAGEz+/dLmkioiz/Llk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYfD3TZQiT+D6UjgbM5kOXgqWn1KPx6/8KABZxlAGEKO4CKiF66Kk3ohmB2dJmylZ
	 S/R+QoLNWY9m9GqwPI3Rnc6p5qsZx0T0NooBtFwZU2xVmk1ynQvQHXdkoher5nNGDZ
	 WKXft3VzllXpVFknoNAJ5StO5G320o2sCnHBXj4w=
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
Subject: [PATCH 5.10 0908/1848] PCI: rockchip: Drive at 2.5 GT/s, error other speeds
Date: Wed, 18 Nov 2026 15:49:06 +0100
Message-ID: <20261118145954.841567313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted header cleanup to existing HIWORD_UPDATE macros where PCIE_LINK_IS_GEN2 is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip.c | 14 ++++++--------
 drivers/pci/controller/pcie-rockchip.h |  1 -
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index bdce1ba7c1bc0..c1567a2ef1890 100644
--- a/drivers/pci/controller/pcie-rockchip.c
+++ b/drivers/pci/controller/pcie-rockchip.c
@@ -65,8 +65,10 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 	}
 
 	rockchip->link_gen = of_pci_get_max_link_speed(node);
-	if (rockchip->link_gen < 0 || rockchip->link_gen > 2)
-		rockchip->link_gen = 2;
+	if (rockchip->link_gen < 0 || rockchip->link_gen >= 2) {
+		rockchip->link_gen = 1;
+		dev_warn(dev, "invalid max-link-speed, limited to 2.5 GT/s\n");
+	}
 
 	rockchip->core_rst = devm_reset_control_get_exclusive(dev, "core");
 	if (IS_ERR(rockchip->core_rst)) {
@@ -236,12 +238,8 @@ int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
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
 
 	regs = PCIE_CLIENT_LINK_TRAIN_ENABLE | PCIE_CLIENT_ARI_ENABLE |
 	       PCIE_CLIENT_CONF_LANE_NUM(rockchip->lanes);
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index de78a3091b6a1..1708a5cc750fd 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -36,7 +36,6 @@
 #define   PCIE_CLIENT_MODE_RC		  HIWORD_UPDATE_BIT(0x0040)
 #define   PCIE_CLIENT_MODE_EP            HIWORD_UPDATE(0x0040, 0)
 #define   PCIE_CLIENT_GEN_SEL_1		  HIWORD_UPDATE(0x0080, 0)
-#define   PCIE_CLIENT_GEN_SEL_2		  HIWORD_UPDATE_BIT(0x0080)
 #define PCIE_CLIENT_LEGACY_INT_CTRL	(PCIE_CLIENT_BASE + 0x0c)
 #define   PCIE_CLIENT_INT_IN_ASSERT		HIWORD_UPDATE_BIT(0x0002)
 #define   PCIE_CLIENT_INT_IN_DEASSERT		HIWORD_UPDATE(0x0002, 0)
-- 
2.53.0



