Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD4B1DE2CE;
	Mon,  6 Jan 2025 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178573; cv=none; b=ZTJzV/2K3ebyUGt9qCnpwBf/SXMeXuefNA4P4uqEgAtHiGwuH0OeeHx1JIRZiA4fSI2HquGfNl0s5+8b4Tb1FO8TsuafOHH2WijibkI0/YE3j0hpU4ybBzy2BXlnJ4a+NcZuWKlB4/rZ0h4NaQ9neDKpJMbRd9ccXYOQvlyNpvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178573; c=relaxed/simple;
	bh=tDAx+TGwYDLfbvVgW+DgyNw0H4qr1+eDvXuvzA11G0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YonEQGNIMZpvTWiDHJAnGCAmTrIa0Wc9TYEsEQe6SgwLnk4DPHG9jb3UHcgdUErNyqaz1YK3bUioNij/UBnq7g97U2uqi4cRaQAe1jRlIkwjG+hy6xPm7qc4/f1M47oLa4BDjP1FmBRdDTjSm4JSVi2M7QeWPXbk/AsN33cXRrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZGvEoEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZGvEoEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04332C4CEDF;
	Mon,  6 Jan 2025 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178573;
	bh=tDAx+TGwYDLfbvVgW+DgyNw0H4qr1+eDvXuvzA11G0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZGvEoEk+PopR0ygnTkOfmuajuzxWzBuC3MsEp74FGNw5qbv9hBLubM9hnjkukR6z
	 GXtZ5gQm80kj25LHCuDjcesG3VXrwj45BJ/NuNjR7CQkxFlcmACPCiagMhqtdnVcf0
	 sm+FKUgxkJVlnUFFQw+5GFNmsddBc4ZMCE0RukjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 024/168] mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk
Date: Mon,  6 Jan 2025 16:15:32 +0100
Message-ID: <20250106151139.376473205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Shete <pshete@nvidia.com>

commit a56335c85b592cb2833db0a71f7112b7d9f0d56b upstream.

Value 0 in ADMA length descriptor is interpreted as 65536 on new Tegra
chips, remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk to make sure max
ADMA2 length is 65536.

Fixes: 4346b7c7941d ("mmc: tegra: Add Tegra186 support")
Cc: stable@vger.kernel.org
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20241209101009.22710-1-pshete@nvidia.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-tegra.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1382,7 +1382,6 @@ static const struct sdhci_pltfm_data sdh
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_BROKEN_HS200 |


