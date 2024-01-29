Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E629A15CD49;
	Mon, 29 Jan 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548330; cv=none; b=cI66a2nR73aerI8Q/dJBLa4U4tLK9/GVblvxt29rIXV5mVYf5e1jP9TvzhgNHRvaOJpxVIs5HNO5MZ3QvH57zUUl2jWvgrsYj1q4J7IL3bA4a9yldO4R6+Ro1gwMgyN2iN76T1mEP0x9g2TsvlGKSr4wyNc16lZDSF/ETjyFFZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548330; c=relaxed/simple;
	bh=Ae+4I5OJfiada0mo9SsyU9A2w2Pithzv/laXhHorNXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7tCzGRIXT8lFGm6CYSoLJGfHoBYLxZG75bzqWXVfGK/YyGAlWL4VYXtCBZHgFX/0XbHLqos54X+7K6GMAW8A7IJzrqDQvoE4fkVr11BStYdweBS2hWrhPmjdCnzRpnN+cKPA+HqWOkf71V3faZAha6u7rgYvbjbgvOfW23kVrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEbiD324; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEbiD324"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB34DC433C7;
	Mon, 29 Jan 2024 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548329;
	bh=Ae+4I5OJfiada0mo9SsyU9A2w2Pithzv/laXhHorNXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEbiD3242qiQS4/9BThgV0+m5YFsbuCMRDRNJBpcZdVSZBFAMwMLzFVfKJyaATMr+
	 EndXwcCY3SoP0VTqICqD5HsNXp05cooz8MLRpyR2CW33yRGrMr3hjx7uom2uRMIsRh
	 VO6EoZ+5+2gdhQeZjOAQdOnDmwSGXk+HRKA0/DDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 328/346] spi: intel-pci: Remove Meteor Lake-S SoC PCI ID from the list
Date: Mon, 29 Jan 2024 09:05:59 -0800
Message-ID: <20240129170026.125038316@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 6c314425b9ef6b247cefd0903e287eb072580c3b ]

Turns out this "SoC" side controller does not support certain commands,
such as reading chip JEDEC ID, so the controller is pretty much unusable
in Linux. We should be using the "PCH" side controller instead. For this
reason remove this PCI ID from the list.

Fixes: c2912d42e86e ("spi: intel-pci: Add support for Meteor Lake-S SPI serial flash")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://msgid.link/r/20240122120034.2664812-2-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index 57d767a68e7b..b9918dcc3802 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -84,7 +84,6 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa2a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa324), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa3a4), (unsigned long)&cnl_info },
-	{ PCI_VDEVICE(INTEL, 0xae23), (unsigned long)&cnl_info },
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, intel_spi_pci_ids);
-- 
2.43.0



