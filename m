Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFB53BFE4C;
	Thu, 15 Jan 2026 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497921; cv=none; b=Iye5k/aCRmXhlyqHOzX/hffgR8xifuk6EmwUEyzV1N6mbSD02LLzqT7MfuXTYcC86BnmYPLoA3SUpmSscvcUf7PAvoi0G3EYnM2s+5kiAlXdMoW8a4v5slt5OwFW3ggTJlcroGFPr0+Wfun+T+o/DqFBQA8ADKGTzRHwlMDt6AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497921; c=relaxed/simple;
	bh=/UXHNgLfGfw8rZLRKRhatg1EI/Ed6f+ydQIcO+ly0CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVhfEIJESQ2e/6raAJuu4bWt7PjpF+Smbd2DLIH3eTcu1sKAy4lXHac/OUYmTdHJsql/30iez0r/wglVdH6iSntDJ+ZIeIc1froU9Z9MAlSDTas4S2MCln4IggjyL9DmZscwBY9mpIFRzmGX8rqsiRsTN3PoKz9yiY0AJ8VsqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGg+SbqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGg+SbqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663D7C116D0;
	Thu, 15 Jan 2026 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497921;
	bh=/UXHNgLfGfw8rZLRKRhatg1EI/Ed6f+ydQIcO+ly0CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGg+SbqI9Wq5PoPzTaIU+tMpklbmsssRaomV17wz5f+C0wzHTR1pU1q6xG4oozKak
	 HWry+pkaX6UzsrcFarfuYIsp6Yokru22gAi5OygTDyESXeSBKZILJMcNtYJPUEmkx8
	 6Ro4Ksgc6Izm1qa1mUAx+Vcaog6jxlDbJvgEmDvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@bvger.kernel.org,
	Jared Kangas <jkangas@redhat.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 251/554] mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig
Date: Thu, 15 Jan 2026 17:45:17 +0100
Message-ID: <20260115164255.323681592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

commit d3ecb12e2e04ce53c95f933c462f2d8b150b965b upstream.

MMC_SDHCI_ESDHC_IMX requires ARCH_MXC despite also being used on
ARCH_S32, which results in unmet dependencies when compiling strictly
for ARCH_S32. Resolve this by adding ARCH_S32 as an alternative to
ARCH_MXC in the driver's dependencies.

Fixes: 5c4f00627c9a ("mmc: sdhci-esdhc-imx: add NXP S32G2 support")
Cc: stable@bvger.kernel.org
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -276,14 +276,14 @@ config MMC_SDHCI_ESDHC_MCF
 
 config MMC_SDHCI_ESDHC_IMX
 	tristate "SDHCI support for the Freescale eSDHC/uSDHC i.MX controller"
-	depends on ARCH_MXC || COMPILE_TEST
+	depends on ARCH_MXC || ARCH_S32 || COMPILE_TEST
 	depends on MMC_SDHCI_PLTFM
 	depends on OF
 	select MMC_SDHCI_IO_ACCESSORS
 	select MMC_CQHCI
 	help
 	  This selects the Freescale eSDHC/uSDHC controller support
-	  found on i.MX25, i.MX35 i.MX5x and i.MX6x.
+	  found on i.MX25, i.MX35, i.MX5x, i.MX6x, and S32G.
 
 	  If you have a controller with this interface, say Y or M here.
 


