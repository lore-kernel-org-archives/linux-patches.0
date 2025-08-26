Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A346134F490;
	Tue, 26 Aug 2025 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217937; cv=none; b=C+UYl3Qzo+G/8xMU8u20qJzHnxLRbviZG2RfQzOlNDXb2Qyy3+Oghwx8Dyze3ZspxXcJJJzGVqM/B/ANLs56peIziExfPJzuJfoy6k1zFUUiivkAcYHRPI6Z+4Im7P+t2rgAi15KTQrcVpQyfnfZG643J8UDpGf+sWNAaPPNtkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217937; c=relaxed/simple;
	bh=3JmrLNp0ioVE09QqUON8IEX4xrtkiyAJ3m1Ih8jT5Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=prVAqxESTU6Xxxmaf4FYNv8J4WcPnDqAWgI5EEnv4rJADe/V4JgwIDW3WcKsoCpEgM3FBU+9Eziit8Ohyu6A3MLgaCBreiG4MGFoL7D57c9lZy7Cz6cLRMC2IIvl60d+rvWwD73PMuhfLYf5rg/fnuLlA4dA4pH69cVEgDcnR2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwJ7RbHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwJ7RbHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87348C113CF;
	Tue, 26 Aug 2025 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217936;
	bh=3JmrLNp0ioVE09QqUON8IEX4xrtkiyAJ3m1Ih8jT5Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwJ7RbHH0nzVZMCjKMaztQr8UOe6xxvbkdLRO5SpliMsiEyUstg4m2aqKR+DpZmm+
	 fWoFehkq1PVAjIHNlwRhPbu0PGVblURjBY4JqbCwMDMyMagIB+/dDAcITucOS4y8fr
	 XfJNNGJ9SDmtvUdt8wTTYNn44fScyJnlVZtS9psI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/523] net: phy: smsc: add proper reset flags for LAN8710A
Date: Tue, 26 Aug 2025 13:09:00 +0200
Message-ID: <20250826110932.617413188@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d860a2626b13..c799c6505767 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -427,6 +427,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 	.remove		= smsc_phy_remove,
 
-- 
2.39.5



