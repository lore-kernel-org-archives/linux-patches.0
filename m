Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22993125B6;
	Sat,  3 Feb 2024 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933353; cv=none; b=O5QiV4CVN2MSwMH2RhktUjHQCwfWOGfpAAw78OUPywF8rKj9x68NT7cepyf6UMh1TXRzui0G0sTLYotBHFDVc/yL0oP+/DdHCoxd4yHtU+SsSi4hJHD39MFAWaecdoN1zvrWw0l5mO+SsynLpe2CNJhDMp/Hq0BQnUn+i1JBrRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933353; c=relaxed/simple;
	bh=yPO7F9GoOWenPp0b0pPAeobxGA11lkPFgMpGGz7jKkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL4M5acfrKdbi7leZzeh9ztD/h59dvKgA62w1UDTrXCpnUKj+StydSXgmte7lNuO/sv6puC15sg0hot+02e6XmcsYaAmrEj7FWWM+ZHWlbw1nE+AADIplQruCYJevlFbG7cI+sGroxzx4o3k2fyK9421gI4AnmRs7pFh3p/2rM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiolwZSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiolwZSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DDDC433B1;
	Sat,  3 Feb 2024 04:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933352;
	bh=yPO7F9GoOWenPp0b0pPAeobxGA11lkPFgMpGGz7jKkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiolwZSwY5EPpEHH5bfPdqxPP+mdzxM6BXz0mp3sSbEV4yosxoDZAP21+s0fT+Kba
	 F4z0ZqvkDVU4JVcLVun5IF9eq7d4QUQkATlODisiNYmpMVhjJHWoEOD4dnj5frh7u1
	 ECWvheGTFrIedeDmumgxXdPyxlk4Oxw6czM2DPIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ching Huang <ching2048@areca.com.tw>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/219] scsi: arcmsr: Support new PCI device IDs 1883 and 1886
Date: Fri,  2 Feb 2024 20:03:50 -0800
Message-ID: <20240203035325.057846679@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: ching Huang <ching2048@areca.com.tw>

[ Upstream commit 41c8a1a1e90fa4721f856bf3cf71211fd16d6434 ]

Add support for Areca RAID controllers with PCI device IDs 1883 and 1886.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
Link: https://lore.kernel.org/r/7732e743eaad57681b1552eec9c6a86c76dbe459.camel@areca.com.tw
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arcmsr/arcmsr.h     | 4 ++++
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 07df255c4b1b..b513d4d9c35a 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -77,9 +77,13 @@ struct device_attribute;
 #ifndef PCI_DEVICE_ID_ARECA_1203
 #define PCI_DEVICE_ID_ARECA_1203	0x1203
 #endif
+#ifndef PCI_DEVICE_ID_ARECA_1883
+#define PCI_DEVICE_ID_ARECA_1883	0x1883
+#endif
 #ifndef PCI_DEVICE_ID_ARECA_1884
 #define PCI_DEVICE_ID_ARECA_1884	0x1884
 #endif
+#define PCI_DEVICE_ID_ARECA_1886_0	0x1886
 #define PCI_DEVICE_ID_ARECA_1886	0x188A
 #define	ARCMSR_HOURS			(1000 * 60 * 60 * 4)
 #define	ARCMSR_MINUTES			(1000 * 60 * 60)
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d3fb8a9c1c39..fc9d4005830b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -214,8 +214,12 @@ static struct pci_device_id arcmsr_device_id_table[] = {
 		.driver_data = ACB_ADAPTER_TYPE_A},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880),
 		.driver_data = ACB_ADAPTER_TYPE_C},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1883),
+		.driver_data = ACB_ADAPTER_TYPE_C},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1884),
 		.driver_data = ACB_ADAPTER_TYPE_E},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1886_0),
+		.driver_data = ACB_ADAPTER_TYPE_F},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1886),
 		.driver_data = ACB_ADAPTER_TYPE_F},
 	{0, 0}, /* Terminating entry */
@@ -4708,9 +4712,11 @@ static const char *arcmsr_info(struct Scsi_Host *host)
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:
+	case PCI_DEVICE_ID_ARECA_1883:
 	case PCI_DEVICE_ID_ARECA_1884:
 		type = "SAS/SATA";
 		break;
+	case PCI_DEVICE_ID_ARECA_1886_0:
 	case PCI_DEVICE_ID_ARECA_1886:
 		type = "NVMe/SAS/SATA";
 		break;
-- 
2.43.0



