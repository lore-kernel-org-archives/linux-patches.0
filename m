Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B05A5103A;
	Mon, 11 Dec 2023 18:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfOEEB7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950F5C433C8;
	Mon, 11 Dec 2023 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320478;
	bh=IN5e6uJNguvrNTSyvoOovy3M+ylzY3UEJ+gw5wfLe1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfOEEB7/G0amy4pEGkIEwHpVduR0Q2aAl0p/wKvY+p+Gm4Cu0g302W/4adgfK4bCe
	 67UQwGqx87MV4qUZKJ/XrOyzrAEVazlk0dEhU3MnG1XE7bfjFtoa91KWquATe7pAMH
	 3PAdvrEMaRp7BQ1DnV74V6L2DFAb4OC0Tfu9do7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/194] RDMA/rtrs-clt: Fix the max_send_wr setting
Date: Mon, 11 Dec 2023 19:21:05 +0100
Message-ID: <20231211182039.844427411@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 6d09f6f7d7584e099633282ea915988914f86529 ]

For each write request, we need Request, Response Memory Registration,
Local Invalidate.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://lore.kernel.org/r/20231120154146.920486-7-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 1bad7fc3231f4..c0781d4279cb2 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1694,7 +1694,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		clt_path->s.dev_ref++;
 		max_send_wr = min_t(int, wr_limit,
 			      /* QD * (REQ + RSP + FR REGS or INVS) + drain */
-			      clt_path->queue_depth * 3 + 1);
+			      clt_path->queue_depth * 4 + 1);
 		max_recv_wr = min_t(int, wr_limit,
 			      clt_path->queue_depth * 3 + 1);
 		max_send_sge = 2;
-- 
2.42.0



