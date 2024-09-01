Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BBE18132A;
	Sun,  1 Sep 2024 16:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209967; cv=none; b=AVOtdE1Yi0IiJLnivzA2A0WDOt3iMex5h1581spfWLoThUkeAVyr4U7eKptJk0PosB+QYty+/4Hi90LrObwFSPZaaHeLjXnh0O4YYBNF/p5TxbF/UDPZniVmoUX4xdfIaSzKyA9RqJJ/Yluefgokx8LhaMSkR+KsRQ+4dcWbddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209967; c=relaxed/simple;
	bh=E+SDNm5G/IOUcPEYB6eO2GKuElij+B3M4HMym7gUxn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwOof14ERbaJMmS4SBLnXbKgOAB8SzpqNqHtlyFRvKFPOfdYkiD1l5neygCMGJG+4YDs9DjPlC9ajnnwcyLhvpuTJzcpgJg3YXugXoC5KqlbyxVJXExCAfW/xU5JAfpPRHlJEQymj+HPwcHeyBf9mIMKRy3KcR35AxD2IR3zXEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pj3WFICC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pj3WFICC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524FBC4CEC3;
	Sun,  1 Sep 2024 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209967;
	bh=E+SDNm5G/IOUcPEYB6eO2GKuElij+B3M4HMym7gUxn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pj3WFICCLTIaPrIuu4Ao4udG+K+coaVzlmJ+oOzaKlxxR3MBFznSwC82s/VSfoNxi
	 Ob4uStuCf+iRpme37DB4GWrkpPc5sjngVTGFUSQ1cS1LBbLp2Fsy1KJoFdjbJZamGj
	 Wi/8F1FSG5GPtWnrBE7ZL2VsWQFBWxU2QOMEL/to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/215] RDMA/rtrs: Fix the problem of variable not initialized fully
Date: Sun,  1 Sep 2024 18:16:00 +0200
Message-ID: <20240901160825.169338105@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 4745f33d7104a..7f0f3ce8f1151 100644
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



