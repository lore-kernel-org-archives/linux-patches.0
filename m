Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C12215060;
	Tue, 29 Apr 2025 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945871; cv=none; b=mIanifLeBBa6joc+7IaRnqKBLM1XViqYI6hIcE1Nh98FRLPcgAxJp2udsEnCaCAkC/FqttBK1FRkl0e6qIWEw64jteGj1Fwh4HGNJGsA3FaEyRibtlt8lNi3LpkwNSZN30Me5QZPwqV3HzryU4mLcPBaUosr9AHJ14XvBmQMnSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945871; c=relaxed/simple;
	bh=yH5jyFac9R5/mgr3sKwhkKjKcHnlt3Uqq1aXgTRuRNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7yOQhL3MiHK9Y4nnkrNAPLLpSn/KrWED7DWXesqITBPeUGW/uJQZxYUOog9qq+kVJCKVSTZgjJgEDKJU9Kh0Aa4tHSEhB6XyM1km37u9uZWfDNpko5s0hI3UoWdCJ9yiGPLaU0BbTZic6LDfLB7vENix7mYxBR0RQgdkcyUmbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLDxw+gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLDxw+gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F9FC4CEE9;
	Tue, 29 Apr 2025 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945871;
	bh=yH5jyFac9R5/mgr3sKwhkKjKcHnlt3Uqq1aXgTRuRNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLDxw+gspCMo/IZFW1RSGzWF+HmH0s0BTT4u+FRVBLcC1of4HjO3fYIpAwYqgH5KT
	 s2a0xKkmUCam35yCyHYZOqmx+YkFd6Jfg9F5SVH9ZH6tCE5W+H9pOnRKUbd64OmLRC
	 l2dY/mwSs8Di/b/Tjax6QCsZkpIjJNVWY6mzPLxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Schneider <johannes.schneider@leica-geosystems.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 077/311] net: dp83822: Fix OF_MDIO config check
Date: Tue, 29 Apr 2025 18:38:34 +0200
Message-ID: <20250429161124.199064759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Schneider <johannes.schneider@leica-geosystems.com>

[ Upstream commit 607b310ada5ef4c738f9dffc758a62a9d309b084 ]

When CONFIG_OF_MDIO is set to be a module the code block is not
compiled. Use the IS_ENABLED macro that checks for both built in as
well as module.

Fixes: 5dc39fd5ef35 ("net: phy: DP83822: Add ability to advertise Fiber connection")
Signed-off-by: Johannes Schneider <johannes.schneider@leica-geosystems.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250423044724.1284492-1-johannes.schneider@leica-geosystems.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 3662f3905d5ad..89094aa6dbbdb 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -730,7 +730,7 @@ static int dp83822_phy_reset(struct phy_device *phydev)
 	return phydev->drv->config_init(phydev);
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 static const u32 tx_amplitude_100base_tx_gain[] = {
 	80, 82, 83, 85, 87, 88, 90, 92,
 	93, 95, 97, 98, 100, 102, 103, 105,
-- 
2.39.5



