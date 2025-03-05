Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1172F2528E4;
	Wed,  5 Mar 2025 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198519; cv=none; b=k1TKF6Pm88Mp/Li6k++Xvs6l5Z2gBeGN+fApKiLEN6qIjY7yzHpn8Niqjzq12euc2fEWTRrnzRbQ3QCYgd1t+2CUOfRGZ7wlKZJJdi9bzVw2RkvZmmcrVZWjrJU4UQpMiGDpfQqLnmoctSa83lWhRmwIvlUOBxpOmxLg63cKxko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198519; c=relaxed/simple;
	bh=El3Qs6pMR1AUFqcKTarbY3YVr+t96p4WzwP0MDABzPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHMVPE1FSzxEhrhUrA09Swe+jfqrI/ohqKqFQSX8EStq767o/H37sYansaQ+OAcI/8A0BcJb5PwHWRLk9fSMpVAyGATwaqP417d7v3/dhcYD7jupBwUbe1UTl7+a0D6nmyEXiXjBp1jyMrGFC1M0x2D5ivWuvtVOXvHsivzY3QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBujZA5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBujZA5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C9CC4CED1;
	Wed,  5 Mar 2025 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198518;
	bh=El3Qs6pMR1AUFqcKTarbY3YVr+t96p4WzwP0MDABzPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBujZA5EguuoN3Xx0j2UFgiWF0uFqpp7ibpLgt3Xcp4kcSztDDzDYLv9Ic2Tx44zb
	 WeNSFK9vewuvsA9EFeCR0vhplAbjfrt3NXeaBsCV3nx4a9e46bT/ChBNUjPPq1e8g2
	 fpxXQdUA3hab67JBubMcWetWyupviENhQe0Snihk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshal Chaudhari <hchaudhari@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 054/157] net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.
Date: Wed,  5 Mar 2025 18:48:10 +0100
Message-ID: <20250305174507.478881858@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshal Chaudhari <hchaudhari@marvell.com>

[ Upstream commit 2d253726ff7106b39a44483b6864398bba8a2f74 ]

Non IP flow, with vlan tag not working as expected while
running below command for vlan-priority. fixed that.

ethtool -N eth1 flow-type ether vlan 0x8000 vlan-mask 0x1fff action 0 loc 0

Fixes: 1274daede3ef ("net: mvpp2: cls: Add steering based on vlan Id and priority.")
Signed-off-by: Harshal Chaudhari <hchaudhari@marvell.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250225042058.2643838-1-hchaudhari@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 1641791a2d5b4..8ed83fb988624 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -324,7 +324,7 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 		       MVPP2_PRS_RI_VLAN_MASK),
 	/* Non IP flow, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_ETHERNET, MVPP2_FL_NON_IP_TAG,
-		       MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_TAGGED,
 		       0, 0),
 };
 
-- 
2.39.5



