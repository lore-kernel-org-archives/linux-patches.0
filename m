Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060772;
	b=XbO84cbVPtvAnTaDUN9HYci5g8iGeDzFtftQrOKOhaezTecVSp/0NmFop+/duiIvdEka
	 yXZC7n/lTiHdl037MKpHVYBfJDvJCkaYrI+tL4n4QLjhypYsJHrqGffEVaAvbRkoo+H53
	 0/cK+BfmY0G9blopmwMWMr5XjjthtgMAiEAWQgdoPjpjvEexw4GTaVTsXQLuypZcOgWDu
	 OI51dEpZTgBDgZDO1g/Lc/kYaFC76KPyOw/98E2jkxvnHSvouvzvWoJXC3N6lxuXfjhsX
	 BvIJaUzAjH4ZJCz6xT/he08s2ODRK+qIzsQOcmiBUGxfXmYIjl9uNzW7VA9GbHzuMCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e74Tt9yctcf6+KUhg2KWXEYZdSQUSM1XCBpUHgGh3v4=;
	b=Ix44jKWUFE+fd7Uqmd2GV8OJxg5iKIuRxi13cekXGsl2ayiRXiz/bSyaF8qUaP6u5DrF
	 MWSe7nkFoCaGrLxsUpvWrkcHuUslcBdntbvSVp6woc5g0KNKOtNa7k8lbEkrY2bTbZol2
	 +yT4skjWCcHs6qxL5DTVkT5iyQgqyYGf4/DL/AZs7rr/OVdn3OhSZagS9sOT1CpZjichr
	 mlCPnwYKBKgCtI1beMdxz4KOY7Y13TX+arGBVOxuEcwJDC89lzmW7JPl7JqLieaHIqzrP
	 jhDz9TVYDnLDWTj7EpPXaJiMv/bBOPGrkPWy1HNYIeFTmLIFcC0W/aDktjwpNwzXZng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QkzKLBw/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF240606A32D;
	Sat,  7 Nov 2026 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkzKLBw/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CC01F0089F;
	Sat,  7 Nov 2026 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060771;
	bh=e74Tt9yctcf6+KUhg2KWXEYZdSQUSM1XCBpUHgGh3v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkzKLBw/YbBf0lpNu+GAJ9PP5o/tOeHtDbByCBLyYvYN3DtqAWJXFVxccjN8dxR1w
	 mhLshvc6Z+SiDl8tXcRrtwa25lnQ0ivM/YP8T1lET3bifINfmf+cXE1TSlc0Kp3/Kw
	 ny+LzYcUCYyKFzHR9leS3zYoGOZYJOTXo9isfcN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0181/1536] net: sfp: add quirk for HORACO copper SFP+ module
Date: Sat,  7 Nov 2026 08:36:37 -0500
Message-ID: <20261107135002.745540974@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 1bb028baab541900d3603d4f93c1c0fb5aba5401 ]

Add quirk for a copper SFP+ module that identifies itself as "OEM"
"HC-10GE-113C". It uses RollBall protocol to talk to the PHY.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260719100158.874882-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 512f817607c82..55388b77dd3b9 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -569,6 +569,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_F("YV", "SFP+ONU-XGSPON", sfp_fixup_potron),
 
+	// HORACO HC-10GE-113C uses Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("OEM", "HC-10GE-113C", sfp_fixup_rollball),
+
 	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
-- 
2.53.0



