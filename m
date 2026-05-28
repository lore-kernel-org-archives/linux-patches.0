Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D9F2F1FEF;
	Thu, 28 May 2026 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001569; cv=none; b=uXnhN3hdfRXhMY/hGsQ68Kyi8NlLVYYPDm3XG1dKSqMBrp5C28/pzgYUDiK8grGzVmgciirfBROmmGKG1sh1j3qVmrhbyTb/nykK1m5OnBCaqxAFDEv57SDjAR63YdM4O1yjcXWHykuDF/CWd9I+JE+66/0YBHS4HJmyDyZSNE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001569; c=relaxed/simple;
	bh=CmCuYzUFQY7jV/L9MgEW2eD4k8mulQZdUaSUlxPXlu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSLeZjR/pPELgYfiFBFxph6tvJavCKP8Frb4Xfw8RxQVUhhLyuFNBC1pmkX2v1S7DnziU2hHO6AWNMyF0KCsntimEmS1EIBpZzZpDasyDyveniGbLSyoCdoX0TFbldLNOiWyl3j9w+mJB3YmxtTscj54DbLj823u9acaTqSK3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7NeBMqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7NeBMqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929511F000E9;
	Thu, 28 May 2026 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001568;
	bh=3PLEm6MYg8I1AZoanLJ27mdoE0ovo//v24HOnWkOv1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7NeBMqOFybDtaT5XbUeoGpsVW4QVMbju5NaCpqo1EDTxV5Pu5cm6oe4oixTsJBrD
	 j/pcL4z4dmoxGpKZ93xvppWZgObm36I4qrzO+fKNSBda+tAvkqGYLbTk3jVL2out6a
	 p8nzKbYDcjMaSpIO1qv7oDyHHLQmSwRAgyYt2GO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/186] net: phy: DP83TC811: add reading of abilities
Date: Thu, 28 May 2026 21:50:27 +0200
Message-ID: <20260528194932.923449984@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Sven Schuchmann <schuchmann@schleissheimer.de>

[ Upstream commit c78bdba7b9666020c0832150a4fc4c0aebc7c6ac ]

At this time the driver is not listing any speeds
it supports. This should be ETHTOOL_LINK_MODE_100baseT1_Full_BIT
for DP83TC811. Add the missing call for phylib to read the abilities.

Fixes: b753a9faaf9a ("net: phy: DP83TC811: Introduce support for the DP83TC811 phy")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260512071949.6218-1-schuchmann@schleissheimer.de
[pabeni@redhat.com: dropped revision history]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83tc811.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 7ea32fb77190c..5425a95352f9f 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -393,6 +393,7 @@ static struct phy_driver dp83811_driver[] = {
 		.config_init = dp83811_config_init,
 		.config_aneg = dp83811_config_aneg,
 		.soft_reset = dp83811_phy_reset,
+		.get_features = genphy_c45_pma_read_ext_abilities,
 		.get_wol = dp83811_get_wol,
 		.set_wol = dp83811_set_wol,
 		.config_intr = dp83811_config_intr,
-- 
2.53.0



