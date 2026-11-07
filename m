Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060934;
	b=E3lAV8aZg7jQcmlp5JxH5z8lCyvjlcAFfWp+jtVWjU26tP/szZO0OQO1Lltyql518rM1
	 IXcRmMgrUYyVxrIdVgoVNE6KSfX12LjuNd5Py8B7MSrcmJtQxHJxeaZxz55eqgUT/0VxX
	 m+Pm2x+HE36tmfA1SBh7ftPQZMIOE4ofjg2r/l9pRv/VtQltzYiHSwEl80MEonX3oW/Ur
	 tW48S0sO+SZH9TBxc5pxa2FOhNtTkj57cGdl4Abb2t2XnQhp8qBQXW5AdUK+g2uH7fKCS
	 Eqe1NziY6R4HpB5UusB08ee++/Ax5sQlGUuavoQ4wyW/Ae0tTTxtEPxozlypHWW0tKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DK0JKywt1DIy6mmekR4oPnOAYU5SHrYqo6Y/1eSX8o=;
	b=wKHwSwyirmxg4x2zZnnLqkTx9Mk8EAvv6Vq3znsz6h1B3bP0M6ng/QnZQ0hxLwNgANOd
	 3d+0suI/xTmWaimhWFRH0HxwIoWPzeo3rAjsRMc6IcbBkxEsuRWC1SQszAZoFCC522l3r
	 B5pp4HnXeQrK2wsFXygbgGcOupKjfoHykKfQ2qFbWOcwFaIfDjPpu9XhA2osifK0B2sbR
	 pD1O6s8/5hqH/vPn2QiTruuhYkhVpX7H3ucMEMHQX7FEchuUAP/sFrwy5ogmL8J/QY8aA
	 WdhH9SXrNkszrscU7BWpPHfLko00olmBTuSK3SJ0ugYoP6W1Kdc4IJW0RoRtkatpO2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Sggf3/ra";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4A4606D819;
	Sat,  7 Nov 2026 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sggf3/ra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1281F0089F;
	Sat,  7 Nov 2026 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060933;
	bh=9DK0JKywt1DIy6mmekR4oPnOAYU5SHrYqo6Y/1eSX8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sggf3/raj0ljEnzw4tDEXhRh1kjt2W3FMOG83pAMoTFoKLJzz3XN65ZDZoKT2PKb1
	 7BS5uA/2OAGHmfn3nZ6ObXn8uqEWYkb+NO7mX10m6bNe+lhishidtD4hgZKfsU+5Fz
	 ls7PRmCLfn94dylkux8mZQ59ixkySbEf4+NUvjIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0299/1536] net: pcs: mtk-lynxi: check regmap reads in mtk_pcs_lynxi_get_state()
Date: Sat,  7 Nov 2026 08:38:35 -0500
Message-ID: <20261107135006.124025381@linuxfoundation.org>
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
index 4f63abe638c4c..03e32abd649c7 100644
--- a/drivers/net/pcs/pcs-mtk-lynxi.c
+++ b/drivers/net/pcs/pcs-mtk-lynxi.c
@@ -95,8 +95,11 @@ static void mtk_pcs_lynxi_get_state(struct phylink_pcs *pcs,
 	unsigned int bm, adv;
 
 	/* Read the BMSR and LPA */
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
-	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
+	if (regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm) ||
+	    regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv)) {
+		state->link = false;
+		return;
+	}
 
 	phylink_mii_c22_pcs_decode_state(state, FIELD_GET(SGMII_BMSR, bm),
 					 FIELD_GET(SGMII_LPA, adv));
-- 
2.53.0



