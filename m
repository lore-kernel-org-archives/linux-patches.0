Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CC219B3FF;
	Tue, 15 Oct 2024 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992839; cv=none; b=DHtxIhmMVCvZSHrH1Ey3UZuZgV9he7XAOlPCvDb0sFYou0tDXui2nfNuwiUI9iTwYE2pzKqRvqCtnSDS0WEhts6aGU++MGCadDqfsRF0ML18pQKhhDdWMFUnzUa8TJU+WyO+GEKGleRUjLW7L2YgIw9kBhrTVB9Nar6V+0dg1n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992839; c=relaxed/simple;
	bh=/wTJetyUZ7LsfOSxDwpwcP9U68ymWNnfbx0/lreH8Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gI6ECWSTPsaDj3Lply6uHOO0s68Iok7cfX2bymY1SQ2q1Djj9RY09U/1xbq2wwcNBLW1HgtanBh7uirCpPs/kC7FtQGAfbTB/9yUPuGJE++JQVLfH8rXDNrO5UhXBEnWyMCnff7ojfJJk5VRreZUEbrK3ae4sEeFloJfggMNPuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZRCpXsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZRCpXsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A12C4CEC6;
	Tue, 15 Oct 2024 11:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992839;
	bh=/wTJetyUZ7LsfOSxDwpwcP9U68ymWNnfbx0/lreH8Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZRCpXsRwk0cKbGoYiwAe194QckfdL/YTLoaQy7McsIsGPzKTA9EUe7pFyviN4wXZ
	 SnS2yOWqXVzxZdRrOtEtKn2xHrKOJTCXQ0nj3wsofFnGqwD2u37RcHWDOW/XMGkYsv
	 SS1t5cfdwK17rIoXgWWWCXy1fwQckPN92L/GSO7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/691] PCI: keystone: Fix if-statement expression in ks_pcie_quirk()
Date: Tue, 15 Oct 2024 13:23:01 +0200
Message-ID: <20241015112449.606045269@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 24031123a5504..80eb0c04bc59d 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -589,7 +589,7 @@ static void ks_pcie_quirk(struct pci_dev *dev)
 	 */
 	if (pci_match_id(am6_pci_devids, bridge)) {
 		bridge_dev = pci_get_host_bridge_device(dev);
-		if (!bridge_dev && !bridge_dev->parent)
+		if (!bridge_dev || !bridge_dev->parent)
 			return;
 
 		ks_pcie = dev_get_drvdata(bridge_dev->parent);
-- 
2.43.0



