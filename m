Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8D1E766E;
	Tue,  3 Dec 2024 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242011; cv=none; b=YzEdYnywL47/Q/w872hmdIFgtpzkW2pM6kDsj1gvQlt6x1E9Isb5dPa1u2Z0Axuuccg/gkE096OhrEdQH3aUj453pOsehVue8Sdx1uBHICpHL3FTUy8oCpptKVoyIKdD5ufBxUABW7FctmHF0n2ZUkFfPgUa8NgMDbf0dq6rHqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242011; c=relaxed/simple;
	bh=RmgA6OQIDlYySKuwsHmzWDSdi7pXTh2MNThVP1jEjlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dghiBN7RsNhIcbUavL4zWLKoeeX7EA4hoCi46vKedEAxCwyCO+mYr9qplq1JtOtQf+YZ50sUc+xAWzXtQy6aZLqpSJ5ZbUdbTEffG//zNmL6yFSEeq8nMnsh50/ZjU0utcsotckegjsW4TlNL7skzCPJxKsfu2LduSGeNQXv8nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLk1SQKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLk1SQKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2E2C4CECF;
	Tue,  3 Dec 2024 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242011;
	bh=RmgA6OQIDlYySKuwsHmzWDSdi7pXTh2MNThVP1jEjlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLk1SQKq5KnPF6tmx0NPTlI4oqWzE4LTcbAPjPStJagmuoGTRn76+rUbvHndt3Ie7
	 4wOQTfzRKhxuTcS7lXtxJAuRvb3bG0mzCTm89o97HVs1G599yv0AXDvXu7PgVVnGe6
	 VlEpWhe2LZHPjpChZ7RRRbw2B1buuXqv89vE1Plc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 550/826] power: supply: rt9471: Fix wrong WDT function regfield declaration
Date: Tue,  3 Dec 2024 15:44:37 +0100
Message-ID: <20241203144805.204969433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c04af1ee89c67..730b252b49006 100644
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



