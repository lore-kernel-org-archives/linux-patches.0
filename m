Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205E28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA7FC433D2;
	Mon, 30 Jan 2023 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087011;
	bh=3hJqPX0nzTG8AkgNPIe8P8pLjIGOySzjXlJxCJz/E54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZFRgqsnP4biM3W3eijkKqcbnJndRf94ZIuLebjzz/UIOdEdw0KyG/qPFcH0HwEmB
	 zmgFbTXO2h5ODX4ZmFQzYvsdX05oVHY0QyZd5ZtuGMrOJp8kWL6//F2lNwh4rnXQES
	 io/TEM6gCkgjKK+HsciG+pNeq1jJZPvXVyfDTIZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/313] RDMA/rxe: Fix inaccurate constants in rxe_type_info
Date: Mon, 30 Jan 2023 14:47:56 +0100
Message-Id: <20230130134338.604964221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>

[ Upstream commit 3a73746b267e5c6a87c9ad26f8c6a48e44da609c ]

ibv_query_device() has reported incorrect device attributes, which are
actually not used by the device. Make the constants correspond with the
attributes shown to users.

Fixes: 3ccffe8abf2f ("RDMA/rxe: Move max_elem into rxe_type_info")
Fixes: 3225717f6dfa ("RDMA/rxe: Replace red-black trees by xarrays")
Link: https://lore.kernel.org/r/20221220080848.253785-1-matsuda-daisuke@fujitsu.com
Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index f50620f5a0a1..1151c0b5ccea 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -23,16 +23,16 @@ static const struct rxe_type_info {
 		.size		= sizeof(struct rxe_ucontext),
 		.elem_offset	= offsetof(struct rxe_ucontext, elem),
 		.min_index	= 1,
-		.max_index	= UINT_MAX,
-		.max_elem	= UINT_MAX,
+		.max_index	= RXE_MAX_UCONTEXT,
+		.max_elem	= RXE_MAX_UCONTEXT,
 	},
 	[RXE_TYPE_PD] = {
 		.name		= "pd",
 		.size		= sizeof(struct rxe_pd),
 		.elem_offset	= offsetof(struct rxe_pd, elem),
 		.min_index	= 1,
-		.max_index	= UINT_MAX,
-		.max_elem	= UINT_MAX,
+		.max_index	= RXE_MAX_PD,
+		.max_elem	= RXE_MAX_PD,
 	},
 	[RXE_TYPE_AH] = {
 		.name		= "ah",
@@ -40,7 +40,7 @@ static const struct rxe_type_info {
 		.elem_offset	= offsetof(struct rxe_ah, elem),
 		.min_index	= RXE_MIN_AH_INDEX,
 		.max_index	= RXE_MAX_AH_INDEX,
-		.max_elem	= RXE_MAX_AH_INDEX - RXE_MIN_AH_INDEX + 1,
+		.max_elem	= RXE_MAX_AH,
 	},
 	[RXE_TYPE_SRQ] = {
 		.name		= "srq",
@@ -49,7 +49,7 @@ static const struct rxe_type_info {
 		.cleanup	= rxe_srq_cleanup,
 		.min_index	= RXE_MIN_SRQ_INDEX,
 		.max_index	= RXE_MAX_SRQ_INDEX,
-		.max_elem	= RXE_MAX_SRQ_INDEX - RXE_MIN_SRQ_INDEX + 1,
+		.max_elem	= RXE_MAX_SRQ,
 	},
 	[RXE_TYPE_QP] = {
 		.name		= "qp",
@@ -58,7 +58,7 @@ static const struct rxe_type_info {
 		.cleanup	= rxe_qp_cleanup,
 		.min_index	= RXE_MIN_QP_INDEX,
 		.max_index	= RXE_MAX_QP_INDEX,
-		.max_elem	= RXE_MAX_QP_INDEX - RXE_MIN_QP_INDEX + 1,
+		.max_elem	= RXE_MAX_QP,
 	},
 	[RXE_TYPE_CQ] = {
 		.name		= "cq",
@@ -66,8 +66,8 @@ static const struct rxe_type_info {
 		.elem_offset	= offsetof(struct rxe_cq, elem),
 		.cleanup	= rxe_cq_cleanup,
 		.min_index	= 1,
-		.max_index	= UINT_MAX,
-		.max_elem	= UINT_MAX,
+		.max_index	= RXE_MAX_CQ,
+		.max_elem	= RXE_MAX_CQ,
 	},
 	[RXE_TYPE_MR] = {
 		.name		= "mr",
@@ -76,7 +76,7 @@ static const struct rxe_type_info {
 		.cleanup	= rxe_mr_cleanup,
 		.min_index	= RXE_MIN_MR_INDEX,
 		.max_index	= RXE_MAX_MR_INDEX,
-		.max_elem	= RXE_MAX_MR_INDEX - RXE_MIN_MR_INDEX + 1,
+		.max_elem	= RXE_MAX_MR,
 	},
 	[RXE_TYPE_MW] = {
 		.name		= "mw",
@@ -85,7 +85,7 @@ static const struct rxe_type_info {
 		.cleanup	= rxe_mw_cleanup,
 		.min_index	= RXE_MIN_MW_INDEX,
 		.max_index	= RXE_MAX_MW_INDEX,
-		.max_elem	= RXE_MAX_MW_INDEX - RXE_MIN_MW_INDEX + 1,
+		.max_elem	= RXE_MAX_MW,
 	},
 };
 
-- 
2.39.0



