Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830853;
	b=AVkPwFyuUoqmU9pt7fZL2v69AT+5AtijwoxDVpGyoXy++r3csojXp0W4mWjLP23tDzPB
	 kDJSpoWDjPZC2sCcn5Zcqbks7jXgKvnH86cbJeyF4CvPBwht74N6CBnH+YCdXsjtCZ8b3
	 c4IiZCebBpDqjDrDuRvmV/2zCJWIFq79jra9wKzgfT9OlB7ztCef/IjqSobGGGY2HXBFz
	 Hn7dlyqRpHgnLyLN3bU42QKzbluOVVMr8GDP8AW7EjLMSBPKokwcSLAxkMpccIhdLvPNG
	 8BVkHjiv0dgNicE9iahCnTKNtaefHn9O6+fc7Wncj2mEnlNBJ8fRj2A7xXDPzaBoYNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KIeyD50HSWAtbDE5PEv+RC5ee9iehtil42hgvPQSVsc=;
	b=DB1UIKblL0p9gYIQR9rTcFPN/nAnCQ7PdcqxvA5CmMsoQptGqkvt4V4jkKAyM+1XsHnA
	 cIkq8lxKCE5uTWmlsooJ/ubYNdCCWkV0lXufy7lHFffx6deizxDz/Sj+fBnXzIu4RbRFk
	 DilXZsUaPK4HKvgzVPXLxoBVDjk/EKRbkBw1qkB42E3ivd8xa4Swh0FNmJcoDnpGviN44
	 aIqRrGSJCxIfmORFmC0CFNg3U8rriWcarGsFYk82wn7Y2LwGQXm2kBTrIjnGo9g6gXz+X
	 jT2dhJmisXoONQo0DQqRCPkEHT8k0XelvgE5/JPrsLWjlWLAvZI73U+96snPZ61fnww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfqP2awa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F9606CA2B;
	Wed,  4 Nov 2026 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfqP2awa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFB11F0093A;
	Wed,  4 Nov 2026 22:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830853;
	bh=KIeyD50HSWAtbDE5PEv+RC5ee9iehtil42hgvPQSVsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfqP2awaT577/u6r/K4ppuvHjDKRRQJhvbvkjv2x+kmFC/p47KyxhrIG3q50wMMAw
	 zOwJx1VR1njR1X4X/o/JF2BE4/TfMaUTmW5DTJR/7tXgtlC5wXxI8cNR1Oufcn5+lP
	 vtn1EH3qbDW6ackCoggoeUfuseEcSB2PNM8QswsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0361/1005] net: dsa: mt7530: error out on failed PHY_IAC command writes
Date: Wed,  4 Nov 2026 16:01:34 -0500
Message-ID: <20261104211054.196231698@linuxfoundation.org>
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

[ Upstream commit 1c95dcb7e923beebccdc79adc3dc1ec8c52295d0 ]

MT7531_PHY_ACS_ST is only ever set by the command write that precedes
each poll in the MT7531 indirect PHY access functions, and that
write's return value is discarded. A failed write leaves ACS_ST at 0
from the previous access, so the poll succeeds on its first iteration
and the functions return stale IAC contents as if they were fresh PHY
data. Check the writes and bail out before polling.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/c34602e63a20ebbfb97babd145c82832d7a0b523.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index bd0a37ead0dec..24c7cb225da1a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -557,7 +557,9 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -568,7 +570,9 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_READ | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad);
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -602,7 +606,9 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -613,7 +619,9 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_WRITE | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | data;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -646,7 +654,9 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 	val = MT7531_MDIO_CL22_READ | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_REG_ADDR(regnum);
 
-	mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -681,7 +691,9 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 	reg = MT7531_MDIO_CL22_WRITE | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_REG_ADDR(regnum) | data;
 
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, reg,
 				       !(reg & MT7531_PHY_ACS_ST), 20, 100000);
-- 
2.53.0



