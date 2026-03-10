Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B19437B413;
	Tue, 10 Mar 2026 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142042; cv=none; b=e+Riewp6+Y2Uc2mugxxzuXGFdImaN8IVQalnAsfXVzckW7BbGMhkrpNDslNxB+tL63fAHVa1wzCS7SYMFRgsU6l9UaIwopOAdULq5f+uscxzgbsLFSK0HyBYGDHq1cCcN3NGUe7rG4Pxf7yrN7RlTNEmLRWjghHPLhI0NLJQhxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142042; c=relaxed/simple;
	bh=9p/MAMdUWhpcC0Z2l9w1V0H7tzR6VzlVJaAlhPEr6x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIZg6VE4P1cTcchsut/HAqN6Me1OiTs4Q19agN1njJ7Phf0TblfFRIv/qxDGN5wxPnYd3FattGQ5BRhdin0ADHgPdCTaWG8HL1xN0hD7I9yWRWxEG40y03PQqbNiLmYW2EANkrH9PhbJ+APE3FzW5NVjkjigN8VwtrIEd0Ap3Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJgWR4mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJgWR4mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22363C19423;
	Tue, 10 Mar 2026 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142041;
	bh=9p/MAMdUWhpcC0Z2l9w1V0H7tzR6VzlVJaAlhPEr6x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJgWR4mbg5XwArviH4ByPrr6apmrSB+91pxz2V1nUD0bIvb3l8a7vzK4yMTxvyRpE
	 sSl/IjTZvhVuSPHuC8focp9Ny9secPVoGb0cA9QYL4rjws6pn54fILsPFpM1r9vq63
	 NChopjNG56oG5BR0IMPBoG+rO0NbJd0VO2Tx6bXUhZ87AQhAuCB/tpMcKPlx0jKVZI
	 aMy95LDhiJVdWE6oPk3joCn5dbUJdzVyOxzoFVCTQb6LxY95OQ5azRwu8riUZuIdlO
	 VhOzfCwJrpysxNCupgBUQBZctSAArItylA6TC84Mm/kJbRwaIhYCrdA+NXHfrjWs9e
	 8gcgh8uPbP3VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 169/314] IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()
Date: Tue, 10 Mar 2026 07:17:08 -0400
Message-ID: <50ecb8dc04f42938522547ea7c8e7d65da99c5dc.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

commit 117942ca43e2e3c3d121faae530989931b7f67e1 upstream.

Fix a user triggerable leak on the system call failure path.

Cc: stable@vger.kernel.org
Fixes: ec34a922d243 ("[PATCH] IB/mthca: Add SRQ implementation")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/2-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index dd572d76866c2..e095873b381b6 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -428,6 +428,8 @@ static int mthca_create_srq(struct ib_srq *ibsrq,
 
 	if (context && ib_copy_to_udata(udata, &srq->srqn, sizeof(__u32))) {
 		mthca_free_srq(to_mdev(ibsrq->device), srq);
+		mthca_unmap_user_db(to_mdev(ibsrq->device), &context->uar,
+				    context->db_tab, ucmd.db_index);
 		return -EFAULT;
 	}
 
@@ -436,6 +438,7 @@ static int mthca_create_srq(struct ib_srq *ibsrq,
 
 static int mthca_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 {
+	mthca_free_srq(to_mdev(srq->device), to_msrq(srq));
 	if (udata) {
 		struct mthca_ucontext *context =
 			rdma_udata_to_drv_context(
@@ -446,8 +449,6 @@ static int mthca_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 		mthca_unmap_user_db(to_mdev(srq->device), &context->uar,
 				    context->db_tab, to_msrq(srq)->db_index);
 	}
-
-	mthca_free_srq(to_mdev(srq->device), to_msrq(srq));
 	return 0;
 }
 
-- 
2.51.0

