Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043460;
	b=hd/DCHElXfW1NSXZ5tfxBfqOE8PPxrwBv4QSKpzHal8+o39Y+jnyDCe0bWN7MyLH9gR9
	 SNSgYepclNaupoSGW56p5ZexwOb5fPzqbHL1Y+9/s1I6z7izl39MOchHZmjbK/oPhAxGl
	 3uVZNcLjVKUtoCscSB68GI2qLmYOcgDC53Offjz4n4ZLmVuEFuz+f3ukJgskTy70Quj5Y
	 2BIvD/MlTpjhIP7hd4CQhn1WzqErOpFwFIrIxWJzLMXIHwy8dBeU0/Cw0unRjK8ZnHNsN
	 03EaxoGeR6SPHjfV0dnSIDpOm9HdJkmx2wEPfj7Pm7dWVcHuZgSDZsaEF9L+59aVNyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v8SDAl9Zou5iZ4Z1pvORYTBUrGGsx/p7uhCbLTRYKXs=;
	b=o1mLpaKEZ6mwHRsFeB8KbvOloPos3z5DqcZ+R5SniyzWM8CuSovyvTigcb4i+mimmh9d
	 OdHHfWpR+A0mZvRfEuL9crjJRlM2cOOkKB1PexKQlcQ+6lczC7NvH3h5AT7XJHq5Wo2Wj
	 FsueaxhHoEp8hKZhjPYetB10bZv9ySfLIuYEhdNpPLon0dmj8ZAjNbK2DDW+OXoya54L/
	 juvy+tl9dUpTBG9nJ63uqm1Mu2pi14rvsoVhxbNdXrrufb9oeaAZrmQkoZp4xauPzL93Q
	 e8LO7DyF/kwW/FjuF6pK/0Yu9Ozi+0Cc9BGh3/HgyKzEUfMqxKmk/MLYVeVl8HebPLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B3/zafXA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A5606A336;
	Wed, 18 Nov 2026 23:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3/zafXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8563A1F000C4;
	Wed, 18 Nov 2026 23:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043460;
	bh=v8SDAl9Zou5iZ4Z1pvORYTBUrGGsx/p7uhCbLTRYKXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3/zafXAp4JsWVO3Cl6QqsViImaadaowjQjAY8CPyETjBdXAiBdop49OOgDNA1XqJ
	 UZJkHxayL3frobeqEC3lLe2tnxXs+4smGN4pmmoxXkeTTjSrK2ELTATPoPUnsI34xw
	 dIO0YcCc0hiD6OV5glWfFLah4A8FyLZ+amaCuLiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0218/2857] net: dsa: mt7530: error out on failed PHY_IAC command writes
Date: Wed, 18 Nov 2026 15:20:52 +0100
Message-ID: <20261118150209.313411002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73eeb6aeac5cc..7826d1e3a1cfa 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -654,7 +654,9 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -665,7 +667,9 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_READ | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad);
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -703,7 +707,9 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -714,7 +720,9 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_WRITE | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | data;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -751,7 +759,9 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 	val = MT7531_MDIO_CL22_READ | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_REG_ADDR(regnum);
 
-	mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -790,7 +800,9 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 	reg = MT7531_MDIO_CL22_WRITE | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_REG_ADDR(regnum) | data;
 
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, reg,
 				 !(reg & MT7531_PHY_ACS_ST), 20, 100000);
-- 
2.53.0



