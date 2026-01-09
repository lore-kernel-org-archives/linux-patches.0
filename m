Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B42F31ED6D;
	Fri,  9 Jan 2026 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962225; cv=none; b=rPJj/TrS2sXUhZTTt/0eeC1VCekz9vK1hhpRnjVDhNPcvKIigk343/v+JtHB+F+cPGr9JY4n89NGLdqcu4G1baI/yniXou4GVNFbdSfS9F35FTsJiRvhGH4IJ6ye4pUXcrWG5htOmjHxzmuQVKsgPua+fhQbPR8NRM7EEf4fUI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962225; c=relaxed/simple;
	bh=NvwEMaur0QTEdxa7PVc0LC/w0NO3ZJP9HtvLRMDUNoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/z8Dub2ZeXNjj+cbVIgAbqkrNJdvaM4H+Mg0VfQedZigjLGoo091JQmP7GNPsImcYTjVH/BUmgcT2hDLQT4XS2kpEb/bhnSoCqhoKxaS8oIhIEvnQJ1lpIgnEovE7cHuT7knnVWoc9xTJND2lMM46AIGmCBq3p/lVkpVH3JXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5KwBp+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5KwBp+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC13C19421;
	Fri,  9 Jan 2026 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962225;
	bh=NvwEMaur0QTEdxa7PVc0LC/w0NO3ZJP9HtvLRMDUNoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5KwBp+5HkT+Krdi2j6aVWKbitMB8zyWonMmJ4TB6bNTX+lwWWg8VOpJCocmrDuj+
	 tGV/2z2bugnEZz+Y/trPv1hnRQNXQgt0vloJUmIBhjLo+i4j4QQiFWSsB1BnNo1uDR
	 ivoGe5+QsvvtVSsPu06zyutRElUYiteVpojT5s8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@bvger.kernel.org,
	Jared Kangas <jkangas@redhat.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 291/634] mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig
Date: Fri,  9 Jan 2026 12:39:29 +0100
Message-ID: <20260109112128.480338273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -279,14 +279,14 @@ config MMC_SDHCI_ESDHC_MCF
 
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
 


