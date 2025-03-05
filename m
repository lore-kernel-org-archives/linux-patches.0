Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2E51C6FFE;
	Wed,  5 Mar 2025 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197430; cv=none; b=ZgJHJe0TbfFB2mSpSDJKM+XFM28xvq8++2DP4rI/74klezsJTjjLUP9dX7Mg0OoYzyvDJf+3Ze8AyQJJZDoNibwTIKYwKchfSZQNTJc7x+CE3g4OxkFlQSgxKkFqDLhFpGWg7hf4j+uMeEHASGBw+En0l6zTPdXerbhgVZ5K48s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197430; c=relaxed/simple;
	bh=861LZS6JdnEbB1CeUTfiY+2srzoDTfAEXQM+o5+/E/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivic7ZjHpR4Ch94DHQ9ObCmgv7ZrMZ5SXPoBSWX+8DYY4AlHElK630nVcvFVuSP6yBsbpjtuvuBptbbeQD/d2yXxXL+gJNXzRndep8iHYOzbYi6OQxky6Rj+JRU9lMpG9VAkaw+624PL9r2ZWy7Lssy/51DIaIloluJW3Pm74qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07sXOU2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07sXOU2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FD6C4CED1;
	Wed,  5 Mar 2025 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197430;
	bh=861LZS6JdnEbB1CeUTfiY+2srzoDTfAEXQM+o5+/E/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07sXOU2fCNZ4Pl2gu5jULl6iflsSAW9bMe1bmdzV6lqQKiXmOUklNS2Fer+Izi8Aw
	 g67yFDmBlZ3tvB/2kks2iatA77/Ks3sy5mfNwgYOdVuNf+SGfy58iBkFDUHojgpWei
	 tmMIlw+lLE1VlN7Md/VYpQtc2EP0mUmdgx69TQ/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshal Chaudhari <hchaudhari@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/176] net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.
Date: Wed,  5 Mar 2025 18:48:25 +0100
Message-ID: <20250305174510.904982274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



