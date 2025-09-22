Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964E01F91E3;
	Mon, 22 Sep 2025 19:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570317; cv=none; b=osi3dm4WGay3aL8MXIX2CAlgkBjQG5r1GPOWgQrcNiVQuxciNXN5JHHwgPRDsWmtnddNFFOMj2iLNnBtfPea+PdeVsSNR+zu1EdAbzPXDecU8op5LTZB4f7yerru5boswg4AxCRRdFdXmNreqrT+MSP9Gpm1kR0zf2TvNXJMSCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570317; c=relaxed/simple;
	bh=VtyKMPU3ufStzeR9Zsj7uNkIF1ZsqeUPkr2P0kaElN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sxc2Qyx75AHyWocmpFxzb4G2q3fchSkKG7Zt5vfd4aSAhqqmTU6ajmO9in8ZrJnyJFB4PZzmYQQEmaJlOPjqqbLZcwV8Za77oLUEDaLHvaY1ipgFikr3ZtGdiCQjKlWHPxiGRD5dW8zP9sH+lBspIkGcjE45W6XAobFXfH/gMh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usX2ZVzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usX2ZVzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304FAC4CEF0;
	Mon, 22 Sep 2025 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570317;
	bh=VtyKMPU3ufStzeR9Zsj7uNkIF1ZsqeUPkr2P0kaElN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usX2ZVzkID9mb+n3dpWqFojT1A2ZwbqZ2PthHhWQ58lS+gi42iTVIshgjZz9buIPv
	 TzZ4vOGha9QSzAOKARGT//kJr7hZlQQuK1EOsKsHiAi+tyohwGGMUUcVNzwQBHd97b
	 nS9Oe3wlOYeHmGOZTPPtQcehJybCt+i72RJLydBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.16 088/149] mmc: mvsdio: Fix dma_unmap_sg() nents value
Date: Mon, 22 Sep 2025 21:29:48 +0200
Message-ID: <20250922192415.104210022@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 


