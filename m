Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D103B1ECC;
	Tue, 21 Jul 2026 20:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666616; cv=none; b=B0UNPRWys4C/MX1sAsBtS6fPu5nSOxqNzmr2UgOoLpnq+DY8nTWf0jtEXBufmzMM5KfY1ETpRCf/l4dMeEmrG1pRlpD5Z80MUr10fhVgaVD4Jpr7gMnowA6vwgQevJTL2JBlKj7/MFN/kjN5FyynGezB+0LhfAZeeKMtvJsUmt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666616; c=relaxed/simple;
	bh=juRhknRXClGhKxsWk2XKX8Tshkvkmf59mb29IJZoRHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmShboGR6rvwZDmhEXUYu937t8zNaBO8kfa0eJJfM7ElZtXwXhJgM8mBRuHiOm/LcceWsXHy7ZfCqXIwE+bZYssT3vw+1pMaIxLJsApv0XvKx0RadmdQ2MvL0lpFVaU8GZ67tFTdLE5HUSfi8gFDZ0BCRmEAKqwi2W2loN5ROsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjFVsR3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjFVsR3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74C81F000E9;
	Tue, 21 Jul 2026 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666615;
	bh=eQxCkr+NZDS84wrjEUbhoKpITfLCHl4qPUBSVDwUUpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjFVsR3NX8Zw/Ts6vQvhXbB+gLA5ZwuKLuFLfOgxn4FrGSNX3gEILDezGPZYdTNB+
	 ANuoH0dO7GWQNE3mc2aSPNuNZjcDBnsy6zklG0Tygstr2H7Mrj7fuNnoIBJv8XmV0w
	 unJfTbMIeESG8bahcMexHtampeZ9KVKlv0d240yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0751/1266] net: marvell: prestera: initialize err in prestera_port_sfp_bind
Date: Tue, 21 Jul 2026 17:19:48 +0200
Message-ID: <20260721152458.675913904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 62b01f72d93c7bc8fde3b2e5b5f783eca5f53324 ]

prestera_port_sfp_bind() returns err after walking the ports node. If no
child node matches the port's front-panel id, err is never assigned.

Initialize err to 0 because absence of a matching optional port device
tree node is not an error. In that case no phylink is created and port
creation should continue with port->phy_link left NULL. Errors from
malformed matched nodes and phylink_create() still propagate.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Elad Nachman <enachman@marvell.com>
Link: https://patch.msgid.link/20260617193228.1653582-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 4fb886c57cd778..fa35372ded43c8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -372,7 +372,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 	struct device_node *ports, *node;
 	struct fwnode_handle *fwnode;
 	struct phylink *phy_link;
-	int err;
+	int err = 0;
 
 	if (!sw->np)
 		return 0;
-- 
2.53.0



