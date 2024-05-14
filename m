Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA75028C;
	Tue, 14 May 2024 11:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687543; cv=none; b=tEkVdxSoZyTZFhR+oouCaLgUhqXQyS1JT9Td6wUgVSGwXXebSkRbvTp5nxasjfCEvfz1SxYgelWXXU6lYB+aNNrECGrbGeOwCelFjBzj7YHHiHtC0EHsD4cEqlaigREt2EQoYzZjgoxnc7i+SBF2mzO/RkK5KD/1Diw7Tjs3Vr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687543; c=relaxed/simple;
	bh=y20qB1PMaT5oLfc+bmZNkE52xRg1vVPu68YpVgxlGHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuUU0JiwJI/MYsv42ZWLxVpMo8Yp8XYtCYJ0vHMJ1uamkCfZcNu5ZlmAgw4ARD2AGUk6ILmM67bPUrpbTlU8DfzNYHoBfDEj/bAJ1panjxYxjEqrIqirApOX26A/sSR00Jbkhff8nZ47ucQQMvkMIFHkahMKvfXkvddKoeAjPZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOl/1tK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOl/1tK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CC0C32781;
	Tue, 14 May 2024 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687543;
	bh=y20qB1PMaT5oLfc+bmZNkE52xRg1vVPu68YpVgxlGHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOl/1tK4pKPx1jfYggGknl9pnTBIx20Brc9KFARFdj7vxZyBXGk92HzRbl076IBNR
	 tLv0X0lAVVsww0qTOEwMoFmPF82k5Z2cB2QG7t6hIP1w3XHBOhXGuOHYhDnG7tLwcU
	 6J+bQGhpIA9QT3QvFaYPyWSUIvMe+6tqZh4jvfdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/168] power: supply: mt6360_charger: Fix of_match for usb-otg-vbus regulator
Date: Tue, 14 May 2024 12:18:39 +0200
Message-ID: <20240514101007.488399071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



