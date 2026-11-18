Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018210;
	b=SgnpiKWqHMt0vAJ7ROdk61nePvhi7nbQb1tu0t8zL/uSUlWMmfP3la0SEOiKBszqpK2D
	 u3ANocWhEb5V717/8uY0yJODv+3HfshwAxWesEVuxnIjDzpABH4Ww40g5QJY/TrstR1JL
	 39D3I3/xbWRQzt3WDixfsB9WIhOslgJBdBRH8Nkq7+zKIVVAIEf4XintZaejrN2uAJbBz
	 Ifu0d1ibO9ZYOaqNNmONYB+a6KTzXyxlHn1z0+MwZt8OuV4S+/yDDCL+al+zE+NWZYZBB
	 os/bqS7lfw4tHR8II2WZAQXC8rKwYfDC/sHNWNyK+fXmav32cTk2Or1ysVVj8jDP0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S9q1md3pwFb0boKOHHIMKpyr9KyLoOMzKXcIGZP6DKQ=;
	b=nYoQV9tpJOKn/kt8ZKUEvoqDzG/oonzmZPY7cBONPPlvfNJqBTm4cYRtewkjXFCRAqDk
	 PWD3ZgQiGnVuE6MlzW6OATEgA4xv2qQjr9EwKx0qCT4rarXO9U9kGiPFFqBcAf25gwWQr
	 T3hPYX+u/rxzcZCjFE3/OUueFgd5sfsoiXhAwNEVh0+BkSsURZPLLgeQLAeyGV5p2XpxX
	 c/r9LZhbueD0dX7M1tO+0tuQCDwXb+X1hLOTwCazhDc/zpIkP0epFoNuh9LCET8XgbAs0
	 d9XgN882l1ohx9i8uWcwoVoHcYrsaY7ySATyNkKlyqo2+iyxMWbGA6P4KQpx05CfdZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXODKbLu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FEC606A32C;
	Wed, 18 Nov 2026 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXODKbLu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E5D1F000C4;
	Wed, 18 Nov 2026 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018210;
	bh=S9q1md3pwFb0boKOHHIMKpyr9KyLoOMzKXcIGZP6DKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXODKbLukICVoFTzSSouYXfibUblMCyEAFBrBWTPYn6S9pT8tbaBrnZcoc6FlSyCF
	 kGwWtUvhF2R0nD80JKyT68PSMFNQiAWkoKYNQTGpCjuygxGe4jT5nxxFkkDWPqTlEx
	 l0uMHLn4tIw7MJtYDXtaZ3IO20ONTL+1iHJ8emZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 7.3 1132/2651] PCI: tegra264: Fix Link Capabilities register offset
Date: Wed, 18 Nov 2026 15:39:32 +0100
Message-ID: <20261118150328.762425378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 42b5b17cf4bb6154028b31f12db94ecb9069fd74 ]

The PCI Express Capability begins at 0x48.  Link Capabilities is a 32-bit
register at offset 0xc, and Link Status is a 16-bit register at offset
0x12:

  Link Capabilities is at 0x48 + 0xc  = 0x54
  Link Status       is at 0x48 + 0x12 = 0x5a

Previously the driver read Link Capabilities with a 16-bit read from
XTL_RC_PCIE_CFG_LINK_CAPS (0x56), which incorrectly read just the upper
half of the register.  When a hotplug-capable port has no link during
probe, tegra264_pcie_icc_set() consequently derives the maximum speed and
width from unrelated bits and requests the wrong interconnect bandwidth.

Correct the Link Capabilities usage by adding a XTL_RC_PCIE_CAP definition
for the base of the PCIe Capability, using the existing PCI_EXP_LNKCAP
(0xc) and PCI_EXP_LNKSTA (0x12) offsets so they're easily searchable, and
reading the entire 32 bits of Link Capabilities.

Fixes: 01c3c27a0ef6 ("PCI: tegra264: Add Tegra264 support")
Based-on-patch-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://lore.kernel.org/20260827093919.2825467-1-lilinmao@kylinos.cn
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260923195719.1933175-2-bhelgaas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-tegra264.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pcie-tegra264.c b/drivers/pci/controller/pcie-tegra264.c
index 653136db401e0..c97576ab4a316 100644
--- a/drivers/pci/controller/pcie-tegra264.c
+++ b/drivers/pci/controller/pcie-tegra264.c
@@ -49,8 +49,7 @@
 #define XAL_RC_BAR_CNTL_STANDARD_64B_BAR_EN	BIT(2)
 
 /* XTL registers */
-#define XTL_RC_PCIE_CFG_LINK_CAPS		0x56
-#define XTL_RC_PCIE_CFG_LINK_STATUS		0x5a
+#define XTL_RC_PCIE_CAP				0x48	/* PCIe Capability */
 
 #define XTL_RC_MGMT_PERST_CONTROL		0x218
 #define XTL_RC_MGMT_PERST_CONTROL_PERST_O_N	BIT(0)
@@ -118,11 +117,11 @@ static void tegra264_pcie_icc_set(struct tegra264_pcie *pcie)
 	 * possible, so this is as good as it gets for now.
 	 */
 	if (pcie->link_up) {
-		value = readw(pcie->ecam + XTL_RC_PCIE_CFG_LINK_STATUS);
+		value = readw(pcie->ecam + XTL_RC_PCIE_CAP + PCI_EXP_LNKSTA);
 		speed = FIELD_GET(PCI_EXP_LNKSTA_CLS, value);
 		width = FIELD_GET(PCI_EXP_LNKSTA_NLW, value);
 	} else {
-		value = readw(pcie->ecam + XTL_RC_PCIE_CFG_LINK_CAPS);
+		value = readl(pcie->ecam + XTL_RC_PCIE_CAP + PCI_EXP_LNKCAP);
 		speed = FIELD_GET(PCI_EXP_LNKCAP_SLS, value);
 		width = FIELD_GET(PCI_EXP_LNKCAP_MLW, value);
 	}
@@ -263,7 +262,7 @@ static bool tegra264_pcie_supports_hotplug(struct tegra264_pcie *pcie)
 static bool tegra264_pcie_link_up(struct tegra264_pcie *pcie,
 				  enum pci_bus_speed *speed)
 {
-	u16 value = readw(pcie->ecam + XTL_RC_PCIE_CFG_LINK_STATUS);
+	u16 value = readw(pcie->ecam + XTL_RC_PCIE_CAP + PCI_EXP_LNKSTA);
 
 	if (value & PCI_EXP_LNKSTA_DLLLA) {
 		if (speed)
-- 
2.53.0



