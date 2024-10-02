Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB36D1CFEB6;
	Wed,  2 Oct 2024 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876220; cv=none; b=qad7PH6hGcUrxNUIAXlmapqE/zH1xZupnI5ghbXNebTur0U3iXB+gBOiHf8A2Xjz014jO4Mdq6k2x1ZlPJsviyDsLOMlwD4NfX1w8lIvTArVOnG0lciuxG6c/jokjDpLa1QDT60ie9Cmqo37Ts46IDnU33oBPy5HhI10yo6VYRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876220; c=relaxed/simple;
	bh=nrrmMEF/Zz1+0UMiCRn3RxCKCiulWTKxhVEi5i1uS0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gl+AfeAP4yJTcDwzMKJxpHvy2x0CLerG7kXQVbOZBhqFzL6EF+Bu5LigzsKD03+g3gelO6B7zGrmPgilzGOz/dZtBQD+9ImG/co6MeUaw3O6WIF0+BW/5JLh/sWMx4EfBMb5yxKASu1ryGOnRqD/k9LAOBE7LYTPk1ZCUyO4Vl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/xWd3LX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/xWd3LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3F0C4CEC5;
	Wed,  2 Oct 2024 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876220;
	bh=nrrmMEF/Zz1+0UMiCRn3RxCKCiulWTKxhVEi5i1uS0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/xWd3LXBScoer+dqSqAUyzIl9BS15W09DsAs5O4TZDtUFJeMGM0obEy2mL6JHwe5
	 rIdakZ1qmzIZaSmDpSGXitjD1xFSG1vyGmfR0gtvJuVfSgJESXfcLTwuu0sQrR357b
	 0mOBO5WQl26b7S1fyPsJUlHGcbwAvRcOz446yVvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 370/695] PCI: keystone: Fix if-statement expression in ks_pcie_quirk()
Date: Wed,  2 Oct 2024 14:56:08 +0200
Message-ID: <20241002125837.217609954@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6188a1c762eb9bbd444f47696eda77a5eae6207a ]

This code accidentally uses && where || was intended.  It potentially
results in a NULL dereference.

Thus, fix the if-statement expression to use the correct condition.

Fixes: 86f271f22bbb ("PCI: keystone: Add workaround for Errata #i2037 (AM65x SR 1.0)")
Link: https://lore.kernel.org/linux-pci/1b762a93-e1b2-4af3-8c04-c8843905c279@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 52c6420ae2003..95a471d6a586d 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -577,7 +577,7 @@ static void ks_pcie_quirk(struct pci_dev *dev)
 	 */
 	if (pci_match_id(am6_pci_devids, bridge)) {
 		bridge_dev = pci_get_host_bridge_device(dev);
-		if (!bridge_dev && !bridge_dev->parent)
+		if (!bridge_dev || !bridge_dev->parent)
 			return;
 
 		ks_pcie = dev_get_drvdata(bridge_dev->parent);
-- 
2.43.0



