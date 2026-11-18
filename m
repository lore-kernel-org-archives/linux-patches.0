Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023373;
	b=NgNyOQYm2XaWfe97LA/N5FtkLsA9NT+5ZcZL+FnMXMAjTbVlgholLfXVj8UNer+TBprv
	 SzwAjutKO/SV8DDLMIdYmeWrFJQA3MPzWwFmaEdT7+A73oW+4fvwaV1nhdCBUmWx256zg
	 dXNJFqDneSs2pz/FXF5nh1oqz8Zg6eh7yzmPOQD109UmyLl8i22astStkNxMwTY67Zmx9
	 CKe8DgQcw5OLJZ1GWMRL3MAQidTxaHk4scViN/634YS1CpXKYvBGW+0/UfX3z+y+ovD46
	 OIzAzp0iuloU38zOBhFkjbKdNqKoD47A/1Q7CAR9Y0Zw9lHBsT41mTGgGgnww9EWphw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RpORf7SHY2jCvOg2P5ZPfar77KcFTg7NNrDnI7h2Ykk=;
	b=gAOKO/EeCKRJUlw2nDytQ8mfXe806dGNFnRBS2HwFPuKAkwqTw3X51KHPTxOMb25jFzB
	 P1rrHpqXXpJfq0Z4DccW4IYy//fgbVTIoNkFPquqHamWkozvtKmq11jpDJ/2lNYNXl5Q6
	 y6E6lx/vD9AXxCi2xmrZ/6ttxngAw4KG0vcsoVXw+CaohfsDFogduek/mNguzEqLG6wRm
	 caekVJOlmfA3IGWBnbycL/ekSSIby9QlvEvVinYM8Lj71uPXdYNudfxkJBuKX6e7yKl5e
	 tZF3uxugRVmEJBwqGs/7M5SJHZ7hVpHez6AJqcN0WROfbsGPQosnRdv7pyjxHxCdj7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StgmRg8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5204060A2619;
	Wed, 18 Nov 2026 17:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StgmRg8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701051F000CD;
	Wed, 18 Nov 2026 17:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023373;
	bh=RpORf7SHY2jCvOg2P5ZPfar77KcFTg7NNrDnI7h2Ykk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StgmRg8eTyW8p3tutJKKVsGWqW58kEcOCGFUsQemSkC010+MEDK4YrjQbyRzzfETh
	 Rt8XZJVuUCbfDA3+Dh0vQXRxazNYOeeIPsAnHpXDP04om5YmD1zYlyGEnysR7Uf9Jb
	 0Qdr9WqMe29oXHPB2vE3R0rpLnSlv8dB3TzQXRuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0339/2151] scsi: mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 18 Nov 2026 15:34:34 +0100
Message-ID: <20261118150134.417226542@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 203b3072e7aa10d98b3f2b766693ea925cfc571d ]

The size of the target device map buffer is held in a u16 while the number
of devices it is derived from is not bounded to fit. With enough devices
the size wraps, a short buffer is allocated, and the loop that fills it
writes past the end.

Do the calculation in size_t.

Fixes: fb428a2005fc ("scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-14-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 85315ee17c70b..83503c44cc2ac 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1466,7 +1466,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
+	size_t size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -1492,8 +1493,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = num_devices * sizeof(*devmap_info);
-	size = sizeof(u64) + kern_entrylen;
+	kern_entrylen = (uint32_t)num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + (size_t)kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
-- 
2.53.0



