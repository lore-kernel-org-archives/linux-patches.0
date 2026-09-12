Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1017F78C9C;
	Sat, 12 Sep 2026 12:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217438; cv=none; b=ea5O1gT1Crwnz+5hDuaX00GieDNJlkIib8XEWBpcwEbEmdrTJyyJtIWK+JIVQJh/ckIEoqkFtogXClTTUWewd/F6OvzSperOtehKM676mslXlSGH3tOi/OIsIfJt6GeE3XaFAZ+173QcrzOlp3xolRx5dI7n/ulArybBMEsraYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217438; c=relaxed/simple;
	bh=Zxsv5cOAgwIhO44c9IC8LjQHMMacX6fXcHuyfT9LpME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZAxFWexzfY81YnxGNglo8miTw+U/8v1/LDL5ulL8CtmS5k/ZNFxxu3v9aFm3yotH+foZrw3kwmzDKU3NMtJcGv8VlP3ga7cxTgFuDWOVQIAIMAcOiZh4Q8OXD5qpxHyKWmw0sPQxDblwRfHsvyw3w6XaDkL+sA973nySwAe9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiRS5uH6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiRS5uH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41431F000FF;
	Sat, 12 Sep 2026 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217434;
	bh=mf6Wgj7hUzxscQTais3Bsr9PvgOQFIn3CFs77PIetns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiRS5uH6ftIKVVgntXvbdZuR26cvyboRU958yy6NB/wk6NfpQ2AANrqE/ikFFv4Xe
	 ZKBD1EXcsUigwclVKCL2Ml/qztRgyOK0z6h42TnzxrL9PO2XfXvbNHwg1h+mEFXVwi
	 UhT+fYWLimQ1z07hu4thizEJss3xVdkbyOEAm1tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Gerald Loacker <gerald.loacker@wolfvision.net>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0941/1376] phy: rockchip: phy-rockchip-inno-csidphy: fix rk1808 hsfreq table
Date: Sat, 12 Sep 2026 08:56:07 +0200
Message-ID: <20260912065628.532135911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Loacker <gerald.loacker@wolfvision.net>

[ Upstream commit 4fae43e33a7c10951fbdc6baf409d51bd66aaefb ]

The rk1808 hsfreq table capped at 2499 Mbps, preventing a data rate of
exactly 2500 Mbps. Extend the final entry to 2500 Mbps to support this
rate.

This is essential for RK3588 reusing this array and fully supporting
rates up to 2500 Mbps.

Fixes: bd1f775d6027 ("phy/rockchip: add Innosilicon-based CSI dphy")
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Signed-off-by: Gerald Loacker <gerald.loacker@wolfvision.net>
Link: https://patch.msgid.link/20260725-feature-mipi-csi-dphy-4k60-v4-1-5b2c4626d31e@wolfvision.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
index 279e19e7546b6..2c1f8e3645df1 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
@@ -157,7 +157,7 @@ static const struct hsfreq_range rk1808_mipidphy_hsfreq_ranges[] = {
 	{ 299, 0x06}, { 399, 0x08}, { 499, 0x0b}, { 599, 0x0e},
 	{ 699, 0x10}, { 799, 0x12}, { 999, 0x16}, {1199, 0x1e},
 	{1399, 0x23}, {1599, 0x2d}, {1799, 0x32}, {1999, 0x37},
-	{2199, 0x3c}, {2399, 0x41}, {2499, 0x46}
+	{2199, 0x3c}, {2399, 0x41}, {2500, 0x46}
 };
 
 static const struct hsfreq_range rk3326_mipidphy_hsfreq_ranges[] = {
-- 
2.53.0



