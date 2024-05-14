Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6800F12FF6C;
	Tue, 14 May 2024 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686142; cv=none; b=brPu8fIIo41nPMY1F69D65iOiCiwsNIdjzStog+gi/l3TJIUhukJOP3VMFrNpZXMIA5meqb7tgZOAHclYb6YteOrAETNJGysW6tlP/0e3mMX933dWpnggkPIGG7+vnimiyMcGHhRn9/Yz2bzU3wrw3bN8uK4iDjR5JdTv4B5Npg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686142; c=relaxed/simple;
	bh=B4oyecOb/oNzXgPCHTUY9C0+zcSxe09f3TVXVIgmRXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ3Ip/L9QBGAMbea2rMKNn1U3Scw6uofmsA6fbiW5mykNdPJTDeTO8qRteR0cj6dv+bvketTD+Tc3wNow3LwEKxl1em42NckA3p5hfyRQclDIZpQ/f+e4jsAiO4jCbW7KX6C4acBh4+NdalUBdor80r7NnPApLr47niPyBrEc+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbPs6Dta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbPs6Dta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A07C2BD10;
	Tue, 14 May 2024 11:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686142;
	bh=B4oyecOb/oNzXgPCHTUY9C0+zcSxe09f3TVXVIgmRXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbPs6DtaNcdpqRBYjEZe2TAXOEIVnU9sROEVroyQ9KAUnTMl7eNg5+jzm7ZcjBaBi
	 oGf2vwGZK0AypOOC3mzDMwLwIQZf3CMcVR1s1nsgycnq/0YxfN93kRQsqRYQNHiijL
	 uN5hqRjmZA8bQ0ksWlYPVobxpIyLN74dZulhjt1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/236] power: supply: mt6360_charger: Fix of_match for usb-otg-vbus regulator
Date: Tue, 14 May 2024 12:16:37 +0200
Message-ID: <20240514101021.674676235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1e0fb113646182e073539db96016b00cfeb18ecc ]

The of_match shall correspond to the name of the regulator subnode,
or the deprecated `regulator-compatible` property must be used:
failing to do so, the regulator won't probe (and the driver will
as well not probe).

Since the devicetree binding for this driver is actually correct
and wants DTs to use the "usb-otg-vbus-regulator" subnode name,
fix this driver by aligning the `of_match` string to what the DT
binding wants.

Fixes: 0402e8ebb8b8 ("power: supply: mt6360_charger: add MT6360 charger support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240410084405.1389378-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/mt6360_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/mt6360_charger.c b/drivers/power/supply/mt6360_charger.c
index f1248faf59058..383bf19819dfb 100644
--- a/drivers/power/supply/mt6360_charger.c
+++ b/drivers/power/supply/mt6360_charger.c
@@ -591,7 +591,7 @@ static const struct regulator_ops mt6360_chg_otg_ops = {
 };
 
 static const struct regulator_desc mt6360_otg_rdesc = {
-	.of_match = "usb-otg-vbus",
+	.of_match = "usb-otg-vbus-regulator",
 	.name = "usb-otg-vbus",
 	.ops = &mt6360_chg_otg_ops,
 	.owner = THIS_MODULE,
-- 
2.43.0



