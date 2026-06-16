Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694F23CC324;
	Tue, 16 Jun 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633440; cv=none; b=dWX4p1zjnRLQi8YQuSzQ3xTBIGq7BwsAVFIPUelnIhuHXO3Po2bredeXe+omnsr/8xKtnyre36VfOZkR8npu1SxSPoZTW2RdxdxSN9HJTOz7JqPjc4n/4X0B1fBU4HRzC0nuZ8oLfjdDRsPQaEb1dfe0EyrXcO0BW9Y0r1JrJnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633440; c=relaxed/simple;
	bh=xQKueE7G+y7uDaOIIwnr/tspvu3/zVUG5SAtHgTFshU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC9yyvon0MdFr/TvQj5gAMGJh8MNDyLrDKuEl1dWjRNNe5jRwKfvSC0CTsE0t09D8/Zk08DXUN7yJUVMfeiiZ44k/l1vs8kdhCzTXfYzBUn0+mKEYWkxc9IUkgRBd73podxR6EVWBw27rDrZOnKHTvrvpWjm5s0KHrfj0xczBtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5JU+6Tj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5JU+6Tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBEC1F000E9;
	Tue, 16 Jun 2026 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633439;
	bh=ZlsXvBlXee97jWErTmGOI6MRNoEyZCGnX3AJKW0O2R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5JU+6Tj0JEXYYP8TlX7QmmJi2N4OE2e+QMn2koLrkCBtI/u6O+XELq270ccgP7CT
	 NhG++wljvj5TkdVLsJhsJgOENp8sVX3HQYbuHKNnmSCLEQ4Ugku70JZ+orE7j9fUMm
	 SadQ49ctpj5AWv6z8GLqL9r622pxVR4xcdFO8Ec0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini Katakam <harini.katakam@amd.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/411] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
Date: Tue, 16 Jun 2026 20:24:50 +0530
Message-ID: <20260616145103.048205136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index acc9e1a2663143..a33e877a4cd151 100644
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



