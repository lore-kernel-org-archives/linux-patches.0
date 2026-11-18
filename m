Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029734;
	b=tXu7Wc7J814UA080ZDv4Tu+P03kVAlrmJn6d8tU1kivt6zigangnEtREShAVuOqSIO1P
	 rCWV5JKwn2V8UrGykwfCoFLya4M3YuBkC8P9U+XpMYFaLTZDZPx6knw6BsHRbNRTybSN6
	 BLDoFor3JTZpzQvsKqIiPvP5WMDlh6b5vv0ZMty/Vzkp7nh4oWmnt52bGIuVJA1o10kUa
	 oSA/FFgnFo1U90ER/ABGDvzAgrR7MQLA0vpQIg/M/72L45XJVfQS5uArJzGo1H/HkI5of
	 sAdSP33AmIMZRJcDGZrK/Hi6nwWdOl2W3sOWPI9cv1JI56dqTvvbnSuQAq179m8Fygw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wH0futqTIasqSbDvA0L9l6BpQcFLzU2hkPO8rme9j+w=;
	b=fDewzUUGBN3DW0cNT0hlT+304/9qxNuhC5jSK4mDtsl//huzQQkp31WUwC466ygcoz5C
	 gdWR80OpK88FGqsgItkTXQvLSi3qAhPVZCwQKCaMACxdXI52u+zEy1IcB6B11+IIWGX/J
	 2vj96vPRIuXHuwmd+GjIFl8BpuRlodsRD9qpqVRe7/+KCIVRdigREJ+PHiZbzv1LK04w+
	 qSznYX4E/g62Th+TE7fPU10ZlYDTtyJEtRlhwU5esUWgs8e8jhIg0QeMOVe2kjsKyLv5P
	 3Y85BdtbvNGLwiy+4DuNjqGn2cr5JWpcIQad5aOz8m/CBvfKHpG8ctAMLBm9EB2D1jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlBJCfHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC27606A325;
	Wed, 18 Nov 2026 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlBJCfHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39711F000C9;
	Wed, 18 Nov 2026 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029734;
	bh=wH0futqTIasqSbDvA0L9l6BpQcFLzU2hkPO8rme9j+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlBJCfHAuCza0YZrwM8n7SqxDrovKB+UtNy3H9QNRowp46cR1yMr4tkc82qB3QbCI
	 IaX2tBfWa5Ye8VhKD4D8NUTfV3Wt2Jv0B4jvCHKJ8HQpEpmKYsUImh4DRMmiMHx6Fv
	 DaIVX3E05M0nDrFYX2zBRwFxeeY4nI0fUvfccwek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0454/1756] PCI: dra7xx: Fix clock enable leak on probe failure
Date: Wed, 18 Nov 2026 15:43:01 +0100
Message-ID: <20261118150026.859845773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 768e5d0936d00d663ce2b8c192cc6ab0b61ad461 ]

dra7xx_pcie_probe() enables the optional clock but never disables it
when probing fails afterwards.

Switch to devm_clk_get_optional_enabled(), which disables the clock
automatically on failure.

Fixes: 5af9405397bf ("PCI: dra7xx: Get an optional clock")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260822-dra7xx-v1-1-23e204d5548b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-dra7xx.c b/drivers/pci/controller/dwc/pci-dra7xx.c
index e9e361f498af8..8ceca3ede34ad 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -744,15 +744,11 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!phy)
 		return -ENOMEM;
 
-	dra7xx->clk = devm_clk_get_optional(dev, NULL);
+	dra7xx->clk = devm_clk_get_optional_enabled(dev, NULL);
 	if (IS_ERR(dra7xx->clk))
 		return dev_err_probe(dev, PTR_ERR(dra7xx->clk),
 				     "clock request failed");
 
-	ret = clk_prepare_enable(dra7xx->clk);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < phy_count; i++) {
 		snprintf(name, sizeof(name), "pcie-phy%d", i);
 		phy[i] = devm_phy_get(dev, name);
-- 
2.53.0



