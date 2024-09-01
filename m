Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85BF17B50B;
	Sun,  1 Sep 2024 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209535; cv=none; b=F8tBDprxKOtBj4klWQqSSnUNrNVPoOiUs1rEG0MsGQrDMa1Gvdc+laSJiRu1LnNF5LxYW7EGZO1zqDjBQ07XBrqnr1b/O62I36yCPvw2J1H10CvGuGCke2+VmF6X0f/f0dFSDuBpBYW1zo8uezHrsvPPx+fB/qaLH/yqpcvv1QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209535; c=relaxed/simple;
	bh=TGZunQHMglgZiueIGQ7jYyKrbissHg1ZzWjVquTNQAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs+cbcHSvRb2pIXyPjik6gVUTX8OsmK8Ry4lj2F2OU15ZALcDywh08u/q0TA0ty+eNCERv3GkFTMEEC3wlfRz1NSJl4YMADxyNXtMIcpCBuw1rmE1G7zEQQiIOSzqWlNLP+taWopaq9Df5b5/7Ji/V7vQpaBJK6EyZkZOVzplvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kINVAb+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kINVAb+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE7C4CEC3;
	Sun,  1 Sep 2024 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209534;
	bh=TGZunQHMglgZiueIGQ7jYyKrbissHg1ZzWjVquTNQAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kINVAb+zLludp0ViRo1o5MyGwq5+KwZE0pCx6nFsSn+W8Yl0Bsser3GuIHc8yXPrn
	 xpZZGuscPGmR1fSnOLC+bRviur0csUiCyM9u52LoYSY5b0bBNrAUtHNZcdFY7n8L/l
	 SQRz8qL9wJwxrOQxwiHULNqQIDW/t47yS6m4RwIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/151] RDMA/rtrs: Fix the problem of variable not initialized fully
Date: Sun,  1 Sep 2024 18:16:35 +0200
Message-ID: <20240901160815.421868625@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit c5930a1aa08aafe6ffe15b5d28fe875f88f6ac86 ]

No functionality change. The variable which is not initialized fully
will introduce potential risks.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20230919020806.534183-1-yanjun.zhu@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 76b993e8d672f..f34793068f344 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -235,7 +235,7 @@ static int create_cq(struct rtrs_con *con, int cq_vector, u16 cq_size,
 static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 		     u32 max_send_wr, u32 max_recv_wr, u32 max_sge)
 {
-	struct ib_qp_init_attr init_attr = {NULL};
+	struct ib_qp_init_attr init_attr = {};
 	struct rdma_cm_id *cm_id = con->cm_id;
 	int ret;
 
-- 
2.43.0



