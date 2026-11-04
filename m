Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829509;
	b=uEiw4L6VeSBSCxlw0jFr6aK98I3eR872T7HMADzxgOaMXgDAEOWcQxTC8sy0Vg6O+etI
	 3QJ6CHjdJgPvf5FrA1XKmF9tQHat+zuM59T9BgsPBLMU7eB7SjPwG0CXlihDpjcmLqk3R
	 8S3hk3Sa0oeNbgqlYHp2Hmd72GA3GmUqTP1jbwThEdLmwJJyxwUR+K3/yF2nIZ2RwfiKL
	 tgDKyuBsL3zP+11ZBNo2JwL6hYV1Sdax41VLywFUfRaq8uWGgi3tRnKoV6fAwJLB5LYCo
	 iVifhXMVj6zjpxE6l8wcyOQUHFEtXaYW0xX8GXHEbCM4re3fji3A60mT8aWEuMD+NIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lwl2YefdmXsXvBXqagsuWnCHKFwK+8HO5UAPTu/crPQ=;
	b=rNpSw+Dln2jP6HrSgroe2/W0PYamIc9C8iJPKwdmkSyYoGKNBlWVjmVWRVMahINJRags
	 oBIZNjOJn3i6bUR2NlfO7ceYyHDqKUDeb6v1hV46l3+hMfKMUl4iwy166pz97HnFfaTsS
	 IjGQ6EzTCCnrBg4CQRoSXy0O1ceKk/4geT2/2VmaBjUO+shFaNE8BoF0dhgQpawnpDVz/
	 5/ebGUcQ4lzdh2xNhsTddc5HaI1UbRZB5JgHz3zN3lRsGgZDluL26dDkGpIafBgiv/uAT
	 NwhfVNQnjP0a/a3iYSt0SI3ssKgZdCCG9Xu+/HLair5Gsl1DyzI/BhCvtkvlXC4z3Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H6t0kS0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571CD606A87C;
	Wed,  4 Nov 2026 21:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6t0kS0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3DC1F000C1;
	Wed,  4 Nov 2026 21:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829509;
	bh=Lwl2YefdmXsXvBXqagsuWnCHKFwK+8HO5UAPTu/crPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6t0kS0/omiS/yY5ISz5jOQunqlcODUv1nVh9InIw0tnm09pB0oqnRCG/PDWgAX0/
	 Q2Acu55BtYqIhxymVsgeVfNgm/1CsOpP4Ef6QtggS3ejND95Fp1BzY0M2alpU02nqo
	 IQOEDX6fUae08GTXKIihaAVPm8WWP214ut6krW1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Kyle Mahlkuch <kmahlkuc@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0169/1005] scsi: qla2xxx: Handle INTx not connected while passing through
Date: Wed,  4 Nov 2026 15:58:22 -0500
Message-ID: <20261104211048.503558385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 07ccfe0226c5e..5b1fb7e5e0980 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2803,11 +2803,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
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



