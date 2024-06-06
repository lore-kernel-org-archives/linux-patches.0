Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4C91A189D;
	Thu,  6 Jun 2024 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683732; cv=none; b=gTOAKk7mRvQa+H2oPMSyi62NYqtcOJ5Z5RIZVcJSULebR8lIbfr58O29jaSk/sEz6myUmGc6yWKKVx1m+OnvDGXJxZu6WhGbjngfK9fl8s4e+6wllfRq2LKUITLJzedY3RxIboQP2OXrz8lZcltv2dOrCbBtNJgn45Ba5GCSbKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683732; c=relaxed/simple;
	bh=Us8bgby8y7fRqEaPh44fGkCxI1eD11Rv5LM0QmwV75E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv3oXYfzR0gSL/m+M0LjgQ0E5kEphCV9HsbEcqb527i5qsEO0avwlojnLkeMI+BlFyxaHZFxJT4jLpLCFjMmSOS/dl4FH6ql2kB3lVMzNeRkivuWMWtP+4Q5AOpbUIjYPzhWrlSZ8wX5woDg06PN4/gQ2EtwaB6FbP2vfKoHfG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdeA7QFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdeA7QFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40673C2BD10;
	Thu,  6 Jun 2024 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683732;
	bh=Us8bgby8y7fRqEaPh44fGkCxI1eD11Rv5LM0QmwV75E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdeA7QFMDFwB1Shk1GDgOgOBtW3TQQivK5JjGgAHEmTbxG/R9I++qeqMPtlNLYzgi
	 3s1/YS7XyoD1uFHy1xcX5Han/+8lQXqxfxtCGB+3Rc0koKDOCqf01LiukEYZBbOYxN
	 LCiDOL2v31wz3/5q5q7ouUfFAVimzKKXlmiidcpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karim Ben Houcine <karim.benhoucine@landisgyr.com>,
	Mathieu Othacehe <othacehe@gnu.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 684/744] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061
Date: Thu,  6 Jun 2024 16:05:56 +0200
Message-ID: <20240606131754.426611818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Mathieu Othacehe <othacehe@gnu.org>

[ Upstream commit 128d54fbcb14b8717ecf596d3dbded327b9980b3 ]

Following a similar reinstate for the KSZ8081 and KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

The KSZ8061 errata described here:
https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8061-Errata-DS80000688B.pdf
and worked around with 232ba3a51c ("net: phy: Micrel KSZ8061: link failure after cable connect")
is back again without this soft reset.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Tested-by: Karim Ben Houcine <karim.benhoucine@landisgyr.com>
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 538a5f59d7a73..e4c06336bd254 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4750,6 +4750,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.probe		= kszphy_probe,
 	.config_init	= ksz8061_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= kszphy_suspend,
-- 
2.43.0



