Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052937;
	b=B4NGa7upKlthEblQ8tNY9mFf/21gXjHvTUZcpthi8DITGFJGMju3/9eoIASVE9YSEuYj
	 dRR75+UVCM20wk5Ma6HVDEPGpewFUL1XSxvqSDamIrv0/wYzsiMSw4ORu64UeZYNabWnF
	 AE0T5aNqCasd4HHWXA4BbDbiaVTnYWtv5+VuunFnSkShZbleEUTfRY+NTcfWYHfepxNWt
	 +lGhxJhRl9UR+BQ4RWfNPoljAPuTzeGVE2EVUGihsLDp3LvzEofHbA9X2xtHxgcpY2wB9
	 ukJY5yYxORhnotg8EbR6Q6fMtpno0Q1u8dZQjXvmaBQqvjMaZZaQC/uagcfkIuQOU+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k5JrACZXqoUOAiNu4qTcMhxUXtYd2wZpyPh0SoPDSgw=;
	b=gsMtvVklsKK7CEw7rEhG2HTvjiazR65sIfn9WQFPfkdWpit4O/dmb4rHPm7YDuZ61Azz
	 Ycjy8vnq2ln7LboxKpyl2gehJh/2dbXhcD5bel1XysuQpHsj7aZoQ12GpX6ZbSo0+ZIRx
	 m8niUbuq85DV+4PVyOkGU1Ib8vTQ3Bi81tXcvF0IV/6gWypueroykWnRmH+mPLadkQvit
	 LOUOoiUmn0eP2PpJOB98foWKaJhgU/CSfPUWuERkTWR/pWnuPa4gv+81hGohq1CRxhzPd
	 ZvrYdMUmpingsdIwIabJmlEU/iVv1xfGC7NTnxVu9U98SVfFGNBevZWdOlgSiZaxdWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KcJLNvny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577E606A32C;
	Thu, 19 Nov 2026 01:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KcJLNvny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2808B1F000C4;
	Thu, 19 Nov 2026 01:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052937;
	bh=k5JrACZXqoUOAiNu4qTcMhxUXtYd2wZpyPh0SoPDSgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcJLNvnyqTCNY31mA+tqPri5zOuEDOL//4uTC9zM+Ybzf/KZqHiRtOEBFRe2zYq2Z
	 G0ld4Q7CHTo2moIZQaBIopjUC4pKUsJvaHDsfTJph/rkDbXKU/V77E12VwWPJYvKa+
	 eTKs/tJR2lsdIP3hj0k0d98IXnCc4CLJ+Dy2zyi8=
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
Subject: [PATCH 5.15 0742/2214] nvmet: Finish the blk plug when integrity allocation fails
Date: Wed, 18 Nov 2026 15:40:18 +0100
Message-ID: <20261118150041.499210772@linuxfoundation.org>
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
index 46752d5d526cb..4b5b3e53cf25f 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -291,7 +291,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -312,11 +312,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
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



