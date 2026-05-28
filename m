Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C1DDC5;
	Thu, 28 May 2026 20:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000043; cv=none; b=g0QasbsyYNzqq2qvBkFgE1WDVOPeeR0JN2LCdntoQYDGn8uTU2JTiWohqJ6XvS0tpIGX8r99LSSE/TG55vai3oYhJ/Be8dutpq2oB3BPx8IZ3VaDp/uVJfrKZBQXFMb7z0zWQlfPQkCZeVY86Uh1CC4Fas6IjvJb6zHAM4TYAHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000043; c=relaxed/simple;
	bh=7/jr0e3ahOqLrq7T6JbriBJSZm/CPUcx4FdAWZChlI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF+JvMhDriqCIxGQclBWM04WEealF3djzZ0XzUvhiRHTngiVCCXEd/ZjNdw6BuzVYwDI9npzCD6zQCRIRa8QWJ54l0E9mnMZrbzVxlmEX8wM3EPVmCxq+6s5q3mjP4yf/I1Tr+7IiYH6qxBfGT9VDS5/YoJk6cfqrvMTfyYaTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrIzvadj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrIzvadj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D5E1F000E9;
	Thu, 28 May 2026 20:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000042;
	bh=gYAlu23n8Fx8mtmLMY5wgagv8Du/+SIOdhbLTcStgQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrIzvadjRd6VzeK9MtHrEfbG7/rTu3HUXAq/OtMvQ42vbW4lnOVEJ5kX3Tz9ivEoK
	 O7HFhS/MVe7DTS1lvA5eE/g5Ee7rtp69yz1xwXlYRmVxJp5ScXe2NZRjl0W9nT7MCm
	 U3S0keauW2ByVz2kDJYBwEchuWqkVzMR7W4AXf0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 283/377] net: phy: DP83TC811: add reading of abilities
Date: Thu, 28 May 2026 21:48:41 +0200
Message-ID: <20260528194646.549462372@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



