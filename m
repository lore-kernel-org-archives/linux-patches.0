Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F9BC8E6;
	Mon, 22 Sep 2025 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569566; cv=none; b=mwW0peRDS7qYTNCeYvhDezAzyJ0n1+512l6KxpRPqwg6kGPXa3+ctQbjTAPpPFh8egYtqqXwQCX5ev5c1MEdnBfn/gtbq64m/nExNXdJneWnYUuHol/FCZed3kTZNHmOCTg3v6fblLQlEwfFP9f5n+PxU0mwB2DZprDO/Oby0dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569566; c=relaxed/simple;
	bh=YRb2D7Vh4nVRCTCz8xiOWZBXLsDMtzt0bSpv4GZBqPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEBvPxzbS0UJNIXyV025Efqoj1V18PY7hvA+N89k3oNs0BQ5WqBm640mW6Xs8+N2BBvWRgOXxs+B72CVBrFTRHFFckPagjCy1wkQgzY8OUzywu/RVhdhnak4rDfKEsf0FI/FTBa0Fc4uREmb5Ok6sIGfpW+ARKiDOqdV1GJ8DaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvy7LOYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvy7LOYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F47C4CEF0;
	Mon, 22 Sep 2025 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569566;
	bh=YRb2D7Vh4nVRCTCz8xiOWZBXLsDMtzt0bSpv4GZBqPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvy7LOYgHEvo64X1HsgdZ4krJhTXmhD43EljHYzTsucEYSIz+z7YpETyZNYnGcNjU
	 JFcNISo7RalseMl4liLNVAJdL7nV/oWteMqbJDM2mtPsrhPR/q8zxUoiBLXRN/4MAv
	 PutHev3gcncCrrJ1aP6k0mzlUXwQvFFfqoD3gR4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 31/61] mmc: mvsdio: Fix dma_unmap_sg() nents value
Date: Mon, 22 Sep 2025 21:29:24 +0200
Message-ID: <20250922192404.408023502@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


