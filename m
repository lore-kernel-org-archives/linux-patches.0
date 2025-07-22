Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CAA288C01;
	Tue, 22 Jul 2025 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192662; cv=none; b=reRiusU3hQWyHew1ATr0qjPZnKJandbzkBTVZr89uoMZvBscZfnGoj4Yvdvuyu/PJRWw6Q06Q2XTDsVkDWTJHzw6xsHE9lShLL4IbvSXW0ghP1B/iFKwWge3XUNBPkNJC4SV7TKhRCvRdyGKILfZgMHWVoPE+t1ZCVglJj+WFuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192662; c=relaxed/simple;
	bh=zNsrtBhDqDupqru5wKCBcrGaF1+IQ2OXadrIHIun7zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aogPMxa5l3XX2MVUfaCsTlUkhEfBzSyJCmDn9IaDJKzBH4MqJSRy4UYTfPjm06y3z+zkd+lVVdvMgybTISoX6B2oz7KPYthJJog2+AYTzyn0FHPOoEkZJbqDwZJE9G2qHKYzQqgjPBd9bWOfRfSWnX2sEVBI4c0wLfjLMJnHjBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIeXph7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIeXph7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51399C4CEEB;
	Tue, 22 Jul 2025 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192661;
	bh=zNsrtBhDqDupqru5wKCBcrGaF1+IQ2OXadrIHIun7zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIeXph7dogHVx5caFg7GMitaH7V5OU+ZU75cNEbLvcSZhUcg9EL3b7ayeNx1HZbhy
	 0Z6zbjRCEKgTOnjcnhRJ46mtfTljOMFNdwRepcG9ViEITiTnx77qVnh11tA8qSoK/9
	 syVkGneE4U7yNS1eS+gG8mQTXienKuwPS2w7JGjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 003/158] phy: tegra: xusb: Disable periodic tracking on Tegra234
Date: Tue, 22 Jul 2025 15:43:07 +0200
Message-ID: <20250722134340.733639968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotien Hsu <haotienh@nvidia.com>

commit 7be54870e9bf5ed0b4fe2a23b41a630527882de5 upstream.

Periodic calibration updates (~10µs) may overlap with transfers when
PCIe NVMe SSD, LPDDR, and USB2 devices operate simultaneously, causing
crosstalk on Tegra234 devices. Hence disable periodic calibration updates
and make this a one-time calibration.

Fixes: d8163a32ca95 ("phy: tegra: xusb: Add Tegra234 support")
Cc: stable@vger.kernel.org
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20250519090929.3132456-3-waynec@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -1726,7 +1726,7 @@ const struct tegra_xusb_padctl_soc tegra
 	.num_supplies = ARRAY_SIZE(tegra194_xusb_padctl_supply_names),
 	.supports_gen2 = true,
 	.poll_trk_completed = true,
-	.trk_hw_mode = true,
+	.trk_hw_mode = false,
 	.trk_update_on_idle = true,
 	.supports_lp_cfg_en = true,
 };


