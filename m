Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D757E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1911C433D6;
	Wed,  2 Nov 2022 03:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358785;
	bh=HhTKqwX2TOzotq9GKZGbY+H/5qtVkxtLySv4+2Tj8n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMp9UnNqe8JMARwiJBuGGC1D+h01SGHvLz3kECMlZfYy6sSi9K6xZlG0YDDsykw36
	 xHXA7XRZrrJtuOEtJPqwfMKEtYzUDuIDCHXO9xk2Q9qMuuSxZqUNZtK29WokpA4KWx
	 8n3EOoQBlUyLRQ8XJV+tizCWdXg7WwPmJPydA31w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 25/91] mmc: sdhci_am654: select, not depends REGMAP_MMIO
Date: Wed,  2 Nov 2022 03:33:08 +0100
Message-Id: <20221102022055.761953863@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@chromium.org>

commit 8d280b1df87e0b3d1355aeac7e62b62214b93f1c upstream.

REGMAP_MMIO is not user-configurable, so we can only satisfy this
dependency by enabling some other Kconfig symbol that properly 'select's
it. Use select like everybody else.

Noticed when trying to enable this driver for compile testing.

Fixes: 59592cc1f593 ("mmc: sdhci_am654: Add dependency on MMC_SDHCI_AM654")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221024180300.2292208-1-briannorris@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1079,9 +1079,10 @@ config MMC_SDHCI_OMAP
 
 config MMC_SDHCI_AM654
 	tristate "Support for the SDHCI Controller in TI's AM654 SOCs"
-	depends on MMC_SDHCI_PLTFM && OF && REGMAP_MMIO
+	depends on MMC_SDHCI_PLTFM && OF
 	select MMC_SDHCI_IO_ACCESSORS
 	select MMC_CQHCI
+	select REGMAP_MMIO
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  support present in TI's AM654 SOCs. The controller supports


