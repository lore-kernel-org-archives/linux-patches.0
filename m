Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7193B9D9D;
	Tue, 21 Jul 2026 22:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671789; cv=none; b=tUwiQ1yDUxq22m4dzcKQIWZbSMEU0s+qDx6r7ptHEdFcNtUoC8OQRoR4jMXW9Qrf44K/ftJUg/KQNfhsgmlRCr1nyzf3RyMOh/j82CEkeS/xp0i25Vql2GVEDf3GMSg6j7kPIBWr54LzS3O30ZyxJF5deLXFb5H+gFPRetHum2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671789; c=relaxed/simple;
	bh=LOSPb8q5f8OUn7gaHN5AGGpiuzQaLKznfqiVtIBz5r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGA9W9M6S3RIpVtX9a35gC8PE8WfY7YHT1AGtQx5nprFeC0ScwdkYJ1Pp8dF8R5RrMNhsrdmmuYZ4mq+X8yFil+HnT15GgSk3BVC/nCGKhaUmTuHQVIw7WyXqMvTJ4vG7ywNbUQYB4NklRJ6bF/yZofOE9WwVf0ZMPiraRhhG2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/iufc7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/iufc7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C696C1F000E9;
	Tue, 21 Jul 2026 22:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671788;
	bh=80P/D+nbYa466EUsjrRPCxP6XqB/ipf1u35wNSFS2ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/iufc7zjMk+zbTAO5KuR2PNqMNBAFBFmXYj5y80r7Ea+fryELQHgEmwDM2mUGCn8
	 ALVtK1Y/g6IA2FY5aVJy6fcPXCmRVWTSsW5lVbTq6gMOJgt3f6izPTgTUwHPcCsCTg
	 JkdA9Qo1v/tOexJqV//i2ynEzhLQjGG0yIOjKwjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/843] phy: phy-can-transceiver: Check driver match and driver data against NULL
Date: Tue, 21 Jul 2026 17:20:14 +0200
Message-ID: <20260721152414.563950605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ebee9004cc0200b2b708ebf7ac625d35c71c049f ]

Every platform driver can be forced to match a device that doesn't
match its list of device IDs because of device_match_driver_override()
so platform drivers that rely on the existence of a device's driver
data need to verify its presence.

Accordingly, add requisite match and driver data checks against NULL
to the driver where they are missing.

Fixes: a4a86d273ff1 ("phy: phy-can-transceiver: Add support for generic CAN transceiver driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260513220336.369628-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-can-transceiver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/phy-can-transceiver.c b/drivers/phy/phy-can-transceiver.c
index 4525d3fd903a4d..751192df066133 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -94,6 +94,9 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
+	if (!match || !match->data)
+		return -ENODEV;
+
 	drvdata = match->data;
 
 	phy = devm_phy_create(dev, dev->of_node,
-- 
2.53.0



