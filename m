Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B175409607;
	Thu, 28 May 2026 20:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998954; cv=none; b=hjB6doi3zFrq9JSz/766mVQhhuxuBY1E7lEjmqOdzZbRymPCTUZApKJY+iHtWUi9m1SjY/7+z1fWiYkQA9TGpldjZjEgkoQ64Nlv2nvsQbp4OUjHvwlCe/pNTyUx4InaFqwf5sIx4VljOi0sTBG9qb77HVpS95pWFLhKbOFCzhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998954; c=relaxed/simple;
	bh=sevlpKJeRMJKZYiii3UEcqm8K01PlsvOB1/nVtnFprE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJQZa4JamlAhNhLimUNwp2og29AqXaWhmcig94dRrm/zjU9e/rveJBZyzKD6rfnd1KPiv6MiGyfsm5632KTFwetJVP89LAOh7oH2nuCcQEBT/gz4Y+SMbNUEYhHuxJmvOVHaGUdcOKnFbhv9qkMBuM54VR0AYLflftS57E0MSFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUXlp1h/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUXlp1h/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0489C1F000E9;
	Thu, 28 May 2026 20:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998953;
	bh=DlTPAoYuzXaGQ8L0DK8l+Tdmjbt/rvRTt4jQ5PGTSqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUXlp1h/GTIlDlRJOlaxiOXurpE0gpOPqDXS8BOiNFx7rcqYbb6Ib79Ge+tyGSk8s
	 ARQ4oUGlCxxBoSQ488zSjHGkWnR6I+H2pu5UlT3//fm3CFjphXYPGmVOU6zc+eosfR
	 QYWa3ZQVBCYFHiXv61sBq+eIJ3ZrGpRS8H3I0wEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 319/461] net: phy: DP83TC811: add reading of abilities
Date: Thu, 28 May 2026 21:47:28 +0200
Message-ID: <20260528194656.543971122@linuxfoundation.org>
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
index e480c2a074505..252fb12b3e68e 100644
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



