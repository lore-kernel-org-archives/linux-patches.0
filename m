Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F42264FB0;
	Tue,  8 Apr 2025 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113677; cv=none; b=V5ahR8pQTklCrVhizL6GTtHf66HY8rKBM9NEAi2WKFCKroMQt2vegPT2iDA9wLVtNtXPx/jcz/U5p/DypU8T34HZ1czgyOuHpimJnOECiLRlaerYnu80YZyCZAsqi3s0DtYMQLrs9PSBFhGci1kfk1RdWUgYClcYMOqCr2IjtR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113677; c=relaxed/simple;
	bh=V1IwRE3n4Q6YIkQGpWES06NcONLL6rf0P8KtDlQHpKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Up+HKLtcJ3oI+ny6plghTmtGr+P1XxwNNCe8FQAScFAPbcTV0NE+P7TD+Z/jd+8CXsU3XPhvYbVgVollDnkmVmRlgo+rMI17f98G/K4mGYx6F102JrUp3vdO6mStRj36q+lIVdorYgsxkVIM00zEjkXYwLG2+pscqa65KApanc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfOxZ9Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfOxZ9Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6DCC4CEE5;
	Tue,  8 Apr 2025 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113677;
	bh=V1IwRE3n4Q6YIkQGpWES06NcONLL6rf0P8KtDlQHpKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfOxZ9GhTSgXsf5kZw2fiv0JzgdYXUrpMmEOzese74pkrZTBcsmgFCMRNjtwnIoRJ
	 wfmZG8cr19pOAS8Sp6wLJ864IJ2V1ZdGLlJH1Fhmv5crovdD0ykk7aj8XVp3+kL589
	 1WGCnpH0JC75YJLsfAQIMx3kKJF7gVYzc3yaKKao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Adrian Hunter <adrian.hunter@intel.com>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 249/268] mmc: sdhci-pxav3: set NEED_RSP_BUSY capability
Date: Tue,  8 Apr 2025 12:51:00 +0200
Message-ID: <20250408104835.304594652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -399,6 +399,7 @@ static int sdhci_pxav3_probe(struct plat
 	if (!IS_ERR(pxa->clk_core))
 		clk_prepare_enable(pxa->clk_core);
 
+	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
 	/* enable 1/8V DDR capable */
 	host->mmc->caps |= MMC_CAP_1_8V_DDR;
 


