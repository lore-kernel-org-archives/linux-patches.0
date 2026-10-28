Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213895;
	b=FUK/py9C5Iv+s/XvrExsubFIle7B/A4FXMOvv5uAaGRrzNMiEXflIlKVZbnnQWdSt2AU
	 FFcYThJiJxsPUVpJKOtrt5UJq22AUzWQG3CKeO4cRgeaR1z00WpkGKpPm8j/smtSZ6vOY
	 d4jyGZkHFNFbEbi2Gr75iW7ytTZN9kcypUHGCZiMyXunGHOTYdGlrhTLOTi1HW1Rv6ooO
	 Grj/EtZsPDQ5Fs8dQnbsJh/RKaAAKpZ+QfbYz9zscgGHUjJJlZB7ajlMA9h7RiGAlj9h2
	 IQGuQi0A7jbunnq4gkIpMdgzBBpPcfOp9t7Plg3vZ2xWnzbdEQCYcYLDWK/zEuZn65Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6EzMSNFoya/2i1YPdXTkA7LGRcxEgCI9W7g9P6M5lWM=;
	b=oI7fOaIHZhvnnPlt3I8O0OO1221cys2E4UnnZzvK3+YfWb7d61elC6fN2edwQZuqDYmf
	 h5hELczLhPOQxH3DbH3TJgahwsgFBmdFuLs1uMDiSuEegHBIAqLCNCW9KwNcBhs37FU9q
	 +Y1RPM1n0wuGu93ilk/KzOEvfNlSWdR7anOgwSuV268dMBkVo+4zBFgdhjZfKYdCQ9Nlx
	 ovpVqUP+YI134DCUlt66ZBIoN3cCUGNrl6IOOxiLmPOyORY+dFydLGdneuHy0rbliL4LA
	 UrGvSwTNAmkmH7JxCYyRMx0wfQ9yAnhO7FW5z6WEpsOka+h1TL0U2lEm1bEbUS4RUgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spIqix54;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D368606A31A;
	Wed, 28 Oct 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spIqix54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6287F1F01825;
	Wed, 28 Oct 2026 18:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213894;
	bh=6EzMSNFoya/2i1YPdXTkA7LGRcxEgCI9W7g9P6M5lWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spIqix54GCzy/eDsrMe8RoF5yDuQJeyDxXAVz0QB7emsHVZ+E/TdtH3H1qkg8A7og
	 B6Guk14dzqAGwM6CZtT7hbe/ZP0Gsqj/wiT5w+0h3X1ZCJ7LGPvMyl82wvxPcGYQHx
	 cu4xohuwJ4pZbVGzJyq9f4WVRAviCH6iZPhtm0cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yingfu.zhou" <yingfu.zhou@shopee.com>,
	"Chunguang.xu" <chunguang.xu@shopee.com>,
	"Yue.zhao" <yue.zhao@shopee.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0665/1887] nvme-rdma: unquiesce admin_q before destroy it
Date: Wed, 28 Oct 2026 17:46:01 +0100
Message-ID: <20261028170514.545018969@linuxfoundation.org>
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

From: Chunguang.xu <chunguang.xu@shopee.com>

[ Upstream commit 5858b687559809f05393af745cbadf06dee61295 ]

Kernel will hang on destroy admin_q while we create ctrl failed, such
as following calltrace:

PID: 23644    TASK: ff2d52b40f439fc0  CPU: 2    COMMAND: "nvme"
 #0 [ff61d23de260fb78] __schedule at ffffffff8323bc15
 #1 [ff61d23de260fc08] schedule at ffffffff8323c014
 #2 [ff61d23de260fc28] blk_mq_freeze_queue_wait at ffffffff82a3dba1
 #3 [ff61d23de260fc78] blk_freeze_queue at ffffffff82a4113a
 #4 [ff61d23de260fc90] blk_cleanup_queue at ffffffff82a33006
 #5 [ff61d23de260fcb0] nvme_rdma_destroy_admin_queue at ffffffffc12686ce
 #6 [ff61d23de260fcc8] nvme_rdma_setup_ctrl at ffffffffc1268ced
 #7 [ff61d23de260fd28] nvme_rdma_create_ctrl at ffffffffc126919b
 #8 [ff61d23de260fd68] nvmf_dev_write at ffffffffc024f362
 #9 [ff61d23de260fe38] vfs_write at ffffffff827d5f25
    RIP: 00007fda7891d574  RSP: 00007ffe2ef06958  RFLAGS: 00000202
    RAX: ffffffffffffffda  RBX: 000055e8122a4d90  RCX: 00007fda7891d574
    RDX: 000000000000012b  RSI: 000055e8122a4d90  RDI: 0000000000000004
    RBP: 00007ffe2ef079c0   R8: 000000000000012b   R9: 000055e8122a4d90
    R10: 0000000000000000  R11: 0000000000000202  R12: 0000000000000004
    R13: 000055e8122923c0  R14: 000000000000012b  R15: 00007fda78a54500
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

This due to we have quiesced admi_q before cancel requests, but forgot
to unquiesce before destroy it, as a result we fail to drain the
pending requests, and hang on blk_mq_freeze_queue_wait() forever. Here
try to reuse nvme_rdma_teardown_admin_queue() to fix this issue and
simplify the code.

Fixes: 958dc1d32c80 ("nvme-rdma: add clean action for failed reconnection")
Reported-by: Yingfu.zhou <yingfu.zhou@shopee.com>
Signed-off-by: Chunguang.xu <chunguang.xu@shopee.com>
Signed-off-by: Yue.zhao <yue.zhao@shopee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ac76f1ac17090..77a4727d503d6 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1120,13 +1120,7 @@ static int nvme_rdma_setup_ctrl(struct nvme_rdma_ctrl *ctrl, bool new)
 		nvme_rdma_free_io_queues(ctrl);
 	}
 destroy_admin:
-	nvme_stop_admin_queue(&ctrl->ctrl);
-	blk_sync_queue(ctrl->ctrl.admin_q);
-	nvme_rdma_stop_queue(&ctrl->queues[0]);
-	nvme_cancel_admin_tagset(&ctrl->ctrl);
-	if (new)
-		nvme_remove_admin_tag_set(&ctrl->ctrl);
-	nvme_rdma_destroy_admin_queue(ctrl);
+	nvme_rdma_teardown_admin_queue(ctrl, new);
 	return ret;
 }
 
-- 
2.53.0



