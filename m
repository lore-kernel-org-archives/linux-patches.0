Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8F81D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqbkOGJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BC3C433C7;
	Wed,  4 Oct 2023 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443498;
	bh=9S0Fhoz3kvU/uX4YbAoROgYfzHhcGsMatscvZy/Q08s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqbkOGJXtpzGtvt0huybwU9+lJqs70FcRYwLW3w8fi5NKJd4DMrr4t7XkyEkN6sIY
	 hZxM9CaqZJm2GimFtZYN8yZoXee8OeEAddnUZU1ptytiRHDjLZpBzW8Uf+Wn40yPzK
	 L91WrkmC0m6LxLbjsbXM+33TfG+QqHD9Onwto45A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/259] spi: intel-pci: Add support for Granite Rapids SPI serial flash
Date: Wed,  4 Oct 2023 19:55:50 +0200
Message-ID: <20231004175225.409936207@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 9855d60cfc720ff32355484c119acafd3c4dc806 ]

Intel Granite Rapids has a flash controller that is compatible with the
other Cannon Lake derivatives. Add Granite Rapids PCI ID to the driver
list of supported devices.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20230911074616.3473347-1-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index f0d532ea40e82..b718a74fa3edc 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -72,6 +72,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x4da4), (unsigned long)&bxt_info },
 	{ PCI_VDEVICE(INTEL, 0x51a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x54a4), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0x5794), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7a24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7aa4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7e23), (unsigned long)&cnl_info },
-- 
2.40.1



