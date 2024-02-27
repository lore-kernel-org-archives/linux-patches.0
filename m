Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BCF1419AE;
	Tue, 27 Feb 2024 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041637; cv=none; b=e9MIfys7hoZHxyCoLTz/9iEIhjWcdRQ5FWcNhI9vl+y2UTA3morZ3m9g8y+cG7GTMw9pEmjckezcQgB0MQlNW/oOGJZuEsUr+mt+O1VplAM9F++47p8F+wzKbnSiXbDEUd29UxApSnx9HgJEtpXojM6wHOoFv60+ILD5jim7I5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041637; c=relaxed/simple;
	bh=m/WGF5wg8VoisUxeQFgcuwxxjJHtwluntDHZvPGXqi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIkw2TiVksVHY7InsoB03VYe4VyPBsM0mxPCJlkYQPrDJVvNfNGjc/dSPw60N30u052H3lqS2uNOyC3p78WzymkmEyeevSjHC19YgiGfy7LTnubm6sk3li5Ff7Jr6crNy90dcNw3yEPp9QzORzgjJHjJjqA3+wPThoid+OLMJ9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxndp+21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxndp+21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625EAC433F1;
	Tue, 27 Feb 2024 13:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041637;
	bh=m/WGF5wg8VoisUxeQFgcuwxxjJHtwluntDHZvPGXqi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxndp+21ZhQhO3EDf8F7lL+fMn8aNJVeDrN3r2iLlfafIlszWuutE65IfwXb0Ka4d
	 3YqWr7ofiLi1pxj8nXJMEfdNvGYFYtxN3VGIwETm5NAZjGYKROPEceRHD4vkpMKt5w
	 eYfdTlsqgi/6biss7Jn5PALGzIalPxMPxz9Hv3C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/299] spi: intel-pci: Add support for Arrow Lake SPI serial flash
Date: Tue, 27 Feb 2024 14:22:10 +0100
Message-ID: <20240227131626.454098187@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8afe3c7fcaf72fca1e7d3dab16a5b7f4201ece17 ]

This adds the PCI ID of the Arrow Lake and Meteor Lake-S PCH SPI serial
flash controller. This one supports all the necessary commands Linux
SPI-NOR stack requires.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://msgid.link/r/20240122120034.2664812-3-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index b9918dcc38027..07d20ca1164c3 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -76,6 +76,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x7a24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7aa4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7e23), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0x7f24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x9d24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x9da4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa0a4), (unsigned long)&cnl_info },
-- 
2.43.0



