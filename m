Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA1F1465A8;
	Tue, 25 Jun 2024 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308783; cv=none; b=cYgeFpqLVG6vRtx/Cc3x4At2t60mgSjPlKGcWLkmktmRY1o8NIfVQUSbO2kxNTxPU2YsxJhOZZLcs2rFCtuyHjHNsR63rDo/G/AFzK1CAdRt1qWTZxhEjC9/MKW+q+4QK2aw5J4yo+h3rW3M30fJ7NK1vmvwaHxXe6boIiEJLis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308783; c=relaxed/simple;
	bh=lUgAOcVDqcLj1DWqkiLTB9p3OYEclv8ReB6Pmab2+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5EgO2j2fUvsrEzSmk6xoaZx5AOuzbTD71Iz2w/sE64m89+H39PucdfIWYCCPMTguMBHrcjtI+/HVAYAWaNvnLNE1M6PiEpxnUlpjZRUnEpUPhek7DWtkMQ3oAeR427jO/+NMNWzatmP7yCP5rJIupT3PHbAaAKWVx5kPCA5LqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6I86Gkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6I86Gkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33468C32781;
	Tue, 25 Jun 2024 09:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308783;
	bh=lUgAOcVDqcLj1DWqkiLTB9p3OYEclv8ReB6Pmab2+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6I86Gklh2byW1a0En8KLhokvjnJ3k5YgRgmd8gwGWt61X4R2XYvg2bNHmg5w8SSg
	 zru3B9qHYCvVsbImV3flzP4I8YfReScFAQuuzbJs7h3FdT5fBdKpWHo2h6QMoK6LUD
	 bfCbaroV9wydX6O8/YPnxGjqyDZcsBq9w9b/kd7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Josef Bacik <jbacik@fb.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Markus Pargmann <mpa@pengutronix.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 239/250] nbd: Improve the documentation of the locking assumptions
Date: Tue, 25 Jun 2024 11:33:17 +0200
Message-ID: <20240625085557.228143048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2a6751e052ab4789630bc889c814037068723bc1 ]

Document locking assumptions with lockdep_assert_held() instead of source
code comments. The advantage of lockdep_assert_held() is that it is
verified at runtime if lockdep is enabled in the kernel config.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240510202313.25209-4-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e56d4b633fff ("nbd: Fix signal handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9d4ec9273bf95..281df7bafc83c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -588,7 +588,6 @@ static inline int was_interrupted(int result)
 	return result == -ERESTARTSYS || result == -EINTR;
 }
 
-/* always call with the tx_lock held */
 static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
@@ -605,6 +604,9 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	u32 nbd_cmd_flags = 0;
 	int sent = nsock->sent, skip = 0;
 
+	lockdep_assert_held(&cmd->lock);
+	lockdep_assert_held(&nsock->tx_lock);
+
 	iov_iter_kvec(&from, ITER_SOURCE, &iov, 1, sizeof(request));
 
 	type = req_to_nbd_cmd_type(req);
@@ -1015,6 +1017,8 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 	struct nbd_sock *nsock;
 	int ret;
 
+	lockdep_assert_held(&cmd->lock);
+
 	config = nbd_get_config_unlocked(nbd);
 	if (!config) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
-- 
2.43.0



