Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF1C39FC6;
	Fri, 24 Nov 2023 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4Y+mlND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F17C433C7;
	Fri, 24 Nov 2023 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849239;
	bh=rMlPqBrvQHbqh58bnkGEpNdhU/ehTjGCl8aTtLTE3Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4Y+mlND1Kzka53RAhqtK7N2h9Vi5G+SDbmKsOseqGsh07XvqqB2IaBQ9y2Y0Sef5
	 kFoHxYUsIS46dqp8ABodt5Rxqyh06HKg9a2NZ9wIqf+wiPeVMMwOZgLVUb36/D+Qhb
	 agQpI64YbjgxgMy2uT/XGAUqD7Ux+mPerm7jeNHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/530] PCI: mvebu: Use FIELD_PREP() with Link Width
Date: Fri, 24 Nov 2023 17:44:28 +0000
Message-ID: <20231124172031.223720609@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 408599ec561ad5862cda4f107626009f6fa97a74 ]

mvebu_pcie_setup_hw() setups the Maximum Link Width field in the Link
Capabilities registers using an open-coded variant of FIELD_PREP() with
a literal in shift. Improve readability by using
FIELD_PREP(PCI_EXP_LNKCAP_MLW, ...).

Link: https://lore.kernel.org/r/20230919125648.1920-6-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 60810a1fbfb75..29fe09c99e7d9 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -264,7 +264,7 @@ static void mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
 	 */
 	lnkcap = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_LNKCAP);
 	lnkcap &= ~PCI_EXP_LNKCAP_MLW;
-	lnkcap |= (port->is_x4 ? 4 : 1) << 4;
+	lnkcap |= FIELD_PREP(PCI_EXP_LNKCAP_MLW, port->is_x4 ? 4 : 1);
 	mvebu_writel(port, lnkcap, PCIE_CAP_PCIEXP + PCI_EXP_LNKCAP);
 
 	/* Disable Root Bridge I/O space, memory space and bus mastering. */
-- 
2.42.0



