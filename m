Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E58D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B95C433EF;
	Mon, 30 Jan 2023 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087523;
	bh=k0MPJtcYSmF/GUKU6MAyPKpvja/CSt1sCkzf3EO7jn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Mi+qvst63/mQQsD7aMp6qfZjeyLmtAWhyktmMWPfRHzuh1a3RHk8tLWR81jX1PGx
	 ulf0K+sXOMAR8FFy8U6FO/ALnbY2GisAl64L5RgGNxyeOEFbLw+X7jA5fF1+8ladhQ
	 OIvXL6XyT2+sanC9jAKQYI9sO2eaUiymCGMYo3YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey V. Vissarionov" <gremlin@altlinux.org>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/313] scsi: hpsa: Fix allocation size for scsi_host_alloc()
Date: Mon, 30 Jan 2023 14:50:42 +0100
Message-Id: <20230130134346.330398704@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index 4dbf51e2623a..f6da34850af9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5850,7 +5850,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.39.0



