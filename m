Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051210;
	b=PtG7UiOaK0aCJ/A5SijfWbqwWEuTE234KMYWWs4Ic0hdKdyhJt4XlauiTsJMSVU/6wCI
	 D6A8YQdxZ8ufeM3WBPXEjAshcMHq41yXv76OdYbG4wi1FVDizUuoSw62xqjEv1nvg4bf7
	 hWylmR79/iElLPEi9y/rJzz/cBLDAypLpGPU+0+UmAfH8+AEdGUMef2lYTjX6XNR7jf1u
	 IBkx0m8vmuLYAtjHPzgH6xbaWZIXDXnlPelnGzWMJszmkvUt5y7kPyNWy9q6Wao7E2nPW
	 vavpbasKISJxdOluhldOn1U/uX/Gb29/OHgbnjCPxaGoQFPhz2+z9UmwNui7J61iNWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2o/Sj8drmtxm1T0IvMWC2wuCQkKP8oYCdtC6SDXpP0=;
	b=cLr9fbB5Q4WTyWORjcH8tAQNuqeDrrvEmm3S8GE2G5W9q6+bKR8iHbPrwtDpewZnuDzv
	 7GIpvhbYtarF0gggl4Gpsj8o0MbWHP0iUl+N2Urlsr0Ywiafv5V/rq1AiZ5081vMpy6/u
	 7o/ZTA72r9E9UQaw/xg+RXmtZ3aajWccRlgypmksPZ8UDxh0a3qrfHOyWnoI750VOXmER
	 QRFr1ujSAqlPo+GYz02lQsCdtt10YIKHzbAskdweAGYEPBN1KdGgcOpgd0mWGPKluVW9g
	 HnHlA+i9K0By6J+HhJeOrDEWz8H9g4y2qW9i+GaDGgEvEWxC9UwgB9/ex76yoNwZRAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etXaGNmU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916F5606A325;
	Thu, 19 Nov 2026 01:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etXaGNmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F821F000C4;
	Thu, 19 Nov 2026 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051210;
	bh=O2o/Sj8drmtxm1T0IvMWC2wuCQkKP8oYCdtC6SDXpP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etXaGNmUMDVUA9huMoX6AFtf0HmhRHfyGIkOnQiTBzd4I5cm1VkIUA3QYPldPpGi/
	 ARSLmnKI2qpF8vN0NhxVKe69tUQIMGHcmMmZk18qShtn2962Gc8eCVM12ngWpvXnnR
	 rtdlVWuG9GnQvIzTbvlENciVMI7GfLVsglSw3ay0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Kyle Mahlkuch <kmahlkuc@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0087/2214] scsi: qla2xxx: Handle INTx not connected while passing through
Date: Wed, 18 Nov 2026 15:29:23 +0100
Message-ID: <20261118150013.465820570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 7268e509b43ac1734e1bdb7d18553f7e1080dfb4 ]

The PCI_INTERRUPT_PIN reports if the device supports the INTx.  However,
when the device is assigned to a guest via vfio, the PCI_INTERRUPT_PIN
is set to 0 (i.e none) if the line is not connected and/or the platform
cannot route the interrupt.

In such cases, the guest PCI_INTERRUPT_PIN is 0 and the port number
becomes -1 (255, uint8_t underflow) for qla[25|27|28]xx and qla2031
devices.  The flt_region_nvram is never set, and subsequently the LUN
detection fails.  Below warnings show the NVRAM configuration failure:

 []-0073:1: Inconsistent NVRAM checksum=0xffffffc0 id=HCAM version=0x100.
 []-0074:1: Falling back to functioning (yet invalid -- WWPN) defaults.
 []-0076:1: NVRAM configuration failed.

Handle this case and set the port_no to devfn like its done everywhere
else.

Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN if no pdev->irq")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Link: https://patch.msgid.link/177885270578.1573.14283751510936407585.stgit@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2e787858f9d50..863f91be4b69e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2789,11 +2789,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 	else {
 		/* Get adapter physical port no from interrupt pin register. */
 		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
-		if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
-		    IS_QLA27XX(ha) || IS_QLA28XX(ha))
-			ha->port_no--;
-		else
-			ha->port_no = !(ha->port_no & 1);
+		if (ha->port_no == 0) {
+			/* None of INT[A|B|C|D] may be virtualized by vfio */
+			ha->port_no = PCI_FUNC(ha->pdev->devfn);
+		} else {
+			if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
+			    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+				ha->port_no--;
+			else
+				ha->port_no = !(ha->port_no & 1);
+		}
 	}
 
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,
-- 
2.53.0



