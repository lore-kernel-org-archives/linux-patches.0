Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830858;
	b=4lEET3UxH8Pq7mbFCxcfw3i5y2Y8lA2/3/zCyxLU5/KxFtDTNIDSmD73SG8esUx6aYGu
	 44Y3AVgobf/7DtgWT/nITaGTgOAhK0UPrXlyFhyus9QtP+y0pLhGPQRuwNq/rBNvKarxd
	 F7Ibl1plPolmg0LFlBm1JBuwprx3uLSa6uKQ3Oinmv1KF6jIxjdOam0ra5Ox4S/KtXKxH
	 U7eiBtfQTGvYsMNCIkPA3NREuWqeoM9cgKErrK7l/HcBG8woPsCglBYVlAanIFGQ/B0vw
	 VLakuqm9MWQluonYU71LVmZp6WYTb1QAeaubK2kmMdSgVjij3yp6TL0HJhd1siG4rqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K4m02cbHIluXdyrYteh6IdWzgU6YSCAo2yANefwJ8Uo=;
	b=5cCnSH7FaLWiTh6SUag5dgaI3W98KeGa7D/UvKUypOEYzpDhmbROSTZOcEFbDXPK8I2I
	 l8sROqW4rmBbJvYFAa9TWkEbuZ2flYC6MLysaPFgORaL40ipSZdppOa3PXBZaZN26MFiI
	 AkBlM+oS7uVgzHHJXX06sBqxCoT4fyqdH2xT9wFg91i7rDUfIXTS50/UGZZAjTWDGB7O/
	 Kl3e9cSM1ufH2tVYf5uVlpLp8j+5Z9xfunr0BnMdpavsEuDp8yC4dc3HJaJTbu2MXIutt
	 hsMwpwFv9pqWQnGlU8I/802GK/fxAaIEbqOz2IRnW1g2cvUuUHqjbM0nFH5/MeAA/1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQhPD5rb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C26606CA39;
	Wed,  4 Nov 2026 22:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQhPD5rb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDC61F00919;
	Wed,  4 Nov 2026 22:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830857;
	bh=K4m02cbHIluXdyrYteh6IdWzgU6YSCAo2yANefwJ8Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQhPD5rbZBVdxGftcEL+55jNZB1EMmd1XiqGMNKdlSMnDhUuKNlrkecjRExKHldE1
	 WMown7vn2nlBBslyo3k+atbG6TzuccARoJRj6JoX5FV2Hn6fqHBvjT9pQWuXWj1Xxc
	 4HobF774oiRcmzUcn85OAor5ewMdlhjO2Su5kE90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0363/1005] net: dsa: mt7530: check bus->read() error in core_rmw()
Date: Wed,  4 Nov 2026 16:01:36 -0500
Message-ID: <20261104211054.253239594@linuxfoundation.org>
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

[ Upstream commit 573d6e3afe3d01e34dc82c77bf22ca96a74d805e ]

core_rmw() accesses the MMD core registers directly rather than
through the regmap and has the same unchecked bus->read() as the
one just fixed in the MDIO regmap backend: a negative errno is
consumed as register data, modified and written back to the switch.
Check the read and bail out like the surrounding bus accesses do.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/48bb9f0b311a9efeda2a6b24a7e05d4792393a3b.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 24c7cb225da1a..d2dcc2f1522f4 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -124,8 +124,12 @@ core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
 		goto err;
 
 	/* Read the content of the MMD's selected register */
-	val = bus->read(bus, MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
+	ret = bus->read(bus, MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
 			MII_MMD_DATA);
+	if (ret < 0)
+		goto err;
+	val = ret;
+
 	val &= ~mask;
 	val |= set;
 	/* Write the data into MMD's selected register */
-- 
2.53.0



