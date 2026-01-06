Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CAD34FF44;
	Tue,  6 Jan 2026 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720118; cv=none; b=Np6o+4+moFaXzAhskjg/XjTconL/3C8d+Wbur/O7XwnQPST6aYnhQ8jRZCbiulxY3sQVeGoXvBkAz34QyrBfJK2G15f2X1Ygu4mHOXaMAXRzeFseXFG875GAcbcoDdcYbQ02eRaDOvhElFs8pZ8mtSbQ0vZJgAUizYO0WIClfRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720118; c=relaxed/simple;
	bh=MBYC10UpzAwOtbHOBb5e1KZwevOytXUU7fuD7zv5qqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVYZQPh/GPhhgfL/N87R9ZDPNT/HjilypgkCNBJHJ9xpXX4aAv3MpeohHPm+Ig7d3cbPnmzLouR6ZwS9u+0eX4fsTf1EMG7E0F3Bh0AbZg0krS9NcaAzgfscATtI0R8P4Fh/u5uFtlMpVvNEShLqbDTMKmWjQMh4qqjl7alP0qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+0VHP0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+0VHP0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF769C116C6;
	Tue,  6 Jan 2026 17:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720118;
	bh=MBYC10UpzAwOtbHOBb5e1KZwevOytXUU7fuD7zv5qqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+0VHP0mKw4q+/MbvX1YQ7YavvdgmutNtNzXEhTmlzZgqc7BCn3ObJxTNWJHCZ5ji
	 z5C3Zoc4K9bJ5PEK8OnKlF4kiNwDCtIvMqO9WHq+7jgDmgvfu0H14/Zo9x2NoZ2VlQ
	 vsQE82N7N8ZDSIfQoGN+oQJe3B78+PF7k9iQFfjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@bvger.kernel.org,
	Jared Kangas <jkangas@redhat.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 107/567] mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig
Date: Tue,  6 Jan 2026 17:58:09 +0100
Message-ID: <20260106170455.288158002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -291,14 +291,14 @@ config MMC_SDHCI_ESDHC_MCF
 
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
 


