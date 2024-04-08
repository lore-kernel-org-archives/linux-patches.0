Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3321C7D401;
	Mon,  8 Apr 2024 13:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583355; cv=none; b=uR1PmC/1hTxXMO7CEFNF4UINEOhkM0trdNVp1tjZIRi7hVjDz5CHEGT0CDgroua8Vmq9xidSEG6tBv8j9SWgyGwFEOdIPkonDXTggynxjJwulBl/9XTpWdBugixObWyt+VpajZEIkAQu7p2+CHAMARq2NcDAhK53patGdYfljnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583355; c=relaxed/simple;
	bh=egeLnAjo5yBe0YCDBFxZVYhrAOARDg0Xb0Ea7fFgviM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXoj+wgPHa1KIbqulCswXvpcMwUcFdwIJlEhAPyUijIERw5ST1LbrLWYt+FMiSsEsyd2NVsiKOfItwzKy+mYmdLmb5734kYJV0oXqca6QnhA/3W85C/0zT7RncizsLBHy+mGIdkjAhN8anlCjg7IzrATQyp426TPjfJ6bceXp1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7b8y90V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7b8y90V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC45C433C7;
	Mon,  8 Apr 2024 13:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583355;
	bh=egeLnAjo5yBe0YCDBFxZVYhrAOARDg0Xb0Ea7fFgviM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7b8y90V1MYGIqzRlTSjg1yXX6vhteaeVjwBPD5lmKhJ8YBqYXtcD6r0/tedxF783
	 Xl7aCk5bTvXd3McO7cjEYDy3S1ZBg1y3ZOi3Fg8WuKVCpSfwbQ0OPNvqLBK0iraKrR
	 Z5cFLiSNUI6xGjdyBcqTOoHt54pNEQA9SgkyHc/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 167/273] spi: s3c64xx: remove else after return
Date: Mon,  8 Apr 2024 14:57:22 +0200
Message-ID: <20240408125314.452124226@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



