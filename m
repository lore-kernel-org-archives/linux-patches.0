Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060981;
	b=A8C1KdGY0GuUAQfXHNsRoy6/UH9EUW+4Y11MR+evXQ+rMUoAi8P3VCdov/9U6uvkbY27
	 Tvv2Y8/65QItzopiQM+DHCwz6jh/++WvMysbAwo1dQf1Ejft+1VCataDeImb81Kukavkn
	 0W/NHMCbkAeabiWl5jO9JN/N3/xcbyXY+HJ8t94Bl1xw8XHzpCMqUvtcjPk+PRkNdVoa6
	 YhHCO0erZ+EgZUyVA4DTs36XIE9oUsOTLwfl473NBrt/paFq2Vc4iEcl3RmKUIHt5x4Ds
	 gaHpvADr7kYcVnTwqhnYBe72328D6CQ57Ma3IhmtXtmSz9AepHmuOvPnezPbH6jr3fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEhKbPF/taC0ui8BZzeKt15tlWR4nkwojDobFXdzO5w=;
	b=WtpXAZuNbC/wolRoKP0qXdpROfFkzPhI3PGxSY+/IzNLXz6ytM2bbxsJSofYa5xRcPpa
	 phCBfgOey+/c/mzqDV1BlrHUiZKfTb7NC9I+CK9FQknb+st9kjJFSHMUMZJYVrb50kMyJ
	 FI2/bDq9QZxwgn8evot1EHNf1V6lbkyPwQgjQQKiPRTddAAUR8vK/6OquK4fgfmzFOXwN
	 s3MMcbGbtUz0wJyEPVbP632dmq3A5OquIGacUz5oVm3UimaFH900R9IZ38xOcQWqe9NVF
	 2ovmYOU99puFA6BDUijxO2EjkyPG2L6mZWwNanStHXxG5HUs/wU51PIiyaSnZcu7bug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbi8RjrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C18D606A33C;
	Sat,  7 Nov 2026 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbi8RjrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1698F1F0089F;
	Sat,  7 Nov 2026 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060981;
	bh=LEhKbPF/taC0ui8BZzeKt15tlWR4nkwojDobFXdzO5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbi8RjrEFU+5kQnLTG683jgyJGcC2fQF67D3MFJUt/I3nunyXX7dzfJzbE/zDyVKy
	 2Rk4A29VIn3P9DTKi3q3hkpqOQ+Sy/3LjPayxSUET9UFHd3CdZ///shcyyRxQctroF
	 sKCsF2sFTcJsuZG4MtBe0IsumQC3o9RDsvlfQ2zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0298/1536] net: dsa: mt7530: check bus->read() error in core_rmw()
Date: Sat,  7 Nov 2026 08:38:34 -0500
Message-ID: <20261107135006.098212860@linuxfoundation.org>
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
index 4718f1fcca6d8..d0b2b478ac22e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -152,8 +152,12 @@ core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
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



