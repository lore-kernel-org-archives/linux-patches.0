Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD1168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9402C4339B;
	Mon,  8 May 2023 10:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542519;
	bh=hqR9NBU7VaQmbbTWi1w16gir0uIP3YlovBnJBhRyTQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKZiXqZwQM+Gk+wEeIXcaD1Ttb/5KeLn0g5J2uZTJ3yK0gxENJJXEKb+/wknomlmc
	 qTvznIgabxku6KMREKMCrghZ8VLr7RgRPpbXvgpSJDM6bF2ZTokS3JvCSkObNEEXkz
	 3rikLGBb3BQerJpawe+rHX3HQJHSCGwgU9WTWk/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 462/663] spi: mchp-pci1xxxx: Fix SPI transactions not working after suspend and resume
Date: Mon,  8 May 2023 11:44:48 +0200
Message-Id: <20230508094443.147203610@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>

[ Upstream commit 4266d21669de62cf3fb6774f7d404c1eb95a5ab3 ]

pci1xxxx_spi_resume API masks SPI interrupt bit which prohibits interrupt
from coming to the host at the end of the transaction after suspend-resume.
This patch unmasks this bit at resume.

Fixes: 1cc0cbea7167 ("spi: microchip: pci1xxxx: Add driver for SPI controller of PCI1XXXX PCIe switch")
Signed-off-by: Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>
Link: https://lore.kernel.org/r/20230404171613.1336093-3-tharunkumar.pasumarthi@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pci1xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pci1xxxx.c b/drivers/spi/spi-pci1xxxx.c
index 0805c441b4065..13efbfeff92ce 100644
--- a/drivers/spi/spi-pci1xxxx.c
+++ b/drivers/spi/spi-pci1xxxx.c
@@ -58,7 +58,7 @@
 #define VENDOR_ID_MCHP 0x1055
 
 #define SPI_SUSPEND_CONFIG 0x101
-#define SPI_RESUME_CONFIG 0x303
+#define SPI_RESUME_CONFIG 0x203
 
 struct pci1xxxx_spi_internal {
 	u8 hw_inst;
-- 
2.39.2



