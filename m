Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098D3A0E97;
	Sat, 30 May 2026 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160900; cv=none; b=lrLdzCDlpZ0RzFAWhqsQTkADyrPz9x1SOGTP5uUyQs0LFIoN6G3kQspp78TU9S+wC+yrd/cRV/Kpz0KTOuf/VVFnZfKzSPXPL3ibYasYrySmgZ4IFPpRlzLLufKZszN3QN2Bjd4hcvoG4rLosRpO/D9Bda5PMcJ14Lcnqp0IeQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160900; c=relaxed/simple;
	bh=3Wp6eRoxnjLKgpkaYial41Z/Q4otCN0gOPO3JE47Ee0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6TqpUla9UhDcdiUnYR/sWuVPzrtjFWGd/PvAJjxlvBMrd9wjX+v1vXo9n/vwh0pqsrcJmX34eDsiE4bdiiv0QW1kyRdmHGIdIWmnyM1WkFh7tQQp6WsVsAEPSdb8Qyp70GGK86nPAQC/hUz+Q6YV61deXSYm1wujsGyq+fYahc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcTgflsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcTgflsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CBB1F00893;
	Sat, 30 May 2026 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160899;
	bh=JD8aCLbDb5x1Jig724Imh48f73yv71MmOJvIphsfvYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcTgflsHOCleAimGIpGjkBrEuKOm3nFMY+imV8sSxMwKSW/NBfyNs5C+quN+IXJZu
	 chw9iVB/wECQcp3yN8LQzrjqmIfeb7zK4+zWxOT5YdM+FYEKqjdKBsTLDPDdxqJHH3
	 sreIIJVz4EYJbwQ2cO9W3kE0IlOUTFg4CVaZFJzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/969] thermal/drivers/spear: Fix error condition for reading st,thermal-flags
Date: Sat, 30 May 2026 17:59:22 +0200
Message-ID: <20260530160312.363286225@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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



