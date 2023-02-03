Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472FE1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF93C433EF;
	Fri,  3 Feb 2023 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419309;
	bh=Xpx3/XqXn+h9WyIq2bzxAtIgX4bxMT++xszklaORfLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sw0uwpURdl6svMuuJ1dkF37bZWrCQMXhZ6EgMPEWUVczqMmLg/NRpsORljG7N4iwC
	 HqVColX1WQe26D9B5c2KpfRAbolYORcB7B7zf57j7AuSaLSxXoTCC++1VPqkgrg5EY
	 iK36jp/Z4yutrKdInK/k6ykhSGP0Z1hGtgqkPMDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey V. Vissarionov" <gremlin@altlinux.org>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/62] scsi: hpsa: Fix allocation size for scsi_host_alloc()
Date: Fri,  3 Feb 2023 11:12:21 +0100
Message-Id: <20230203101014.093410184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit bbbd25499100c810ceaf5193c3cfcab9f7402a33 ]

The 'h' is a pointer to struct ctlr_info, so it's just 4 or 8 bytes, while
the structure itself is much bigger.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: edd163687ea5 ("hpsa: add driver for HP Smart Array controllers.")
Link: https://lore.kernel.org/r/20230118031255.GE15213@altlinux.org
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b25c5ce13ed..34434b7107ee 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5627,7 +5627,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.39.0



