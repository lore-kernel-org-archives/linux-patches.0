Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B51AB6F1;
	Tue, 30 Sep 2025 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244209; cv=none; b=NNjFLArnnZLSdD57FFHY5CU4iJXAwKjsfeu5NvtpKw4CFPie8TFuuH4j8xU6EvyDyq1K5sdlngdthDC+P7YwCS+eBuSADAgDB1V+sgwRPUhU3YksVg1eAVQNUVHm17+odiqSvFg6n87M1xAmc4fFN217f0VgH8TamvKv/qvqA6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244209; c=relaxed/simple;
	bh=OBWAc3Jnn05/Dur3l8GQb8k5rq/se3J/R99nTpTaFIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8/YOFU8JUtrdCbFgP0VypzQCHdyj3qj4db2OkhJ4JqhToLTpxsgWARF+PYvvKc52zcY3v9TOZCNq1Msv4w1NR4Uuo0q5vkxEsHvt45vrPuT7l4YDAQw/QPcFgFjKfCRYDK7d+NbfXpgBxFE3FBx1KjGD6r+ku56ip/IrkrMbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiFf91sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiFf91sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4434BC113D0;
	Tue, 30 Sep 2025 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244209;
	bh=OBWAc3Jnn05/Dur3l8GQb8k5rq/se3J/R99nTpTaFIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiFf91sgWP1yfKXyGtEcbnjLlyK7XAtqghnd8L4KLLJ6+EHJUlkPu0TRFxKi1DAIy
	 hMJKYlv9z96ThrPfXFulOGlWfCNlsUiDxU+hvs9Qwp87OZxdHm2d+qjZbuGYW6FR/+
	 U1BspeR6rt436YN4otDzvs0OS1/qAyVclbNFk8FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 061/122] mmc: mvsdio: Fix dma_unmap_sg() nents value
Date: Tue, 30 Sep 2025 16:46:32 +0200
Message-ID: <20250930143825.494480948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 8ab2f1c35669bff7d7ed1bb16bf5cc989b3e2e17 upstream.

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 236caa7cc351 ("mmc: SDIO driver for Marvell SoCs")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mvsdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -292,7 +292,7 @@ static u32 mvsd_finish_data(struct mvsd_
 		host->pio_ptr = NULL;
 		host->pio_size = 0;
 	} else {
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_frags,
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
 			     mmc_get_dma_dir(data));
 	}
 


