Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058758;
	b=ejf1lHpgEgKA5/br9DdtePBCS5T40UIJr2FWxRW6wOqUe1GrdzhT1DMglw9+gkoW2+kJ
	 g0IsYIGOlr5FVCc4b/dccLE10NTAJEGtnfE6phi6nA0p+ubzffOhW5nCk6y+gYh5AL1nO
	 e+GAFERBYde2xINHZEQGpzSqAOX9YpBDpnkkzGV/o9nffEDk3S98qwx/KtkQvIJ/N2ys7
	 rs5sfPO9Lyi0favK0BKxU3X9UOGDR9RPHB5cKl7ec4X3JhJa6fvrxz3E3rcbCsnp7XHXQ
	 kOeEdtRHeiGsROEhQwRYdBoo5BWW2wm6PV3eCJZd2LUjEDHFxu7wppct/oBVoXtu2QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fz/Ub5/fXU+BnFEdRV3GtGUglN1GZc47w4Yi9rNHp3U=;
	b=tQcg7CB9iS3mFJ/WAJt6ctfCZ8621OUlpNWMn3+0ApFoI79FZvxHZNRiLLN3vaZ2Nh3c
	 w35rzGmR0jOe45NsOgHD2nhlaPSBLzJYhL+j8odTwTZtiZsg6nyAvWMwUBuwHISdlove5
	 VWSYheND3yZg4Oubjh19TVUNBogTs+GsrV/IUfjyg9+NfTfwkPblxeU5jQFF3oNpU173+
	 jpL3j1Efx5vCApzppJSvD/QkC0esPIVjoMWh360RLgGFFuD5fvx6X9jQVu0siaWTR+7WI
	 95cLEwc2R/q5cNEj0zKEyLB6z3O45zcg2Q6xxLItg6bdLVtFU1ABgmXWa8t6sBMUMZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZDx5h90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E90E606A325;
	Thu, 19 Nov 2026 03:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZDx5h90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059671F000C6;
	Thu, 19 Nov 2026 03:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058758;
	bh=Fz/Ub5/fXU+BnFEdRV3GtGUglN1GZc47w4Yi9rNHp3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZDx5h90wy/aDHbqNPJTcUtHzdDVB2sgYWczMhg9afdraYWNd5YmZ3sSwsK1bU4nH
	 AOsBsmvcFwD6/Qud6s+E6yBS9MYcmlXfzqHJmnq65JM8btY7ORTtXEC4/YevMY8/Bz
	 lr6H/Ujla2JfdMxbhcxIto3zqcZp31ZAlAW5VqAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0600/1848] nvmet: Finish the blk plug when integrity allocation fails
Date: Wed, 18 Nov 2026 15:43:58 +0100
Message-ID: <20261118145940.459428562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 18fc5f6f1ca945630dae5404265de55d65194e22 ]

nvmet_bdev_execute_rw() starts a plug before building the bios, but
the two error exits taken when nvmet_bdev_alloc_bip() fails return
without calling blk_finish_plug().  current->plug is left pointing
at the stack frame of the returned function, so the next
blk_flush_plug() walks a stale list.

Route both failures through a common exit that finishes the plug.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 58dd91d2d71c8..7e39f47ef04e7 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -285,7 +285,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -306,11 +306,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		rc = nvmet_bdev_alloc_bip(req, bio, &prot_miter);
 		if (unlikely(rc)) {
 			bio_io_error(bio);
-			return;
+			goto out_plug;
 		}
 	}
 
 	submit_bio(bio);
+out_plug:
 	blk_finish_plug(&plug);
 }
 
-- 
2.53.0



