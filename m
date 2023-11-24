Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E229381DE;
	Fri, 24 Nov 2023 18:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxz021HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A277FC433C8;
	Fri, 24 Nov 2023 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850397;
	bh=MLQLC8wC7e/5Wly9XWiEB1qV81WwrXOfsvbV0oi9D3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxz021HQQL+rDGTaXyOP94rVN5BjI7NcN1cJhg8nt4GDg1R+TFPoNLDcq3S4Tbo8i
	 K3RjaAc31ozY+8VSdywpXPTV42sv75N5bBhxiF5r+bq/HDKnySZ23mOQxTTepJ9jPr
	 0sDLBkqXIwHuBw2Ic4uZJ0xBX3KqlsGNyTPjyKqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 033/491] net: sfp: add quirk for FSs 2.5G copper SFP
Date: Fri, 24 Nov 2023 17:44:29 +0000
Message-ID: <20231124172025.694573632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

[ Upstream commit e27aca3760c08b7b05aea71068bd609aa93e7b35 ]

Add a quirk for a copper SFP that identifies itself as "FS" "SFP-2.5G-T".
This module's PHY is inaccessible, and can only run at 2500base-X with the
host without negotiation. Add a quirk to enable the 2500base-X interface mode
with 2500base-T support and disable auto negotiation.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Link: https://lore.kernel.org/r/20230925080059.266240-1-Raju.Lakkaraju@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 338b9769d91a1..f411ded5344a8 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -468,6 +468,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault),
 
+	// FS 2.5G Base-T
+	SFP_QUIRK_M("FS", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
+
 	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
 	// 2500MBd NRZ in their EEPROM
 	SFP_QUIRK_M("Lantech", "8330-262D-E", sfp_quirk_2500basex),
-- 
2.42.0



