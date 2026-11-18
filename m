Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025248;
	b=Vjp/K28GHMSqQCf1wA66nWqrTN2P7htmtbmOgL926lDfSrlWcml0EG6BAarCbWAm4dvz
	 bqpbJIQUakBFvrcXG62ddMR3FEiNEyRCUDW/XujmA/BUbqsg/Si63pnYwG4LNmuTiVWfG
	 LbKeIdGS+F3iCoHLOFeq0cMEXzG80R8jka1sJFou4gSiuntYnAuoGE1K+ABT8FIAfwEu/
	 b51bRy03Rb6FYI+CUtf1jBHqhkktPdEMyKWQ8eCs9VjwQ9hB7mymOcpmxbJAiPxmonHU/
	 hgwmOpaxmouFvMjlR46USF9K+9syBiklNBk/e11Lq+ow+kz8dI7jOI6oij+VAhfxnsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9D3ATwVGFKX4zMU40LUqVDZABjHSHUx1XgejHAzX35A=;
	b=UJPnBuOG0dQj/64ZK9PRbdtQ/tyADKI0kzE98yAxXfS05y6c6sW+wsKkye2qdE1Ee/5O
	 9V4v12ooNrx2Rwm69J1G7PHa0DTzrmEcnVtJ9UUJf2lK1GPVMlETVqiUry1QHbK74+btU
	 1putoDDseuJJBEm7FbuS6fVNn3iPHhkYorKZPgi6c4tdDLRCAmTPeZ06NnorhHHC7Vzwu
	 Z7fYE/50rEVtUJgFUI1+rGoyuo13uFRKX8IgT62MJ3Xiin2MKnWifFyDWkcJT2HSLLiRh
	 Lq1WQ10QQxzWmCEspI0k0+/tC0k3tI2J+8yO52wIBLjQILVMb5V+Gvin2pQ5b4wHnOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIxavsXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C52C606A33B;
	Wed, 18 Nov 2026 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIxavsXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7ED1F000C4;
	Wed, 18 Nov 2026 18:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025248;
	bh=9D3ATwVGFKX4zMU40LUqVDZABjHSHUx1XgejHAzX35A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIxavsXh/TwFuO9RSwvp5d1J2X/xVK/3lbcWJNI2HC3+QyEPOuymg9QWBnm0aFWfc
	 tKwO7DZZqpzWF1SMthePdM3OJANoGrTcl1vKntCRKQ1HyYsGGOLqkCzwxI+J+Wl5V5
	 esXPAn6m9k36D/U7Lmd0uxztWMPkfOdNGmlu/3LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1011/2151] scsi: core: Move two statements
Date: Wed, 18 Nov 2026 15:45:46 +0100
Message-ID: <20261118150159.255653410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 21008cabc5d9bf2864ff244f4f94abebe3380947 ]

Move two statements that will be needed for pseudo SCSI devices in front
of code that won't be needed for pseudo SCSI devices. No functionality
has been changed.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251031204029.2883185-3-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92feb036a2d3 ("scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1b48820a5eb41..55d6478d255c5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -347,6 +347,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	kref_get(&sdev->host->tagset_refcnt);
 	sdev->request_queue = q;
 
+	scsi_sysfs_device_initialize(sdev);
+
 	depth = sdev->host->cmd_per_lun ?: 1;
 
 	/*
@@ -360,8 +362,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 
 	scsi_change_queue_depth(sdev, depth);
 
-	scsi_sysfs_device_initialize(sdev);
-
 	if (shost->hostt->sdev_init) {
 		ret = shost->hostt->sdev_init(sdev);
 		if (ret) {
@@ -1065,6 +1065,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	transport_configure_device(&sdev->sdev_gendev);
 
+	sdev->sdev_bflags = *bflags;
+
 	/*
 	 * No need to freeze the queue as it isn't reachable to anyone else yet.
 	 */
@@ -1110,7 +1112,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
-	sdev->sdev_bflags = *bflags;
 
 	/*
 	 * Ok, the device is now all set up, we can
-- 
2.53.0



