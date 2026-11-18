Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016036;
	b=ZtpFPxzSu9/FTR2si8OnSGWA6OclWR2hOKQa4VcoVxrjdIzs2wkgPvSsZQEUc17r2pPp
	 /ScwHSRBm898TiH9iM/hkAg0S9ao1qMEIFwQGsuBWP3ZsxtdPloTZMrg+8K9EiqNZoY89
	 pcWEBpRqfkENekfxleemqxmGvUlbkNCfyTsxH8syUs6CGzNkQrLvv9eoRV3Db1goClOJI
	 AUvtirK0IPDRcsFejMtv77xXRZI3M5el5k5toZWrubUfXU/QVWqsv7z3S3a1vVysP+Df8
	 yK9DbcdbeIrLB5iVCBARx+lQXOEo/fCSrTATdqmv6gB0xLnv1mCDsnGw5Fe2H3Enh/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6RJnRnzcfW5oWYfuse2YzgzvRAkXH2Xhuy1vYVgqTYk=;
	b=AdX0O9PeaM4K86ujNReE60s4fAvrnv57FMAfsNC0N0YG+LqCPnIzigRD3JUn0UjBcIGF
	 4P9NKS7FbPUhPrjXJcfqd74hX2TBBOFRh4BXHzolZ6uMjSMrV8wBzs87dSeBKvkvFMa4K
	 e/laQgv3YTqYwL26Ujd7ImoPKSwhoJWJoFmBjn8UDquZybzDYnL9YXpc+f04a7U80La6Q
	 qBan0cyQGAjDT9BzEGpse3Ati4sggPci5docwYDDVD/1gDji7JzCjfC9L9flkrHWd9Uy4
	 UlEaruqJko8Qxh+icggvL5ssfvmEahUUTDcIgcvjeyMo9TX4RC7yFgRG1VNiX2T3lwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooXZMdLM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0364606A335;
	Wed, 18 Nov 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooXZMdLM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2D81F000CE;
	Wed, 18 Nov 2026 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016036;
	bh=6RJnRnzcfW5oWYfuse2YzgzvRAkXH2Xhuy1vYVgqTYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooXZMdLMRngs49jd9XGy/PNkqxs+odP6z2r8bp3kUq/lp2ueT1Qu+3xTrLs3B7WPA
	 tIPmvHhBfgEfgXvZ+e5OjN2lyfZMZ1gSfF42Jxv5w+Ha58J1GTVaJ4Jm5JIp6A30aq
	 PBvAyIuemPRjLaP4yQuFsh56BX3MpgcCJD41k+Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0345/2651] scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 18 Nov 2026 15:26:25 +0100
Message-ID: <20261118150300.264265955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit c94c746e6c80439a4a9a0e1e20f2dae62a4d57ef ]

The enqueue path reads the workqueue pointer before taking the event lock,
while the remove path clears that pointer and destroys the workqueue while
holding it. The enqueue can therefore reach queue_work() after the
workqueue is gone.

Move the check inside the lock.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-17-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5a1cc6557e2eb..dbeb8375ff05d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
 {
 	unsigned long flags;
 
-	if (!mrioc->fwevt_worker_thread)
-		return;
-
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!mrioc->fwevt_worker_thread) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		return;
+	}
 	/* get fwevt reference count while adding it to fwevt_list */
 	mpi3mr_fwevt_get(fwevt);
 	INIT_LIST_HEAD(&fwevt->list);
-- 
2.53.0



