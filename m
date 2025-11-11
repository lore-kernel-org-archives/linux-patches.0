Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16DE26056C;
	Tue, 11 Nov 2025 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823404; cv=none; b=DVW3lr1WAJvyF96jUOpsQ+ZJuCnVNXQfFom3lNXK364Q2/Urv5QZ1yzGA4ao/k7ws0UzJvXXUmP8K9gTx0K+4hr/7enWT7IKcINh8uCde/w/s6DlAXt9z4LqXj5Emw4j8hbXX4Xh58S3EUYYHQlZftsQTRO+HV21lySnJCtHBx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823404; c=relaxed/simple;
	bh=Y248m2qPKljrqVx8bNZzhjpExGBy9ewvixIcY7cqPZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpH9cTrn6n5lx5Su1VwhoKS0rr/jsYFOkcJxAWPR911rjrLWDoQbJiqgC79JORhYIIL0uCII5GkgNnE10r5/KRurOKbvd+RIG00rMcdExF2LzqpwBPdBBbJ3ipvdac71+pbWihU+pyohjqBSsHPf6dmF3SqQyZcw3fj5xdtjIcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adi3WtPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adi3WtPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E8AC113D0;
	Tue, 11 Nov 2025 01:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823402;
	bh=Y248m2qPKljrqVx8bNZzhjpExGBy9ewvixIcY7cqPZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Adi3WtPcMfnHKu261S3gSEOZnT5ZooXWT39KG7FVYfDLYj8CyQ4uqukM2cu+htXgc
	 P7LUa75VDeK3tvGdPSXyTmicyTK4g57xjYfyycyRnkfQrOWD2ZMPekCodlbKsld7q+
	 cxLvKSv4JqymJqiPumm/izzqNNrN/m5nHdIpQIxE=
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
Subject: [PATCH 6.12 240/565] bnxt_en: Add Hyper-V VF ID
Date: Tue, 11 Nov 2025 09:41:36 +0900
Message-ID: <20251111004532.312704377@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 8a6f3e230fce6..30d8e8b34dfb9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -139,6 +139,7 @@ static const struct {
 	[NETXTREME_E_P5_VF] = { "Broadcom BCM5750X NetXtreme-E Ethernet Virtual Function" },
 	[NETXTREME_E_P5_VF_HV] = { "Broadcom BCM5750X NetXtreme-E Virtual Function for Hyper-V" },
 	[NETXTREME_E_P7_VF] = { "Broadcom BCM5760X Virtual Function" },
+	[NETXTREME_E_P7_VF_HV] = { "Broadcom BCM5760X Virtual Function for Hyper-V" },
 };
 
 static const struct pci_device_id bnxt_pci_tbl[] = {
@@ -214,6 +215,7 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1808), .driver_data = NETXTREME_E_P5_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1809), .driver_data = NETXTREME_E_P5_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1819), .driver_data = NETXTREME_E_P7_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x181b), .driver_data = NETXTREME_E_P7_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0xd800), .driver_data = NETXTREME_S_VF },
 #endif
 	{ 0 }
@@ -297,7 +299,8 @@ static bool bnxt_vf_pciid(enum board_idx idx)
 	return (idx == NETXTREME_C_VF || idx == NETXTREME_E_VF ||
 		idx == NETXTREME_S_VF || idx == NETXTREME_C_VF_HV ||
 		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF ||
-		idx == NETXTREME_E_P5_VF_HV || idx == NETXTREME_E_P7_VF);
+		idx == NETXTREME_E_P5_VF_HV || idx == NETXTREME_E_P7_VF ||
+		idx == NETXTREME_E_P7_VF_HV);
 }
 
 #define DB_CP_REARM_FLAGS	(DB_KEY_CP | DB_IDX_VALID)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1758edcd1db42..cb934f175a3e4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2096,6 +2096,7 @@ enum board_idx {
 	NETXTREME_E_P5_VF,
 	NETXTREME_E_P5_VF_HV,
 	NETXTREME_E_P7_VF,
+	NETXTREME_E_P7_VF_HV,
 };
 
 struct bnxt {
-- 
2.51.0



