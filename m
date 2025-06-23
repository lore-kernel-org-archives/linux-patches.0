Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A0521CA07;
	Mon, 23 Jun 2025 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713128; cv=none; b=OHe4VGB5UGn4lqeoTBX727NjKflego+XoAyNJzkYQwOm6E4IdUUeB2J7GOens36K/XwWBsTEFQ1iBrF5qMcJCuzNStv05UgdHLz6RoCBUHWEDTbmi/e2oQt3No5W0DZbiN5Qv7/pgChLWogI9edgkf2rj+sr1Jl8bPpqdbvjmtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713128; c=relaxed/simple;
	bh=fYGkASWHmz4eRBMhiZAIfsay2O6EXUnmyIi2sT8crco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qofc5gVBIQH9kcJqzUPcgqbxYLYtxK9REeijLlWrS6P+n+V5viJcPbd9/SpKu9VEiPrvk4LCjAyIbpalJ7cbTgGhAIRa+fPHBvja9zrWzgqaJzzxQ1McHK8YlCn8LHWR76rNvsM31zB7QLQDnUpAvn1oc05EcW0A12QILPLxGrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keAmi02p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keAmi02p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5227C4CEED;
	Mon, 23 Jun 2025 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713128;
	bh=fYGkASWHmz4eRBMhiZAIfsay2O6EXUnmyIi2sT8crco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keAmi02p6oBuoSuYgohWbceb7Sbyvlxt6mOYlfK01GbT3f2XGre/GHpWGhkm7FWLS
	 PwE8NhOQITB7y9QcWB1e655r8S0N5ujS3OfXCGfbJZCcIdgYQ/lG5yk4rrZIJORyHy
	 s7qQc7Hkixeq0BnWhVnv49tu0tma1xOqRYLSQ9DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/508] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Mon, 23 Jun 2025 15:02:24 +0200
Message-ID: <20250623130647.709319965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit 68927eb52d0af04863584930db06075d2610e194 ]

rename the function to lan743x_hw_reset_phy to better describe it
operation.

Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250526053048.287095-2-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index fd35554191793..0f456d389e53a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1389,7 +1389,7 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 }
 
 /* PHY */
-static int lan743x_phy_reset(struct lan743x_adapter *adapter)
+static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 {
 	u32 data;
 
@@ -1423,7 +1423,7 @@ static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
 
 static int lan743x_phy_init(struct lan743x_adapter *adapter)
 {
-	return lan743x_phy_reset(adapter);
+	return lan743x_hw_reset_phy(adapter);
 }
 
 static void lan743x_phy_link_status_change(struct net_device *netdev)
-- 
2.39.5



