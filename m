Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA572882AB;
	Sat, 12 Sep 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230995; cv=none; b=tmJc4lsOWLsDNcGL8xEr1DKF/nzCZPuI+uFgrTUeVnnb+07xgeSV0LwcXSsKqsplUadCZyWmzNYv7N1Qfn9wqJP1YwSWsegHrecYosqP1M2429cwK7NthAIodSwZFqF3ChdXAMSA9bqbEJhyIsByIYPHMZoQWzeruUF3WKYYEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230995; c=relaxed/simple;
	bh=mAbXHUmMK+u3npl06Oe7sSN75QSiiBfUXRErY4Obqak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngkyogCX/cgROFZWetk5qdU7fzkPK7pcKNUXfScEuC4m5bNSE8rvrjawTcyleyUeCCz7eFvn5CfZZc7AJtscI3i1D54nOyJivWHQhNMtfDr711DlooJJwHfubFqzq6i2gEW3u7Nw/+/64kM2U7TQJg58oBqEeNAsvsKLCEmcG6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I54hZBdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I54hZBdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFE51F000FF;
	Sat, 12 Sep 2026 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230994;
	bh=BAAtzmNbN8xBEXAGcyV6EggW70Tr5v0DHwDmRnmxTIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I54hZBdYFkYbg2v4s+ZnuDU0qLdm+o5IUZZ4llZ0Y6FlrVMk7GdrmoGgXGsJl68C5
	 v2EY9om8XXNo47hq2nNA5xaChzXlxdA3GKrVoRvIXvLiDPYE59RvgdulmV/kciX+/y
	 wFQfGCviYx3SDTxaj/EdyklOCHuk/wocoItkxy+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Gerald Loacker <gerald.loacker@wolfvision.net>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0907/1191] phy: rockchip: phy-rockchip-inno-csidphy: fix rk1808 hsfreq table
Date: Sat, 12 Sep 2026 09:00:35 +0200
Message-ID: <20260912065608.604701980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 20737a0400f5c..2ea3150f38312 100644
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



