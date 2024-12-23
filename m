Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C6E8827;
	Mon, 23 Dec 2024 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970721; cv=none; b=CnT1MeCguIhkjC80xBQyBWhic6HpO0n/bpMLUIbs9uB/JnI+xzJn8wbMfN84o1t9H7jxB12QWf/kOn6id5ZsM16N8xHBx00J5IwwyiT+Hs66thvSsCqGCAZ2xgo8F0kHygQa+HX6SYpx4gSIqan/OUilvqPY4dS/p1OIiGkni2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970721; c=relaxed/simple;
	bh=L2OZ/qICzE5g3y5BgHakShHnWYudd8uZ5npHZy0djmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StqjWdWjQCuGZjZwyKXunK61coWuiO6kHeeJPZIt+T8itzMEPBHiDgcA2CALFezN1ancZy2FBMBGHB315MA/JIRkDv8A66WYi4cnu4CnGlbCIGw7m9ajWMQHfgZ9C1AsUcAohRedMSIJU/Uu1T0o+QMTw1nXQMQ7x/CxvO1Nz5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gqwk0Neu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gqwk0Neu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CA8C4CED3;
	Mon, 23 Dec 2024 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970721;
	bh=L2OZ/qICzE5g3y5BgHakShHnWYudd8uZ5npHZy0djmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gqwk0NeuagpbjASJTWo32Km+WqK1XqRAhKwTF2RpHLrf/qYDhNk8TmufuVoIe/TqM
	 g2EYqAkk/c/OeVKeNUod6jJc0DaWzcuK+FOkSJbjY839WpOMU677Dn/AjO78K2qEvr
	 UwQvJGd9v8LeBZomHVev8J1eoDJtJ7ftuzEo595c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 32/83] mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk
Date: Mon, 23 Dec 2024 16:59:11 +0100
Message-ID: <20241223155354.891332149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1520,7 +1520,6 @@ static const struct sdhci_pltfm_data sdh
 	.quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_ISSUE_CMD_DAT_RESET_TOGETHER,


