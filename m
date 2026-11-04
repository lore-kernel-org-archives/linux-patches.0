Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830860;
	b=APM4pq6YmHSeIeOKBnhebkrBfcPp+SivNBu5BJUk3AaGJSOIiMjFz4/WEtZxp30Picpw
	 d6uNtpHCpEnQbpcpNOgI8FrrAnYKu+eobDALV6l8lcXNDu3TMX9HhXMfnG0KVtimGeYjD
	 3pkNmwHZGDx40kAbUrOEqkYfOK8uTCvV1rk1OfK99KzNSzngK++tv0y2ZxqtyEMjhR43u
	 PsF6Fl67n62XIsDm6WPYD1pKuQ1FpCpATTanMqfSNK9OkehT345gdYrBF4HM9J72ZBTWH
	 0n4/8rSTC1x60vigGx5VoCtLyNgeUDwNVHi9SDsD7o+P9Asu0cNMx+TuLDbjZMzGFEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2qOpkr1T+AOkTMzPzF+3PXzVgQUvtkj/5E9yvXkf2Sk=;
	b=RuWMP1tmbxN8Iibpe/ArvLjOFHOHjwz8hGTDKPoGDd2MlsiOMiaFGEpP6qki28qtqL3F
	 5HRcvtDE2QZ3g9bLExCVmroAtOKg71qMI+5aLwSNdD63d2ZBInNk8/YjtmO3qKsxqGVe6
	 +iummfbMx8VuYz4lF5OGkF2wczek/1dRX59hx3jWNor8ucxVZk9HiY+k1mlsj2wuGd1EY
	 OWdBNh+1WtMPuVEZMucOc75zKWGqMkxSgygQcrSDm4njhJFoqZYFx7MV3GaQIMke1nuHe
	 UJvLEuG/dh1cGzxUf3VtVk/JRMKp9C1txZsNFMC5fM9WmMDbhUY4pHiuGKBeq4fWXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSkrbuvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39EC606D803;
	Wed,  4 Nov 2026 22:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSkrbuvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FA81F00919;
	Wed,  4 Nov 2026 22:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830859;
	bh=2qOpkr1T+AOkTMzPzF+3PXzVgQUvtkj/5E9yvXkf2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSkrbuvpK/y4Cwo5etTuLLjLg5eO7qW+7FJx5BVgzIKo0+HpeUp2aLZT4IbChe99o
	 yrg58x3q0Ea1sBM9xu6TnOsj/LEOv5wHEAnQtrip64Qn9ftJiLY/pagsjruDT4AWHN
	 giul5AqkQt6al0t8gREL2QPv7SfP1UnqK32B9PF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0364/1005] net: pcs: mtk-lynxi: check regmap reads in mtk_pcs_lynxi_get_state()
Date: Wed,  4 Nov 2026 16:01:37 -0500
Message-ID: <20261104211054.282952835@linuxfoundation.org>
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

[ Upstream commit 5cc65c01cdc577621d1320f4aa03a1382c5a4a45 ]

mtk_pcs_lynxi_get_state() ignores regmap_read()'s return value; a
failed read leaves bm and adv holding uninitialized stack values
which are then decoded into the reported link state. The regmaps
backing the MT7531 SGMII PCS instances sit on an MDIO bus where
reads can fail. Check both reads and report the link as down on
error; phylink presets state->link before the callback, so a bare
return would leave a failed read reported as link-up.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/fce70657fc03bbaf60a04c0fbf2f418531135c4f.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-mtk-lynxi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
index 87df3a9dfc9bc..64fb17c189afc 100644
--- a/drivers/net/pcs/pcs-mtk-lynxi.c
+++ b/drivers/net/pcs/pcs-mtk-lynxi.c
@@ -110,8 +110,11 @@ static void mtk_pcs_lynxi_get_state(struct phylink_pcs *pcs,
 	unsigned int bm, adv;
 
 	/* Read the BMSR and LPA */
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
-	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
+	if (regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm) ||
+	    regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv)) {
+		state->link = false;
+		return;
+	}
 
 	phylink_mii_c22_pcs_decode_state(state, neg_mode,
 					 FIELD_GET(SGMII_BMSR, bm),
-- 
2.53.0



