Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C381F7566;
	Tue,  3 Dec 2024 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239294; cv=none; b=Zeogl3RYyxbdgWPli5qiASynywjhWAQ8XWO23A28ywpbXWsUwWsQRcVIxxQfE7OfWA6gY3MB+za4o2G8y6LgA8ELqZXaadmPRthTWqcImGeHU85hCCAl/iyucLyif6mv9x8kbSJzD3BGOdtujqmmH55lwIPJ/C359IWG40mA7Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239294; c=relaxed/simple;
	bh=4KkjG4fdYwzWyWneoV0Rz8PeiG3FqWGtv6E+tT+WbxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFwSpsHqSQ0/N79iMOzjvpiVzbFQcKSa1482lVdQ4rmE39oihbAPuVdxTQ9yDfYX2TbTiXcc24O+EEmVSytoeHnhb5LmuGEEnsfEgfudWlvCQaz3l1AaLOk9o8sRcH6yCGGV1Kx+22JLBLWk0lpLcBLiubzuP9q7BMOehCFLpCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK0uHtig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK0uHtig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3F8C4CECF;
	Tue,  3 Dec 2024 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239294;
	bh=4KkjG4fdYwzWyWneoV0Rz8PeiG3FqWGtv6E+tT+WbxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK0uHtigLNKpZEuXa0sOhlyVCye+rg71ojVd3TIQilthYFuQaoaJ+wA9FrEHt1ZVf
	 xUdsLXx8Nn/bwh54cFoR8Uo4Ogwk/xTTGBreNx+1XgXKHovhscPeA+7DBhWAT4fsLF
	 uYZwHg2UaKblFNJ80tttecxBeVIYGu49Tz6RL8ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 564/817] power: supply: rt9471: Fix wrong WDT function regfield declaration
Date: Tue,  3 Dec 2024 15:42:16 +0100
Message-ID: <20241203144017.925539412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit d10ff07dd2b933e3864c592ca932996b07bbf22a ]

Fix F_WDT and F_WDT_RST wrong regfield declaration.

Fixes: 4a1a5f6781d8 ("power: supply: rt9471: Add Richtek RT9471 charger driver")
Reported-by: Lucas Tsai <lucas_tsai@richtek.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/f862e23f220612f01fabb6d8e76cfaf63756c22b.1727252762.git.cy_huang@richtek.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9471.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/rt9471.c b/drivers/power/supply/rt9471.c
index 868b0703d15c5..f62154d929028 100644
--- a/drivers/power/supply/rt9471.c
+++ b/drivers/power/supply/rt9471.c
@@ -153,8 +153,8 @@ struct rt9471_chip {
 };
 
 static const struct reg_field rt9471_reg_fields[F_MAX_FIELDS] = {
-	[F_WDT]		= REG_FIELD(RT9471_REG_TOP, 0, 0),
-	[F_WDT_RST]	= REG_FIELD(RT9471_REG_TOP, 1, 1),
+	[F_WDT]		= REG_FIELD(RT9471_REG_TOP, 0, 1),
+	[F_WDT_RST]	= REG_FIELD(RT9471_REG_TOP, 2, 2),
 	[F_CHG_EN]	= REG_FIELD(RT9471_REG_FUNC, 0, 0),
 	[F_HZ]		= REG_FIELD(RT9471_REG_FUNC, 5, 5),
 	[F_BATFET_DIS]	= REG_FIELD(RT9471_REG_FUNC, 7, 7),
-- 
2.43.0



