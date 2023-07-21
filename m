Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F6E1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F93C433C8;
	Fri, 21 Jul 2023 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955948;
	bh=PIMcGzkA9rBskh2hjqVFdCnySKThQMaTWi4wW3Dw+0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDMfyx47oVK9q2EOA15evhofUdAQqC2+3pUdZJ97jWwbVewMoueQAoSr/emQ7sCL7
	 KDUwnHo35kB8VO7ffbEg2ILsYAfRC7drfIS2I1WZgKuit95JqijVLjY1TxMEv7YJOi
	 SB+qO+Zb2Y2REso+7jpUZMNQuiPtFnW7J8zmMeY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 087/292] net: dsa: Removed unneeded of_node_put in felix_parse_ports_node
Date: Fri, 21 Jul 2023 18:03:16 +0200
Message-ID: <20230721160532.539625837@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit 04499f28b40bfc24f20b0e2331008bb90a54a6cf ]

Remove unnecessary of_node_put from the continue path to prevent
child node from being released twice, which could avoid resource
leak or other unexpected issues.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: de879a016a94 ("net: dsa: felix: add functionality when not all ports are supported")
Link: https://lore.kernel.org/r/20230710031859.36784-1-luhongfei@vivo.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 8348da2b3c97a..d78b4bd4787e8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1286,7 +1286,6 @@ static int felix_parse_ports_node(struct felix *felix,
 		if (err < 0) {
 			dev_info(dev, "Unsupported PHY mode %s on port %d\n",
 				 phy_modes(phy_mode), port);
-			of_node_put(child);
 
 			/* Leave port_phy_modes[port] = 0, which is also
 			 * PHY_INTERFACE_MODE_NA. This will perform a
-- 
2.39.2



