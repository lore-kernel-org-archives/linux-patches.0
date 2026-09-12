Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C4422E08;
	Sat, 12 Sep 2026 10:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208116; cv=none; b=PrI/el1Qw3tyaKTVq4IcrXncQ7X9eGEcd5No94QpK6EGFC5OTP+LwF/zJkfKTCHlYbek/1C/73mCaHD2DtNBJP042uOtvJll1CZHulxiXQl7qVHfRVe0I9+uFq0IS7N5a2XcJ4PnXvtknX9LmPirCtDLUgMWxYxIOEB4aXrewP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208116; c=relaxed/simple;
	bh=p9XvlL7DywVXEj/KSB+Y2fsRaevKAZwYpSnQ+5HbV1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRpLMCDlJdDzVQpOv+AppfUVJntXXR+uHGGMOQbjZzwVmR32GbkMx7xwnnn/Q0wnHAI8LFmJFM9KjPhBD0hY3Vzl4AhTuoMGecLlfOszZz2fFc3Kamc6kQpHPPO6gjiFiIoU8e/QHKGsEmK8qgdF9qcfEWY3Z3qD22+zbM0rF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPj0sKfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPj0sKfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0087D1F000FF;
	Sat, 12 Sep 2026 10:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208114;
	bh=prO5nV7ol7xHUoceBY2NkcJXhgTwhspk8IQXEQX4+Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPj0sKfTF6xFvQwfFauxIFnrRdrXcscEYk7sZze+TtFVbmJvdqAwHVyq3y8BisMsu
	 IDhQ+r5+lQixFRMV98ITwWJZyYAn8ZDzbV0qiaBaRw/HzdKjrctTrFuvtMiGBHa7fp
	 eihYCflrhS2FnB6L5Uf+DVGTgHpUpBSQ8UDLT5xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takuma Fujiwara <t-fujiwara1@ti.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0509/1518] PCI: j721e: Fix incorrect max_lanes for J7200
Date: Sat, 12 Sep 2026 08:44:38 +0200
Message-ID: <20260912065634.959630005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Takuma Fujiwara <t-fujiwara1@ti.com>

[ Upstream commit 7147a7bfce47acd48c3738130bf0bd692bfd80de ]

The PCIe Controller in the J7200 SoC supports a 4-lane configuration.
However, j7200_pcie_rc_data and j7200_pcie_ep_data incorrectly set
.max_lanes = 2, limiting operation to fewer lanes than the hardware
supports.

Set .max_lanes = 4 for both j7200_pcie_rc_data and j7200_pcie_ep_data to
match the hardware capability.

See J7200 Technical Reference Manual (SPRUIU1D), section 12.2.3.1.1
for further details: https://www.ti.com/lit/pdf/spruiu1d

Fixes: 3ac7f14084f5 ("PCI: j721e: Add per platform maximum lane settings")
Signed-off-by: Takuma Fujiwara <t-fujiwara1@ti.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20260721155743.3347659-1-t-fujiwara1@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 0413d163cfea0..e2ec684cc54ca 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -381,7 +381,7 @@ static const struct j721e_pcie_data j7200_pcie_rc_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.byte_access_allowed = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data j7200_pcie_ep_data = {
@@ -389,7 +389,7 @@ static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.quirk_disable_flr = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data am64_pcie_rc_data = {
-- 
2.53.0



