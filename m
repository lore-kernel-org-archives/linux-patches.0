Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8821CB302;
	Thu,  6 Jun 2024 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683752; cv=none; b=AmSuQhfDLdb8UcUqivnh7QD+u1LYcZvW/sLPIif8RCh2d6xZX4StTXje6ifTN23J26CHefs7gpURmMCjgfMVaXSgWdBtxexDhkZ2ngN6A2tLAdkBlgK/MUaLQ8ij63O7TEN2kK9x0wgY5z5cqOrEsq0A87sA0TZ3BPzV2VWI4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683752; c=relaxed/simple;
	bh=EmFyl/dsc/3YLguhPxtv7jHrBVBhvepHyoZYxSStRHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEREvSYO5IEnnc4m39jPqvsVm+Kv2l2L2SGZ/w7zLqH/gimPbRl25355LwaSlny9CH5axTe4a4CpkImTt03TAhuVbh9QEWDfLRUzCq78M3voCevA2e7+UUy3QOemGmQJAI9Se1cWK5icv+Qul/n66+JYkEtPVKC5toTbIU23oLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8Q3/ew3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8Q3/ew3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7D3C2BD10;
	Thu,  6 Jun 2024 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683752;
	bh=EmFyl/dsc/3YLguhPxtv7jHrBVBhvepHyoZYxSStRHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8Q3/ew3htQBi1Q69BJvA6LDwnL7v2BiiNK0r/Nek+0oFMJwgwwhydbUaSQzQVfbW
	 RGXkNz6HVbTQm1ox/DhfjC0yXSIXyrm5KNZe4Cx39McGaHVVBU62ebG0kB0DyRplsu
	 ibg5fTgpBrdC2g7offmaJqV3YY8vP+4kJ8OeUnhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Jerry Ray <jerry.ray@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 722/744] net: dsa: microchip: fix RGMII error in KSZ DSA driver
Date: Thu,  6 Jun 2024 16:06:34 +0200
Message-ID: <20240606131755.620765720@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 278d65ccdadb5f0fa0ceaf7b9cc97b305cd72822 ]

The driver should return RMII interface when XMII is running in RMII mode.

Fixes: 0ab7f6bf1675 ("net: dsa: microchip: ksz9477: use common xmii function")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Acked-by: Jerry Ray <jerry.ray@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/1716932066-3342-1-git-send-email-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 286e20f340e5c..3c2a2b5290e5b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2864,7 +2864,7 @@ phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit)
 		else
 			interface = PHY_INTERFACE_MODE_MII;
 	} else if (val == bitval[P_RMII_SEL]) {
-		interface = PHY_INTERFACE_MODE_RGMII;
+		interface = PHY_INTERFACE_MODE_RMII;
 	} else {
 		interface = PHY_INTERFACE_MODE_RGMII;
 		if (data8 & P_RGMII_ID_EG_ENABLE)
-- 
2.43.0



