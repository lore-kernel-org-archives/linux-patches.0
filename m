Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D715172F0;
	Thu, 17 Sep 2026 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664292; cv=none; b=fHBzfzGDWfY3onYsYiYryVRzlGu1oObRWzn5J0MMS2jY7IbV9IgfQqxQPrbihZesyUPY5qk5Y2qHVsiUsrzHEyHbLuBSKLeBppYy303igQ+1d8YnUMggWiq+DwycWipIHBljfOFunFCUvLpNnHXyUslCslIr0Kxw8ld/wgfUXYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664292; c=relaxed/simple;
	bh=GgI95lDMrDx83wZXPFgJgzymxtfOzCggQffVehPq/fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwfHgwGpbBsIyktefqaYiDS7sYPAzPiF7BGmItWoOz40kpcG6YLhXtj1aqv35j8G6FfwaGKcvh8iMz54ZKNnr5dRSGkrG91QOQ+Rgt+DAZxfOsacT66XnjTu9Q7BbgojxN3SlTEvrk/xiYyUMBWB0W4U7rA9pDWgiExn+9fDdhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrQecVaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrQecVaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0DF1F00893;
	Thu, 17 Sep 2026 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664291;
	bh=+npYUNbZiaYwiG3AZ6nxnuBRyEwYStHKHDPjVlf2WG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrQecVaH/QNlWnH0wL41cj2zP5wULjJ0P23rmGuM/gXNo6C/jSCcYcd96GgkR4jz5
	 cqU9kaZhQ4S7JzSGrhCkwJ1xdx5HFqv8kmtg8n9y9vl6HtCnV1xmXPeAGgmu7YM7nz
	 dteJfYw2DtgtNqTvzDu5lxk2CxgTx8KUFL9DFv8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0322/1250] RDMA/irdma: Fix typo in SQ completions generation
Date: Thu, 17 Sep 2026 16:01:57 +0100
Message-ID: <20260917151600.824729962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrill Gorcunov <gorcunov@gmail.com>

[ Upstream commit b548a6c4eee5c428663f3944e173e6c92e2e8d6f ]

When we generate completion for SQ the opcode while being properly read
from ring buffer is ignored when written back to completion. Seems
to be a simple typo.

Link: https://patch.msgid.link/r/ahjB87k54bYdFbft@grain
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 835c11d6cc85c..f78d5dd4b24a9 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2467,7 +2467,7 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
 			cmpl->cpi.wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
 			sw_wqe = qp->sq_base[wqe_idx].elem;
 			get_64bit_val(sw_wqe, 24, &wqe_qword);
-			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, IRDMAQPSQ_OPCODE);
+			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, wqe_qword);
 			cmpl->cpi.q_type = IRDMA_CQE_QTYPE_SQ;
 			/* remove the SQ WR by moving SQ tail*/
 			IRDMA_RING_SET_TAIL(*sq_ring,
-- 
2.53.0



