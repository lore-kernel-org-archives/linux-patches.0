Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044000;
	b=g45J+CIZB/8XIMJiOigpKtYVJyuqegKgZyMr7ok1O4h3iEEGov9nGGEUA+S/rsfpZrW5
	 BHtzR8I6SR0QaoC4CmYpJHVZvDHvxAT4kdmTKmMZIDefZYMlOtQBMX2ix8ZCCJdEtqxXK
	 JXdYr+kfB7HRL1agnDKiLfe/mhoHqzXq6Vohz0gDgofQaSeMiA5QmarrAYJ/1eRQQCGH0
	 ooNL58rogex5bhNqXJLSAjknCUNHdRTqM7AYFNjxEko/OIRnt55uQSt3SdowexB12ktH+
	 niKNxBhH56L6AAZjbXyJTsurLIMNbmgKGqvQxNodApZwzXk+UTtnRk6u7tNEV+ry2/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jCyOsxp++W4ePk0uWT8mgRiwsRytlM+upckVK9809I=;
	b=mA5AgKqIiDe0qHO5Df+YvGGK2EsbXME74bYIgaplcVMuxti3AkafStgY78NbOSeNdMp3
	 rEuR5A36/St/dwUh3B9GanxTuSUqWiGuEGa/ya/UHOzJMTRgrH49ybQB2jA4U0wwrPcyt
	 I9FyUT/gkHPcafesZgXgo6ORKv0PapF1I1JjV/sS8F13v9K5dWlP2iMBsSBfh4zuJujgZ
	 HJ67NepZ3BCLZ6zsjTD6uLYJQrS3GmmYYhGgltUN8sTBf86ucCTjiMEb1PnmJPMGTkGjE
	 yFKqWRu3MJK1P1+UWIsmOiPVYeYo2vzIm87yXdVqY6eoLo8OkflSsjDFTeNzl3I65pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBRtEwaS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3215E606A331;
	Wed, 18 Nov 2026 23:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBRtEwaS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831591F000C4;
	Wed, 18 Nov 2026 23:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044000;
	bh=+jCyOsxp++W4ePk0uWT8mgRiwsRytlM+upckVK9809I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBRtEwaSNMuRT7bIpxWesz1qQnrgT48TrpIBo/e8lgG4WioUp4kS0X38riDCBHKX3
	 ZBkXJg4vkDEXgmHysSD9BlohlXW39luSVDuZumeBqAtMr+0Hv084NG8UOE9USZ6eK0
	 bPhwi8l3QpzR3x6cXjRx/C6WEcApPhCFFkNINleQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0409/2857] EDAC/altera: Use parent device for devres in altr_portb_setup()
Date: Wed, 18 Nov 2026 15:24:03 +0100
Message-ID: <20261118150216.109484549@linuxfoundation.org>
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

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 9868f5c077dfe0b606331f2e782484f91a5789a5 ]

Anchor the devres group and the devm-managed IRQ requests in altr_portb_setup()
to the actual parent device (device->edac->dev) instead of the embedded struct
device inside the copied per-port altr_edac_device_dev.

This keeps devres_open_group(), devm_request_irq(), devres_remove_group() and
devres_release_group() all referring to the same long-lived device so the
group and the resources allocated inside it are torn down together.

Fixes: 911049845d70 ("EDAC, altera: Add Arria10 SD-MMC EDAC support")
Closes: https://sashiko.dev/#/patchset/20260503212558.2811480-1-dbgh9129%40gmail.com
Assisted-by: LLM
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260617164303.585555-1-dinguyen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/altera_edac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 8d3eedb55e2dd..7a46ca232ed77 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1544,7 +1544,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 	altdev = dci->pvt_info;
 	*altdev = *device;
 
-	if (!devres_open_group(&altdev->ddev, altr_portb_setup, GFP_KERNEL))
+	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* Update PortB specific values */
@@ -1572,7 +1572,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		rc = -ENODEV;
 		goto err_release_group_1;
 	}
-	rc = devm_request_irq(&altdev->ddev, altdev->sb_irq,
+	rc = devm_request_irq(device->edac->dev, altdev->sb_irq,
 			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
@@ -1594,7 +1594,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 			rc = -ENODEV;
 			goto err_release_group_1;
 		}
-		rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
+		rc = devm_request_irq(device->edac->dev, altdev->db_irq,
 				      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 				      ecc_name, altdev);
 		if (rc) {
@@ -1614,13 +1614,13 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 
 	list_add(&altdev->next, &altdev->edac->a10_ecc_devices);
 
-	devres_remove_group(&altdev->ddev, altr_portb_setup);
+	devres_remove_group(device->edac->dev, altr_portb_setup);
 
 	return 0;
 
 err_release_group_1:
 	edac_device_free_ctl_info(dci);
-	devres_release_group(&altdev->ddev, altr_portb_setup);
+	devres_release_group(device->edac->dev, altr_portb_setup);
 	edac_printk(KERN_ERR, EDAC_DEVICE,
 		    "%s:Error setting up EDAC device: %d\n", ecc_name, rc);
 	return rc;
-- 
2.53.0



