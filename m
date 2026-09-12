Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F642D0C75;
	Sat, 12 Sep 2026 12:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215899; cv=none; b=D7NJGH3dNGQFN17K0QxTquj+2vPl6Q6UofhIzI931kOKoR8dWEFdAzDZKI9JTPhy8VS14u3ihdQX+63pluHoboMyvcntta98+VfBKDRPhk9QnLfHUR0+dzeXrwA8PAmYQOjYbEd5xVwUOBAuiJClQP76G7qtJZ0riXlId4gzcZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215899; c=relaxed/simple;
	bh=eMz113nHTEjCM8ghB8UoB6Sv2zR/OeO6P8tUuwh54Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrsnA67q1jl1cOOhnyOwShz1kJTxMW5Fjh0rY/6ZDA+UZ/l+jJhNZgShO8AEij3WhOK9J15e08Jah81U/ZtJLMeL0zIeKgFSLHoy8qBzebS8nfCQaz8aOYua1DL90kqDoz2DgXgIW5Vl/NeHR/kNO9nqF5zQJqY2zB4GQSfGCCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfWrdH1X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfWrdH1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97DD1F000FF;
	Sat, 12 Sep 2026 12:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215897;
	bh=k8z3eqqRZ1KVrkGS6cPu0nk4Rf921hXkhX3+NsFMX9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfWrdH1X67wTuUiKw8zX4mjI2pEydxAqW6AgnMTaVr0uMLhruCuNkyavb3cA1enQW
	 NdY8bbQShQ6mctCUU2LiwRTDHxZZcTDMSfcBFoIRZJD3hWJLnAgeSMV32KyiQJKH1I
	 c6JjBvzn9vtUCXGjYom5kK4W4gNAZp5x9l6c7qOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takuma Fujiwara <t-fujiwara1@ti.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0626/1376] PCI: j721e: Fix incorrect max_lanes for J7200
Date: Sat, 12 Sep 2026 08:50:52 +0200
Message-ID: <20260912065621.497440634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c014220d2b24b..e2a522d0f6c14 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -374,7 +374,7 @@ static const struct j721e_pcie_data j7200_pcie_rc_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.byte_access_allowed = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data j7200_pcie_ep_data = {
@@ -382,7 +382,7 @@ static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.quirk_detect_quiet_flag = true,
 	.linkdown_irq_regfield = J7200_LINK_DOWN,
 	.quirk_disable_flr = true,
-	.max_lanes = 2,
+	.max_lanes = 4,
 };
 
 static const struct j721e_pcie_data am64_pcie_rc_data = {
-- 
2.53.0



