Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62FC1DFD89;
	Fri,  6 Dec 2024 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497796; cv=none; b=JpsNtORCR4Xi7bDhzLlAJ1IHC19LW/i4ecBuC9DkOcqPe1VOKzHsn982NR87cxraZunLp9JDKGdzo3ZUNB7BzILoA+mdeDPc9ytMJKVJw+J8BV7Lxdn/qZdh1ak/SZIHlzB9xfhVIQvPJQAC2K9F5HH+z63jl4X8xqkPSIkPPWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497796; c=relaxed/simple;
	bh=0ZDEFy++ZzJXq9QHsTbARvdhGI56wwPm+5M4TV4F5j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW/hB2zqWE6hFILt+GPxSZhTaUxmSNQt8+Ummozq7zVGY395lnYZ9IKGYXIht7sEiQ7BHgesHMxiPQlDT8qyjC2Ox93DF4PLrauVJcDKgvBNTiJgSljOooYw7u5KM1aB6O0XQWx4g7ZgDYFWe1apM1vY6rzXBK2uU9CpRlEv+7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRrRGdOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRrRGdOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A84C4CED1;
	Fri,  6 Dec 2024 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497795;
	bh=0ZDEFy++ZzJXq9QHsTbARvdhGI56wwPm+5M4TV4F5j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRrRGdOd+IyWmBwglsHPq96DnTnut5bVgtvHzjd7utIU89ZzgM3xPVC+LuCid+S/R
	 Iij8tj3fkj1mwRBgn5OTF8VMqAIodt7afOmYm5krvPA8Yxlx8dh7jDykO0WFtNBHnR
	 cMyqwMmEtR2r5Hp7zjwPm5EPoJ74pv+mMD441Uws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/676] power: supply: rt9471: Fix wrong WDT function regfield declaration
Date: Fri,  6 Dec 2024 15:33:35 +0100
Message-ID: <20241206143708.819534631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



