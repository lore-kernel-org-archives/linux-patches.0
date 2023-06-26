Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B3F14A9E
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AADC433C0;
	Mon, 26 Jun 2023 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804327;
	bh=B+Z9ziGShRXR14vlnJ4PvGPJlwLyKL+nA2/bnQL2dqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2i5so1WvFVZ3QwGGsZRj11GgzrUS/sdS3M0PVrvS9xLnRjpSMcfJc4iPlt8Mn/eCq
	 ktL7s6nOD45bvdqHkZ2d1oGNpSezfukwtqDGBaOyPksDDAIlPAHQTm5H6j4DTRInYl
	 Tn8jNy72G/8jv2Ynz1+orgupSXIWqZ2VSN75g1Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/170] Revert "net: phy: dp83867: perform soft reset and retain established link"
Date: Mon, 26 Jun 2023 20:11:28 +0200
Message-ID: <20230626180805.906405438@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit a129b41fe0a8b4da828c46b10f5244ca07a3fec3 ]

This reverts commit da9ef50f545f86ffe6ff786174d26500c4db737a.

This fixes a regression in which the link would come up, but no
communication was possible.

The reverted commit was also removing a comment about
DP83867_PHYCR_FORCE_LINK_GOOD, this is not added back in this commits
since it seems that this is unrelated to the original code change.

Closes: https://lore.kernel.org/all/ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com/
Fixes: da9ef50f545f ("net: phy: dp83867: perform soft reset and retain established link")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Praneeth Bajjuri <praneeth@ti.com>
Link: https://lore.kernel.org/r/20230619154435.355485-1-francesco@dolcini.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 14990f8462ae3..f7436191fa807 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -905,7 +905,7 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESET);
 	if (err < 0)
 		return err;
 
-- 
2.39.2



