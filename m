Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB4246AED7;
	Mon, 20 Apr 2026 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691834; cv=none; b=ZywW2BMPLHP0lqHOzoVA1BE0tIBNNoIx0JKw4jVvsQkMvYSEr7jC3nEYEqtOpl/UUsYwzLU3lQ0QZapjkKZ9G+NCDLTjksns+PZWNIKS92m72NmAMfgFZgf4Ai5naAKVP9l79ViGBcry5c/fHmHd6OpC++c6H+pL36v1qLXPDCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691834; c=relaxed/simple;
	bh=bt6berltNkf1U5kZkT4GAds6cfIlcXXFyCAGAFYAT6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5/i0ioFMBuedOCW+tKDTsI9ULrhFDXyQYCr+BjW9y9KD5p6SKMLc+23GO0+/Mi4QKqcN3/vYeJSECRZlBkkC2sKFy0QhGRjv8/vCttrDcaHMGkHhMxqdzsYRPsgzYs4J1AzYLUl/c7vkn428ywcxZpKbEi2fybNIVxZtiLsGfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdjPVbJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdjPVbJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A96C2BCB4;
	Mon, 20 Apr 2026 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691833;
	bh=bt6berltNkf1U5kZkT4GAds6cfIlcXXFyCAGAFYAT6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdjPVbJkSPs7r5KL2YqUWgoj/wsmceQTgIMdqaiyOEaSGxeKaJB2DcFqxNA8W4EtZ
	 LvR2gGEvIkLR6YuH0Fc1INaJ7c7SaNWk7B6nUFvfpDEDY/HIVIrh/bllq9qNs4BdBJ
	 BO8DBP07xjfv8HXRTbHGheC53vBIJoxD7BOXPglASylAcKBvm7CguT1kQtFO1F+ya3
	 4ioXhtiLlSoDaL3TTd3F01bvqXGFyIO8pNGkuxkWP3K8XzztoOQZwq0hCrXPRyuDkk
	 VsG2PnmMoJIk6SYiUmpKoEJKLpbC3P61yEIT57Lwlgmz1ozO3YO+hWkSDL3xmVxHJF
	 SNUUkASmmb7vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	chris.packham@alliedtelesis.co.nz,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: mdio: realtek-rtl9300: use scoped device_for_each_child_node loop
Date: Mon, 20 Apr 2026 09:20:16 -0400
Message-ID: <20260420132314.1023554-222-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c09ea768bdb975e828f8e17293c397c3d14ad85d ]

Switch to device_for_each_child_node_scoped() to auto-release fwnode
references on early exit.

Fixes: 24e31e474769 ("net: mdio: Add RTL9300 MDIO driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260405-rtl9300-v1-1-08e4499cf944@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/mdio/mdio-realtek-rtl9300.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-realtek-rtl9300.c b/drivers/net/mdio/mdio-realtek-rtl9300.c
index 405a07075dd11..8d5fb014ca06c 100644
--- a/drivers/net/mdio/mdio-realtek-rtl9300.c
+++ b/drivers/net/mdio/mdio-realtek-rtl9300.c
@@ -466,7 +466,6 @@ static int rtl9300_mdiobus_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rtl9300_mdio_priv *priv;
-	struct fwnode_handle *child;
 	int err;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -487,7 +486,7 @@ static int rtl9300_mdiobus_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	device_for_each_child_node(dev, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		err = rtl9300_mdiobus_probe_one(dev, priv, child);
 		if (err)
 			return err;
-- 
2.53.0

