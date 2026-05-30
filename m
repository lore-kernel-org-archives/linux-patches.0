Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440133E36A;
	Sat, 30 May 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161833; cv=none; b=hVA3H+vM3B1PYq2B7mEnZYbz2gPjr2SyJQnOdae1GX7792fGwMmXHPdlyuR6jZpGp10l90UXrqKqNN/HtanafAQIZgb4E4boIL7VAmSHB0gAEBYJELrFv4prMwdBcYlBU8Kc4YBIGxVgORXg3uC5C9yFUNQLm5LB3SSF1Neo2bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161833; c=relaxed/simple;
	bh=084PQU/lBpFdxGgGQmKMs+omFDASWr0pysik5SFRj4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3zms24AliTDeYUbxK37aw+LTTKU8cWoBo3HRwgYK1a0C6Psj9n4lWPIvjhSQ6mMPp4sS5j9mvQ9TLXS/p6vaNPb+/zcyCXjxOnbJ1tV8rTLMCS2n82Tjz3UvyIj/RD/bmr2oMYyOge84TwAhMMsYXrgO+S83E1qmS2tzt9sp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjXr0zal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjXr0zal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1441F00893;
	Sat, 30 May 2026 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161832;
	bh=ZAsLg1x8VQERNn3nafyrgjzaA0EgZEBNNTjag3B9UMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjXr0zal8uI81L0H0RAYLDdq+HMM9n0TcHazkRSzwTsA++biSUH+6l37BItKQSJXT
	 CizeIg47NYj8F49pnyZv1kUPIZnG1Q1EyHNmo19nWrD41pjYoD7nRzOLnKhJljYMTB
	 we7z2C7B4WlG4Yg+54cuWDgEiTcwGbT8RT9dOkLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhe <sensor1010@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 741/969] drivers/spi-rockchip.c : Remove redundant variable slave
Date: Sat, 30 May 2026 18:04:25 +0200
Message-ID: <20260530160321.021368005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhe <sensor1010@163.com>

[ Upstream commit 8c220e6c6da9c2f70a78ba8b3121893b3634a54c ]

variable slave in spi_alloc_master() or spi_alloc_slave()
has been assigned. it is not necessary to be assigned again

Signed-off-by: Lizhe <sensor1010@163.com>
Link: https://lore.kernel.org/r/20230226063334.7489-1-sensor1010@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b4683a239a40 ("spi: rockchip: Read ISR, not IMR, to detect cs-inactive IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index b460a393a7fea..b3247fad5f7e2 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -772,7 +772,6 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ctlr);
 
 	rs = spi_controller_get_devdata(ctlr);
-	ctlr->slave = slave_mode;
 
 	/* Get basic io resource and map it */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
2.53.0



