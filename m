Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026133;
	b=kQcXJrglJ2O/ti/0khGLHjuFvEArilqIsUygm/8TiflTD5+P8o9Iy+Wd9fsHf2HCZ5Ty
	 08M7UhCMnNOgXXsrX+ONEwi3M2SLEjRTTOoahU7eKR02Kdk7wKSGAXYji62e209cYezcx
	 o1cO5xTpErNFYu4JuDeY1S9AgEfVCnDubH0z8ICDFg7rKdUpWzrs9TjWmmmFZQio1u68a
	 r9nifUW1GJ+RA4ZFecb3/NRTGxgzHHPfIMZZ+oMF5Ya6rWXYPPUN1jM1f32DtsGTG25tc
	 7IrwMjVdj5F8hD6uBchSOiSBZsshi07DMCY6n6iFMEaPDDrjth3l8/Aim+gTEdclpWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e08z4oEBR9OumjfBo3CyZseG6ZXZLpWkCl3aYHM8o0U=;
	b=n32BMA4mNVaxj76Z+V/Lswzfc1S81sUs37Fc84Jvpe/A5tGDIJpco5lnIdDs/XVfVZot
	 fwHWhY5GBJVIHGpuOsk8mnbmMI5HHS+mSfJsn9Om79FHQNJuHPtbKmYY7Jueqq7FOm+JG
	 VGNiui4pSvjDYKcloE2Pbq1lty+JfQVa84MFSw8aWoXn8uVotYNc/o/cG4I4JSwshPlyQ
	 MCNlOy4C4xDhIZdFQaW6yjJE28wjw0/Ht/sacMfWqFTs37ebdGwmvBKq8JeB2zziYoxiH
	 uPJK7br5q57dIeZK2oJVGeqp7q11U5dI+CJrIsVrTr7FaD3YlA7P5DPN+gjTJFM/P9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G+j1Z9//";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ABA606A320;
	Wed, 18 Nov 2026 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+j1Z9//
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684641F000C6;
	Wed, 18 Nov 2026 18:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026132;
	bh=e08z4oEBR9OumjfBo3CyZseG6ZXZLpWkCl3aYHM8o0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+j1Z9//eUlKwK55hyf36YDh3ZQLUpLXlw8r0UTzCIMq2rFkabwwcMaqUbFIhmzs5
	 eeLyh05CFeoeU7YevQtGXoH+nynCMcoY0SRDs/GnVwA4/5Ipk4Mi/KLkhLShWbUTwb
	 /wKs+Vlu+Pmec/GApB5CLi01lettQpDc9mjg3Qng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1325/2151] mailbox: arm_mhu_db: Remove redundant mbox_controller_unregister() on probe failure
Date: Wed, 18 Nov 2026 15:51:00 +0100
Message-ID: <20261118150210.348012986@linuxfoundation.org>
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

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit 8228ed61b6cbd6e79531c9ebfcad233c35eae562 ]

mhu_db_probe() registers the mailbox controller via
devm_mbox_controller_register(), which automatically calls
mbox_controller_unregister() through devres when the device is removed
or probe fails. If devm_request_threaded_irq() subsequently fails in
the channel setup loop, the error path also manually calls
mbox_controller_unregister(), resulting in a double call that corrupts
the global mailbox controller list and causes a kernel panic.

Remove the redundant manual call and rely on devres for cleanup.

Fixes: 7002ca237b21 ("mailbox: arm_mhu: Add ARM MHU doorbell driver")
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhu_db.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mailbox/arm_mhu_db.c b/drivers/mailbox/arm_mhu_db.c
index a39239e38a479..9f1c7bcfdcb40 100644
--- a/drivers/mailbox/arm_mhu_db.c
+++ b/drivers/mailbox/arm_mhu_db.c
@@ -317,10 +317,8 @@ static int mhu_db_probe(struct amba_device *adev, const struct amba_id *id)
 		err = devm_request_threaded_irq(dev, irq, NULL,
 						mhu_db_mbox_rx_handler,
 						IRQF_ONESHOT, "mhu_db_link", mhu);
-		if (err) {
-			mbox_controller_unregister(&mhu->mbox);
+		if (err)
 			return err;
-		}
 	}
 
 	dev_info(dev, "ARM MHU Doorbell mailbox registered\n");
-- 
2.53.0



