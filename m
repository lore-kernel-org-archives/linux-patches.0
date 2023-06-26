Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4BF11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFE7C433C8;
	Mon, 26 Jun 2023 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805105;
	bh=iti1Hd1jW+hO1GJQ/zErADDHuXMBP5Z6ADmdtG/bdkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfocP7Op2wkve8DYRkDlIdQRLfaIcT+2mgVgZy8Nh+sM3VEOTlsWsOnm72khzHKNh
	 a2fn/Sp/glIMUBQg0OnHhNqKltLxv+H/N9MfMao2Xt7iJpcYyV892Z8njfHs7KmMlH
	 w5eDzV/AeKIjb9bdkxPB2aj4Kt+rfbzDh/kCBHas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/81] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
Date: Mon, 26 Jun 2023 20:12:33 +0200
Message-ID: <20230626180746.540812464@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 4ae90f90e4909e3014e2dc6a0627964617a7b824 ]

All MT7530 switch IP variants share the MT7530_MFC register, but the
current driver only writes it for the switch variant that is integrated in
the MT7621 SoC. Modify the code to include all MT7530 derivatives.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d3b42adef057b..4056ca4255be7 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -966,7 +966,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
 
 	/* Set CPU port number */
-	if (priv->id == ID_MT7621)
+	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
 	/* CPU port gets connected to all user ports of
-- 
2.39.2



