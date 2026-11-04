Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829670;
	b=qLzHijjUSRT3J24Jcn6dlGraxxYazeeselcHdxdG3jKwsDgyLE50j+995gcDiKMkD/c/
	 /fg4X4xkEQUYVvOQmpFcSzT/FkWD0yVD/5J06smUBvm8ZuoDNuYx9SAiyXHT/HMM9ztVv
	 ZDTr9for9HmEV1HyjEDjt6mDcS0XAz3r5rz8Zh4esxogkOXqI3pHwmyI1Hr4LjB4BaMON
	 RKkrxCwgTh334supZtUZsKcAmNQ1vlsbUrgpxlNFJyBsWvBIyoVGEfpZuf+XHWfBvTgA0
	 hUpeKXVgF/3tO6YcOKm81E4HHIibI/xymhs+Qlgpr7qMZ0CebSBLDVhCWIdnLsokY4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p/Alny20gNEUQPSR9DPRYIbo0bDlR/8LdNYDWub1Wto=;
	b=bxBLKGo8gdDqXgLetWVfmDMG3DrdyGOXoAUrnp/5VXBbZziAdCn2vAEefa5qxthki+It
	 FvT5ZnTDfTJ0asdtvk+udiASe0j5qAcXhkg90g2M0sEWAbR4yjkUN5JuCzmsxaW/rObeW
	 iJkzEEZ32wcm8QrpE1mv4OpTPITAI4g0xGTzrbpjS70JYQiQgZYjm9jBDs45rzq7kkZDB
	 GZvVx4zafjg2pDxgg4IGvgAKQKO9RBR9MQIp3VR3JnZLPTIW2/p2gV259B7h6FSk8521J
	 tbKFF49BGU0oqm7KrzWJlCh/S+LAjJXiC7C63qOTuVBpz4tPq8o2TMnoeZDkQZR/FIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGxefkja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56A606C583;
	Wed,  4 Nov 2026 22:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGxefkja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAB31F000C1;
	Wed,  4 Nov 2026 22:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829669;
	bh=p/Alny20gNEUQPSR9DPRYIbo0bDlR/8LdNYDWub1Wto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGxefkja58VazhxpRKwILBZP4BDu8IBE/dNFOirVWK/GoNuUpP0fQLtnFixDJREjK
	 D3F9LP/SZdjmLHbK69978HvoWMqtWYn3uImQkZk7iBioRThUYi4shWSl04z93jh2HT
	 xWcSy/w+smTdEkQpdafALIQNUv/wJvZEWKBpjm1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Strahan <david.strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0270/1005] scsi: smartpqi: Add new PCI device-ids
Date: Wed,  4 Nov 2026 16:00:03 -0500
Message-ID: <20261104211051.440853071@linuxfoundation.org>
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

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 1a220e6e87a31c2572cd07ff47023e5cd92ac80f ]

All PCI ID entries in Hex.

Add PCI IDs for Hurray Data controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 207d / 4246
                                            9005 / 028f / 207d / 4256
                                            9005 / 028f / 207d / 4356
                                            9005 / 028f / 207d / 4940
                                            9005 / 028f / 207d / 4a46

Add PCI IDs for ZTE controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1cf2 / 5451
                                            9005 / 028f / 1cf2 / 5452
                                            9005 / 028f / 1cf2 / 5453

Add PCI ID for Ramaxel controller:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1f3f / 0670

Signed-off-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/linux-scsi/20260722220401.6357-1-david.strahan@microchip.com/
Link: https://patch.msgid.link/20260722220401.6357-4-david.strahan@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 36 +++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 88cffb1fb59ce..3f5fabf723c3e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10152,10 +10152,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4246)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4256)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4356)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4840)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4940)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4a46)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -10340,6 +10360,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x544f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5451)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5452)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5453)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x54da)
@@ -10380,6 +10412,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f3f, 0x0610)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3f, 0x0670)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0220)
-- 
2.53.0



