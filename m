Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3A733F5A0;
	Sat, 30 May 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164033; cv=none; b=lPWv8992pKc6pfscPzMOkEC03oFMUdsdHi0bvjS6Nm2vmewAlOuw8BT609cZd5en678Jw1tOOETRP2cIEfFElF2SUkKPEYHprf1x9b8Jo4Uc3NC/ODo7XO0u1Z4vlvsvEJwDXtSDk36x3MGObkWYstVYuL2Byg6nwMp2OByHlFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164033; c=relaxed/simple;
	bh=DKg1yUZOBTTxKEmdWO1c9zIPMxP3fB75JMM82GsKEnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9NnQCKYhtxueGV+PUCFLBmN5X+rHjL1dXrsVB2PRm6J0ZOTfNaszJ/BW9vCg/i5yPDeObdl0Bx/G2wOqGcUptl77xwAIPKklV4pqg6eMJLk6g470xnxdVjLTG0wks6H2ZmBVz1hmKHX2gTpeFQE0MFIvlNqZPO+d9z6z3gOgps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbMghMIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbMghMIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14061F00893;
	Sat, 30 May 2026 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164032;
	bh=oG9mQhNJlt88ziH0zCRdMEVWQJjepg5vq2pB9gHyqzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbMghMIQ3vj6yLS34gn3RLHheV7w7T/RaKheYk8qbfrudwv+9mXFInlBmcnKOQIgK
	 SyWRdX95KL1VGQiO+FWTUP9IxVTk3/vPq+6Lb++pWwaOQbhP5TvsqDPKYWH/lhb55L
	 v4E8QLaxVKNuxzjFe5FqpdZ45WI1w5RQBTk8CY/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/776] thermal/drivers/spear: Fix error condition for reading st,thermal-flags
Date: Sat, 30 May 2026 18:01:44 +0200
Message-ID: <20260530160250.575777117@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Gopi Krishna Menon <krishnagopi487@gmail.com>

[ Upstream commit da2c4f332a0504d9c284e7626a561d343c8d6f57 ]

of_property_read_u32 returns 0 on success. The current check returns
-EINVAL if the property is read successfully.

Fix the check by removing ! from of_property_read_u32

Fixes: b9c7aff481f1 ("drivers/thermal/spear_thermal.c: add Device Tree probing capability")
Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Suggested-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260327090526.59330-1-krishnagopi487@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/spear_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index ee33ed692e4f7..42d8736d5ba49 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -94,7 +94,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret = 0, val;
 
-	if (!np || !of_property_read_u32(np, "st,thermal-flags", &val)) {
+	if (!np || of_property_read_u32(np, "st,thermal-flags", &val)) {
 		dev_err(&pdev->dev, "Failed: DT Pdata not passed\n");
 		return -EINVAL;
 	}
-- 
2.53.0



