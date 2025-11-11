Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E1A266EFC;
	Tue, 11 Nov 2025 01:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823629; cv=none; b=T6DCLbdkeEuT6sOiVOdcJEWEjXOuJDy2pnJUT3lVrDFDDCbIH+tcCvzYE2iS3E+9OmD/DXv0Db0Zj2tAB/Z6RioD1zPuEHJvf347FNTEWA4UFGIJNx2984nJG5wNQhMoXJ3EiyGwnzmCJH4RXGfL3HFcJikxXzOmZ7beQpHrJgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823629; c=relaxed/simple;
	bh=QlPfgLeKOAG2b7GoFCP0v4GPRCDfGJO/Vy8uldEJexY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REjRl23Jacvk+qvjrwdpHO5Pyg4DrgDS0V2MJoOQtQ2b2AuvQq6vXQkgJmLa0qh2u5vgBt9kLrhM0YZlMZYoMh5Z9caz8Y+yV4/91uj2wLWWbqi9TMCYbOOO/YMV1aW7OMJ9AeeLJngQ86eNL29PCjlbcglymhSsjQ+ZcPuHlCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzRtTYA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzRtTYA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E653AC19422;
	Tue, 11 Nov 2025 01:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823629;
	bh=QlPfgLeKOAG2b7GoFCP0v4GPRCDfGJO/Vy8uldEJexY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzRtTYA66kzmeCribfzj7wlT1meonkVzbM9yECEJXVNVQjIIKmPQeVLD3O0vxRtXC
	 RlyAXvmKMYXo2MI/RZGx5Hn6hIwyrFgPVZVyrOlL9A2r1CGScI3OrTt5IyFLKPpvlg
	 Xt8vlqIfEM744lE4D+0ke+B97Qq2CbVL1j+8NTvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 339/849] bnxt_en: Add Hyper-V VF ID
Date: Tue, 11 Nov 2025 09:38:29 +0900
Message-ID: <20251111004544.616794642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 5be7cb805bd9a6680b863a1477dbc6e7986cc223 ]

VFs of the P7 chip family created by Hyper-V will have the device ID of
0x181b.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250819163919.104075-6-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0daa08cecaf28..0f3cc21ab0320 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -142,6 +142,7 @@ static const struct {
 	[NETXTREME_E_P5_VF] = { "Broadcom BCM5750X NetXtreme-E Ethernet Virtual Function" },
 	[NETXTREME_E_P5_VF_HV] = { "Broadcom BCM5750X NetXtreme-E Virtual Function for Hyper-V" },
 	[NETXTREME_E_P7_VF] = { "Broadcom BCM5760X Virtual Function" },
+	[NETXTREME_E_P7_VF_HV] = { "Broadcom BCM5760X Virtual Function for Hyper-V" },
 };
 
 static const struct pci_device_id bnxt_pci_tbl[] = {
@@ -217,6 +218,7 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1808), .driver_data = NETXTREME_E_P5_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1809), .driver_data = NETXTREME_E_P5_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1819), .driver_data = NETXTREME_E_P7_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x181b), .driver_data = NETXTREME_E_P7_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0xd800), .driver_data = NETXTREME_S_VF },
 #endif
 	{ 0 }
@@ -315,7 +317,8 @@ static bool bnxt_vf_pciid(enum board_idx idx)
 	return (idx == NETXTREME_C_VF || idx == NETXTREME_E_VF ||
 		idx == NETXTREME_S_VF || idx == NETXTREME_C_VF_HV ||
 		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF ||
-		idx == NETXTREME_E_P5_VF_HV || idx == NETXTREME_E_P7_VF);
+		idx == NETXTREME_E_P5_VF_HV || idx == NETXTREME_E_P7_VF ||
+		idx == NETXTREME_E_P7_VF_HV);
 }
 
 #define DB_CP_REARM_FLAGS	(DB_KEY_CP | DB_IDX_VALID)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index fda0d3cc6227c..119d4ef6ef660 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2130,6 +2130,7 @@ enum board_idx {
 	NETXTREME_E_P5_VF,
 	NETXTREME_E_P5_VF_HV,
 	NETXTREME_E_P7_VF,
+	NETXTREME_E_P7_VF_HV,
 };
 
 #define BNXT_TRACE_BUF_MAGIC_BYTE ((u8)0xbc)
-- 
2.51.0



