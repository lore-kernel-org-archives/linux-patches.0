Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A95128394;
	Tue, 23 Jan 2024 00:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970976; cv=none; b=O1X6gest1xqgHI9x+BXIS0uU5hOcQNPvGiYJb+1YbjI8PIWi0ky2LuCeyCCHbAFvWXW4+TG0yg7Ln8OxQAgHqypmEth/y07kvXybUzPPTdnB0xu2JOK76hz5kZyPV8pmTH48gcVLFITmyrcG1WgJ9zvhkOQAOQyczSoiHBI3kRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970976; c=relaxed/simple;
	bh=Gie9Dr4QIx6F6UALF7zkcNYCgY+hFd/4Dxth1ex+pWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5uG96WkxIikul7tlJx7jYn+YxOVcSavM1QYeGWagj7uFsA37r9xlBAe7lENmQ2F6CHBW/Zbekc4pQTQ9PwWrEmngdGJpWJ0ZrfMDMS5xeL6SamvLapx/CfTK+VU+YSKio9KgKwJEqhatMYdQKNOfpxY0U3uJ6FQqG4RKiP+ADs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ5VWZbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ5VWZbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6669C43390;
	Tue, 23 Jan 2024 00:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970975;
	bh=Gie9Dr4QIx6F6UALF7zkcNYCgY+hFd/4Dxth1ex+pWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQ5VWZbQpkt/l7eVfsX11hHf4YFkHza4/Ek4y7xJ0VSic5BoU7gSeN4zcSN9WMEtn
	 TBLaogdl1kVSVxtWg745yrfLi1w3dV5/2NEwSDlGnUM45lbBTuorLoHomIJXvbSkHo
	 d6Uggbps5bKMM2uHLXMci51zWLCZx1zFKJwl2O8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/286] spi: spi-zynqmp-gqspi: fix driver kconfig dependencies
Date: Mon, 22 Jan 2024 15:56:07 -0800
Message-ID: <20240122235734.382071853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>

[ Upstream commit 424a8166764e462258fdccaaefbdeb07517c8b21 ]

ZynqMP GQSPI driver no longer uses spi-master framework. It had been
converted to use spi-mem framework. So remove driver dependency from
spi-master and replace it with spi-mem.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1699282435-884917-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5fd9b515f6f1..74ea6b6b5f74 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -957,9 +957,10 @@ config SPI_ZYNQ_QSPI
 
 config SPI_ZYNQMP_GQSPI
 	tristate "Xilinx ZynqMP GQSPI controller"
-	depends on (SPI_MASTER && HAS_DMA) || COMPILE_TEST
+	depends on (SPI_MEM && HAS_DMA) || COMPILE_TEST
 	help
 	  Enables Xilinx GQSPI controller driver for Zynq UltraScale+ MPSoC.
+	  This controller only supports SPI memory interface.
 
 config SPI_AMD
 	tristate "AMD SPI controller"
-- 
2.43.0



