Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB438484
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D13CC433D2;
	Fri, 10 Mar 2023 14:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457266;
	bh=Bqq13GJ0RrJRkDyXIzePBxHdJWcN/44R6Id0IGAHTZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ebiz5l+sf2FRovEzX6W2VjuQWD+EJFZwIHjTf3e2P9f2USXDmvQ1gx2u9QBxUCatt
	 BlBt0YJCfDEJb4naUadB56cch4OweqBqPoBHX+TdLr/jA/evaLZyEaJ9Xh+k18vJUj
	 r4MTVBXunERlDcgFk16IkQDG9QqkGGBvtclZAnYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/200] spi: tegra210-quad: Fix validate combined sequence
Date: Fri, 10 Mar 2023 14:38:05 +0100
Message-Id: <20230310133719.501576427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 047ee71ae4f412d8819e39e4b08c588fa299cfc2 ]

Check for non dma transfers that do not fit in FIFO has issue and skips
combined sequence for Tegra234 & Tegra241 which does not have GPCDMA.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20230224164034.56933-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 9f356612ba7e5..6498948e150a5 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1297,7 +1297,7 @@ static bool tegra_qspi_validate_cmb_seq(struct tegra_qspi *tqspi,
 	if (xfer->len > 4 || xfer->len < 3)
 		return false;
 	xfer = list_next_entry(xfer, transfer_list);
-	if (!tqspi->soc_data->has_dma || xfer->len > (QSPI_FIFO_DEPTH << 2))
+	if (!tqspi->soc_data->has_dma && xfer->len > (QSPI_FIFO_DEPTH << 2))
 		return false;
 
 	return true;
-- 
2.39.2



