Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FBE332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301253; cv=none; b=J/DfkJdas8E4fyPWk4+FOKHQfoPIVZp4PqgX7d2l4DlJbO7+4qJbHKaSAINsWhW+iqDK+u5wsHfO5sbj4fShjLQVO0TwATHKK2nKqxs1JKksuzP2YNmjIXNadsfv9e+zqzE0X5rIEnG8SN7y5RfBE4OX5Qp6JMNqvhyWIUmGquI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301253; c=relaxed/simple;
	bh=RZJViCNLIiBqodozrBC42YiKsU8srBesroCSyoWxziI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqdE3ThYu9tf0NPe4EyBGCF0h23t3hVWiWxB+TpfXl9ZIc+XML29q07D8NrMa/tDHratMTWJD9XTtFQVM2/kYorFGptKjDQD1ZQNZaBuMglehkeDU/6oSI4FUfsN5nl3Q5qSsHGx+2UpyfxVlWRKkpuQ9tJTP1NEAYUMcGuPzcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjuxZ1/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjuxZ1/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035A5C19425;
	Sat, 28 Feb 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301253;
	bh=RZJViCNLIiBqodozrBC42YiKsU8srBesroCSyoWxziI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjuxZ1/M2cqqsnFPLZAwNJij8v6oh5rlJdF451jRj95qYkUr5vgjC9JP1iSWtfkra
	 v2Blpq6ieHXYyH24vfEZ27G3yf/OOng0XhJZr40PX+Vrc3C/5H35EF/+zidzmBUBZ6
	 iIoVWSt2Jy3h5nclUGcyHd8Myk85/7agAzwGrHM/iTJNaKPIxPbFVmfcVDBhU2xIMW
	 vIpgtNc7CkRV+spIMuSQfJU3iTqICKwqt/XDY+wy9XyayYLKPugYGcgYoWlENqX8d0
	 AH42sbrTBd9uPVjwOb0dJnAal5fZRn7/69sLdrs1BluEZN0LU+JJgrpn07kSitUpRr
	 GDrlkmILm4v4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 436/752] RDMA/efa: Fix typo in efa_alloc_mr()
Date: Sat, 28 Feb 2026 12:42:27 -0500
Message-ID: <20260228174750.1542406-436-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f22c77ce49db0589103d96487dca56f5b2136362 ]

The pattern is to check the entire driver request space, not just
sizeof something unrelated.

Fixes: 40909f664d27 ("RDMA/efa: Add EFA verbs implementation")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/1-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Acked-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 755bba8d58bbc..5cab7dd70aebf 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1663,7 +1663,7 @@ static struct efa_mr *efa_alloc_mr(struct ib_pd *ibpd, int access_flags,
 	struct efa_mr *mr;
 
 	if (udata && udata->inlen &&
-	    !ib_is_udata_cleared(udata, 0, sizeof(udata->inlen))) {
+	    !ib_is_udata_cleared(udata, 0, udata->inlen)) {
 		ibdev_dbg(&dev->ibdev,
 			  "Incompatible ABI params, udata not cleared\n");
 		return ERR_PTR(-EINVAL);
-- 
2.51.0

