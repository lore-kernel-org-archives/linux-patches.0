Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D735A924;
	Wed,  3 Dec 2025 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781009; cv=none; b=TaCtw7adgbAq0Pp1L7kvNyQxEny8Rj9DMChleu/Rdx8kicqgTaNQg7zKaziAKIOzrPm/ALFUhc3kW/ZU/e+U7QUvRsS+JkynTaHTo4GyyqnDwHmjzN0R2mnvDvrEwMwTenwNzds7b2ueZaC1H4wGLBP+BQPIMVl0nXntEz/6sG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781009; c=relaxed/simple;
	bh=DWkvslaMu2IrQKr8Uuu/0BkkELV1RRpo7WCOcIHuAMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpOJWQRcmXsvQq66zqe1Im5Bsx5u3XLgs+rgff2g6vTt+36J8F8veJfAsJozzC1EHM7CzUTSQCSJPR8jneYypWyJJT+2OCXvaF/XbXIxDGrVRE4K5x4RbWHzS4rvdEE7YbkBTUpzkhSS3F2mmuM9tC2pPX0NtcNMFie00CNZUn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW8qi/6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW8qi/6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F144EC4CEF5;
	Wed,  3 Dec 2025 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781008;
	bh=DWkvslaMu2IrQKr8Uuu/0BkkELV1RRpo7WCOcIHuAMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bW8qi/6yachQ+tGNtdlmefwRTBaGOYTZLzRvB5qKQ3ibUEfSjlghJ/CyE7qjPHNqc
	 +TBbvSRiRSLZ9c65iVzihgbxryV2oQMQfScP169g4WH4e+85MGSz9O+/8vudS5oMhs
	 G69+5ahh0zWbSYk50tab/EXBuBzpAZ6rJzZMsZHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/93] net: phy: mxl-gpy: fix bogus error on USXGMII and integrated PHY
Date: Wed,  3 Dec 2025 16:29:00 +0100
Message-ID: <20251203152336.777051512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit ec3803b5917b6ff2f86ea965d0985c95d8a85119 ]

As the interface mode doesn't need to be updated on PHYs connected with
USXGMII and integrated PHYs, gpy_update_interface() should just return 0
in these cases rather than -EINVAL which has wrongly been introduced by
commit 7a495dde27ebc ("net: phy: mxl-gpy: Change gpy_update_interface()
function return type"), as this breaks support for those PHYs.

Fixes: 7a495dde27ebc ("net: phy: mxl-gpy: Change gpy_update_interface() function return type")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/f744f721a1fcc5e2e936428c62ff2c7d94d2a293.1763648168.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 034f5c4d03377..5868a0747097f 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -515,7 +515,7 @@ static int gpy_update_interface(struct phy_device *phydev)
 	/* Interface mode is fixed for USXGMII and integrated PHY */
 	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
 	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
-		return -EINVAL;
+		return 0;
 
 	/* Automatically switch SERDES interface between SGMII and 2500-BaseX
 	 * according to speed. Disable ANEG in 2500-BaseX mode.
-- 
2.51.0



