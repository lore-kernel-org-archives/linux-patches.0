Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4BD32ABC0;
	Thu, 28 May 2026 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999222; cv=none; b=ho9gmTMAhBqXT88v6iJcSEri/eQ959IMotbqBalaQFHesxsu9tgJDi2BHhYNZXdbt4Li9R9n721tpPiOY7KFLQPalDmO5x5J8bQM8p6l5ZBOjBdUyUn9qwtTV60yS8f97liAFjgrEkO+sNRX13f+w80hdGKy54Cg0kO4qzf+1EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999222; c=relaxed/simple;
	bh=iDqJjgNQ1OxD10PIaTnuzHvo1zcW/enqaD3lk4iyp4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUEXxicqFY6xlPtApIMSSIWonnVD/4qYay+qQvIHvScwXllMtjNxD3Yzc3jJ9BeJoXeR8NXZO+w204vdzS328mDuYX8oxYB0/BVEeNLbXqhD+tEC0XJRLwtqIkQj6IR5DAQ/GuFjmSfu1P1qCbO3MeRqUxryRGnnouo7yWjMcHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ku3/Lmsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ku3/Lmsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FC81F000E9;
	Thu, 28 May 2026 20:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999221;
	bh=BL5qGMQMEBH0BIYMMnHcGRRqobYpst9+kbMSYKOWYs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ku3/LmspzeA1SU55Wvqf592cyuDqcjKTw2QE+9hyBru5+UP9uVG9mC2BBsdVG55KZ
	 HSYia2M9vohy+xXLvWlLFp/wUZJK00fBjD8r54qA/FKSIIp9zYBbViIjazhYlWiDMx
	 SOVMSowkGJ9GHZdUagWA85kepV+DP8r+oYEPWLdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhur Agrawal <madhur.agrawal@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 451/461] net: airoha: Disable GDM2 forwarding before configuring GDM2 loopback
Date: Thu, 28 May 2026 21:49:40 +0200
Message-ID: <20260528194700.596359400@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 985d4a55e64e43bd86eeb896b81ceba453301989 ]

Hw design requires to disable GDM2 forwarding before configuring GDM2
loopback in airoha_set_gdm2_loopback routine.

Fixes: 9cd451d414f6e ("net: airoha: Add loopback support for GDM2")
Tested-by: Madhur Agrawal <madhur.agrawal@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260520-airoha-disable-gdm2-fwd-v1-1-1eeea5dffc2f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 83882a8953d25..13f7433592866 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1781,11 +1781,8 @@ static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 	u32 val, pse_port, chan;
 	int src_port;
 
-	/* Forward the traffic to the proper GDM port */
-	pse_port = port->id == AIROHA_GDM3_IDX ? FE_PSE_PORT_GDM3
-					       : FE_PSE_PORT_GDM4;
 	airoha_set_gdm_port_fwd_cfg(eth, REG_GDM_FWD_CFG(AIROHA_GDM2_IDX),
-				    pse_port);
+				    FE_PSE_PORT_DROP);
 	airoha_fe_clear(eth, REG_GDM_FWD_CFG(AIROHA_GDM2_IDX),
 			GDM_STRIP_CRC_MASK);
 
@@ -1803,6 +1800,11 @@ static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 		      GDM_SHORT_LEN_MASK | GDM_LONG_LEN_MASK,
 		      FIELD_PREP(GDM_SHORT_LEN_MASK, 60) |
 		      FIELD_PREP(GDM_LONG_LEN_MASK, AIROHA_MAX_MTU));
+	/* Forward the traffic to the proper GDM port */
+	pse_port = port->id == AIROHA_GDM3_IDX ? FE_PSE_PORT_GDM3
+					       : FE_PSE_PORT_GDM4;
+	airoha_set_gdm_port_fwd_cfg(eth, REG_GDM_FWD_CFG(AIROHA_GDM2_IDX),
+				    pse_port);
 
 	/* Disable VIP and IFC for GDM2 */
 	airoha_fe_clear(eth, REG_FE_VIP_PORT_EN, BIT(AIROHA_GDM2_IDX));
-- 
2.53.0



