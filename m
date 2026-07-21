Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28C3F2101;
	Tue, 21 Jul 2026 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660147; cv=none; b=jlRGxloO+K5TSFsT1CCMVF9hdGIa9mSc9ljZCNEB1p4zmVf3gOPLjUK6/XbAOFe6hy81xzkng9xv3CsAvIDQ1By0P0sS3L7hWRKRskk/goAB7zpCHwOQDAX3koIp5tlyTC/3Kk7JLIVvB2XPUhEwbGl8u86quLi/abBV5J5oqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660147; c=relaxed/simple;
	bh=8YTJzZG0fXZmKPkf2xTIcHYlefXvfhniYQ2GitSaRWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsFdjToVeM+PbhupTaNO09QMJVY76G1NXSNyfgew/xQctu2gVwYUxkOzwxZ7ZiphGdOK3WaBuBPtfd/8TTrVNjc0gjdeClWsKdrNtIDhYJBqp98r4kaIHA/OE+mXB3AyoZZimFQ4fA+9U6rPjsbxWvELs+0jkXYvpHSfovZQkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apx1kE9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apx1kE9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BCB1F000E9;
	Tue, 21 Jul 2026 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660145;
	bh=tEiADCAflLJvnpIddm//R0BEchxNlokur2RF2YvTQmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apx1kE9Z1Gfz5MZ4eiL5AFdHuqKC0yy/3aC1lsWtFfcuza0sXaZygPmcg0HIi3Sjo
	 jsQ9mX9/v3vzVgsMpbXOD5nwlcdfAq3145rIGat7mELrsijEzP4rlOrFz5NcOzgVBw
	 azZXwibCS+JpLlLmHXRbvcLfEq7jG55GjRmtN08k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0867/2077] phy: phy-can-transceiver: Check driver match and driver data against NULL
Date: Tue, 21 Jul 2026 17:09:00 +0200
Message-ID: <20260721152613.238690687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b52e47f247a2b..1808f903c05707 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -162,6 +162,9 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 	int err, i, num_ch = 1;
 
 	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
+	if (!match || !match->data)
+		return -ENODEV;
+
 	drvdata = match->data;
 	if (drvdata->flags & CAN_TRANSCEIVER_DUAL_CH)
 		num_ch = 2;
-- 
2.53.0



