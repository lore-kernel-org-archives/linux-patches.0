Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217263;
	b=kBzjerdhdxvNF+dNdEorzP07ixHS2+D6OUppY9m+FamapjKMd1NOh+wWoK9Ejviw4kUL
	 /3zypvDvia3EySLSPMXaCk1hqe/WCanBBOtT6D50yLk+oSqTHgnI6uxchr9ult/UzMKZK
	 Ho49U6HNyHjHqulJlvWDvGDP6BPH7GQDmRpo7qPoUgA7WPzYj7peiWFwTzypSJzAKUDmn
	 Gj5rGFmnvN33/jWDb8T9Zd5P07jwEKhOknEatkAd+C3b2bDU5IhGvjdWi7E4svHEJ4D2M
	 +2hoiXeCqTmyf/4SCfzgk0Axn4WgB6JHIwnsqQhTZINPv/lfQ/rbXjg506kmR531KmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MhHSXQdSKtoSrIv3Y/PC/OcuJaQwgp3ZJaHO7Evgq7s=;
	b=Nly6H1oMFty3OQdTjlMrCLWbTxyHAx6O81fWROc8wEcZp0Mk2Gx6YKLWKjsrXwrIDvlk
	 iTVZyTokJEOqPZ5W3Ir0YLtljOOYjniRElX8F0HdYzeCc8QTCPDf8KtCKs/8vs37wq22D
	 BTfkgSdBo8F08rYgE90iCDNG5bJb449it1YGeQl36/oF0KxZeIEP9rvv1LBupAh16Vy0a
	 /3e9B6Wi7T6ycVVA5QdvzhHjxPzWL/Q5JcwVBO1MkysUcOq2MOxz6DYxSNRn+JrmE0eS/
	 bscm1z43+S7g6B8mpsepHpYAzHDQMMQBoGDK3ND/GxyySCnU098IndaJDUuLVI7s4Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7VgRpgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3AE606A31C;
	Wed, 28 Oct 2026 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7VgRpgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FF41F01825;
	Wed, 28 Oct 2026 19:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217262;
	bh=MhHSXQdSKtoSrIv3Y/PC/OcuJaQwgp3ZJaHO7Evgq7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7VgRpgODzXTzmQsfUmeR49cmwtE89+wkvBZDvRthLvK1Amo/MyGV5FxJEjWEJEf0
	 BLZqGMQ2+7UGCX0guoLB5+wxxtsjYtpGCSNv5QNgzpM7dpr5g4+MDs1E6ueRHRBuck
	 7z+DYqebTWMlVtrgp7/vebwVZgkGQvc1CwwxjhFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1844/1887] scsi: hisi_sas: Check before using pointer variables
Date: Wed, 28 Oct 2026 18:05:40 +0100
Message-ID: <20261028170541.411941258@linuxfoundation.org>
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

[ Upstream commit 8dd10296be8562a45c6c6794dd492a2b7dccede8 ]

In commit 4b329abc9180 ("scsi: hisi_sas: Move slot variable definition in
hisi_sas_abort_task()"), we move the variables slot to the function head.
However, the variable slot may be NULL, we should check it in each branch.

Fixes: 4b329abc9180 ("scsi: hisi_sas: Move slot variable definition in hisi_sas_abort_task()")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-4-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b5375a1bd41de..1032da57210a9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1605,7 +1605,10 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	if (slot && task->task_proto & SAS_PROTOCOL_SSP) {
+	if (!slot)
+		goto out;
+
+	if (task->task_proto & SAS_PROTOCOL_SSP) {
 		u16 tag = slot->idx;
 		int rc2;
 
@@ -1652,7 +1655,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 				rc = hisi_sas_softreset_ata_disk(device);
 			}
 		}
-	} else if (slot && task->task_proto & SAS_PROTOCOL_SMP) {
+	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
 		u32 tag = slot->idx;
 		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
-- 
2.53.0



