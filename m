Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D2D336EC9;
	Fri, 17 Oct 2025 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715626; cv=none; b=KqoV39qJt4OBqqLBndxZl+0O2aZRcR/FNFfQKNyb+5DtjoYT9odWpSo57nBpGIDoqgTSXMsz3euLBlJY+/FHg78nR7fokc+GeL/RH6W4DDSgOTR87UcagZahDcsWxlzOnjgQJooMn4LxvUTCicei6xGc5LwGcu/cD80dXeQ1Zc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715626; c=relaxed/simple;
	bh=cExiwiU9oTVHmQDa8ORyvpU2/AdSXHbOaDfcjKFHbZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zoq/EG+swvNETALA3/BIEWBsD8Mmapteu0RSYEP2ewocQSDoa0S0IjD7VyWfsYyigjp27khfyp7GKIpnXmjJsJu9Y1Gs1iGxQPVxUVZyigAHa7Sh4PNbYfS0t+A56h2BzFLpiDUAhlTGfQn9hdeUUWoZIyDInSoZwfl+pZwjRnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3uzc0FC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3uzc0FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD03C4CEFE;
	Fri, 17 Oct 2025 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715626;
	bh=cExiwiU9oTVHmQDa8ORyvpU2/AdSXHbOaDfcjKFHbZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3uzc0FCDmgKjwZJQ9Ei7ARbYtTbfZUG4q+d4RI5N3+o69o7I8JCiTQ6sed7UMf0N
	 RV1H42a95TXA0TFTOuv7OjZHngSPD4H/CXl1c1NMfKP8v8x/H7kJ/DiXHVEgsaL9Ol
	 D8pi0Dx1Vw3nQBQGfwSmSskj7FXi04HQrPsL11JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.17 282/371] PCI: j721e: Fix module autoloading
Date: Fri, 17 Oct 2025 16:54:17 +0200
Message-ID: <20251017145212.278335192@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 9a7f144e18dc5f037d85a0f0d99524a574331098 upstream.

Commit a2790bf81f0f ("PCI: j721e: Add support to build as a loadable
module") added support to build the driver as a loadable module. However,
it did not add MODULE_DEVICE_TABLE() which is required for autoloading the
driver based on device table when it is built as a loadable module.

Fix it by adding MODULE_DEVICE_TABLE.

Fixes: a2790bf81f0f ("PCI: j721e: Add support to build as a loadable module")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250901120359.3410774-1-s-vadapalli@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 6c93f39d0288..cfca13a4c840 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -440,6 +440,7 @@ static const struct of_device_id of_j721e_pcie_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, of_j721e_pcie_match);
 
 static int j721e_pcie_probe(struct platform_device *pdev)
 {
-- 
2.51.0



