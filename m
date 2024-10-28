Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7FD18D65C;
	Mon, 28 Oct 2024 06:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097998; cv=none; b=V7b0nvuixPHXblY8iuNBdOAz/JUQg+vsRc1ay+T2CIgOJVdczmC5u2h+8astHMSBz1sZFR1SStTegooox7ipAi/uruC5F6V5FWQ3+u5atF+eWGNR7K+drKS924VuhU9uiDfkcKrQ5DQXGVb/qgexB/457PkVYyO6eK0pdr3ha8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097998; c=relaxed/simple;
	bh=qi9p1C7vJg9VMpouB89PAFqF5T1qE+BDpzuB7kPCQxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRUxn15V98v7+xfKsyWbjWczimESWpEUkk6cqd5Z9G+m6B2XAgE5sRZQt1h+vHaame+D8Ir5T27sNNXahgSMV+7OiHAwd0IC7GbMyxe/ufACCRCjYolyZBl+yZHyMj0ZejRvgdRRVJVdPQSjt7/k0OM1vdJXs2fdvKexGDMhX94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjsYKcv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjsYKcv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD8BC4CEC7;
	Mon, 28 Oct 2024 06:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097998;
	bh=qi9p1C7vJg9VMpouB89PAFqF5T1qE+BDpzuB7kPCQxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjsYKcv0HoNqFjSxNHDIiE4qRTIVhY0TbPnbxCvfFnsYXvMx/ZKF1YeNxkRUmnwOJ
	 72Ba9+Pa5jfY83tRghPCnYdFOoEVVKRztTrbPDMucbNcLufUfT2TMe+3OGf7r9pXil
	 xiTlcQEgLG5mAVglO/LIGEP51fWRg+2ulRQ2oDDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zubkov <green@qrator.net>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 033/261] RDMA/irdma: Fix misspelling of "accept*"
Date: Mon, 28 Oct 2024 07:22:55 +0100
Message-ID: <20241028062312.842346222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Zubkov <green@qrator.net>

[ Upstream commit 8cddfa535c931b8d8110c73bfed7354a94cbf891 ]

There is "accept*" misspelled as "accpet*" in the comments.  Fix the
spelling.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Link: https://patch.msgid.link/r/20241008161913.19965-1-green@qrator.net
Signed-off-by: Alexander Zubkov <green@qrator.net>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 36bb7e5ce6382..ce8d821bdad84 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3631,7 +3631,7 @@ void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp)
 /**
  * irdma_accept - registered call for connection to be accepted
  * @cm_id: cm information for passive connection
- * @conn_param: accpet parameters
+ * @conn_param: accept parameters
  */
 int irdma_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 {
-- 
2.43.0



