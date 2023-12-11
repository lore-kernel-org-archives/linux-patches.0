Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB734321B8;
	Mon, 11 Dec 2023 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCxPKtxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F26DC433C7;
	Mon, 11 Dec 2023 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320956;
	bh=NW3CBN7Kk540Ed4tKNsaqC5lahOjVdWgz+swaJQzxUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCxPKtxzd5dCmnMNmj02l3tf/KCc90LhDjTCLFi/pbuwWUM4mMVJ4YzJkTHkR0NO3
	 aBQRUcOgY2SdCdAS5/bXNz5ihOqPz/ly4w+2fUr9NGVt+T0T7pkurMF3Gd3X25P/AY
	 9q46+OjBzWZVaIXjR6ymf0ozrnmcecxZ1jLhFkOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/141] RDMA/rtrs-clt: Fix the max_send_wr setting
Date: Mon, 11 Dec 2023 19:21:56 +0100
Message-ID: <20231211182029.032615304@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fac5e122fd372..c0950587f377a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1682,7 +1682,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
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



