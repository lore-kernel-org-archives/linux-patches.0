Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9BE34DB4D;
	Fri, 21 Nov 2025 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732793; cv=none; b=BveFzAGqwwZ61JMltmww/+CvCa3HZy8NDtTHzSeLT/is/AK5HcluwKN0Yy2W0MVtcF7dCsN8jC5krqVQqIGfnr0WDriFKisoKfj9sISayLWpwqX99a1cvf+5ndbCHj8RKPhsW2/rJ20+kyQRGMvxahrqxcUP3bJP8dtwjr47MU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732793; c=relaxed/simple;
	bh=l9QG54mkN75DKNSTVYL+Wqm/e30eqOk+pDzjmFtB4sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afqd+WT/a1EOc9UUcPr50tbJNBgsxGX/u9LOpHGX9/10NZe35sTQJCGFhKHlBSz+U72mLf0tJzlnND1vM3o6U1Af3erzKA3g8f40fgUmEJWJWSGaRK+ryrRML3VyRofR3lvgRjfPP9lJhP37P8D3Ns6aS5q5czmTk6Apx2lorXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8L4M614; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8L4M614"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EF6C4CEF1;
	Fri, 21 Nov 2025 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732793;
	bh=l9QG54mkN75DKNSTVYL+Wqm/e30eqOk+pDzjmFtB4sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8L4M6142BXuS7inA+fPXJYl8kyATcys3DabT0fBxeBHGunNp8nSaGYkCkYX0la5S
	 XoZ0L6UOaAvimy1Mo2ZXg2bYPrfcbVyD/2CZngxPXAyMyJGIXRFoZXobXoelAOUijw
	 FSC6oJgYP6lTiizmevcbwuxRjRddJehLXS5mm+M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Dege <michael.dege@renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/529] phy: renesas: r8a779f0-ether-serdes: add new step added to latest datasheet
Date: Fri, 21 Nov 2025 14:08:31 +0100
Message-ID: <20251121130238.558043846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Michael Dege <michael.dege@renesas.com>

[ Upstream commit e4a8db93b5ec9bca1cc66b295544899e3afd5e86 ]

R-Car S4-8 datasheet Rev.1.20 describes some additional register
settings at the end of the initialization.

Signed-off-by: Michael Dege <michael.dege@renesas.com>
Link: https://lore.kernel.org/r/20250703-renesas-serdes-update-v4-2-1db5629cac2b@renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/r8a779f0-ether-serdes.c | 28 +++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/phy/renesas/r8a779f0-ether-serdes.c b/drivers/phy/renesas/r8a779f0-ether-serdes.c
index 683b19bc411a8..59546301a6b9e 100644
--- a/drivers/phy/renesas/r8a779f0-ether-serdes.c
+++ b/drivers/phy/renesas/r8a779f0-ether-serdes.c
@@ -49,6 +49,13 @@ static void r8a779f0_eth_serdes_write32(void __iomem *addr, u32 offs, u32 bank,
 	iowrite32(data, addr + offs);
 }
 
+static u32 r8a779f0_eth_serdes_read32(void __iomem *addr, u32 offs,  u32 bank)
+{
+	iowrite32(bank, addr + R8A779F0_ETH_SERDES_BANK_SELECT);
+
+	return ioread32(addr + offs);
+}
+
 static int
 r8a779f0_eth_serdes_reg_wait(struct r8a779f0_eth_serdes_channel *channel,
 			     u32 offs, u32 bank, u32 mask, u32 expected)
@@ -261,6 +268,7 @@ static int r8a779f0_eth_serdes_hw_init_late(struct r8a779f0_eth_serdes_channel
 *channel)
 {
 	int ret;
+	u32 val;
 
 	ret = r8a779f0_eth_serdes_chan_setting(channel);
 	if (ret)
@@ -274,6 +282,26 @@ static int r8a779f0_eth_serdes_hw_init_late(struct r8a779f0_eth_serdes_channel
 
 	r8a779f0_eth_serdes_write32(channel->addr, 0x03d0, 0x380, 0x0000);
 
+	val = r8a779f0_eth_serdes_read32(channel->addr, 0x00c0, 0x180);
+	r8a779f0_eth_serdes_write32(channel->addr, 0x00c0, 0x180, val | BIT(8));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0100, 0x180, BIT(0), 1);
+	if (ret)
+		return ret;
+	r8a779f0_eth_serdes_write32(channel->addr, 0x00c0, 0x180, val & ~BIT(8));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0100, 0x180, BIT(0), 0);
+	if (ret)
+		return ret;
+
+	val = r8a779f0_eth_serdes_read32(channel->addr, 0x0144, 0x180);
+	r8a779f0_eth_serdes_write32(channel->addr, 0x0144, 0x180, val | BIT(4));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0180, 0x180, BIT(0), 1);
+	if (ret)
+		return ret;
+	r8a779f0_eth_serdes_write32(channel->addr, 0x0144, 0x180, val & ~BIT(4));
+	ret = r8a779f0_eth_serdes_reg_wait(channel, 0x0180, 0x180, BIT(0), 0);
+	if (ret)
+		return ret;
+
 	return r8a779f0_eth_serdes_monitor_linkup(channel);
 }
 
-- 
2.51.0



