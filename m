Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045494;
	b=eiuFGRcvj8B4W9JMhzYTgocMOd5tJoHVAm8fV7DdC73udOCzy5fJ7zFFAelGvaKKd+Em
	 CAjbL3FWYtPdAhzu5rY485Ozu3fgkncbQOmSJBB4OXjrs5xEtnxdunon+1Eu1w041nqtH
	 PgPma9/IuatCeXcpcR69McWlpQSIAiBo4/Ckg9nkPtmzQnnVwxS2w/XBY+uPIxQ4gkQQ3
	 fiop+y4evxz34w4UCPaqEQHUyZZdBlDfR12kKBaUeOJbz4BspWPG9nc/9PiHVxr5kMSMt
	 q4A5zKEQTs8ats5Ks2DbWcoO5Y3hfLfkbd7cTe99f/1Fa7QcylBUH1fhXRZnBwT9tkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1XprbiX9Jg2c/tH1o99hw/tVB/2pnh0SC9JI6/6lI/8=;
	b=hzEdz8svIkgWlLHGYXC2FiuozG9x8qUsmUCmY7y/gjNSEMGWqvCc8w9Vkk73/xFSbA/h
	 qzjJOS2srH3VrHecrzCvBJCE6by+gFsD2VL26T3nV53Sj7lRhLoUU5HlgoZIQyPfTtvGQ
	 CfCoFnr9lbcMx0MmsMcgWVQQsRIsBFPmmR3obAK6/nF96Wrqn4whGLe4DdRUQA2Pni8BS
	 /tE21TLls/qXUyxvLAwZ+qVk2sBmC5fgXmiqL1uzYov3Djko14JmyzenvfoPzh8sx9Eiy
	 lDJvLJH+hPZzBYtZ6DYZVOo0p2An7rvPtW+4iBMdStpAim+rEPGXiwo4ZiiRS2aeCcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VYfsN2S/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54F606A31C;
	Wed, 18 Nov 2026 23:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYfsN2S/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DE41F000C5;
	Wed, 18 Nov 2026 23:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045494;
	bh=1XprbiX9Jg2c/tH1o99hw/tVB/2pnh0SC9JI6/6lI/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYfsN2S/qOyiswHbekhZ7umeyBcZZeXne71/pYBFz90n+UOP1lUUEKGskRjFfIB94
	 q+D+uf/vMP35Y6jU6zmoR73D1SZ9yGfmHs0wIkd9L1q09KzOwNJr++GYGNwv1qo4+E
	 Ks24+N0lyTrRD1lN3ZCjK26y6ZILp01qv6EBFgps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0940/2857] nvmet: zns: dont leak stale memory in zone management receive
Date: Wed, 18 Nov 2026 15:32:54 +0100
Message-ID: <20261118150235.450381933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 31b8a6af19b73e6167c4b655cd5e86681bac1c41 ]

A Zone Management Receive report returns the full buffer the host asked
for, but nvmet_bdev_zone_zmgmt_recv_work() writes only the 8-byte
Number of Zones field and one 64-byte descriptor for each matching zone
that fits. The 56 reserved header bytes and every descriptor slot past
the last match keep whatever the buffer held before. A 4096-byte report
covering a single zone leaves 4024 bytes unwritten.

The tcp, rdma and fc transports allocate that buffer with sgl_alloc()
and pci-epf with kmalloc(), none with __GFP_ZERO, and on success each
sends the whole buffer to the host (nvmet_setup_c2h_data_pdu() for
tcp), so the host receives old kernel memory from the target.

nvmet_bdev_execute_zone_mgmt_recv() also never checks the transport
data length against NUMD, so on transports where the host sets that
length, the buffer sent back can be much larger than the report NUMD
describes. pci-epf derives its data length from NUMD, so the length
check below does not apply there, but the zeroing still covers the
report.

Reject a data length that does not match NUMD with
nvmet_check_transfer_len(), as nvmet_bdev_execute_zone_append() does,
and zero the report with nvmet_zero_sgl() before filling it. Zeroing
NUMD bytes is only enough because of the length check, so the two go
together.

Allocating with __GFP_ZERO in the transports would also close the leak,
but it adds a memset to every read command to fix one handler, so the
transports are left alone.

Tested over the loop, tcp, rdma and fc transports with a zoned
null_blk namespace: before this patch, zone reports carried stale bytes
and a data length larger than NUMD was accepted; with it, reports are
fully initialized and such a length fails with Data SGL Length Invalid.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/zns.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index bb512a88053df..64ec757c7c23b 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -291,6 +291,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 	if (status)
 		goto out;
 
+	/* Only the zone count and matching descriptors are written below. */
+	status = nvmet_zero_sgl(req, 0, out_bufsize);
+	if (status)
+		goto out;
+
 	if (!req_slba_nr_zones) {
 		status = NVME_SC_SUCCESS;
 		goto out;
@@ -319,6 +324,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
 void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req)
 {
+	u32 out_bufsize = (le32_to_cpu(req->cmd->zmr.numd) + 1) << 2;
+
+	if (!nvmet_check_transfer_len(req, out_bufsize))
+		return;
+
 	INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zone_zmgmt_recv_work);
 	queue_work(zbd_wq, &req->z.zmgmt_work);
 }
-- 
2.53.0



