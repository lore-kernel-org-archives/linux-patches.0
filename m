Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C811346E003;
	Tue, 21 Jul 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656689; cv=none; b=RGTfvU5+HWYgksq58cV07tlblgvdIpHSTyUkcnIYs+VvDvVySZ1ZgENXhv7KlIivarQ3VAofqc/nvoGGF/EBJoUQLc4WS5twmcc423QOUUjaoXUxGmnFozsaXkuwHaNceoAy1pGQdz0O9ZH6iA68J/NQU0JzTUi33k1VhUQ7Dg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656689; c=relaxed/simple;
	bh=+TxDx68b+hdsTv7NUhodGKYZmdBEDOSPXwQr4DEUd3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osOU/YmK06ZIKb6m6pG4uxQFMEN2X+Dq5nHumw5dkq6euZOakZBOuQG/AOGdgNCt4859r+1uK3yWxr4S0FVgsq93IBKh+2Z8bUxwIhE51qqLRS3CTLxBfEVL3Ql5cyCeRPLf+gEpLCJGLxJmGy7pq9umw/2EU52JAY61j0exnE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucTDK63a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucTDK63a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD3E1F00A3A;
	Tue, 21 Jul 2026 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656684;
	bh=re/URXOofZvWmD19nRBuktg9sjy/73Z/tsYDNCyq0k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucTDK63a1cF79m+wPuEwXBmJMDMkWw85isbXBFqMchZNwmB6/Sq2TL/9kod5IjZtO
	 GlodAtxfofsvT3e+QQ3c3jlBEaqdXHPBHkhx1zdVKkq0A6RshDsYd7v9tDWpSGxUbV
	 tXBbeO9vfIlJpsLboXRQ95v72QEdbC/p10c6QjoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0481/1611] net: dsa: qca8k: fix led devicename when using external mdio bus
Date: Tue, 21 Jul 2026 17:09:57 +0200
Message-ID: <20260721152526.150917408@linuxfoundation.org>
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 0b7b378ce6cafbb948786cb6f17f406d94016c8c ]

The qca8k dsa switch can use either an external or internal mdio bus.
This depends on whether the mdio node is defined under the switch node
itself. Upon registering the internal mdio bus, the internal_mdio_bus
of the dsa switch is assigned to this bus. When an external mdio bus is
used, the driver still uses the internal_mdio_bus id which is used to
create the device names of the leds.
This leads to the leds being prefixed with '(efault)' as the
internal_mii_bus is null. So let's fix this by adding a null check and
use the devicename of the external bus instead when an external bus is
configured.

Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260608-qca8k-leds-fix-v3-1-a915bb2f37ae@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-leds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 43ac68052baf9f..ef496e345a4e7d 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -429,7 +429,8 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		init_data.fwnode = led;
 		init_data.devname_mandatory = true;
 		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d",
-						 priv->internal_mdio_bus->id,
+						 priv->internal_mdio_bus ?
+						 priv->internal_mdio_bus->id : priv->bus->id,
 						 port_num);
 		if (!init_data.devicename) {
 			fwnode_handle_put(led);
-- 
2.53.0



