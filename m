Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C8322A37;
	Mon, 18 Aug 2025 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526108; cv=none; b=M/Agt4c5UF5Kwoagp6aHzJco8We6Ix4LY1rKWZdujac3GGHTdespZfehSld0CNzNvFweixXrZ2Hu7rV2PaO+y9HVv6J3OsQNJcuj0qxHol05uEjWKdXdaIuS37DzJvUQmN+TfEFjGAx/1cB9EUYY0Kv6bMat2dX1nApiRaXVpBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526108; c=relaxed/simple;
	bh=kj5CHvj6FCSiz3ogt34t4yOS1YSj64iDgZPQJ9Gs9/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HwRGKhPBQGqcvqjPspznSM2HRIv2vE1zJ/khA3w6ZeJUP7mQIywrwdtBOhCwTAlLqXAbw51RjVmS/f/WOMAaWthBvBdfLVzE3Jqe/9KIBITSba6pGHMtdeP/USiXsy2lmcy4aOARr8AbVGd23b07cNLOLBNHll1t211MVvDuRoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BacuxlVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BacuxlVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760D9C4CEEB;
	Mon, 18 Aug 2025 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526108;
	bh=kj5CHvj6FCSiz3ogt34t4yOS1YSj64iDgZPQJ9Gs9/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BacuxlVshyqB6USE+JyoZHdCutgFx/fO/ACZ7jrJ0w9de2aC0X9z0x3NxR9GdtS5X
	 YalYPK0D6umB1cGt3xH4mBYAxeeMQCxlyRjtBXX+DYG6ZVg+w8IhV9rngTz5jdY1Gi
	 AQT+lw2kNkyhU0QCad5Zjddv6fHqfyAiHt796ZHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 461/570] net: phy: smsc: add proper reset flags for LAN8710A
Date: Mon, 18 Aug 2025 14:47:28 +0200
Message-ID: <20250818124523.622258281@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index b6489da5cfcd..48487149c225 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -785,6 +785,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 
 	/* basic functions */
-- 
2.39.5



