Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060935;
	b=B0s3A75Nu5NTlNuV9fyyb5zBgwdCeorWrWCgYsOfdEFpeJWA7hNfJ4Sn/Ynbl7ZaxA/o
	 0RLMP21cl2oKLHWahLAdT1YC5L9Em2lC4XzGXZl2NTk5XqHCu3msYCQGsINb31lOt1C7Z
	 fzeOJ1ZNTk9/hE1FCp1AsHSbSCjmDRutuK6rDnp7Gr8zh0SBXVKuQP97Mf2ZJPB+VVihs
	 aRV/BuVuVt4u7EVFKLUJVYyfqseWjQpCxDmP6IXzOf++cWxYOgijWy9cMUMPE+CJeSg0o
	 U4++4Z7yjn2G2lyhWhj7xc2OH9LbigfpiQrKmbTpBTveuZldedBfY9D1kVxua8Ptbnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdvmzsmUBi5SBaFoRNee9j4XqKYYqCi9U7ZKgjqLcKA=;
	b=k94PaDPN/e91jN+pBeqRe7bcReLoj2nS48olxS/IFQC4bP1dtd5jqw1nLjp2nnauij4J
	 l8u9BMu3YEeNEHBWKaegtb5OPz9E6imosUKixe040TBszALwnMDmQ8JtYBy/9QF7/C+mo
	 yVqVS2le2TCdElsl9cnwl15nSsQdURYA9WJ0vDoGaqasgG30p26GtN4F2YSj2MyzcldQr
	 4bVoY67hrBqMeOFtfTnh+TpDJo0aRp0X/bd+RIjeIOIiORkYUbniZ8nBoCL9+TPbswpHL
	 LiLDwXAX3o3hM+GCv5I114E9Ds0Ywi0Ux5aoHgzkCuYkIy280spMBnis40O9R8+9OPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOwxKF2g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFF9606A33E;
	Sat,  7 Nov 2026 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOwxKF2g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FBA1F0089F;
	Sat,  7 Nov 2026 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060934;
	bh=tdvmzsmUBi5SBaFoRNee9j4XqKYYqCi9U7ZKgjqLcKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOwxKF2gVzUYbcCKTuuhF2u5MudjEgpLw9AMfqgu14e69YB+q0VtiQyhBLo78zhC7
	 dKL7iPFuSbBMBuYHjiBXXZCgSNr7HrV58dJoe+kKAcW4GIqoD1u8X7ZBkW5E8aIRDC
	 pSh2tG1hdJPow5XYyOaSEq3/tyVrh7J611jMobh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0300/1536] net: dsa: mt7530: check CORE_PLL_GROUP4 access in mt7531_setup()
Date: Sat,  7 Nov 2026 08:38:36 -0500
Message-ID: <20261107135006.151698615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d0b2b478ac22e..8c9eafb6af7be 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2678,14 +2678,20 @@ mt7531_setup(struct dsa_switch *ds)
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



