Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58AC2ED165;
	Tue, 22 Jul 2025 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193231; cv=none; b=gB8OUVWy65dgD8Yg44M0h4Y26dDHppL58sG1iLD2MLHJesov8BhtdTkNsraihZQ5/8vvOGcWHWStp9q7Sp0oJXrEQ7mYVw06vsPfu6KoulbZTnThjEMlZcVfJjhotSltC7u3HH1a/RfBdd96KxB3xM8QV6UjKLTorzmLx8hCk2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193231; c=relaxed/simple;
	bh=7zAbo2CbCB1oKB23wQh5uTFnCrITzi2tfy6k6L9JsnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZGA+YhetVlD/drYBHxU6xMx5R6mKSXPWw9i0MfIKUR3MNWz/DE4DGW0aL9lDJPCTX+Lr0LJMDld4GrMoSHXPnAhSHYzjeXwGKR5covtDd6u3NmY+HXkvLmnhAIrbr9sziCXVH7sVf8keJQ78IoEcPNUJGsgqFNcErNRypoqr1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl7mTI8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl7mTI8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0895C4CEEB;
	Tue, 22 Jul 2025 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193231;
	bh=7zAbo2CbCB1oKB23wQh5uTFnCrITzi2tfy6k6L9JsnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl7mTI8w9V/6glKcXT18bf+Z1Qv3+zrlKXWvZBMtO0fg2bWN8fwhmYelhsJt6zyKp
	 bg8YJt0VCQT8hfVcRBrDBB36uGR1uIRm/H0kX4C03WsCF0l6qoTqWRdj/tscxI2s6o
	 8GNA0tcMAaMuYAcLixFufKVGkzPIkF6FOCKFVBVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.15 003/187] phy: tegra: xusb: Disable periodic tracking on Tegra234
Date: Tue, 22 Jul 2025 15:42:53 +0200
Message-ID: <20250722134345.889908795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


