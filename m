Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C155B1CFBC;
	Tue, 27 Aug 2024 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772123; cv=none; b=LGWEAhqqAxv6ThNnu5t3t2SsWLj1zQjKN02LlDk76IpXd8n4Nraa+zXmK87lvRGZAarvqnUIocaVfm6lSe3tLNzs2fMKLj/YYgxOBHv0NUHpGPRhZELONCr3lwWXnYXFoaD0PZguXj3khGcaLlE6qg4ejWDW/FHyXi5qAfCMIKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772123; c=relaxed/simple;
	bh=uVV8O/5QxJNQOToKG7CUCCp+JvVaEq+XdpvV+gAj/Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O31wjRzNdkimXfeZXV7B12h8nxOcZ2HxsiRHijAI0tz8PYTYJ48veRLrlu9+Cb1Q6rzBpPgDpAP9QDRDISYvRex6IF9S99RVw7EPFyHsxxedhmALIDMakVzMGk0Cc0qr8UoMr8WMl1ShRbNZDFP/3JXhReZSPuBegR64NDqV92M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zckQjyQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zckQjyQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47437C4FE09;
	Tue, 27 Aug 2024 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772123;
	bh=uVV8O/5QxJNQOToKG7CUCCp+JvVaEq+XdpvV+gAj/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zckQjyQhbv2oiSTY5jq8hL6m4w0bTsS8JXoPydNkyObozSuZNPOAs7RdbQ8U56ej9
	 6TvGB8CHoGUht0huUd3OZR/5/dyeHlwzXEOOvCk+yGD1v54f5+u5gnen5kOAF6tMvo
	 a7Rv/ZIAnzuPeL/CYH6v4O6cSprdp1Lzt+xxDbw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/321] RDMA/rtrs: Fix the problem of variable not initialized fully
Date: Tue, 27 Aug 2024 16:37:08 +0200
Message-ID: <20240827143842.811243302@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 716ec7baddefd..d71b1d83e9ffb 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -255,7 +255,7 @@ static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
 static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 		     u32 max_send_wr, u32 max_recv_wr, u32 max_sge)
 {
-	struct ib_qp_init_attr init_attr = {NULL};
+	struct ib_qp_init_attr init_attr = {};
 	struct rdma_cm_id *cm_id = con->cm_id;
 	int ret;
 
-- 
2.43.0



