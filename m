Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10B914A090;
	Tue, 25 Jun 2024 09:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309341; cv=none; b=UGzI6TkRzdMFUpYbw+t37k3cT43StAJBUITy+aAEYCN7gDneXenJH93eJvbjNY7HbKSnvFppjJzIl9AJx6i6YJcinndeUzxSPD+1ONVDaOK0MvptuTbxU+jd15On3J6cSaVvUSCs1EehnLIjpcXCyxbi8ai/EFL954y0KxscIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309341; c=relaxed/simple;
	bh=sMxV0u7XHxF/Yfks5X8PbalLxKI8oZs+6Jkohv+ROWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2jayAQq/qsGnFRc40I7pJQApnAN5cMIpQ/WQCFBKPrBRAOlvU+wIOQLu+Apj6eXmV+vjbQuAp1tEGGzfJyMgHa+2kEv5nFP4C+I0e3VqAOwm/uK8aEIL/HsI820UFKm2n2BaPlff96XxEbNJfVWx5p3BkLZ3dzOHGTDPCqRQeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRxY5pyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRxY5pyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2396AC32781;
	Tue, 25 Jun 2024 09:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309341;
	bh=sMxV0u7XHxF/Yfks5X8PbalLxKI8oZs+6Jkohv+ROWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRxY5pyPA5OcRirpDEo8CNJpij2fC2IwwXLeLnzCpJmIZJkw2ofvHnssLqnmKJ3YD
	 ah7p5Oib+fMTISpuKymxSOSkmmsqR5foBX1Nlc90a7A74rsZKRekr9x2mVcBNkPVZG
	 NeD0yTlb2t3NHw37dtpVjn7klfU7FSCj+Iz1GSi0=
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
Subject: [PATCH 6.6 176/192] nbd: Improve the documentation of the locking assumptions
Date: Tue, 25 Jun 2024 11:34:08 +0200
Message-ID: <20240625085543.915962245@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df738eab02433..a906674f71147 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -569,7 +569,6 @@ static inline int was_interrupted(int result)
 	return result == -ERESTARTSYS || result == -EINTR;
 }
 
-/* always call with the tx_lock held */
 static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
@@ -586,6 +585,9 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	u32 nbd_cmd_flags = 0;
 	int sent = nsock->sent, skip = 0;
 
+	lockdep_assert_held(&cmd->lock);
+	lockdep_assert_held(&nsock->tx_lock);
+
 	iov_iter_kvec(&from, ITER_SOURCE, &iov, 1, sizeof(request));
 
 	type = req_to_nbd_cmd_type(req);
@@ -996,6 +998,8 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 	struct nbd_sock *nsock;
 	int ret;
 
+	lockdep_assert_held(&cmd->lock);
+
 	config = nbd_get_config_unlocked(nbd);
 	if (!config) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
-- 
2.43.0



