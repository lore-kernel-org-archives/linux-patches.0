Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217269;
	b=Qn5vrIpLcRGALv89rB6oyIUsKfq1o3gc6vxzSWBBl9XyenbKAvOA3dSod4a5xQjjBpTA
	 iEm2NBhZ57zAuSjOYG57RobUZ3kijAN1yHOdSk31A5SFVEH7IPKWLk0yis5fHYC//WLdW
	 LMtuzoaakFUGzpT1puZ4trPKRx/SZbpLdsENx76LEJI9PEIznY1ksXhEyn0FuBSxO5149
	 anVaxE95froWwUUaHnEh0QkIvxtLppwOPjSSJpWsF3rz+/4tsPeTnF2hdbTifLDuoURUq
	 BqfWgLX7KqsTAg1f4rfwisNX9OyHF5H95L/QYRDzTfN4BZbm6qUeTRQ3y23RkPQxK/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ypotNK0hA2rk2CrV3Nq7irzmaXoysumF7MxzR3HAJLA=;
	b=D7dAYLj637Sn+43OmaQRqqQO+DVCr5eYbom0J2llC1rq5CFgOk02YeMpFKpIsAkQgDmp
	 plVOhOvi2eyWjcVE8+/AGLP0ZcEIZ8N6vGT7bCeVucNOxCq37dC7n4Rp3mhP2qKCKpqbq
	 +9EcTG8XUfpi4WbvmhZ5AF4eieUJH+YXIYkt4QIGPvxavy9KlaYvqUeMi2x15dMQg6hmH
	 lb3nyVjLAWxehuj9B47Ha0WKoZpL3gfhCXL/gOjEBExtJIAEAIlRzgQXh4yFJv2eU4T1k
	 JyN1PSpdqEyfI6A1PJafTZu5YJ/04ggzo9c9bjnnr4nSu3jcv2vUUyo73MTTm43VAhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Tzozxlu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31B0606A31A;
	Wed, 28 Oct 2026 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Tzozxlu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C641F01825;
	Wed, 28 Oct 2026 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217268;
	bh=ypotNK0hA2rk2CrV3Nq7irzmaXoysumF7MxzR3HAJLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Tzozxlul3/83Kxj1Uoy3Fo31YvkTQd3q6bQO62TD2/LZJzjFxNabMo2ZHZUEzUzY
	 bO/ZGk/nIA2Z7MozX+3cDiz5vJ0Fy3fC8E5gFCbHa2hpKJnQ9s0jWa25/IY7MQj1JH
	 ySCT4xLZ29Amzed0OvnKcWw4S6IDQIYlAc4YlFyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1846/1887] scsi: hisi_sas: Remove redundant checks for automatic debugfs dump
Date: Wed, 28 Oct 2026 18:05:42 +0100
Message-ID: <20261028170541.457202792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 3f030550476566b12091687c70071d05ad433e0d ]

In commit 63f0733d07ce ("scsi: hisi_sas: Allocate DFX memory during dump
trigger"), the memory allocation time of the DFX is changed from device
initialization to dump occurs, so .debugfs_itct is not a valid address and
do not need to check.

The parameter hisi_sas_debugfs_enable is enough to check whether automatic
debugfs dump is triggered, so remove redunant checks.

Fixes: 63f0733d07ce ("scsi: hisi_sas: Allocate DFX memory during dump trigger")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1705904747-62186-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5d2442678926f..16ddf63ee9b8b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1537,7 +1537,7 @@ static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 		return -EPERM;
 	}
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
+	if (hisi_sas_debugfs_enable)
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
 
 	return 0;
@@ -1910,7 +1910,7 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_internal_abort_data *timeout = data;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
+	if (hisi_sas_debugfs_enable) {
 		/*
 		 * If timeout occurs in device gone scenario, to avoid
 		 * circular dependency like:
-- 
2.53.0



