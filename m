Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37D17B3E5;
	Tue, 14 May 2024 10:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684320; cv=none; b=X/ZIP31P/M8UEBf20EKBfw3XaAzSFCOeFt5Ak82lY3F6sSwkqd+RQKsTb+K924rEFcwjS7szZtFhqeEqAdBY9399zxVLI0MteyCaUUcuB6V02gSzVcNJyt0AcvfEw7nB/Rh+JlhUGzFjuvkwGFU98VQnGESXlQ0wDR2gOzkRzxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684320; c=relaxed/simple;
	bh=PO3kM1xeeqlL8jrxv22/Xyn6bZc29w85Xmsu/V7kTP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACdExYKjRBGytQoUCbsLC7pPv65wDSgxNR80ymvLNUkSoPYQSN+B4lDAuMeGCX44j/TM8I5pj39ZqchbDt/jD5vS08o63dadKylJ52hEDlWsrUNpKhpxS2cWCzj3tnjIflaPgWvXZXXK+qMXgJvAHZq+99ol/HTMFVWXW4i83hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2m3tOG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2m3tOG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D921BC2BD10;
	Tue, 14 May 2024 10:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684319;
	bh=PO3kM1xeeqlL8jrxv22/Xyn6bZc29w85Xmsu/V7kTP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2m3tOG7miBfb2Hcl0yDtAh+g4OKzQrc4xBVZEKiARnCyHwaDXM/izqO60eEfC61d
	 wY9FcJvid6xw7DVqliH1xfc4nr71DskXofty7zxtN5MEHD5InqJV7ZdwxcDv0m/mMn
	 tp5mI7JsGtm/6syh4NQQULBF9NlVgKzmYvq6zmYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/301] power: supply: mt6360_charger: Fix of_match for usb-otg-vbus regulator
Date: Tue, 14 May 2024 12:14:54 +0200
Message-ID: <20240514101033.120955883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index 1305cba61edd4..aca123783efcc 100644
--- a/drivers/power/supply/mt6360_charger.c
+++ b/drivers/power/supply/mt6360_charger.c
@@ -588,7 +588,7 @@ static const struct regulator_ops mt6360_chg_otg_ops = {
 };
 
 static const struct regulator_desc mt6360_otg_rdesc = {
-	.of_match = "usb-otg-vbus",
+	.of_match = "usb-otg-vbus-regulator",
 	.name = "usb-otg-vbus",
 	.ops = &mt6360_chg_otg_ops,
 	.owner = THIS_MODULE,
-- 
2.43.0



