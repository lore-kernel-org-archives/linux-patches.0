Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB8537E9;
	Mon, 30 Dec 2024 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573821; cv=none; b=bw/LRdp+6GLFM3flzO/sXh54cDEzFp5YN+wsAmfpqASwO8RHTJ4AwuAew/E7U95RsIIcKDcc6ovkoIFH6z0oBtmnKJZDC68LGGXALo9xCetjfyGtcvWtRpYzWXD7vwswKA0O/QB4jN3MyNS2IpMGYfAJOkIhAHKn5chdYcm9tCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573821; c=relaxed/simple;
	bh=t9yQWY+8d6mQQRU1GKdbraVR6/6coRzzSJ0n30g2igs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhcfeDzMJneXB8i1k9108peEvLppdEyB/b2bj9aCUE4aw+fFdU4Hg7hN6bF0sKSanBEtsHLjmPIDzjIAMhzNaLvpT/bFRJt5Yp18YGxntkQPrRDEpqH/ozBBQ+m8InTUeSSHM42Q/EI+iTv0fgRKZmK6qFKEgDeT4YLF8gW5tCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIwpEkVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIwpEkVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8D4C4CED0;
	Mon, 30 Dec 2024 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573821;
	bh=t9yQWY+8d6mQQRU1GKdbraVR6/6coRzzSJ0n30g2igs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIwpEkVrCgzll09YfvsZXkHE2EAeWRkfmY7Da7cVoaAEJy7rLSMXHYB7qLeDTXRUC
	 iXLjtd+2hDP663gzMQCvB2epaN6+MTGt14ptQqyMB3PRwo1uCFnduQ2jGBKg8Qf4IT
	 6m1iPTjVF8njbmnSnFH7tx0+0GmihDE4rJR9lW2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aapo Vienamo <aapo.vienamo@iki.fi>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 44/86] spi: intel: Add Panther Lake SPI controller support
Date: Mon, 30 Dec 2024 16:42:52 +0100
Message-ID: <20241230154213.386960547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Aapo Vienamo <aapo.vienamo@iki.fi>

[ Upstream commit ceb259e43bf572ba7d766e1679ba73861d16203a ]

The Panther Lake SPI controllers are compatible with the Cannon Lake
controllers. Add support for following SPI controller device IDs:
 - H-series: 0xe323
 - P-series: 0xe423
 - U-series: 0xe423

Signed-off-by: Aapo Vienamo <aapo.vienamo@iki.fi>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20241204080208.1036537-1-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index 4337ca51d7aa..5c0dec90eec1 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -86,6 +86,8 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa324), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa3a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa823), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0xe323), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0xe423), (unsigned long)&cnl_info },
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, intel_spi_pci_ids);
-- 
2.39.5



