Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E1F746E
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A37CC433CB;
	Sun, 17 Sep 2023 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982384;
	bh=wd5lbRiU6rwLRJ0PU99mh5oWIbEGmpEOniZJL/8igDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqluvowoZgDYrSFjTwQoPy5AYBoRD7XqTXTf8HWat1c17ofZ9dOe9wYv8g4Chs4e1
	 jvgkywV9WUccgpy3ciIhbc08SsY9QhddIn6M+k4c5NdZzmoli752jKkaCJ7d7H5BYT
	 qnMXOOLpVP9gHlhJ7GT61aWSXn6szaF/O2WHnABo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	Alok Prasad <palok@marvell.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/511] RDMA/qedr: Remove a duplicate assignment in irdma_query_ah()
Date: Sun, 17 Sep 2023 21:11:01 +0200
Message-ID: <20230917191119.461187663@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Minjie Du <duminjie@vivo.com>

[ Upstream commit 65e02e840847158c7ee48ca8e6e91062b0f78662 ]

Delete a duplicate statement from this function implementation.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Minjie Du <duminjie@vivo.com>
Acked-by: Alok Prasad <palok@marvell.com>
Link: https://lore.kernel.org/r/20230706022704.1260-1-duminjie@vivo.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 60cf83c4119e7..8ccbe761b8607 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4310,7 +4310,6 @@ static int irdma_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 		ah_attr->grh.traffic_class = ah->sc_ah.ah_info.tc_tos;
 		ah_attr->grh.hop_limit = ah->sc_ah.ah_info.hop_ttl;
 		ah_attr->grh.sgid_index = ah->sgid_index;
-		ah_attr->grh.sgid_index = ah->sgid_index;
 		memcpy(&ah_attr->grh.dgid, &ah->dgid,
 		       sizeof(ah_attr->grh.dgid));
 	}
-- 
2.40.1



