Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C9478E26;
	Tue, 16 Jun 2026 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630684; cv=none; b=SbzOrt/bV+j0Ywl/leZqb5Ot33A69zJ1ylm6aZXVfd1fucs45sDb7n9jYf9LszCN1/ZOKeDvbIew1cP4QCxooFCUsy3h0lzTu0clak/dL2K9j0d9tTxsr8/rjYqik5JTWQDm5yRXmzllqsZHkRhXrjCfXBGdioTm8/nG3g5PnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630684; c=relaxed/simple;
	bh=5rOGyOjGKr0e9muRsLHdfD3z0bxmkWMAvsyyS6eRvY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNCi9CVwdB6C1UZVkLnI8OhxKnM9pUDwfG9PAY8pbHgGxmOMYZ5LeOG+NVIOLhVQ3ggRn+aidVxtMMF2dG/Is6OI9u2Gb/20OU4tQhgeGqSbc8hJcYASUkf1nLz/vFNJ8CD6x0XVBIlHv3ek82DQuauwU3RDH1wZs2Ryl9CknrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gd+OUBxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gd+OUBxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E2A1F000E9;
	Tue, 16 Jun 2026 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630683;
	bh=3kdt+7MQX/usK+aWmKho+bJaflraJ0A2ZeulKs3lQ+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gd+OUBxBt7dG8KduvbPne9/fF1S0OOp1E8y2XDwmNIQg/1GdtreiaDS2PCzt2N8rc
	 xnXX+Z6th8Q0HPUKSZOdYeqkN9mv045OTTK1RHLIx+hy8THAHvvca9EQafBSH2yhaZ
	 LdClStIS+BzolOdrs5SNNBXrUQuWAx397uRomMyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harini.katakam@amd.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/522] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
Date: Tue, 16 Jun 2026 20:23:44 +0530
Message-ID: <20260616145129.447910333@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini Katakam <harini.katakam@amd.com>

[ Upstream commit 31605c01fb242806f5b8c9d08abe11328d514206 ]

All the PHY devices variants specified have the same mask and
hence can be simplified to one vendor look up for 0x00070400.
Any individual config can be identified by PHY_ID_MATCH_EXACT
in the respective structure.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1bc80d673087 ("phy: mscc: Use PHY_ID_MATCH_EXACT for VSC8584, VSC8582, VSC8575, VSC856X")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 15 +--------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index fcfbff691b3c6b..4a9c12516f2057 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -291,6 +291,7 @@ enum rgmii_clock_delay {
 #define PHY_ID_VSC8575			  0x000707d0
 #define PHY_ID_VSC8582			  0x000707b0
 #define PHY_ID_VSC8584			  0x000707c0
+#define PHY_VENDOR_MSCC			0x00070400
 
 #define MSCC_VDDMAC_1500		  1500
 #define MSCC_VDDMAC_1800		  1800
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index d9ad8aac580982..dd3b102fb4eec9 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2676,20 +2676,7 @@ static struct phy_driver vsc85xx_driver[] = {
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
-	{ PHY_ID_VSC8502, 0xfffffff0, },
-	{ PHY_ID_VSC8504, 0xfffffff0, },
-	{ PHY_ID_VSC8514, 0xfffffff0, },
-	{ PHY_ID_VSC8530, 0xfffffff0, },
-	{ PHY_ID_VSC8531, 0xfffffff0, },
-	{ PHY_ID_VSC8540, 0xfffffff0, },
-	{ PHY_ID_VSC8541, 0xfffffff0, },
-	{ PHY_ID_VSC8552, 0xfffffff0, },
-	{ PHY_ID_VSC856X, 0xfffffff0, },
-	{ PHY_ID_VSC8572, 0xfffffff0, },
-	{ PHY_ID_VSC8574, 0xfffffff0, },
-	{ PHY_ID_VSC8575, 0xfffffff0, },
-	{ PHY_ID_VSC8582, 0xfffffff0, },
-	{ PHY_ID_VSC8584, 0xfffffff0, },
+	{ PHY_ID_MATCH_VENDOR(PHY_VENDOR_MSCC) },
 	{ }
 };
 
-- 
2.53.0



