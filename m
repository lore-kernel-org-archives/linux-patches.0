Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BED26ED5E;
	Tue, 11 Nov 2025 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824469; cv=none; b=INYGPEUBfHfaclfHXRFoZ5Qbabsm7Ls57Jm2OIcTy2f0LbacX/DyMPYRpgZCdrd+2E40GosgepvcicsCXuwKTqqnc1/IZXHouThezhRc+pX2ur2+571w49brWwU9K1zwo8pBU4+wR6GIrkwu6rR5unhS/AEiIeEy509DI8Ev49k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824469; c=relaxed/simple;
	bh=dCATCRaAn34DO2/+ThL+Vvc96E4HJiUnRmkdHFvYFCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSf0WtMYeB6SrhRYM1v6Jb21OQO9bVg2ZaV+lrddYWdBGnCPuup1pAs7ZDDr9YM99dWxghYel4jGkVufrWk317JdJibndHm3gfDYzcbFf8K6Oga1cdk0a5TALcSOfgBTOn1ON6Ulf3MA4uw3Ec7bE2EpXlXVVTu88y1vqyMhlCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVs6Pmdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVs6Pmdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C393C116B1;
	Tue, 11 Nov 2025 01:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824469;
	bh=dCATCRaAn34DO2/+ThL+Vvc96E4HJiUnRmkdHFvYFCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVs6PmdmzhdO/T+VihQn1UK297LZtQtthp3ztkeJQ/Y29QW11WyW/0V8F+BfbAvFy
	 tKElZKQil/Ej65dCaZt1KgvZZ/TglTzoTLXohwQ2ilC6zXcNOMkNewWcwhdTNNfnt5
	 hkdMl4/kJANIwLgRh73piPhOnQ80Jygm0NEC+aB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Dege <michael.dege@renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 506/849] phy: renesas: r8a779f0-ether-serdes: add new step added to latest datasheet
Date: Tue, 11 Nov 2025 09:41:16 +0900
Message-ID: <20251111004548.663862233@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3b2d8cef75e52..4d12d091b0ab0 100644
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
@@ -274,6 +281,7 @@ static int r8a779f0_eth_serdes_hw_init_late(struct r8a779f0_eth_serdes_channel
 *channel)
 {
 	int ret;
+	u32 val;
 
 	ret = r8a779f0_eth_serdes_chan_setting(channel);
 	if (ret)
@@ -287,6 +295,26 @@ static int r8a779f0_eth_serdes_hw_init_late(struct r8a779f0_eth_serdes_channel
 
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



