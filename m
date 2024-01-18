Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB842033B;
	Thu, 18 Jan 2024 11:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575789; cv=none; b=Z+xVLpZYJ6VdBHhqvKiusV08K8ztXkxmJIUENN19AZWShAWtmQtNG0EwVhZllma1dV1rikvcWt9OkvxHEMUXf5K1VQlU7Lf2mm3bDIHmlsjn4ZZ2qaOcpGna/W0WeP0lR1yrHpcZdjstXsZPRUFrnTvQGXcGIOYnhrF8AomVCck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575789; c=relaxed/simple;
	bh=L0tOcuBVFsvTSWfc1D2YFpVcnI+kHARJtc7ZEWR8WTY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=eAHBOrmFFjC0Faf71a23uDryT6H+JAW6WIic6VCSj7M/9iz8Tr9E0YJjAmDrjGFCwuet4f2t9faEl5Gy9AM6zByMyiNF7tLQOdh0aqV+cryHOJSq65d9ut6e/So/qqb7JrjBZhxQbsr8VyaSJOCZFPC7tYP/Rp5DJmZpQ9aTOzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O52FrMoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O52FrMoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13229C433F1;
	Thu, 18 Jan 2024 11:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575789;
	bh=L0tOcuBVFsvTSWfc1D2YFpVcnI+kHARJtc7ZEWR8WTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O52FrMoGQUfxa6d4P/jLrwl3w2P7xSIOAVgTtMFybjWYdcE2aMkGKylHDvoAqOL9q
	 qZbFrIoUgvjqzlUy4KIZpNLe4ozmv7MpZxnVhYEudIbVizlpFnO1mwkNWyZSOD/e/K
	 BI3Hqzdd++ggQYFm3qqqoTEgE0qsvJzvdIY0h+qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LeoLiuoc <LeoLiu-oc@zhaoxin.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 098/100] PCI: Add ACS quirk for more Zhaoxin Root Ports
Date: Thu, 18 Jan 2024 11:49:46 +0100
Message-ID: <20240118104315.100684607@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LeoLiuoc <LeoLiu-oc@zhaoxin.com>

commit e367e3c765f5477b2e79da0f1399aed49e2d1e37 upstream.

Add more Root Port Device IDs to pci_quirk_zhaoxin_pcie_ports_acs() for
some new Zhaoxin platforms.

Fixes: 299bd044a6f3 ("PCI: Add ACS quirk for Zhaoxin Root/Downstream Ports")
Link: https://lore.kernel.org/r/20231211091543.735903-1-LeoLiu-oc@zhaoxin.com
Signed-off-by: LeoLiuoc <LeoLiu-oc@zhaoxin.com>
[bhelgaas: update subject, drop changelog, add Fixes, add stable tag, fix
whitespace, wrap code comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>	# 5.7
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4602,17 +4602,21 @@ static int pci_quirk_xgene_acs(struct pc
  * But the implementation could block peer-to-peer transactions between them
  * and provide ACS-like functionality.
  */
-static int  pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	if (!pci_is_pcie(dev) ||
 	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
 	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
 		return -ENOTTY;
 
+	/*
+	 * Future Zhaoxin Root Ports and Switch Downstream Ports will
+	 * implement ACS capability in accordance with the PCIe Spec.
+	 */
 	switch (dev->device) {
 	case 0x0710 ... 0x071e:
 	case 0x0721:
-	case 0x0723 ... 0x0732:
+	case 0x0723 ... 0x0752:
 		return pci_acs_ctrl_enabled(acs_flags,
 			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 	}


