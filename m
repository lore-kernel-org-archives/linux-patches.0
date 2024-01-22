Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41141374;
	Tue, 23 Jan 2024 01:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972150; cv=none; b=YCRrrYws9tXGNe92SyCdJ5yEynD33+Rkd5fAAKGx8ptlvCk7+k4Dhj6sjD/108zyCHalm652F68h8rcC6YnRW7VEk49ZoUk2VV77AldFG265v+gm8ciG8HkiSmywepcDoB/6NHkU7+5BG87hLkbcqsfN99ds3f5PRgQKjRemF+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972150; c=relaxed/simple;
	bh=NAzoZ4zmIqT7EuMjwmq7dvd82Jatgh5Ud3MfE4W9wKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA2ciJTbDdliNXDvGNedYhVcgKm5x1uUHf0veQERMqhj723GqB7ihaPZYdBAmnfryd/X5ybKXi4+dN6sCSfXEpbb0G96yV+yZdZpy4UlWLkYoIci7hC/Z2dKK4nsvMtQILYWCpe8zXS0B/AMMGgIklr24/v6g9RLLHAKqzV4JsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hm81xtbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hm81xtbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD26BC433C7;
	Tue, 23 Jan 2024 01:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972150;
	bh=NAzoZ4zmIqT7EuMjwmq7dvd82Jatgh5Ud3MfE4W9wKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hm81xtbig6HZ/z6Gwm7k3DVrGeJjZ+sCYj2jpOkyY25zkD3FzQrHbErudQCCf5OAx
	 +I4123fTBUYWejX3nwnE4bV1NdaZYxy1ey3aQ4RxPRhBqGZkXZmGnQ1AeJAkyDTcs8
	 nfSRruPkSFBV8wZxbm5lVvKaEUyzsg4UlYIkIHOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/374] spi: spi-zynqmp-gqspi: fix driver kconfig dependencies
Date: Mon, 22 Jan 2024 15:55:34 -0800
Message-ID: <20240122235747.330198493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 123689e457d1..412154732c46 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -984,9 +984,10 @@ config SPI_ZYNQ_QSPI
 
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



