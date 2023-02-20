Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C75263B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E1BC4339B;
	Mon, 20 Feb 2023 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901523;
	bh=Rq4n8uSGL6HKdp05k/r4meCtbqJ+11BI6aGjnZHod8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5cIpU1nYeAowxrkf11Gx0NfRJKFGu9sI6HUfW+PytmvjaB7Er8+yJDXTBcVBpRLV
	 MDYJhvhunUQIYsnzeeEOVFqH3pHY+nZYOazqC+l1wdl7eKAvmhgeEmj27ikByho9Zu
	 Yt5OiBfqGeezDrJx3omAEzO1Bteyl/+/UjvQRoA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/118] nvme: clear the request_queue pointers on failure in nvme_alloc_io_tag_set
Date: Mon, 20 Feb 2023 14:35:48 +0100
Message-Id: <20230220133601.711413753@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 6fbf13c0e24fd86ab2e4477cd8484a485b687421 ]

In nvme_alloc_io_tag_set(), the connect_q pointer should be set to NULL
in case of error to avoid potential invalid pointer dereferences.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e189ce17deb3e..5acc9ae225df3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4933,6 +4933,7 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 
 out_free_tag_set:
 	blk_mq_free_tag_set(set);
+	ctrl->connect_q = NULL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_alloc_io_tag_set);
-- 
2.39.0



