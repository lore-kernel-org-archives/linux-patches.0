Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2FC6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61796C433EF;
	Mon,  3 Apr 2023 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533226;
	bh=XqCYsBqcdS3JoSuA8/wHHStjQJ0Lc+gJQ3obvfy4Esw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fqzqrx3oaQjJYkV3o/KwnWsusszvm2Rmbj09Tjc1tUcjbRYbgSqApNVwVPaQNr2z
	 908BKR4dlM5YHqaPTtrjb9QdYlRqVcBKZN/a/puSPVAz5Zb8huGcATDSIprk6JDIGw
	 FxbMNBmbjSI9+vuT8+DhBacDTbW/ZBpJ4P/EhY9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Auhagen <sven.auhagen@voleatech.de>,
	Marcin Wojtas <mw@semihalf.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 102/187] net: mvpp2: parser fix QinQ
Date: Mon,  3 Apr 2023 16:09:07 +0200
Message-Id: <20230403140419.334614097@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit a587a84813b90372cb0a7565e201a4075da67919 ]

The mvpp2 parser entry for QinQ has the inner and outer VLAN
in the wrong order.
Fix the problem by swapping them.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 75ba57bd1d46d..ed8be396428b9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1539,8 +1539,8 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (!priv->prs_double_vlans)
 		return -ENOMEM;
 
-	/* Double VLAN: 0x8100, 0x88A8 */
-	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021Q, ETH_P_8021AD,
+	/* Double VLAN: 0x88A8, 0x8100 */
+	err = mvpp2_prs_double_vlan_add(priv, ETH_P_8021AD, ETH_P_8021Q,
 					MVPP2_PRS_PORT_MASK);
 	if (err)
 		return err;
-- 
2.39.2



