Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9012714B075;
	Wed,  5 Mar 2025 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197716; cv=none; b=NoceOF5vo5aeUxtgrFq810yY12yaeF8o4iyCTsCsLSXbFHA4PErQlaNg2xxg6v0nIC6ONgm1trsKRwVLdqsSytmEuRCRpVP1rej7pupoVP2GgPzVhr0dpCuFQG8FwB2pfDQbZR/SIa/7JC7tVP7r+33DQr/LGVP+p2yZIMsxm9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197716; c=relaxed/simple;
	bh=JY7Gij6oONr68iDEqLaeZM6zzV4op7qTYt/q8WwIt5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISWFM8UDcn02k+GXL2GnksIqTWlWjWLBFTnbn/duWIpTufOjjdH1UEzmL2FR3Og4et3qk1i9zLFOLfU+1KV4wKuBTUZoRW619XrxWEHLay9LFvYPDeHybdl9ROSqvAdvUTv8LT44cctyB52m/YImzyG1q8+7PrGA3koWF/HUrQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onnFM1o6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onnFM1o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D9DC4CEE0;
	Wed,  5 Mar 2025 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197716;
	bh=JY7Gij6oONr68iDEqLaeZM6zzV4op7qTYt/q8WwIt5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onnFM1o6rtacezmcrsRITpOpl8bVkKxkWx8R3wsWQGpRAnZBzlj6E0ntZeh6qhcg2
	 St+grdvQh5MfoBIIhWbUFwgkR96pBRzHR1rxXgzlCxpI7kOhJBCle3gW3hx3EPaU1J
	 Hz1uwyBa5+3nGsxVsLrqObyD8nqSfoyXaTlMESlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshal Chaudhari <hchaudhari@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/142] net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.
Date: Wed,  5 Mar 2025 18:47:42 +0100
Message-ID: <20250305174502.067828261@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 40aeaa7bd739f..d2757cc116139 100644
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



