Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5521170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2584C433C7;
	Mon, 11 Sep 2023 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440650;
	bh=iswAMcoCAAGBJXZjq2asG4Lp6Q5qFhlNwPnSyXa5psU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpAblfExeJGkaUlUiB1rhZllYK3ho4rCISgQ1jXYTPY8Dk6sY0nwDx4owUobsp029
	 UQorFH+Xwh01Fp8OfL+7XqvZy+7lWARq/rmH8IA+ziQobg3IN0TKcmkrZbNVaAL9qV
	 N18M8+y2Y+bLDjWMQXiaGRf0Fe7VqLcEmvBiH5Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 109/739] spi: mpc5xxx-psc: Fix unsigned expression compared with zero
Date: Mon, 11 Sep 2023 15:38:28 +0200
Message-ID: <20230911134654.145046336@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit de5e92cb5cefd2968b96075995a36e28298edf71 ]

There is two warnings reported by coccinelle:

./drivers/spi/spi-mpc512x-psc.c:493:5-13: WARNING:
	Unsigned expression compared with zero: mps -> irq     <     0
./drivers/spi/spi-mpc52xx-psc.c:332:5-13: WARNING:
	Unsigned expression compared with zero: mps -> irq     <     0

The commit "208ee586f862"
("spi: mpc5xxx-psc: Return immediately if IRQ resource is unavailable")
was to check whether the IRQ resource is unavailable. When the IRQ
resource is unavailable, an error code is returned, however, the type
of "mps->irq" is "unsigned int", causing the error code to flip. Modify
the type of "mps->irq" to solve this problem.

Fixes: 208ee586f862 ("spi: mpc5xxx-psc: Return immediately if IRQ resource is unavailable")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/20230803134805.1037251-1-lizetao1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc512x-psc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 99aeef28a4774..5cecca1bef026 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -53,7 +53,7 @@ struct mpc512x_psc_spi {
 	int type;
 	void __iomem *psc;
 	struct mpc512x_psc_fifo __iomem *fifo;
-	unsigned int irq;
+	int irq;
 	u8 bits_per_word;
 	u32 mclk_rate;
 
-- 
2.40.1



