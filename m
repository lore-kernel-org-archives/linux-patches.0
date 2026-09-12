Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D1D247280;
	Sat, 12 Sep 2026 11:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212519; cv=none; b=ZyspAVvYrYvUxBlLLy38wabmzKjI67SyCE0tJF3UM5OoX5o4fd+GeLc/mWTxUmQl290jsVVKGkGqYqwT+uPL4UYZKgGMhnUQt1NN2Tb9vFxXR9sIbNLSiRjsrP0b6PnS+mt0AR4vF/GMcSODjW15pKGKY41/g7ynWrEWka8MwvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212519; c=relaxed/simple;
	bh=oti+yoYYYOmdFWBa3SXQXITjqSdJG0XYc3f4MBIOoNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2EWng8VN5K3GV/XSumQZAnBGg8V1Ov18p2nyAwAlPScOS4siHUOwMCIybPEhopfKNMYK6qdu5DFA2K8R0Tw3NG33Z5CJV5ED/XylCOYIvUkN1mzT2LUxOafKm9fXk/Mtrb0IWpmD2TgV9YTZy4mkeBhdyRhKKybbdAbrv0JuFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFv4JD+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFv4JD+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0559C1F000FF;
	Sat, 12 Sep 2026 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212518;
	bh=/5vSFmgL+0IffU8qqToh78jLT9sfvuac4kh+SZG7nBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFv4JD+7cSXxh9eNFFVd0vZYzlWWBnCFeQ7jSHffTdHOI3gXrHBkHssKqGhSkQ8Jx
	 gI0u3PgtaNbuW8QQtBjsHxgTyritL/Xrqiruo0YdNTQtrTzSsDG9Jm+9g46+bkHXAK
	 YGTuUChvgkI3/5HlDnQ/dnxBIx8UgqOFy6bZbFjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1452/1518] net: stmmac: dwmac4: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:00:21 +0200
Message-ID: <20260912065656.401778643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 82187f42c014d22520b9c3c4e2cfb519223fb29b ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-4-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 1f61177ece453..666aed0906b5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -515,7 +515,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.53.0



