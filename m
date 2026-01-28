Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92E302779;
	Wed, 28 Jan 2026 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615624; cv=none; b=VKwtN1KoQ8gfM5xaPLLYnUgw+qHwpB5GI8MPCRzoBn6CslT6k17JBsUgKdEFMyEl4PzD+xmE9svxHVNSSdaha4i1fzyHa8U9CC+li9qqEQjejgBYOGnPqLP9bYTk7EH5nUvZoBARTXVPa152jaj27fo0+x4XY82uMYoH+2dlm3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615624; c=relaxed/simple;
	bh=VqBIQMzAj7O5GuUWa9ygPWz9usQ8+ZncKNHxM3ZVLro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQrA3upWQtNzNCwNn4UEaXnRWS4E3RBL1Pqorp+ZekVnkwOMAVq9BOdp3LTg1WEwjJcY3fn3ygXpGMYS2jaJR2wNvqY5VtMm9YJTfhvl/4oJ1plq9jh7yKx9ln0LrIV1IGlVbd3fP0sCCcIh+Y9pb4u550JtPtE0CUVeb+xZc+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuHd3yz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuHd3yz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BB1C4CEF7;
	Wed, 28 Jan 2026 15:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615624;
	bh=VqBIQMzAj7O5GuUWa9ygPWz9usQ8+ZncKNHxM3ZVLro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuHd3yz5qh1r9mI3YEbgpcdTirpSbxqH4WDcT6VARTLPWsYfdjiG7X/nt+ByEX1Os
	 LK5TmpzAyL+1k6px5BxT28tovuaRXcon1ggZ4nxTNxeciEyes9Hzr2FE9S8rqRosVx
	 rMhZJzO6mO+pOvU9+0h5Wn08/eCREADm6jb3Wjwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/227] net: freescale: ucc_geth: Return early when TBI PHY cant be found
Date: Wed, 28 Jan 2026 16:21:17 +0100
Message-ID: <20260128145345.500272301@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit a74c7a58ca2ca1cbb93f4c01421cf24b8642b962 ]

In ucc_geth's .mac_config(), we configure the TBI Serdes block represented by a
struct phy_device that we get from firmware.

While porting to phylink, a check was missed to make sure we don't try
to access the TBI PHY if we can't get it. Let's add it and return early
in case of error

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601130843.rFGNXA5a-lkp@intel.com/
Fixes: 53036aa8d031 ("net: freescale: ucc_geth: phylink conversion")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260114080247.366252-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index affd5a6c44e7b..131d1210dc4a8 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -1602,8 +1602,10 @@ static void ugeth_mac_config(struct phylink_config *config, unsigned int mode,
 			pr_warn("TBI mode requires that the device tree specify a tbi-handle\n");
 
 		tbiphy = of_phy_find_device(ug_info->tbi_node);
-		if (!tbiphy)
+		if (!tbiphy) {
 			pr_warn("Could not get TBI device\n");
+			return;
+		}
 
 		value = phy_read(tbiphy, ENET_TBI_MII_CR);
 		value &= ~0x1000;	/* Turn off autonegotiation */
-- 
2.51.0



