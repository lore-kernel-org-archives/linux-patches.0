Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AA5749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06A2C433F0;
	Thu, 12 Jan 2023 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532373;
	bh=7RP4bFCmSmxgoTpawRnr5tTohrlim9hfMYdf297KNgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+yYjHnZL8N7FTy3EuBX5zmpiK8RKRTgPG3J6NhiGh1z3xiMQImKk3Rp2q3cktvbK
	 HE68cv6WzFpqLUfN7l1Fotbc8/446JH4syhMAvx5+zY4LCwGxfDDlvzAj72KMx4An5
	 wtYxNnJV7UKEwgbwwGHMnKfb0erUbZd//kZTbF50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Yang <yangjunlin@yulong.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/783] pata_ipx4xx_cf: Fix unsigned comparison with less than zero
Date: Thu, 12 Jan 2023 14:47:05 +0100
Message-Id: <20230112135529.246871071@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Junlin Yang <yangjunlin@yulong.com>

[ Upstream commit c38ae56ee034623c59e39c0130ca0dec086c1a39 ]

The return from the call to platform_get_irq() is int, it can be
a negative error code, however this is being assigned to an unsigned
int variable 'irq', so making 'irq' an int, and change the position to
keep the code format.

./drivers/ata/pata_ixp4xx_cf.c:168:5-8:
WARNING: Unsigned expression compared with zero: irq > 0

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
Link: https://lore.kernel.org/r/20210409135426.1773-1-angkery@163.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_ixp4xx_cf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index abc0e87ca1a8..43215a4c1e54 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -135,12 +135,12 @@ static void ixp4xx_setup_port(struct ata_port *ap,
 
 static int ixp4xx_pata_probe(struct platform_device *pdev)
 {
-	unsigned int irq;
 	struct resource *cs0, *cs1;
 	struct ata_host *host;
 	struct ata_port *ap;
 	struct ixp4xx_pata_data *data = dev_get_platdata(&pdev->dev);
 	int ret;
+	int irq;
 
 	cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	cs1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-- 
2.35.1



