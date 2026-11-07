Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063614;
	b=g7TCuDSeQWsRAKoSb7ZGv7Hdl3TFjK07FovPyOoOnNfsONy5gUPio2XXPmxSKvDiVRGM
	 XkkqUpkGDwH5Cnltw+TYwpsjTb60FdPiLfmebeY8gVyvh83yunZIf2FF98LwMBzKuLesU
	 jLl1Ei23vpQY/J1JtlxOo7r1EessBq53vong5V/nhpM5E3znb6DSR2iHrhwHxKtLuEeAi
	 2qoq3Q9sSHAoke5kBRM3JBOzu6DBvV0r7/0nuNpsl5DM5igjxLOoDC5O1nlbK7cTnG49b
	 s2iUsch7haLcJLzYKb9Pg++peeayZ25AcN1ocKlgLt2nORxNtOYB4x1ggyq+TDDrDcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GjyaSVUp4dmZ5dYZSg+mHcj3CjSbEnJyPBL3mprkUfM=;
	b=w5j5/WFK81IAecXOG+8O7L/f85zNx9Ofk1PAIUXnD540WoyPH96PlwGcG5umjbaC7FC2
	 gdjMhJKMoEhNaxkVaAilrfXeaNyAT11kJ4NYvn6RCQu3V/Jsa1L11BH7szKfJotCUfvH0
	 AbHrazRkRJSLcPnrjepyKFost9oZCJ/k57T23puMi4tOiik2zDrUe42LjoFCc5RU1yX/e
	 X3fgTPKOGLj6BUCtZVoW5SuPP7guB3blubo6f0FwY9Kad1BMdfGqSCRaGwTOo6ePRtITW
	 ojUuWp63jPBMGo9v56E/lZDeYIxc9uGp7lvYvfA1S0JVhR+0wiOErAjKfy7ssa3by8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEpb50L4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D304460A3834;
	Sat,  7 Nov 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEpb50L4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FC61F0089F;
	Sat,  7 Nov 2026 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063613;
	bh=GjyaSVUp4dmZ5dYZSg+mHcj3CjSbEnJyPBL3mprkUfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEpb50L4w3h4ocRMSKdtH/HfyPQd7c5lIFkhWarh5W48p3E0sVPbYmVa0dGs3gCRE
	 lZQTnMyogttVKYUpwr3LFlpUmH8LL3Oj+G+CYaEaSCjaxxUv2fhJL0ak9UHd3OpfRI
	 ao61Ic3TmiWFniryTCRR3eXwNZ7qHFx68i5Lsm4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 735/869] scsi: ufs: core: Remove an always-false WARN_ONCE()
Date: Sat,  7 Nov 2026 08:56:57 -0500
Message-ID: <20261107134917.764718907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit cd37a69c367b6a5f685db0ac7d01f08545081a30 ]

The WARN_ONCE() in ufshcd_poll() can never fire. completed_reqs is set to
~tr_doorbell & hba->outstanding_reqs on the line above, and
hba->outstanding_reqs cannot change in between because ufshcd_poll() holds
hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs is always
zero. Remove it. No functional change.

Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Link: https://patch.msgid.link/20261022034443.3034432-2-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d225ad90cc392..b3dbfd3552dc4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5714,9 +5714,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
 		/* Do not complete polled requests from interrupt context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
-- 
2.53.0



