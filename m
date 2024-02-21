Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C5A7E595;
	Wed, 21 Feb 2024 14:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524098; cv=none; b=aIrghk5cyuWwpu/RmCzwXGZdMz8YQ6XMImj0o/JgOvZDxfBUEv7sgiBSquZB4b3fjFWrSP2Icbs3el8hCKGbJ0RmQe7Tf3NF6HL1T5OajZXWXilByXJ3mqzfdzs15BuBEky9Xzs+moIQ1/mikfziywHISdzO8aLyCvTK1NlL9ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524098; c=relaxed/simple;
	bh=H+HzTdTjkUicEumF+woahV9Qa7SZOlciRxwdcRY9ZHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMJrwYCei+tYLK9vqDv7m0wDDPgDMLZxG6OgVBdCsFpz7QDtgc7vc8UNrAjjjyA21Pe4S1xxLSdK4iCRf5O4ieZjDnd9MEsXJAZV8lnp7ZYdMmA05p2gYL9b5mKRxfhUF7zkS+U6rTZQk4wAa3f/PrV7PPVhy22z14LdhkVsm0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTq8weQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTq8weQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D70C433C7;
	Wed, 21 Feb 2024 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524097;
	bh=H+HzTdTjkUicEumF+woahV9Qa7SZOlciRxwdcRY9ZHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTq8weQeOu7AMB0waM3Rr/IKWmD3i0OQKkI1WyDHdIVCg1+Lj8hspgwx3P6D6xGm8
	 5kJG/Xo+U+eOH/qj1rqug7VtJeNE83uQcbsTpQqtDh3JkWB3hRJoRbHYVeTxvYNIWW
	 gqBrNV1gzRUGJ3Vh3uli9QDBd+FjL4xTv+NOjr4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ching Huang <ching2048@areca.com.tw>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/379] scsi: arcmsr: Support new PCI device IDs 1883 and 1886
Date: Wed, 21 Feb 2024 14:05:22 +0100
Message-ID: <20240221125959.156138467@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5d054d5c70a5..f2e587e66e19 100644
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
index 9294a2c677b3..199b102f31a2 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -208,8 +208,12 @@ static struct pci_device_id arcmsr_device_id_table[] = {
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
@@ -4701,9 +4705,11 @@ static const char *arcmsr_info(struct Scsi_Host *host)
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



