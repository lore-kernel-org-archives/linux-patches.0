Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09481547D8;
	Mon,  6 Jan 2025 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179118; cv=none; b=Dx/3lHbkWiGT9Q6n3g4/QSV41HTgsffepOekGwv/gQL4eAJjolAeV12Z3/I8xXC8Z6rmiRATzbP282a0ir0SiM7XH+oQk4v1q1i7NlwsfU8uWrMDEIj5WM0kQq2ks1GCncbc0KqbTXUTBHFNQ4Z0xylxDLZ8QjnQ4nNhq1tjpO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179118; c=relaxed/simple;
	bh=kjLvfA7QA+a0FPtJEmtGUdl5GWTDYLsjp0jISYxvvAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOzDpAo48nlet2hz6/adxHBUP3y32H8B6zlK/F5EVd+HLP4ikxxww2GnAfBz5aW3o4MowcYdF8u+V4omCctRXfoJE2non034YboC8xLWaXUyr59DUgJTQKV6K3gR76oWBXxTRAxmxVvgIxyfYpNzAmQPkPTU4NuDCVIQthYe8iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZShuFrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZShuFrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6A3C4CEE1;
	Mon,  6 Jan 2025 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179117;
	bh=kjLvfA7QA+a0FPtJEmtGUdl5GWTDYLsjp0jISYxvvAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZShuFrVlyPBxU/7LXGArKRxKQCH7qJYfKRz+t49qGjZcg9MRTFJSIritq3TKaKiW
	 OzqpIzWy30rCd1GmhE/mvidgaLqCNhrZ4Wj5KdTxDcZx2/4JYcjEInB/fxsyfFsTU5
	 dOdYsN0eERhsz2dAPrSAhry9EiyZCtK5jIxs9/mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 15/93] mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk
Date: Mon,  6 Jan 2025 16:16:51 +0100
Message-ID: <20250106151129.277975076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1300,7 +1300,6 @@ static const struct sdhci_pltfm_data sdh
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_BROKEN_HS200 |


