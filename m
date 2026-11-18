Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050367;
	b=f0muM5IuxYYskmf2cYfHuqrdJmM1YvzMrMcpCOFJPrEyw4w0piEe8N1wlMOhNurT4RVK
	 L1do4YJnRTVXw6+013leh47yQSvCpD8DdP1TZu4BtpqtZX6LLqLt7/lYIRg3h2v+AexqT
	 ZpJbHY8db4JiCB7cWEM+5pyI39L+Jty/ziV7l09YaN6kB5z+Ja7PZ9+JGuQX0KgwHNEyb
	 BaMzX8Fi4tXAJoFN10zv69qu89Xpl2ytUpBpEray6l10ApVflx3FvN9bNm42c0avEbaB2
	 aC1BLl9souV4otj6f4Vf3aSoJRvh1xJda2L/jlzHU/JN0U0DDdiW9cHn8lA5OsPfpTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z9OvOKAKUaOU146Nxf6NrjMVO03WPf7HIR00IKsn038=;
	b=ekolxxNIE9Pk3bshuodAx4x3Va4JWDKxsuJxSfhJgc3Z16clysrDD4lvRiaJe0NCAE4H
	 AacYWBOjzJNBnhB/SgmH/Za6hTlUZtelvH88+QaCStzlR697z2MptXT2N5A0SqIMlK2q6
	 FTdmQi2d5WNFxOdIoI5SGyNLl3pYTjbAYdIHDYV7mN42ZTmwoUWUtDzH8scsrlLoG1qE8
	 Iq0mP02dYH1fJmb2jujQq4Y7OsziEsQmTEqoQfYlBClv5sWU/69HMZ/UesFEOgSmS01GG
	 1lqmi+R3ZLeqm5nv7c6Cy0FPEqXCOuIKF9VzeGEs0sfbxh9kkLXXIC1f2/BLsgstxeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXcAye7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D8F606A338;
	Thu, 19 Nov 2026 01:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXcAye7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BA91F000C4;
	Thu, 19 Nov 2026 01:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050367;
	bh=z9OvOKAKUaOU146Nxf6NrjMVO03WPf7HIR00IKsn038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXcAye7hXXWMwCdFmKVZ0GsFaz0XQ727W03L3UBifw8tfVFyHuWdUCXbC47cfVMsP
	 FrojAUuHDdZQEE6QAhcVKqwpJOZw+mIbyH4rmDGlgTeYyBweQR1xDnTUi5+Z46cECF
	 ZU0rX0dkFeReazbqpaI7GoY8zE6yWrjjCQvwerKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2684/2857] nvme-fabrics: add queue setup helpers
Date: Wed, 18 Nov 2026 16:01:58 +0100
Message-ID: <20261118150338.217276425@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a249d3066de62ce2ed68fdf6445556658ecba222 ]

tcp and rdma transports have lots of duplicate code setting up the
different queue mappings. Add common helpers.

Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 9588769af5fc ("nvme-fabrics: reset io_queues before computing the queue mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 76 ++++++++++++++++++++++++++++++
 drivers/nvme/host/fabrics.h | 11 +++++
 drivers/nvme/host/rdma.c    | 79 ++-----------------------------
 drivers/nvme/host/tcp.c     | 92 ++-----------------------------------
 4 files changed, 96 insertions(+), 162 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index c4d58e5f3ea7b..7d3a34acf80e3 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -959,6 +959,82 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	return ret;
 }
 
+void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
+			u32 io_queues[HCTX_MAX_TYPES])
+{
+	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
+		/*
+		 * separate read/write queues
+		 * hand out dedicated default queues only after we have
+		 * sufficient read queues.
+		 */
+		io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
+		nr_io_queues -= io_queues[HCTX_TYPE_READ];
+		io_queues[HCTX_TYPE_DEFAULT] =
+			min(opts->nr_write_queues, nr_io_queues);
+		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
+	} else {
+		/*
+		 * shared read/write queues
+		 * either no write queues were requested, or we don't have
+		 * sufficient queue count to have dedicated default queues.
+		 */
+		io_queues[HCTX_TYPE_DEFAULT] =
+			min(opts->nr_io_queues, nr_io_queues);
+		nr_io_queues -= io_queues[HCTX_TYPE_DEFAULT];
+	}
+
+	if (opts->nr_poll_queues && nr_io_queues) {
+		/* map dedicated poll queues only if we have queues left */
+		io_queues[HCTX_TYPE_POLL] =
+			min(opts->nr_poll_queues, nr_io_queues);
+	}
+}
+EXPORT_SYMBOL_GPL(nvmf_set_io_queues);
+
+void nvmf_map_queues(struct blk_mq_tag_set *set, struct nvme_ctrl *ctrl,
+		     u32 io_queues[HCTX_MAX_TYPES])
+{
+	struct nvmf_ctrl_options *opts = ctrl->opts;
+
+	if (opts->nr_write_queues && io_queues[HCTX_TYPE_READ]) {
+		/* separate read/write queues */
+		set->map[HCTX_TYPE_DEFAULT].nr_queues =
+			io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			io_queues[HCTX_TYPE_READ];
+		set->map[HCTX_TYPE_READ].queue_offset =
+			io_queues[HCTX_TYPE_DEFAULT];
+	} else {
+		/* shared read/write queues */
+		set->map[HCTX_TYPE_DEFAULT].nr_queues =
+			io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_READ].queue_offset = 0;
+	}
+
+	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
+	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
+	if (opts->nr_poll_queues && io_queues[HCTX_TYPE_POLL]) {
+		/* map dedicated poll queues only if we have queues left */
+		set->map[HCTX_TYPE_POLL].nr_queues = io_queues[HCTX_TYPE_POLL];
+		set->map[HCTX_TYPE_POLL].queue_offset =
+			io_queues[HCTX_TYPE_DEFAULT] +
+			io_queues[HCTX_TYPE_READ];
+		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
+	}
+
+	dev_info(ctrl->device,
+		"mapped %d/%d/%d default/read/poll queues.\n",
+		io_queues[HCTX_TYPE_DEFAULT],
+		io_queues[HCTX_TYPE_READ],
+		io_queues[HCTX_TYPE_POLL]);
+}
+EXPORT_SYMBOL_GPL(nvmf_map_queues);
+
 static int nvmf_check_required_opts(struct nvmf_ctrl_options *opts,
 		unsigned int required_opts)
 {
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index be2388ecc91be..ad24ce5382ff4 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -196,6 +196,13 @@ static inline void nvmf_complete_timed_out_request(struct request *rq)
 	}
 }
 
+static inline unsigned int nvmf_nr_io_queues(struct nvmf_ctrl_options *opts)
+{
+	return min(opts->nr_io_queues, num_online_cpus()) +
+		min(opts->nr_write_queues, num_online_cpus()) +
+		min(opts->nr_poll_queues, num_online_cpus());
+}
+
 int nvmf_reg_read32(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 int nvmf_reg_read64(struct nvme_ctrl *ctrl, u32 off, u64 *val);
 int nvmf_reg_write32(struct nvme_ctrl *ctrl, u32 off, u32 val);
@@ -209,5 +216,9 @@ int nvmf_get_address(struct nvme_ctrl *ctrl, char *buf, int size);
 bool nvmf_should_reconnect(struct nvme_ctrl *ctrl);
 bool nvmf_ip_options_match(struct nvme_ctrl *ctrl,
 		struct nvmf_ctrl_options *opts);
+void nvmf_set_io_queues(struct nvmf_ctrl_options *opts, u32 nr_io_queues,
+			u32 io_queues[HCTX_MAX_TYPES]);
+void nvmf_map_queues(struct blk_mq_tag_set *set, struct nvme_ctrl *ctrl,
+		     u32 io_queues[HCTX_MAX_TYPES]);
 
 #endif /* _NVME_FABRICS_H */
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 79b6c9d5d0ad5..4a9368669aa1b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -720,18 +720,10 @@ static int nvme_rdma_start_io_queues(struct nvme_rdma_ctrl *ctrl,
 static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
 {
 	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
-	struct ib_device *ibdev = ctrl->device->dev;
-	unsigned int nr_io_queues, nr_default_queues;
-	unsigned int nr_read_queues, nr_poll_queues;
+	unsigned int nr_io_queues;
 	int i, ret;
 
-	nr_read_queues = min_t(unsigned int, ibdev->num_comp_vectors,
-				min(opts->nr_io_queues, num_online_cpus()));
-	nr_default_queues =  min_t(unsigned int, ibdev->num_comp_vectors,
-				min(opts->nr_write_queues, num_online_cpus()));
-	nr_poll_queues = min(opts->nr_poll_queues, num_online_cpus());
-	nr_io_queues = nr_read_queues + nr_default_queues + nr_poll_queues;
-
+	nr_io_queues = nvmf_nr_io_queues(opts);
 	ret = nvme_set_queue_count(&ctrl->ctrl, &nr_io_queues);
 	if (ret)
 		return ret;
@@ -746,34 +738,7 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
 	dev_info(ctrl->ctrl.device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-	if (opts->nr_write_queues && nr_read_queues < nr_io_queues) {
-		/*
-		 * separate read/write queues
-		 * hand out dedicated default queues only after we have
-		 * sufficient read queues.
-		 */
-		ctrl->io_queues[HCTX_TYPE_READ] = nr_read_queues;
-		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
-		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
-			min(nr_default_queues, nr_io_queues);
-		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	} else {
-		/*
-		 * shared read/write queues
-		 * either no write queues were requested, or we don't have
-		 * sufficient queue count to have dedicated default queues.
-		 */
-		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
-			min(nr_read_queues, nr_io_queues);
-		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	}
-
-	if (opts->nr_poll_queues && nr_io_queues) {
-		/* map dedicated poll queues only if we have queues left */
-		ctrl->io_queues[HCTX_TYPE_POLL] =
-			min(nr_poll_queues, nr_io_queues);
-	}
-
+	nvmf_set_io_queues(opts, nr_io_queues, ctrl->io_queues);
 	for (i = 1; i < ctrl->ctrl.queue_count; i++) {
 		ret = nvme_rdma_alloc_queue(ctrl, i,
 				ctrl->ctrl.sqsize + 1);
@@ -2143,44 +2108,8 @@ static void nvme_rdma_complete_rq(struct request *rq)
 static void nvme_rdma_map_queues(struct blk_mq_tag_set *set)
 {
 	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(set->driver_data);
-	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
 
-	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
-		/* separate read/write queues */
-		set->map[HCTX_TYPE_DEFAULT].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
-		set->map[HCTX_TYPE_READ].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_READ];
-		set->map[HCTX_TYPE_READ].queue_offset =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	} else {
-		/* shared read/write queues */
-		set->map[HCTX_TYPE_DEFAULT].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
-		set->map[HCTX_TYPE_READ].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		set->map[HCTX_TYPE_READ].queue_offset = 0;
-	}
-	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
-	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
-
-	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
-		/* map dedicated poll queues only if we have queues left */
-		set->map[HCTX_TYPE_POLL].nr_queues =
-				ctrl->io_queues[HCTX_TYPE_POLL];
-		set->map[HCTX_TYPE_POLL].queue_offset =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT] +
-			ctrl->io_queues[HCTX_TYPE_READ];
-		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
-	}
-
-	dev_info(ctrl->ctrl.device,
-		"mapped %d/%d/%d default/read/poll queues.\n",
-		ctrl->io_queues[HCTX_TYPE_DEFAULT],
-		ctrl->io_queues[HCTX_TYPE_READ],
-		ctrl->io_queues[HCTX_TYPE_POLL]);
+	nvmf_map_queues(set, &ctrl->ctrl, ctrl->io_queues);
 }
 
 static const struct blk_mq_ops nvme_rdma_mq_ops = {
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 31c2ffb6d011c..d434c24e035d5 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1931,58 +1931,12 @@ static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	return ret;
 }
 
-static unsigned int nvme_tcp_nr_io_queues(struct nvme_ctrl *ctrl)
-{
-	unsigned int nr_io_queues;
-
-	nr_io_queues = min(ctrl->opts->nr_io_queues, num_online_cpus());
-	nr_io_queues += min(ctrl->opts->nr_write_queues, num_online_cpus());
-	nr_io_queues += min(ctrl->opts->nr_poll_queues, num_online_cpus());
-
-	return nr_io_queues;
-}
-
-static void nvme_tcp_set_io_queues(struct nvme_ctrl *nctrl,
-		unsigned int nr_io_queues)
-{
-	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
-	struct nvmf_ctrl_options *opts = nctrl->opts;
-
-	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
-		/*
-		 * separate read/write queues
-		 * hand out dedicated default queues only after we have
-		 * sufficient read queues.
-		 */
-		ctrl->io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
-		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
-		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_write_queues, nr_io_queues);
-		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	} else {
-		/*
-		 * shared read/write queues
-		 * either no write queues were requested, or we don't have
-		 * sufficient queue count to have dedicated default queues.
-		 */
-		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
-			min(opts->nr_io_queues, nr_io_queues);
-		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	}
-
-	if (opts->nr_poll_queues && nr_io_queues) {
-		/* map dedicated poll queues only if we have queues left */
-		ctrl->io_queues[HCTX_TYPE_POLL] =
-			min(opts->nr_poll_queues, nr_io_queues);
-	}
-}
-
 static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	unsigned int nr_io_queues;
 	int ret;
 
-	nr_io_queues = nvme_tcp_nr_io_queues(ctrl);
+	nr_io_queues = nvmf_nr_io_queues(ctrl->opts);
 	ret = nvme_set_queue_count(ctrl, &nr_io_queues);
 	if (ret)
 		return ret;
@@ -1997,8 +1951,8 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-	nvme_tcp_set_io_queues(ctrl, nr_io_queues);
-
+	nvmf_set_io_queues(ctrl->opts, nr_io_queues,
+			   to_tcp_ctrl(ctrl)->io_queues);
 	return __nvme_tcp_alloc_io_queues(ctrl);
 }
 
@@ -2581,44 +2535,8 @@ static blk_status_t nvme_tcp_queue_rq(struct blk_mq_hw_ctx *hctx,
 static void nvme_tcp_map_queues(struct blk_mq_tag_set *set)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(set->driver_data);
-	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
-
-	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
-		/* separate read/write queues */
-		set->map[HCTX_TYPE_DEFAULT].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
-		set->map[HCTX_TYPE_READ].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_READ];
-		set->map[HCTX_TYPE_READ].queue_offset =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	} else {
-		/* shared read/write queues */
-		set->map[HCTX_TYPE_DEFAULT].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
-		set->map[HCTX_TYPE_READ].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		set->map[HCTX_TYPE_READ].queue_offset = 0;
-	}
-	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
-	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
-
-	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
-		/* map dedicated poll queues only if we have queues left */
-		set->map[HCTX_TYPE_POLL].nr_queues =
-				ctrl->io_queues[HCTX_TYPE_POLL];
-		set->map[HCTX_TYPE_POLL].queue_offset =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT] +
-			ctrl->io_queues[HCTX_TYPE_READ];
-		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
-	}
-
-	dev_info(ctrl->ctrl.device,
-		"mapped %d/%d/%d default/read/poll queues.\n",
-		ctrl->io_queues[HCTX_TYPE_DEFAULT],
-		ctrl->io_queues[HCTX_TYPE_READ],
-		ctrl->io_queues[HCTX_TYPE_POLL]);
+
+	nvmf_map_queues(set, &ctrl->ctrl, ctrl->io_queues);
 }
 
 static int nvme_tcp_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
-- 
2.53.0



