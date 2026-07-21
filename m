Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F043B46E01C;
	Tue, 21 Jul 2026 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656996; cv=none; b=BXl7vX0STF3weY3dEGoA/aobE7gMDUvjbq38fUmYu953s1P9MaP/eufH9FR8D77KMymfxkAd36hMU1ci4Dzx6AbCJ/PvaWC180EHvRSaTiHpFLrug+bE2jvDCFPD+u3emB4AWGGBEkX3H3n40r2EW8skahycvkiq5cBoFXcZ33U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656996; c=relaxed/simple;
	bh=rj5Zk0UQtpQP/wnTUr/wiC5OIrUTjiNDS29T2FurIqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWlLttsI8GS03TNDs1ZkECO/U7H2Z3IaLl9fVAwdu87sQiC3ocph0V5YdW0OpPjGxORhGnuVc/45smf/GLBZFCkiwsTPTHxfS5pZm9E27MxiV3wXiV4CMDQ8rI0N4PboYVYF61fkZaOsChFXN8Ju9bMtH0NwKtDY4PgBCS9WM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjXpY8oF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjXpY8oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C551F000E9;
	Tue, 21 Jul 2026 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656994;
	bh=YmIkCupa40mPalB1PoDm7tkDod0RoKPvbXwjEbuEoAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjXpY8oFwYc2O1nDimeGVkxRE5YUP3mgUx4E12znPDSN6U2+nDQKkYLMRf4k7Utac
	 7Xjtc0cla3T1aznXRgPzAD2mbjNDrglZBmym9hpkcYURKCk5GDF9IsjZ/1yobZfj2x
	 UIxb6JtKJQcge5H5soNvTYwXjCWPALGRMbpLpBRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0596/1611] phy: phy-can-transceiver: Check driver match and driver data against NULL
Date: Tue, 21 Jul 2026 17:11:52 +0200
Message-ID: <20260721152528.792188277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f59caff4b3d4c2..e09ce1a86f5a4e 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -122,6 +122,9 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
+	if (!match || !match->data)
+		return -ENODEV;
+
 	drvdata = match->data;
 
 	mux_state = devm_mux_state_get_optional(dev, NULL);
-- 
2.53.0



