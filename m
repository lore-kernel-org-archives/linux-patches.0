Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2807A13BC0C;
	Mon, 23 Dec 2024 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969820; cv=none; b=G1j3ZIwN2f1YADjWs0943as6EuU6BgvZ5U7Lo6PbkYZqheJTxELIMxV1GnlVNWQMjNgO4rjFh22fdeI70mOryvzdzcTJ1BjnGKhMZ6t+Oe6u0iUBClHw1ruCRNsaRpyqGGMWbHDFiE0oNTGXBU8HHHtLkysmgvD9fqfF8ARxCI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969820; c=relaxed/simple;
	bh=zY2ry4xTuO95U3ZUXYmT5bFaKbLI15j26y9IRxWYHIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma0hNexfV8X/faQzl+j4YD17jWFGLFV0TRCEggHFE2lz/tcUJ6z8s67Lj8iRjU6MTH2RJSS/6W3212JZv6kur9uIju/JgVmDGxnVIpC7N1aBTL0JrawNmuoYgMS7Xt2KK0hi4wDfYglQwDDKyNQbozlUrcKByxCWfzoLWmQTI5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7oY8kCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7oY8kCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1724C4CED3;
	Mon, 23 Dec 2024 16:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969820;
	bh=zY2ry4xTuO95U3ZUXYmT5bFaKbLI15j26y9IRxWYHIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7oY8kCIP1KZ4vwp4QuqIYjXfRKpt6NhC/D1XxGrxJdnGGO6+gYiDqpUTiCA79zcx
	 MhF1TPqxV9+qywLREy8Xv+i7TxS0oUjITWAJLyxASb4SUDdv3wuu3lmtyFFjv7SL8c
	 p8kTwqOugPb35NmgeL7hsR2B7+qXIqhJUAzydNoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 063/160] mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk
Date: Mon, 23 Dec 2024 16:57:54 +0100
Message-ID: <20241223155411.105430859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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
@@ -1525,7 +1525,6 @@ static const struct sdhci_pltfm_data sdh
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_ISSUE_CMD_DAT_RESET_TOGETHER,


