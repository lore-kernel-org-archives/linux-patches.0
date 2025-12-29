Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D726FD9B;
	Mon, 29 Dec 2025 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025290; cv=none; b=CThhaREl9eTiMh32hev58iCKtur6HdfFhZedDUdp6qhsSrUu3xL7cOLTqPYp+VwnDklRNDBeVkPzKBrIaJNLveiJnGfQd69fiufX6l92IvmRL1/e5uJsaRLfpPZ+UMc5Gp8YjNEHNLl6eRblOtMYj0WUkx/8RtBCbBk7eJ863mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025290; c=relaxed/simple;
	bh=oNSbo0NV+LUsn6qzc4Oa0rIhiBkRmcOYmuvgVFpkWbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADMCdFUtq5SKLsOpQCISo/Qgvwk/BcHsNr0/SPi8r1GcJ8G3J0UHymmduBkqJ5fmxEWahnBgP+bEjvo47uV1HLQTBPhrHkEVCgsGkIeeWK2jYsIMYkLqpJOmTzjtEmmEqAg+QsevT0W7sj1VqLbgOx7LLn0UUlU393y/Rgwgf6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWeen9O3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWeen9O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C0DC4CEF7;
	Mon, 29 Dec 2025 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025290;
	bh=oNSbo0NV+LUsn6qzc4Oa0rIhiBkRmcOYmuvgVFpkWbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWeen9O3+2SsTIklKixyXVJ67LGS8vTxlhpumARwu2QLAAwVzgiR6bQFomYfOGHpZ
	 J1J7R6d9T8trbeMLmrVA/fkRbOnguD0SvoyLb/3pL0ztKIzD96ZASn4wPweqKFqnyH
	 Ed/QK4lvPDC0EenBpZNdFTIW0zwnRNPGK6p8ZKQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@bvger.kernel.org,
	Jared Kangas <jkangas@redhat.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 160/430] mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig
Date: Mon, 29 Dec 2025 17:09:22 +0100
Message-ID: <20251229160730.250579988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -315,14 +315,14 @@ config MMC_SDHCI_ESDHC_MCF
 
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
 


