Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E3F33A9FC;
	Tue, 21 Jul 2026 20:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666257; cv=none; b=Hodz1gzQjawsIAKJIPumLAqqYFjrvOB++nElzYXV1RTGFb/0pY/iUVdgwLqKMEO4ujwgunoKivN69ImFSMooqO4pYEqfBC/rdWB1iG7F1BLgyzr0qkWq9/xy/mZPAR4Jqsa+7fN3UZXO5MbKG8ha30aUSXC/o/wX1zEkrnFPs4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666257; c=relaxed/simple;
	bh=9LXKTUPvtKVFt+nh1NRC3VHEBlHHqFuxjvlv7QQVins=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEkDA5hxxsuE3ny7YHdSr6maWEht6CMUbWkwZNum/NKzpfTo0cZtgGKQtbCED3rt6dZDRQsllfDoa4w1ZHWHfrwqUlV0pAfJ1u4ph39QYn2YA4tC1kkdNZEvseazXMZ/A8uYWTjv135O5XvMC3Y4A5P4m11lzUVDeno4h5piKwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HOfXW0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HOfXW0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1346E1F000E9;
	Tue, 21 Jul 2026 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666256;
	bh=mu0UAxw+Gckv1wDcaGyhf0BStDRL2J9KBS9wXYkj8yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0HOfXW0psBHnRtMByTwdIeHyd3lEO6E527HqiJtH/vSQGHVveyZWK+1/7q3XGYsIe
	 JkfTUD9ECGcj1fZATIS3KwFKN4y337/gjK/t3fvDTjfgJqI4TNf3osFr82qWcu4imQ
	 03VAHAp8TxnSAf8wAHBY3y3ZhGo3vQeshD2aj+Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0615/1266] phy: phy-can-transceiver: Check driver match and driver data against NULL
Date: Tue, 21 Jul 2026 17:17:32 +0200
Message-ID: <20260721152455.624001393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 840b7f8a31c5fd..72dc65c7246784 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -111,6 +111,9 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
+	if (!match || !match->data)
+		return -ENODEV;
+
 	drvdata = match->data;
 
 	if (of_property_read_bool(dev->of_node, "mux-states")) {
-- 
2.53.0



