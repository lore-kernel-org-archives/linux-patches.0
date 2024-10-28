Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B5C18CC1F;
	Mon, 28 Oct 2024 06:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096904; cv=none; b=r3KYM+Rp+N9HMTk0cJBOdQIb/lCPvDDl6aGXa02zKxtsf+YNPIhZ0PaXSKwu50ku3JwQAu3PBSkOLHkbGGXFH5gPGRi6u64zBl2R2ik06KamFc7xzmnTVIGvUBFSEF8l3SrAWPD9g2F6M6T03QcXQ4WnvW0DxRqCTG/c5ivsY5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096904; c=relaxed/simple;
	bh=LuZCwpnDV4nEMVQoukW/J7prfg3dblXZDfUhqvdkZJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjCoAC18fPK7+AMtfBv87DynI9F71uqpPOXw/pH/z6TMF1UaawFvZcd5JzlcdbWXT0BpI/VgLmbp6OYoEXA2VezulquLhDjKmyGyKXOs6cu5I5zaicIpU7YH8g1VF5erwuQHcAka2iWGJ0KYF9r5k+5oPj0I4o1lrFFmjqSO8Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxeY7Fdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxeY7Fdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66272C4CEC3;
	Mon, 28 Oct 2024 06:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096904;
	bh=LuZCwpnDV4nEMVQoukW/J7prfg3dblXZDfUhqvdkZJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxeY7FdoQB98W/aZXmULtPNDHh6RxWYKSRB4lQh5xcljrvHtpJF3jOyAEbBaC9tp3
	 YfyqvLOERLYT9ecz+rmpk/LnvvudZxPl/ZWgiKOYlEdWv0t7xoH8rdr8PVykxzzGKJ
	 q0fvk04nP6wA2IcquYv21UmYwNYjijGixLTzyg5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zubkov <green@qrator.net>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/80] RDMA/irdma: Fix misspelling of "accept*"
Date: Mon, 28 Oct 2024 07:24:49 +0100
Message-ID: <20241028062252.881755103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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
index 64d4bb0e9a12f..d2c6a1bcf1de9 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3582,7 +3582,7 @@ void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp)
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



