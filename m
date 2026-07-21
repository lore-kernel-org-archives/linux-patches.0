Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7662544AB62;
	Tue, 21 Jul 2026 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669246; cv=none; b=GEgtrJik0s/+KS/Bi6Z3LDv1rRLtnYKy+45NKm072b5EcIUJ9mk9Q0XXGA0EWBEqHa/yNgwxoCWHzQ+Ep0euNSunm6lcVByXvbnBKtA5iDJTdl+eiS/vcKvVJoJ9rl8Ut8Rimr2vFG9buQtgJ7UvsyTqM2k18S26RWGBjarbjEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669246; c=relaxed/simple;
	bh=q0o2bpJ2W094woZGqk1PSV7ky58+6YiZBW5ussZ7Y5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7sWBSoSdnQ9l6CxIrYlzDZDaObzOEZxt1EfE3imfndUbQEsXZmnbL/pqqFFtwcBhUcoUnomkzun0I7NNXhbgWPTRICwNq8Z84xrANI7f7s4taLdeTSCXqB18KDegqi8sAj47ZjM+ynS8rFXoODb68c7ZTb9jHyut8JPQFCiAwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4nvIuUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4nvIuUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB6E1F000E9;
	Tue, 21 Jul 2026 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669245;
	bh=1enBDzjkpI1IhmRksIUI6Knr5H0jhX9WZAcHeLWbpMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4nvIuUp0m6HWypQ4T6gwIm+dgoKv+wAKfGUO+Hx3WDaO5zwlolTezE+lKY+SGfVy
	 BOnrdkhyZo7iEGGPQODW8Nx5WkSrWG7g33FioOd0Fo8X/MZWZZueWF7N+RdoPcsDy1
	 2GTFZHkxeZVyRglogNIQTLB3OvnwazWct7H/eCgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0483/1067] phy: phy-can-transceiver: Check driver match and driver data against NULL
Date: Tue, 21 Jul 2026 17:18:04 +0200
Message-ID: <20260721152435.422275480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce511ad5d36907..2852661d398603 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -106,6 +106,9 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
+	if (!match || !match->data)
+		return -ENODEV;
+
 	drvdata = match->data;
 
 	if (of_property_read_bool(dev->of_node, "mux-states")) {
-- 
2.53.0



