Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054347;
	b=hHtgOUMq7EBOrGuIKTJJkIIePevFbiv6cUt4m6hahPLa/ASm3+aV34tWMfjeLgLsXL6a
	 R7aQ6SYpLcX0/V95bffruYZ3IoR5zhykx00gARxN6MRjlqI2DfDhLmlaakmpvqrNPq0+B
	 v4k4cGiACbCcxjo3O9enXrzLGebZPZNsgtooVjfmrPdQkTc1HYk57jbE1wUYtSp3gzaci
	 DaPvbiqBpau0A+nwZgwTEGNHXdn0+JIXBTTKHQmTVlI0hgjwWGmgaOdF5B/NtluhtYIY4
	 hxc5uWGSFXJL/KYMBcv3GNtk0x+kzhsBLrRgGWPplfjTrLvMd6PxbfO5DSPLxbpvyAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7iGlOWH0dPDrS/derk2rRP3G4DFjeYRNvDPcZETD7L4=;
	b=GqKXPyhPOpXvoG6nzdhRl6vKKnEk++lqAc98v8fU6Z7ZX34+ZK+QlJsT/6ZjFCIy7dot
	 eJQ/F4GgyopH8YmKSAkiP7pSSuHOQC2VYMxBBR8mXlNs5ez50iKGsxhaUhPJrCxoKEqNp
	 Xqi30gkhKAicBZ4DCW/jZP7sVkwG5lc/RxYWB6tkop8i/XpTSDMPHvBny0FGmIHlFQE6p
	 rxFZZSbeYsqP4ZXf+ulHEbHJWaVdOrjJ5yR2UXmVZFaBrG1dE7oZeAVZUrsHzqoi0dUSf
	 yCRN+CJe/WZtV2G42Klcq+HteaTwikuNU++GyvaVVITNuROtPTPCe9UAL/vSUXoAtSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1n6e4J6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1F9606A331;
	Thu, 19 Nov 2026 02:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1n6e4J6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CDD1F000CA;
	Thu, 19 Nov 2026 02:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054346;
	bh=7iGlOWH0dPDrS/derk2rRP3G4DFjeYRNvDPcZETD7L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1n6e4J6yK1ycWThrVM6CBQAxSQsJM4Li1R6BVNoI1WObgVPfL776PhahNInWRYUd
	 w6ey2ojKzkMJzWG/Q4+tCGndsxt6kZaaZ1oZYHmx70mzmD6RQnHJcm8rC5g1lCRl+T
	 FvVAo6Fk4riY8rHmTxVewR1pGSDuUtZhe/tAcOCI=
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
Subject: [PATCH 5.15 1240/2214] scsi: ufs: core: Remove an always-false WARN_ONCE()
Date: Wed, 18 Nov 2026 15:48:36 +0100
Message-ID: <20261118150101.328637029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted ufshcd_poll() context to the equivalent code in ufshcd_transfer_req_compl() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 39e2fb416ec29..1a33618c43285 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5322,9 +5322,6 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	hba->outstanding_reqs &= ~completed_reqs;
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
-- 
2.53.0



