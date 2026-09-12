Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455C8346ADC;
	Sat, 12 Sep 2026 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199401; cv=none; b=nlTMJqysRsJQfjwXhPjYgxbHvXYniMXiiGK5i+0qWqSaFmLYDH8MaUDsT4QpruENaBGeKHMOSSGiAD5qCLWWId36Xr0RQDnfoLiv2/Judlo6QzaBNqO2d4jS9/qwF+47FCLqaN/ZNs7UdUAQjP9QFI3of5BJelLzt4F4Tph1Eng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199401; c=relaxed/simple;
	bh=XwcpfA0X62v4XJqkNUC7hVDuwJ/PZfw6xZbhWEEo0F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEAyhwRixtWBOd8wdLlAPZh8JXeucdiW7xk8qYSuAnb7s8exfsy4MhZWrnI86nFFL5nzpt0WWkVkdK8csgeTdsskqrUqb9ee71NBZGLB6u6kfmmyjjp++5mmBYtll4d31Oxx0nt3VaeivNRgoW0Lqwb2BoLY/ni/P/kEX7474N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Icjd/qmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Icjd/qmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27061F00893;
	Sat, 12 Sep 2026 07:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199400;
	bh=eMb1Kr26Pz9Kf15Pf7cTPftIKfgtaHxZQe7J852+Zcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Icjd/qmq5ZvUpF/D6xTO4ijaYUkm95/d5bO1DC+WJk8ANVwp7nx41yHTngsbJxW6Y
	 34lalMNsq6qGusE2FGPuDsqMl1QhF9cQjKpv5gI7YyXD8kRa962q/tl1QgceJgopap
	 7dh6rIYlmtlLG9/0ZYipY2SaNzikL7mC81yxtvU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takuma Fujiwara <t-fujiwara1@ti.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0576/1815] PCI: j721e: Fix incorrect max_lanes for J7200
Date: Sat, 12 Sep 2026 08:38:46 +0200
Message-ID: <20260912065702.402756560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ae916e7b1927a..822602836b120 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -383,7 +383,7 @@ static const struct j721e_pcie_data j7200_pcie_rc_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.byte_access_allowed = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data j7200_pcie_ep_data = {
@@ -391,7 +391,7 @@ static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.quirk_disable_flr = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data am64_pcie_rc_data = {
-- 
2.53.0



