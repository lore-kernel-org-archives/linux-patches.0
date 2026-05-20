Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36178363C6F;
	Wed, 20 May 2026 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295843; cv=none; b=GmofAINvTo0sgGLjssEiS0zvy0jVLh6bSfIy5yorV+CPLmZhXPam7OqsTH+ZMUVkp3WJf82RE/c5fdO83nlCPO2kph67MeAbZCzD7HbShFdG8Z588+Jebw1vu1/E+LBMalb1wMb2E1c3yReoKJ0/Hy6hA2jmrFbMuGBM1JmryIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295843; c=relaxed/simple;
	bh=pC9vSRnO068xejNMBBQWbEXD2OB/YBW6dLW0OIvuyIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5/nx4rS0hmEBCA8Rs69HoCmN9wWuQs1NCLlNho9DF6Kg0UcqCE1Q9kgQ3TW/X0055RPbAM4sgnrSanUSCruubn24k4LdAAIJMXrXlTe2eUzuDlM/Y5xwkhhnoejCpfQqrgWBGH+sJTAVD+EBYvHBN8TN6H20oPshScYqwn1DD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0/JcJyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0/JcJyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936651F000E9;
	Wed, 20 May 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295842;
	bh=Ld4PGUnqBWNZiKxirCYdCzcxWM51kn9NJrWEnreH6JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0/JcJyPwsGkxlg+9xFm+CL3LbbzSTErHFnkNS1xtZjsAUMBqRr1CdGJW1xX1cBg1
	 PhSAwKvlCI+VIZdxPCMutc34Swsr+wDxxGDoDU6ESOgePA2f/ihwk2NzGz0VDIoEsf
	 /hIzSEUhAjD6Z3BEdMrnNnU2TFdhWOfeHrFdeAfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0574/1146] phy: apple: apple: Use local variable for ioremap return value
Date: Wed, 20 May 2026 18:13:44 +0200
Message-ID: <20260520162201.173672982@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit 290a35756aaef85bbe0527eaf451f533a61b5f6c ]

The indirection through the resources array is unnecessarily complicated
and resuling in using IS_ERR() and PTR_ERR() on a valid address. A local
variable for the devm_ioremap_resource() return value is both easier to
read and matches expectations when reading code.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/asahi/aYXvX1bYOXtYCgfC@stanley.mountain/
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Fixes: 8e98ca1e74db ("phy: apple: Add Apple Type-C PHY")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Sven Peter <sven@kernel.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260215-phy-apple-resource-err-ptr-v2-1-e43c22453682@jannau.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/apple/atc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/apple/atc.c b/drivers/phy/apple/atc.c
index dc867f368b687..64d0c3dba1cbb 100644
--- a/drivers/phy/apple/atc.c
+++ b/drivers/phy/apple/atc.c
@@ -2202,14 +2202,16 @@ static int atcphy_map_resources(struct platform_device *pdev, struct apple_atcph
 		{ "pipehandler", &atcphy->regs.pipehandler, NULL },
 	};
 	struct resource *res;
+	void __iomem *addr;
 
 	for (int i = 0; i < ARRAY_SIZE(resources); i++) {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resources[i].name);
-		*resources[i].addr = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(resources[i].addr))
-			return dev_err_probe(atcphy->dev, PTR_ERR(resources[i].addr),
+		addr = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(addr))
+			return dev_err_probe(atcphy->dev, PTR_ERR(addr),
 					     "Unable to map %s regs", resources[i].name);
 
+		*resources[i].addr = addr;
 		if (resources[i].res)
 			*resources[i].res = res;
 	}
-- 
2.53.0



