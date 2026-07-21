Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7598F404BF9;
	Tue, 21 Jul 2026 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657695; cv=none; b=RqtdJg0WS32AtCvvkIluMFt+FX8c3snIdGKUJ/dsb2nk+TXMd1Cw5S10WfLakNZ1RhLlaOpdEVEDt6KohQh5JszzfHd5tUmA9mBBHJShHJLUNEbjqdWslrvzkFbbpHn05cLmCYlTDxB3DtilpnMASgBfgz1y8kEKoJlXBvbU5Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657695; c=relaxed/simple;
	bh=AE9Noqmo5uf+veS2O3CDwEL+CpTTa4rXR/egOPbJoFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byBYtf5yzpPKWTsmaAcoOwHlvSIu5T6yOVTQmBZrd2W1+05sxd47HCzjWrw2x/sJrQCNK/lXLy2ThGL8oVb9LI/2HAiRO5gJr4NO1Hm1IvFUslQB0qSMeRX8e2GAvi4ufnxDHQ3ZeAoUxXgfQ7lko1Zo79feN5Ti7Ml17S2Rl08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhnG2KNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhnG2KNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BCA1F000E9;
	Tue, 21 Jul 2026 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657694;
	bh=SCl3T7HWhk0o9RxEohBv/NZ8WmjhhwLJjmb9YxiPIHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhnG2KNL3ED988xDSlOVIlXUPrvuevuPKUsEhFJ8nFT3J+FITvlf+NBbBxGrzH7dI
	 YeWMHJVKecV1X0AOcPhI50L1hICJC70FlyeIz/9C4v5kC/bjOXOOZyGy2YIW6YG3De
	 uXjWHiBuKOuvSM3W84z/Xye5Z/lAa2PbIgjZUM/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0862/1611] net: marvell: prestera: initialize err in prestera_port_sfp_bind
Date: Tue, 21 Jul 2026 17:16:18 +0200
Message-ID: <20260721152534.779331359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 65e7ef033bde5a..84ff651dd058b5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -373,7 +373,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 	struct device_node *ports, *node;
 	struct fwnode_handle *fwnode;
 	struct phylink *phy_link;
-	int err;
+	int err = 0;
 
 	if (!sw->np)
 		return 0;
-- 
2.53.0



