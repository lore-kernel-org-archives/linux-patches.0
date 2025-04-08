Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83400374C4;
	Tue,  8 Apr 2025 11:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110275; cv=none; b=EEV0rcqqlzH7bspqOcVCXnwgHvwpqYskOLA5QwnF6mpDgeh4q89YILtdJcbh7SY0s8yutuM6XO5ctWjOHfmnf6u7Q2W1Kc0AJJJX9BOvYW4MnOd+nL8fDwRiw149Eo3AnrjzX4mqQlymwI9CXyCcR0Q1fSSbAvfAmtDIjxlDhss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110275; c=relaxed/simple;
	bh=ifj8bTnv15hLf4ePdCNOsb8GZgzyqRt/hqVd8HD0q0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjwREEKtOkTCioo6KrtTMoGVBsM6sturu5ZRgD0fMUaDIxaYPpkL82ldmJ+F81V0psfzCx4H3Z+tDrNU2n6h1K9fdck6kTwyVfPQe1cZzS7Uwc2bHrtVpebOwnEx8UCl0m+QKtgng/xKZjlm1CYPjuZzAWEvnzN+iSEbz3hRs6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpxYGUaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpxYGUaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1256DC4CEE5;
	Tue,  8 Apr 2025 11:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110275;
	bh=ifj8bTnv15hLf4ePdCNOsb8GZgzyqRt/hqVd8HD0q0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpxYGUaRTWFipvBjWyOqfavEBT20nzSIqjXDNhcPqjU+CXHyelSndpL87uv5ixSEU
	 UVwWYJ0k6gfHKUebLl0eyJGyfqzIWMhtNl/ArfMjTGNRxNfS7V9qNBTAi9DbI7aS4Z
	 dMRdqxDdAlGFTjspM7LW5enqQPcL3a90QUm9l0wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Adrian Hunter <adrian.hunter@intel.com>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 217/227] mmc: sdhci-pxav3: set NEED_RSP_BUSY capability
Date: Tue,  8 Apr 2025 12:49:55 +0200
Message-ID: <20250408104826.816063880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karel Balej <balejk@matfyz.cz>

commit a41fcca4b342811b473bbaa4b44f1d34d87fcce6 upstream.

Set the MMC_CAP_NEED_RSP_BUSY capability for the sdhci-pxav3 host to
prevent conversion of R1B responses to R1. Without this, the eMMC card
in the samsung,coreprimevelte smartphone using the Marvell PXA1908 SoC
with this mmc host doesn't probe with the ETIMEDOUT error originating in
__mmc_poll_for_busy.

Note that the other issues reported for this phone and host, namely
floods of "Tuning failed, falling back to fixed sampling clock" dmesg
messages for the eMMC and unstable SDIO are not mitigated by this
change.

Link: https://lore.kernel.org/r/20200310153340.5593-1-ulf.hansson@linaro.org/
Link: https://lore.kernel.org/r/D7204PWIGQGI.1FRFQPPIEE2P9@matfyz.cz/
Link: https://lore.kernel.org/r/20250115-pxa1908-lkml-v14-0-847d24f3665a@skole.hr/
Cc: stable@vger.kernel.org
Signed-off-by: Karel Balej <balejk@matfyz.cz>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Duje Mihanović <duje.mihanovic@skole.hr>
Link: https://lore.kernel.org/r/20250310140707.23459-1-balejk@matfyz.cz
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pxav3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -401,6 +401,7 @@ static int sdhci_pxav3_probe(struct plat
 	if (!IS_ERR(pxa->clk_core))
 		clk_prepare_enable(pxa->clk_core);
 
+	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
 	/* enable 1/8V DDR capable */
 	host->mmc->caps |= MMC_CAP_1_8V_DDR;
 


