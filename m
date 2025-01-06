Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410061422DD;
	Mon,  6 Jan 2025 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178229; cv=none; b=NEx0s0sTdwRJ0Fq9hWb89CY1KYhtcQHGb/pHMv7uhTLkl8nYtGkQDJul95zKrq+rJx78VjndfDMUh9gb6AXr3NLXamK9CDYAmuwVpO7jDgG41tO8lp0cMGy1UOhfzDeNSbj9iMjYfGrMXiQcld/b+EtGW4qaKckAilTgR0oPyNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178229; c=relaxed/simple;
	bh=oCZDH7FzNQt5J3WxPc/r/fbG+tPSqgc6pntVHebNDNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1SE05DKc0Blvdx20ngxX2lfDEHUpgZp2FLu6Wairltm9f6Ctll1ZrEPO7O1W5Wq3uqMLpRhMrcY38kZ83D5LCKPS+qGLQZXv+yPiulenPlR1byof49Np+nqm0pBRRQK5nalhpYDQyz4WR56GN5j8eJ7q7Py5l/K5Ap1qVVpBAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLE+FG8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLE+FG8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0545C4CED2;
	Mon,  6 Jan 2025 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178229;
	bh=oCZDH7FzNQt5J3WxPc/r/fbG+tPSqgc6pntVHebNDNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLE+FG8uMM4nNY0REQLQTwPmNb6Hzns37qwcupKD0riotlviGsk8MAO6kPRVU+m2g
	 8S8pIPTRaP8+lMe0jQKI5Zu5O0Jc+5QV93PBYLr6EJgTmgNbz6bILwOKW5Ad4/TOGY
	 O6zmGDY2rgPzWYNRrZwFowqnMwDJPljlaw9tcjo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 021/138] mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk
Date: Mon,  6 Jan 2025 16:15:45 +0100
Message-ID: <20250106151134.020780579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1379,7 +1379,6 @@ static const struct sdhci_pltfm_data sdh
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
 		  SDHCI_QUIRK_SINGLE_POWER_WRITE |
 		  SDHCI_QUIRK_NO_HISPD_BIT |
-		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_BROKEN_HS200 |


