Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0756A359F99;
	Fri,  9 Jan 2026 12:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960369; cv=none; b=TXbH4pX6FpY+Apd87ItBp3Wp6ZtuQ9/jfmsn9VbX2v6YWOMx9lmRfZCbsqYhw7UJupiwLpznZhtw8NLLOoME8LbPI0Oryi1xUd8VJrI/N1SEhL63JS2ZA8CXpKut4+qHZVnfRUIcG51/TyKw3hwc7tA3peGeMs8GZ057oETkhHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960369; c=relaxed/simple;
	bh=T/FgkQCLKyHvU9XKJegoQG6tBiYl/1HguX7pQJAuIX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA5WmRX+9CHzeMoZ61mB6xxuFh2OqDHpAmmH7vB8DvNCpQuOae1FNh29HLJih7rHPpB6+fW9sd17SXr8N47Uc54Vm2aYEwVYA/A2csSfrMkbwhNiyDJ2ASQfaNxN4SiGpHiwR/3RIi8nKwOOkna3WgZT7F2r8Hfy0qlIEpBphvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGXKYk0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGXKYk0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87091C4CEF1;
	Fri,  9 Jan 2026 12:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960368;
	bh=T/FgkQCLKyHvU9XKJegoQG6tBiYl/1HguX7pQJAuIX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGXKYk0/jYYVNlXQJxIa8fuVkSctf4MuFTTWU+/82wCFCYmsDMw/Vv6RzoHe0XdmP
	 DBPUV54emFlAddsZjrOyHcQm1c2MuxYqwesMq251ksldRihKF1KhNTyZEGPU9mt8NT
	 idJ8ARdOVfpq21hJOrbmfBmrE2L2iKQAWqAkHhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@bvger.kernel.org,
	Jared Kangas <jkangas@redhat.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 379/737] mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig
Date: Fri,  9 Jan 2026 12:38:38 +0100
Message-ID: <20260109112148.256479111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -278,14 +278,14 @@ config MMC_SDHCI_ESDHC_MCF
 
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
 


