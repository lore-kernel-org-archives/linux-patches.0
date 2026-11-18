Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043122;
	b=D/eDt9P0TbpP+jf1zzB6EY7FtMlZO6tHPBd+f0WvsbSz4XZvKMZ6roZb5dIJK2zmtlUf
	 PMUMApDUR99D675zoanQwGBYJnHgLKYoW5O0BjP/vbJKrkr+G5vEGxElXIutW0G4zuZsm
	 1Tuk2viASF2+O3HpfauVomiatPv/N0F95nDwzWThfOEGmtHCENEVLqY4PI2pAUeNEcAML
	 VBHaMKGoBep6AKqkswK1iu82aL0L2oux6uqnWS+Kc1NWTF5JYFSM4o1W+sn6LBfIbU79Q
	 jNEgvbJnCM+i7uKCWWOdUwzTo/ixvnYHctDGWbC8i/Ptm02IABBpKpBihqrX4LfQpNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1vfSclSloh3W4ORWC9wcc2Asy/80R0nOUsVeX9GI04=;
	b=l4VOxX9CzLdNCSrBVADDDQ3YLS60GNCIKgx4Ztw4F+szTXxKOXhhu1qsqQLJ0mDeEXSq
	 v9E4kzwBEvP9+rYhwy/LtT5Oqu9cakOJvJmYicGbK0rRe/I8FVdD14NdGUrMsF69r69jP
	 GH4AGp8khzSbIyR8Uwih0jgMOf5YsCIYvi3dUzHsODvzKDQF48aWGsuqknmr6rp957GOF
	 5WvW9D2vF0h5RtK8aQewOP6d1HdBJVKmi3HMEbx4sf1GZzBN628dG/PqJ9yng5f1k+kRb
	 Oo6v3zbjxMfiF0Kj2X3AWfnC7NS8nMqCdhaE25/ruGeny25Lw7UENM3HucLSAyBCgrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PecpWzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA4A606A31C;
	Wed, 18 Nov 2026 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PecpWzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BF01F000C4;
	Wed, 18 Nov 2026 23:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043122;
	bh=U1vfSclSloh3W4ORWC9wcc2Asy/80R0nOUsVeX9GI04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PecpWzR/RihbnIpvCpawAuOSk6KADlbgva6h206gaFl8tcCkpsP9D8268/+/b2Dh
	 MLKqHpdhTMh9SE1SyW8M2E7+Kj6lLJeN5rWqFCVDGPHWApzI5xD3oVGDW/4r8tgmgr
	 vKjCiMOKh9P/lzYJFkYBVpqB4o/eBMOah69IFb3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Kyle Mahlkuch <kmahlkuc@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0097/2857] scsi: qla2xxx: Handle INTx not connected while passing through
Date: Wed, 18 Nov 2026 15:18:51 +0100
Message-ID: <20261118150204.756065585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38e2b31237025..d1d42e03adbfc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2813,11 +2813,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
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



