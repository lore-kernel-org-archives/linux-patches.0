Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034210;
	b=DCRtgxGeUE2q7j2T6Eetk7id/6HXaPewOZ0mDEFSXV2mRSuT/Ogyoixpzj0+G2WH7SZ4
	 yvPVng/jLxa71Oasmhagei4Sv5EnCVUAr498yx+t41swR0WYmqv1V9t0l2FnB5+LwoE6Y
	 nSngx5pIqVhLgW2b0XvgE1KBs0XjTRpatwjZXb4WL/VuaV/SXA1wNz+DwD3mSkVwRskpN
	 pSAyqhz2/eAgRVWDBWK/zgRhlweqKDAf1tfrf4cftuufC+v+t7yClDgh69MZ1IxUOt2Vq
	 c0SxS41MtjdzK7dJOnDRLjreFcXGmbrN+SwWtwbS5JMz+nFg5QFWeZ0NM2v494GucwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yaKFjEDkQFyBOmzSC0Dm+fUPYNjo4BlgeTLJutp1EI0=;
	b=ixus+AfxiVImS8PD2wvyBPqfHV5oarnKiZvE5PA2EM47+w1YwInzLb9EF0YG7ITcyU8K
	 WnEg1Kz+HzRNw1XIOQFXVbrv3lMw/GCYNt5D9kuyum4Bn6wUFqiyCrDKMvXGEzc7qBWJa
	 GwMgnBSW8PwoPQ52cRvClqAwEqfSLt6O6Pwpo0FBJg7CPBtrUIDAxTsnVJqfodJ6UZOGZ
	 /IZ9CUUCts/IszFXtgjQoZaZQNYELulu+fAfZ4iO+anY3ygMUQ1w4+LIEFAMFxkEcLCql
	 rn756H7HhAVayd1YuYr69YkSBGM+fLyCYH6rSCAHYRisPDCy9Pq28zmnIRFs7hc+mow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvXH5EID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E5606A32C;
	Wed, 18 Nov 2026 20:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvXH5EID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1541F000C6;
	Wed, 18 Nov 2026 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034210;
	bh=yaKFjEDkQFyBOmzSC0Dm+fUPYNjo4BlgeTLJutp1EI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvXH5EID22KGGm9CyV0LgzBJBwvihFYMXlRKmRW08dbFmv/IH18sEl9tmNK8aL2bU
	 fqk7n0vA8mPGb/MVqWBVFBwOeGKr/MB4C/A5zNvueIt32LVapF2pVN46EM+Y9edz2T
	 LIgI6CoYiwJcLsdr9p6aDoKNzyE6eXOn1D3cS/Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0253/3318] net: pcs: mtk-lynxi: check regmap reads in mtk_pcs_lynxi_get_state()
Date: Wed, 18 Nov 2026 15:14:35 +0100
Message-ID: <20261118150322.906390050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8501dd365279b..236f5567809ff 100644
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



