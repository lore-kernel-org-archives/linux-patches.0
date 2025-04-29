Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F041D24EAB2;
	Tue, 29 Apr 2025 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946262; cv=none; b=snETOxgEc7qibJtawVRNOHfWGu/6QkUiK1Yqz2V7wg/yBGPMFgsD8DtBUhjVtu9wxWquey4LzNO9KGRRX75cJv7NrQ/wG2Slbni6Nl9dbApcAfj2wKNAjr2vMEc1ifDMko8PY7heG5N/bzrAs20kBzWR1BL+swkxY4pCMVMezGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946262; c=relaxed/simple;
	bh=X40NhaBLYC6l2H93B1/d37pnXsbmAhpFUUMyoCPY84A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aiag/2tI9USbz0gug5y2ewP2fh3uZ47xU9c61xzjzood3KDkIG6D5Nip2Dcp4T0s2DwlFUU2RAkNZTLW5LEiRXSmXnJyj1f7g72sWVr5y1Is9XORyjaRRy0k0LDS5mgWjZJnrKlSUZlvWJfhY98eYeQOEWZ9z5qBZD3ho6kza0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQSZzRQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQSZzRQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5853DC4CEE3;
	Tue, 29 Apr 2025 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946261;
	bh=X40NhaBLYC6l2H93B1/d37pnXsbmAhpFUUMyoCPY84A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQSZzRQ26EFnA8l8DuDEobmxTaRT/RljQSIc43TtyB/XvVeINofQOj5AhI2wqa4VR
	 z6qtmwNhRQ6WC+1fgtAa/wgxwaTPx4/jwevyyGPuSTs1P/TixNDw19H2FxFW1C3rkY
	 5fRydiNZu2HkjYWhoo0ijcEF+vh/S0Sx9AjrnGUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 208/311] dmaengine: bcm2835-dma: fix warning when CONFIG_PM=n
Date: Tue, 29 Apr 2025 18:40:45 +0200
Message-ID: <20250429161129.525728382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 95032938c7c9b2e5ebb69f0ee10ebe340fa3af53 ]

The old SET_LATE_SYSTEM_SLEEP_PM_OPS macro cause a build warning
when CONFIG_PM is disabled:

warning: 'bcm2835_dma_suspend_late' defined but not used [-Wunused-function]

Change this to the modern replacement.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501071533.yrFb156H-lkp@intel.com/
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20250222095028.48818-1-wahrenst@gmx.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/bcm2835-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 20b10c15c6967..0117bb2e8591b 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -893,7 +893,7 @@ static int bcm2835_dma_suspend_late(struct device *dev)
 }
 
 static const struct dev_pm_ops bcm2835_dma_pm_ops = {
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(bcm2835_dma_suspend_late, NULL)
+	LATE_SYSTEM_SLEEP_PM_OPS(bcm2835_dma_suspend_late, NULL)
 };
 
 static int bcm2835_dma_probe(struct platform_device *pdev)
-- 
2.39.5



