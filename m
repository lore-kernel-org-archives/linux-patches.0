Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5894615E8B;
	Mon, 30 Dec 2024 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574195; cv=none; b=qlT4zgggVl+dbfjmacfpRQ/IxSU/pSsjaA1+ZjzeCifW0XlHNHdHZlQ7yasRRn+Fb3XtVmvoeopHircoDW/X7MCd7Dkk7kW7VaiI1LUQywEDULqh/XhIDbIP0wmFvhpFzMtiwtK6u49ghXmFq1ihTGIdhohLtsBsmDheswEyqtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574195; c=relaxed/simple;
	bh=6ryWWzywO1gA7+4aStzwkfxLqk1hQD3497xqrHlezR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTwre5ANQ1S9rKrSltyWFV/hBTda4HaQORqSgq632RXjI7mksZ1NcbzFHieLBfXXHEYH0lVZByqnJ/HigSR9K7U/yb6ONBTB99WpwDQU6Db+k4POFxrsN9fu4UYMWB24tW1ta9nAXFBeVfRwI/fieNe39t8I2QW6aDzKZAfFuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0Pm5oBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0Pm5oBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B58C4CED0;
	Mon, 30 Dec 2024 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574195;
	bh=6ryWWzywO1gA7+4aStzwkfxLqk1hQD3497xqrHlezR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0Pm5oBip+W9zH4jLFEarJtE3eTyz4I83ytntZg/Vou5Cy9UdfnttNNsddqxqFKfO
	 i2ZWmkJCBnNOGoOaBJdqrZ/1khmfpGGFlvOZgmqBUKDxXLES8r/bD5yBK0IQ6lGp8r
	 P4RnW6M4q5mqX/izt7WheXsU+azpLWCc5+PD91uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aapo Vienamo <aapo.vienamo@iki.fi>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/114] spi: intel: Add Panther Lake SPI controller support
Date: Mon, 30 Dec 2024 16:43:02 +0100
Message-ID: <20241230154220.604021857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



