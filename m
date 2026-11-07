Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060710;
	b=oLzcxBwwOsVRW6NbMgvhBWF2atVrpjyWKLaJTze3pVJGiHwm/zgoyic5G5CdTOuZaY15
	 6JuUazXA5tURL1Wmjxmuh/Wv74ONymj+ctbQC2BZa3GKFngcsifGkdjrI/76lacuHVixW
	 UhYdPpMhzaTV21M3AelgPssWjmXnW7+Q/2YWSFwkArLxdnlyADMzEsY+KWW9DzFhOhbQe
	 NO0QGlprgJPxtEe5JRKydoSOPUkcv1tq1CZbRtHvWCz6gxzNQUTfzOfx1ims/7M7IG5ig
	 EfKLQedod6nggsGpWPZe9k9JK19VWhHp/2kDfTM/gmC+xlASu49ybdDouQ8FidJw5dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=esNADnEXokjxuGgupcnqWpyGPxFZtnl928TUuImPgzw=;
	b=wEyxEKa/OStvdTDivunsL3zYwd5SdmBXtpcd3TgZNOD0LL/iGCTIffeQr6Jxmim/uFsx
	 P71rFQQ7OExYXIpy/zq2hy/AX54h8OOWumiQSspJl8ukElbi2VeM540c71mKrPUU3Ofb5
	 vjHnt3F335EsDRtVSllwDcUk4cmkH1+eQOCK5pvujETTZZ7zNLvA3n0+2BPBtO3ex5ia3
	 3o88a3wrhWGDPg9GBaFqtAfpzrb/hc+vS0fUwE1xI17sW4L/tsHfw+ozwXTj6QQnhLfH/
	 yVFoNj2F7XFw6i/zOxUwCsQW9sG7fMaXwqSu/6kmctg/bwLXJZl5V265Zf3/NR3cxuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhbjQZGP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A5606A326;
	Sat,  7 Nov 2026 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhbjQZGP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021F01F0089F;
	Sat,  7 Nov 2026 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060710;
	bh=esNADnEXokjxuGgupcnqWpyGPxFZtnl928TUuImPgzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhbjQZGPwm0hjf+4vNMKWId6frO7hqKvdO10YqSmtsKLlQHkpKDTxmlgUeKi/0sFd
	 CxHG3NFjySC+/glkCkDZVn2XVV7wXOorYiwznkGfREcY4gRksmGedKhp52nTbY9SgM
	 MvLfWZjTMcmebXzTyRTh8mvKIPF9GEl8aT/1DpPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Kyle Mahlkuch <kmahlkuc@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0137/1536] scsi: qla2xxx: Handle INTx not connected while passing through
Date: Sat,  7 Nov 2026 08:35:53 -0500
Message-ID: <20261107135001.536140227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 56330f6a396e1..e5729663f869a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2815,11 +2815,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
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



