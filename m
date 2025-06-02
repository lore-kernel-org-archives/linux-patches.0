Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870052288F4;
	Mon,  2 Jun 2025 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877180; cv=none; b=b7M9rppkpR2xHOZKGKf8iQ7O9p/rC3lMa28uKkNX40sWG+cYIlIPP3Met2iyaBpe9kUlpwbxKf9kPxSaoPbS3+sptUSCXR4/z3hKTQfFQCOe9ZcWrtgjxvCGW1w/FIi4pelu1xW4clde4wHmfQs3GdtWv9+uklTI7+U5P+skLuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877180; c=relaxed/simple;
	bh=SP5t5C2zVjaYUzYV4GAPB87VDtmeUYkqtW3kvZmwk44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6Y649bQOsW2jD/xCa9yVYtFrYkVaadthlmGpag02DtczpyXCiYF1VQ5fUkyzZFhJkFxYMZp/8Qe5NG7kBHG3hgBkO0ZmKQMFd8qtB89srytBrTpSg3d3QejEvsymhPSfX+5vMhk7fHtPTeIclfHflLZrim5zvaPSsdzDTZFeGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngGCYDr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngGCYDr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF402C4CEEB;
	Mon,  2 Jun 2025 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877179;
	bh=SP5t5C2zVjaYUzYV4GAPB87VDtmeUYkqtW3kvZmwk44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngGCYDr8FWCezkOAUdzuSaQJzhbHsSC/uvRP83BUI08f+h+4deYGo8jCtGGQzKVV+
	 02JhOrIiv57g4mSSXc5OaK4pTXpcT172I5klNVFPXRVZoeVBltaz2RKrI+L0EXYzxV
	 wjeCO9qYzU1JK63zAkU/KOw29MXn7Qj0TBAhMSwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/325] r8169: dont scan PHY addresses > 0
Date: Mon,  2 Jun 2025 15:47:52 +0200
Message-ID: <20250602134327.763961643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit faac69a4ae5abb49e62c79c66b51bb905c9aa5ec ]

The PHY address is a dummy, because r8169 PHY access registers
don't support a PHY address. Therefore scan address 0 only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/830637dd-4016-4a68-92b3-618fcac6589d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4b461e93ffe9d..6346821d480bd 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5156,6 +5156,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
+	new_bus->phy_mask = GENMASK(31, 1);
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
 		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
-- 
2.39.5



