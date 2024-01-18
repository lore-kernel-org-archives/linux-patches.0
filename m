Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2311B96D;
	Thu, 18 Jan 2024 10:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575296; cv=none; b=VLTXbH8x94HFwepRVtYcXDLvm0etCqz+a0g0/W+9u8uLB/L+VVij589Ui2ouOm8wU5bjfp8wNfEv8Od/sIIdk7lcNGzGOsjt3UMcC/QrPyYg2M7zRI160hip/A2eruRQNSElPNlcAHfDS6LBS4STpmLJUxVPDL8DRlkmH0zFImg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575296; c=relaxed/simple;
	bh=d0IvE5PS3GnqVomaDW8D0lqQckBjSy+WJtwKNMTO0AY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gn8l1EvZMRIpQG87Pl0VkaWGI824KFkXREaUSer34jjvP2mMOmq3N/Wf4FoEey7jt2O2JRe6XplBWeJ4indX6zylBHpfHoMbagJDezt2Fh/g3GfSXoCXp46FlrlO49cpae2/Svp2GWsn1rZIjWAiQQBOQlRfXrJ8tsUsQV+ecUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjrgpiiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjrgpiiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30517C433C7;
	Thu, 18 Jan 2024 10:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575296;
	bh=d0IvE5PS3GnqVomaDW8D0lqQckBjSy+WJtwKNMTO0AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjrgpiiDtmaH6p9af7e/7QEKi6Qbfs2iQRRpH7dX+ZgXLSfqZhTGGq3Y/CcD6+nxY
	 PJHG2MJLxZK3sdXm3uS2Y1e3Ys9+ZKHLXib4ds075P1oiqSFqKS5q2WBtxVuEBxmJs
	 V1rtK536q7IUHRBAVXZmxv8958y86ne5CCu2QtfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Yanteng Si <siyanteng@loongson.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/150] stmmac: dwmac-loongson: drop useless check for compatible fallback
Date: Thu, 18 Jan 2024 11:48:23 +0100
Message-ID: <20240118104323.707606170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 31fea092c6f9f8fb2c40a08137907f5fbeae55dd ]

Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
so checking for some other compatible does not make sense.  It cannot be
bound to unsupported platform.

Drop useless, incorrect (space in between) and undocumented compatible.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index e7701326adc6..9e40c28d453a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -59,11 +59,6 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		return -ENODEV;
 	}
 
-	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
-		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
-		return -ENODEV;
-	}
-
 	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
 	if (!plat)
 		return -ENOMEM;
-- 
2.43.0



