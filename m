Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F435CEDD;
	Tue, 26 Aug 2025 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219133; cv=none; b=Ys0gHeuJ71u40mCg2S5QaKeLIUbKqbvHosPeIaKtgInSlQ9Vx36caadayoEOCYDPqEEbSvwcFo03V67ttD3kpIMeqINf1XtOv0swrfjPWZDUXIlU2TjtuYo38rIsN/DIVG7szmKst6KxB9DFiSoDsN/HZ48Gcaka8tJge5qzpkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219133; c=relaxed/simple;
	bh=iv80kTbURV7XkPcx5qwWq/gkV+DFb6+dDMZBpn+nEpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDdvW/dT7g4fLcs9cJwJFYLmpw7Vr4ZLeRiwpbKYH3jScBjMoaLdiQfGq7tMFvEsHnQPQ1dz3aoKiytK3eAM+HZ49PIu6lkNnSD4zhK+njlwEQ0mo2MJDLEpMXXKrIfn0jwjfIZi8JMWDEbJS1vNfnRglOR/IZWhHTBpdVPjDD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UM40mwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UM40mwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7C0C4CEF1;
	Tue, 26 Aug 2025 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219133;
	bh=iv80kTbURV7XkPcx5qwWq/gkV+DFb6+dDMZBpn+nEpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UM40mwk36bwDAdkysrslIKEEsFOXdD1wwc7YZwVUzT90VNDVH+TW5NKO9pRlgcYT
	 d4Vv9IZl3Obzm0U+XDSrKPGEtKNMYKzSLdMJMRFDFaHq0PNlKZqLSsvQDYyJdRoWV1
	 TQtlitmXRj1HHV8cjcMUguQ0VpsD/pYBORwtWGJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 266/403] net: phy: smsc: add proper reset flags for LAN8710A
Date: Tue, 26 Aug 2025 13:09:52 +0200
Message-ID: <20250826110914.156105614@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 57ec5a8735dc5dccd1ee68afdb1114956a3fce0d ]

According to the LAN8710A datasheet (Rev. B, section 3.8.5.1), a hardware
reset is required after power-on, and the reference clock (REF_CLK) must be
established before asserting reset.

Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Cc: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728152916.46249-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index e387c219f17d..68bb94f970f6 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -306,6 +306,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.flags		= PHY_RST_AFTER_CLK_EN,
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 
 	/* basic functions */
-- 
2.39.5



