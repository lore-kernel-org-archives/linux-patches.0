Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412641D551;
	Wed,  2 Oct 2024 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879926; cv=none; b=mHVv3msSVXw2pPLlwIB8kcBmyfNsYaHvFBQzmemvlCOlVwP02I1BsAn79GeYKASod9FJqEGIosMs10ynlFpu3JXrakNGQgT+hEa+uyjr0gcM0y42JOLunTuMZLI96EzICasohDtKo1Q+qUnW2ynLKlS9iOsKdtIxZev5K8+AKYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879926; c=relaxed/simple;
	bh=xZ8SB3Ejmqxn1parzHuYi0eJWHTinqSWTmRJOVBHvgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suq8ewoeplWK9S9biPG61tJqnHRwHCfX0q/eSJi12OOuuHZgblqSkFotBPGo/8dLlx5vtg2jzoyLnzx27xhcPx78BWbo3wvT3aQsS5h3UwtWPgdzFOiUMjUdIljIHJAKYzriduK45wGuzaP1IKifQVv56L3wYaGxz/MjfDr3q0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhKOlXoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhKOlXoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3737C4CECF;
	Wed,  2 Oct 2024 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879926;
	bh=xZ8SB3Ejmqxn1parzHuYi0eJWHTinqSWTmRJOVBHvgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhKOlXoXVF0BHZ5PkY2FhsWtKl2nOhDxPouJ88VvOQN13dBVvC+DNLjqZC8mTwM7d
	 xxRD2YStI5zzYXg+3U5Wtu6Bx7HGQPrwbNa+vNbNBHv3/H7eAN7S1/bpG0DGLdKqd0
	 PiK5RD6a3fqMziY/icNIU3bcDm6C+VddVORb9kUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/538] PCI: keystone: Fix if-statement expression in ks_pcie_quirk()
Date: Wed,  2 Oct 2024 14:58:44 +0200
Message-ID: <20241002125803.505536112@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c1dedc83759c6..c5475830c835f 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -579,7 +579,7 @@ static void ks_pcie_quirk(struct pci_dev *dev)
 	 */
 	if (pci_match_id(am6_pci_devids, bridge)) {
 		bridge_dev = pci_get_host_bridge_device(dev);
-		if (!bridge_dev && !bridge_dev->parent)
+		if (!bridge_dev || !bridge_dev->parent)
 			return;
 
 		ks_pcie = dev_get_drvdata(bridge_dev->parent);
-- 
2.43.0



