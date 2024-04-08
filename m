Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4737CF37;
	Mon,  8 Apr 2024 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583279; cv=none; b=Vxjv1XbohTR1UmSQRiGsdwsu9AFAienUWGxfLtk7MeRU9PYWTBZjeUsVPjRiiNK7Lwv2s2Bcr7EKQNoqan6xTezVsRb593eLmpaNsKZ7X+2qQP4MV99XRG2srk8AhdMuAMRTdGiC5k1V872K/dlzHazDTGJBs+HS4MyY4zk/S8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583279; c=relaxed/simple;
	bh=svrHSBoEc+/Qxmh+AWVuUPXDvgf63RMM9H029rTxUcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFsFsF+cwABoOTSoc9Xy3xk6d3j/4qu7O4yvHHhT2JfXVOHHWxID9nDwK1kvGe7vRzx/Zr98YtrQxm9x4rcmhNB2hTuDYOI1qcyXrTsfkoNHZ9t/zWNe3cC2UK3hDw7xtb1njJ2InP1D/MoDeJbhPBhOdEa71Jt0kw4e/wr2v3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGxXi1t4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGxXi1t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F45C433F1;
	Mon,  8 Apr 2024 13:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583279;
	bh=svrHSBoEc+/Qxmh+AWVuUPXDvgf63RMM9H029rTxUcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGxXi1t4HhTeTDfKS2dLpU2E7g5aac34OvSwfPlrWj4JP7+1WUeMn/0Gm20zQPCdt
	 JPC/YtT5Vii7IAdFhenJk+GwX/Dzw6Sd0bzZshSEBEGLyVzoOo/XUWu4X/afhdB2/P
	 2oVERjf/TVjGjt1GzX5n+Rz87GhWeckTVjl5HS7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/252] spi: s3c64xx: remove else after return
Date: Mon,  8 Apr 2024 14:57:56 +0200
Message-ID: <20240408125312.153183629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 9d47e411f4d636519a8d26587928d34cf52c0c1f ]

Else case is not needed after a return, remove it.

Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240207120431.2766269-9-tudor.ambarus@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a3d3eab627bb ("spi: s3c64xx: Use DMA mode from fifo size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 1e519b1537e71..29e99410c9716 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -406,12 +406,10 @@ static bool s3c64xx_spi_can_dma(struct spi_controller *host,
 {
 	struct s3c64xx_spi_driver_data *sdd = spi_controller_get_devdata(host);
 
-	if (sdd->rx_dma.ch && sdd->tx_dma.ch) {
+	if (sdd->rx_dma.ch && sdd->tx_dma.ch)
 		return xfer->len > FIFO_DEPTH(sdd);
-	} else {
-		return false;
-	}
 
+	return false;
 }
 
 static int s3c64xx_enable_datapath(struct s3c64xx_spi_driver_data *sdd,
-- 
2.43.0



