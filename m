Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062648;
	b=Ww2NwKyl0P1X+QOzNprT1slXxnUXS25KOyezDM8kTzUy6g4SRmxcwxRwMKZsnIqP4ECi
	 059dbC+WSJp/tUQa5PvBy95iNrX8R4FjKtFfuFX7RRKUjMZrXu02EyircPrRjmkei1F4P
	 CHkv1uqT6Hw8c8tj6PM4q95hrLZD7H+7oSQ73t2OYmxw40GdvT6kANj5uNJ951rm6GGqS
	 Gli7F6WXLsJch5VQcs26F9YLCCTl5U/frQZ7/SFR+W7tp3Tz0BV2EpKgn2BVUB4iHwuzj
	 Oc78Q+MRYpV+yX/lLvYJXsLarX6+xAL/O+3cPa+ue0aAlQqtvgmgwRN/1SNXicJHVkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e9WKcQobXv+jIjJveWGPZfeSqx0kDwBdMu0Ub35I8wM=;
	b=onVn5dqvbpWPY1nhmU3yPtEOtxnmCWKDujTa0ASnjsJWoBn7m3MvNTvo1GFktzTx/+f9
	 NrjI/SCKoaKi9ppx8daAzekaiKtSdc/AoB0bKzWlM6x7/qUYUO3EPOnw3ML9pXwfQ+W2f
	 10aeSHGwas6F8fdj1T2hhQfay2RDD1xJdmpDnWAl6zJ+BowyNiQNFX8hb4C+WXZESNdG+
	 EDPKIOznSFoiBaJBav4xJdJsMeGc8KIMo7wSREgVIGil1uzY6rLhm8rh4DfTQwSnSS3eY
	 VaRcBfTf4B694ijlVnXJ+dxPhoqTZur1FGLeDS90FJhYpLhc5Nxmo/xknpGeqxAGU2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R+0pWzAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3156D606A332;
	Sat,  7 Nov 2026 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R+0pWzAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84CE1F008A1;
	Sat,  7 Nov 2026 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062648;
	bh=e9WKcQobXv+jIjJveWGPZfeSqx0kDwBdMu0Ub35I8wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+0pWzAZcaCrQzYHme/F7oAgxixjzBOxakhpc7HdEpvJzyQDgzsUUhWzF+a5qUYPi
	 oPRUHSa2DIm4vGtPFVycR0u8cbkWv4dg8zS3xiCYUl+sACSJE+kNYNw4lWLazSkz1v
	 M3bXEdWnF0gVDvR0Wt52btuy8/cUX/E2M4/u0TfI=
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
Subject: [PATCH 6.12 1513/1536] nvmet: Finish the blk plug when integrity allocation fails
Date: Sat,  7 Nov 2026 08:58:49 -0500
Message-ID: <20261107135040.360181434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff6082d03edaf..3b081f421c81d 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -298,7 +298,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -318,11 +318,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
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



