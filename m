Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58F23B604;
	Mon,  9 Feb 2026 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647429; cv=none; b=WJPM6G4v82lZ2RaofCNrNwNwnMnIaEnHxgT00rpStsnFy+cAm8PvIew2AR4j80LyGLNXM9pPnFQLReTR2T0uNaWjKwHH52azLkAcSDljvHrkNoRloJu38B3pQgegiYm5ukRgD3oE2pQy8Gp+x3/WLbSJiyclj6eEm/dnXeR7ZOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647429; c=relaxed/simple;
	bh=DyZa6X5/jh+1YahfAJRmvHPVmPx4J6LE+0Wzr0VpDkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aigIWRL6+QWLQobF0tNqpmzPGfO+QfKMCF2QYw8W848zE6Peo8mMOcJcvJ8kmm155ix6zZ6SerL2WgJ/65EhDUKGsOx6FKxW9cLi7GP4CcFUVU90IsFlv1eM+DRKEFpuRkvt+2EbVdx0h0UGh0Fgd1sVc0cjqxCHaWwqDu992gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4U4iDxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4U4iDxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668EBC116C6;
	Mon,  9 Feb 2026 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647428;
	bh=DyZa6X5/jh+1YahfAJRmvHPVmPx4J6LE+0Wzr0VpDkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4U4iDxK+QACgEvk9A1F8cq2YzdVWGdXF+0cYgXHGW1nIeVXluruC7jVHykqiMJdK
	 obDS/b0UiuHkwtX5tcy9n5vG2k39Pwn2SK1QlaKFOTrijD5FgXV23upg1vSPB3rnru
	 4SiRaIwpd4aawh8AN+J941twXwrSoeIscHV0SJFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/175] spi: intel-pci: Add support for Nova Lake SPI serial flash
Date: Mon,  9 Feb 2026 15:22:51 +0100
Message-ID: <20260209142323.948360933@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit caa329649259d0f90c0056c9860ca659d4ba3211 ]

Add Intel Nova Lake PCH-S SPI serial flash PCI ID to the list of
supported devices. This is the same controller found in previous
generations.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260115120305.10080-1-alan.borzeszkowski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index b8c572394aac2..bce3d149bea18 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -81,6 +81,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x54a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x5794), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x5825), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0x6e24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7723), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7a24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7aa4), (unsigned long)&cnl_info },
-- 
2.51.0



