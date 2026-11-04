Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830861;
	b=REFrMcQb7HHjxu/IbeDGxQ80hyPyHKMEGVXrR+DakPERBwvI5YJUZ/qIYU3pNn5o4cRb
	 by7/eXqocBnqKjVDdoNnw3S31DWaBxixtGU214twZyTXm2BQv89F5Y9lR6gt/BvjSICXI
	 USr1TwaWfogFzG6YA42dLf1wborhWUxZV6v/5pT7thEq0dU3PIIn/cN1DMZMMs3lnvEtk
	 VGnLILaD66ocVwrvRAm9KJmtbPWcmtf5lHIV0ZtM2XO6EcqzOqflspu67kZZx9J9T9M5G
	 65iS1Dqr49iv+C6p4/sZUZgCkw2DHqHhW7tjtPRt8sgph/PWzwNLlVdLSPxKCo4T+NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jtoi5gq29+ouITrLOFPUfQqtmrD4Z4fn4pMRdulkjSw=;
	b=cx/L/ct/X3cbya+UUNOGp8br3uJc9KDxO4BntuZlEiUS5qkt3HscHVY2NZ7FkBghXTxA
	 udlI5iJ/ZXlfSkl1riITzW1518ydi9LliOgwFxU26PqsCsAQWiq3C6Y9DSl5iKSmqmewO
	 blP1+ImdInlEruCS72xUGdbg+xGX606YwBGfVs4brJxj1ShTGmYm7dg7ep0p9Wus2IB5i
	 hb5B1xhNm4atdX2oYN8X6jrSoF2uiCPosVWjCJmhd28PFLg68bCCD+BTWOhXQIkukAZeW
	 TDkukaespHuJaCDRcmrGRkdFyyQTLSDWMKYNjktJKQP3eJ/BdwwY5vQ503ykAz6cWQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA5Oi7Tx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013FA606D815;
	Wed,  4 Nov 2026 22:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA5Oi7Tx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9208C1F00A15;
	Wed,  4 Nov 2026 22:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830860;
	bh=jtoi5gq29+ouITrLOFPUfQqtmrD4Z4fn4pMRdulkjSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TA5Oi7TxghIo0JIbwPyLdaO7nSr8uURoOV10muQJ4/PtlZ7lznelez0jXgtOO8ITH
	 QmCpGSG3ncfV3Z7whPfr130HvCB3mfkQE5e3p1Z3+CpNwtD/krRFuPZ49ggTwYkJKx
	 TyyxMH4cxS6HzMPdK6kqtZP8xCQ/Ze15nIeKHNd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0365/1005] net: dsa: mt7530: check CORE_PLL_GROUP4 access in mt7531_setup()
Date: Wed,  4 Nov 2026 16:01:38 -0500
Message-ID: <20261104211054.314221410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 1ae63b018d3d70e96d420b59a1334860cf232bc6 ]

mt7531_setup() reads CORE_PLL_GROUP4 through the MT7531 indirect c45
PHY access, modifies it and writes it back to enable the PHY core
PLL, but checks neither the read nor the write. Now that the indirect
access functions propagate command-write failures, a failed read
returns a negative errno that would be bit-modified and written back
into the PLL register, and a failed write-back would go unnoticed.
Check both and bail out. The adjacent EEE advertisement writes push a
constant value and cannot corrupt state, so they are left as is.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/a7dfe3b66ea6ac1ae7915034de0527060e6ddcd4.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d2dcc2f1522f4..4f391ef797ea3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2758,14 +2758,20 @@ mt7531_setup(struct dsa_switch *ds)
 	 * phy_[read,write]_mmd_indirect is called, we provide our own
 	 * mt7531_ind_mmd_phy_[read,write] to complete this function.
 	 */
-	val = mt7531_ind_c45_phy_read(priv,
+	ret = mt7531_ind_c45_phy_read(priv,
 				      MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
 				      MDIO_MMD_VEND2, CORE_PLL_GROUP4);
+	if (ret < 0)
+		return ret;
+
+	val = ret;
 	val |= MT7531_RG_SYSPLL_DMY2 | MT7531_PHY_PLL_BYPASS_MODE;
 	val &= ~MT7531_PHY_PLL_OFF;
-	mt7531_ind_c45_phy_write(priv,
-				 MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
-				 MDIO_MMD_VEND2, CORE_PLL_GROUP4, val);
+	ret = mt7531_ind_c45_phy_write(priv,
+				       MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
+				       MDIO_MMD_VEND2, CORE_PLL_GROUP4, val);
+	if (ret < 0)
+		return ret;
 
 	/* Disable EEE advertisement on the switch PHYs. */
 	for (i = MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr);
-- 
2.53.0



