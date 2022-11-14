Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DA64C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34528C433D7;
	Mon, 14 Nov 2022 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431033;
	bh=gYTMm7VUwqh4kPxOTqmx9VLN2+89m1+IW9DrhUoao9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJ0r0YZndE3PSxEjBtqBkdW/QGwliuxoMXfUO5rDreOD0yWRCktT92A3C74IkO5C8
	 jmMuo5THUmibhxDPZaHDY0mTEwtIi35avSg6L1nNPuWMsncNfpX5bTCm7eN/eXYH8M
	 JGb8dIxdh78k5+Ff4YKQnlD54ipQrrC8PwdTd+TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Thomson <git@johnthomson.fastmail.com.au>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 045/190] phy: ralink: mt7621-pci: add sentinel to quirks table
Date: Mon, 14 Nov 2022 13:44:29 +0100
Message-Id: <20221114124500.776681813@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit 819b885cd886c193782891c4f51bbcab3de119a4 ]

With mt7621 soc_dev_attr fixed to register the soc as a device,
kernel will experience an oops in soc_device_match_attr

This quirk test was introduced in the staging driver in
commit 9445ccb3714c ("staging: mt7621-pci-phy: add quirks for 'E2'
revision using 'soc_device_attribute'"). The staging driver was removed,
and later re-added in commit d87da32372a0 ("phy: ralink: Add PHY driver
for MT7621 PCIe PHY") for kernel 5.11

Link: https://lore.kernel.org/lkml/26ebbed1-0fe9-4af9-8466-65f841d0b382@app.fastmail.com
Fixes: d87da32372a0 ("phy: ralink: Add PHY driver for MT7621 PCIe PHY")
Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20221104205242.3440388-2-git@johnthomson.fastmail.com.au
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ralink/phy-mt7621-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/ralink/phy-mt7621-pci.c b/drivers/phy/ralink/phy-mt7621-pci.c
index 5e6530f545b5..85888ab2d307 100644
--- a/drivers/phy/ralink/phy-mt7621-pci.c
+++ b/drivers/phy/ralink/phy-mt7621-pci.c
@@ -280,7 +280,8 @@ static struct phy *mt7621_pcie_phy_of_xlate(struct device *dev,
 }
 
 static const struct soc_device_attribute mt7621_pci_quirks_match[] = {
-	{ .soc_id = "mt7621", .revision = "E2" }
+	{ .soc_id = "mt7621", .revision = "E2" },
+	{ /* sentinel */ }
 };
 
 static const struct regmap_config mt7621_pci_phy_regmap_config = {
-- 
2.35.1



