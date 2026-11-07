Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064814;
	b=DHsCJY2xbnJsOo6d3FtdvqE5VI/zPn0sYTcjsp0sEIOHRfhsC9rXNFutOiuN7BeAKBHk
	 MpSeOl0P0S8/b1VOTNaU0PLVFjpRc5rNbR3qG9xPoc23BhZm804wWp4/mKfCMQoRlo+5m
	 kh5VsTe20r7TIbKGK8OvHKKcCQZmRv3/PLZ98i5to6jZY0qU+GhsACSdGaysBmsRL6sDF
	 y1r1dUrQYuveuNbR9OI2PMrvyGk4e5KhHi1pY/Jb9EyAp3/s/wVkr9wdIWtz6UKQlh//F
	 QcUy2Gwk5jBu92UhzrHKSKT07Bm62gt7AUYRYKds4GvnAR73wMc/5gJA4G5oOMXSfqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7Q91Ce8YYS5T7IhO29wFQvpqfpJ3cnSeUVinbmRTfk=;
	b=spMhhMJ3HxB5y/WZwJwNoYiAGKjuL/WpyUnLWkRzD/VwfGfzLj1APaCU5r2nHTGnm2Ca
	 aKpKqcpz3E7HydiUKrLkIvAUywW17LRkT14uLD+DIfhAHQzookrO31lvz2WI43e2OJ6k1
	 P2DxY5f0B7f+XW1h0s0Xk7P17VSK3jefMJXyi3RqpSL7hcC2oNjNJ5npPsTi5ovNvCp7w
	 a66MKkjHm+oKI56+Z7fkD0NiIAQ/O3/2cYVVLqu9A/Sd9+9hSJqRKQdKhS/7vWYpZI2f2
	 vRbk50/NCqaPsa9gZDgyQqcTbf5FmioWMBs4LT3vJvv4iuwFlU+ICPo9rsYA5O94pOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBeOroBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE81606C02A;
	Sat,  7 Nov 2026 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBeOroBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2CA1F0089F;
	Sat,  7 Nov 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064813;
	bh=u7Q91Ce8YYS5T7IhO29wFQvpqfpJ3cnSeUVinbmRTfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBeOroBGbl8sytA/z/kMMGsMy58mZz0t5pmObXK7yDsOn/Lkkw9xKGpYwiAv8bJAX
	 1Mn7cHTR44O2NPoAbEvRUetUpVsHK/TzyaW0oL7Rsd8zgQruhnYAG55Frv4jqqSK9n
	 EmVpmL7AOB/lgibpdmbxHoxWbBNN0EDGNb6uQCas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0713/1257] nvmet: zns: dont leak stale memory in zone management receive
Date: Sat,  7 Nov 2026 08:50:09 -0500
Message-ID: <20261107134958.947766669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 23a17c02abee2..78d82b6ff1214 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -282,6 +282,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
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
@@ -317,6 +322,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
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



