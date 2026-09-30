Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB94E36F5;
	Wed, 30 Sep 2026 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784428; cv=none; b=bdnN/IMp/tW7Sql9ptlj18129166fs1hSc6bSYXua6tRQ3gh9dueyUuiRH4jA2ploOo4nwTAZKPes7ushTPjxG99+K8jf1hL2AAAxyTJG38AHCKvwCIHhG4antnAUCls3pL6pJ0PesyXcNNi1ZTnaZUZRCeOmaRCRkHAvTh5gTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784428; c=relaxed/simple;
	bh=B9Orso30NJiYAGiY8J5qNBZGo/MZ6dSEHaIyGQsyxlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebmOR4qz6mhO5DnxSr5GsIUVjN0z59ee1hKj/IKQDJQZi+K3TAXNoYemcliBGiG61Gdy1lDI0rmqMJHq3G/igMQq78tTpMJSFug8GZLrdybZa/sl5/Ra3FNvghvw+ywF4m4847PXB4vJR4Wcwxfxh9hOrRzRVLUKg4Qrgq8F1GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML4NEglC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML4NEglC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243421F0089A;
	Wed, 30 Sep 2026 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784425;
	bh=wGjE67ZIp6ZNOAe7KfPw5cd9+p36LZ2etlobR56BS/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ML4NEglCuaN6aObzPDVCJkNIqEvof8aJjanthn++sCuNjFuta0EKR5Qom8F1FCNDE
	 98AicNq6vlTdcna7k5eUO6cDEycI+QoI3va6rCuDMZDXj1Yk529DxMNqdu2zAVLWIx
	 EhVEvj3oSI3BS2R9tQgnSMPEm9o2bsMfr9LRTYOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/982] RDMA/irdma: Fix typo in SQ completions generation
Date: Wed, 30 Sep 2026 17:14:46 +0200
Message-ID: <20260930152420.036745568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 98a3849c39bf0..b66910b2942c2 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2589,7 +2589,7 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
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



