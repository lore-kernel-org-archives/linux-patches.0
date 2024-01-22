Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2255B5C1;
	Tue, 23 Jan 2024 00:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970414; cv=none; b=a5znUtN5GuzCIBOnrLxQM5uwaOp6JJ3xGDPuGHrosK8lAb3s1f0paCrt4hTJcG+Vco1UXWCzcrmGDykoth6D15t49c4NYIlo70G48IRp7ePWg8vL4WqUPYAJIz8x8H39RntOdfAbB/80+pqxqeqTJoIWqlEoPSPp7RaeBkYuq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970414; c=relaxed/simple;
	bh=5k3bPpW3qpbeuZ4fXigM3C4dK90ia/OIjPgOngSaZjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs+R3uQ6sE3HHi8IvRS/g65okOKb70QhrEZ3nr3ZDu2AmxpJfIxjduJZ4fkn9c4LGGbrXYJSunPt09ioLrAjrCRhLJV82XtUk4H3oiAa1bDmnuh704ar4N/tKKgbJXp2BEWaCDXRTe1AdFELc/+S/JxlJHlCjs+1NPrVqw96d+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYKY9w/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYKY9w/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8A2C433C7;
	Tue, 23 Jan 2024 00:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970413;
	bh=5k3bPpW3qpbeuZ4fXigM3C4dK90ia/OIjPgOngSaZjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYKY9w/ZiX3oP5LjYXPOFXeTRtyJzumaT9Go/lkgAvHDlVD+PdkyYx3ixvJ/3dQb2
	 5dpuPzYbR5Ctg1tPFuTMitZRizbnuYJojWNwQ/BoRDH7G1lo/r1HqEzP4Wn7wY9RDI
	 7Q9X3+UPR7bZyTj6r02he+Fy85sPsNeCStMWNr9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/417] spi: spi-zynqmp-gqspi: fix driver kconfig dependencies
Date: Mon, 22 Jan 2024 15:53:01 -0800
Message-ID: <20240122235751.962727224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 946e2186d244..15ea11ebcbe0 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1101,9 +1101,10 @@ config SPI_ZYNQ_QSPI
 
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



