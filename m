Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052730;
	b=uBmFNcQR8icvp2EoyDyaipEkWsrluMNtfcaWpEXIRqhlPFjVAKsWzcTsB8rkCu+Z81Hs
	 PAPFNQGVdxUDjH0vfSZQtFJnpqzBNd+KSUNbpwa7jeDHrX3FGfJmPzMeSLm/l3mZywFAM
	 Yqpm0Rz7lWJhlPO8lr3pryvNpS/kVtYWN7bHP74wY9jFQ5cM+FylanFiUI4T4EfOHNblC
	 H8JSIiuMpYda+fACvMn9JUPx5iZplcRMDkFXPnF28AL8dNhOljeRe3J5ocXcUSW6FZsef
	 gaJvsgg/D7eMyqDTD38fqzTmda/aURgFBLBb5fDYeyTS6Lb/1XPTwEDmvSH4nP+Lsdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mZdqkHDodO/9NsuvJPC3mXMzCe/sqG+10VkC24647Hs=;
	b=fbulag0dsoc3fdymaXFKzu96BArg1vKRbj4aWjlcj57FyAg2eNgFEvu9nAOF2F45PfQh
	 IsU3OFoylUm7mMZ4TiQn046RZho2EZ2a+EbhfhciokkPIDI4zL1VCbP2ktgN2H/nO3BsD
	 ZCH+5VotBaoRbIkRK084yzHO+TNwxHBnHlMs59g2nW0RvBNTx46HGSwT6IHj5peNt+y6Z
	 X68ISZJ1DWN6+yBuFewX+nj9owNSR+kdFvGXcnInMOfDX3yi8C1DSidQkCsxVrDEvjcF+
	 35AhLC30cGzuJELN9qp2EpdV1u88gb/NdsqhQM5jPYoZ7cAcDOpnfoiYL8s+SN9JHIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aPOm/NIp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEE4606A31C;
	Thu, 19 Nov 2026 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPOm/NIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD41F000C4;
	Thu, 19 Nov 2026 01:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052730;
	bh=mZdqkHDodO/9NsuvJPC3mXMzCe/sqG+10VkC24647Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPOm/NIpcldG3llJqoavzxcva0I0MqdY5Wlw6bydXcBfY8n6TBdKLljicr5Fc+VNc
	 R8gH6mP+y/QQqoq86AzZMQGO3j/tHqq4SwE5K88+Iqtq5vy8qXCxU51kCRPKsO0oXx
	 ReOGNfAf+0HXgqsig7V9FM2CAKIyZiEytPwZRK+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0631/2214] nvmet: zns: dont leak stale memory in zone management receive
Date: Wed, 18 Nov 2026 15:38:27 +0100
Message-ID: <20261118150036.596106611@linuxfoundation.org>
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
index 70f1d106b7065..c620ae5a5c577 100644
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



