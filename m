Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB915C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3184BC433D6;
	Mon,  5 Dec 2022 19:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267579;
	bh=PLLXZ7ysdojzjIwos1PDKEBcZRV/PCDG/A9mngxQGgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7jTp6OAhuanhjTYyhWmA4vOBoRyTaqHTwoRuVQ8TSSVkSgJL+iV5SFjBKs3hqGkl
	 UKjvVsMLBi4Xcq+PNMnEPsCARsFkouYb96qgtm2xu81bXLk3VdpIjHwJnCe2e3rLGM
	 khKrjARo8reNDdaXnt5/c68TcYqCc7/7yum486sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/62] can: cc770: cc770_isa_probe(): add missing free_cc770dev()
Date: Mon,  5 Dec 2022 20:09:34 +0100
Message-Id: <20221205190759.494895246@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 62ec89e74099a3d6995988ed9f2f996b368417ec ]

Add the missing free_cc770dev() before return from cc770_isa_probe()
in the register_cc770dev() error handling case.

In addition, remove blanks before goto labels.

Fixes: 7e02e5433e00 ("can: cc770: legacy CC770 ISA bus driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/all/1668168557-6024-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/cc770/cc770_isa.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index e0d15711e9ac..8df613bc3be3 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -272,22 +272,24 @@ static int cc770_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"couldn't register device (err=%d)\n", err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "device registered (reg_base=0x%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_cc770dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
-- 
2.35.1



