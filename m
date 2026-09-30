Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52FE2D594F;
	Wed, 30 Sep 2026 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794329; cv=none; b=oJ4LgkW4IHB0ab0kFkvRFLu8t23Fo/NRwX5JyrhgH4sVXhU5NG4e8eCPMEeNIk5iiHBJtWx2CzFYbTfNlbV37P7cCgFrudOCeTGCiMNhXCUZXl+LL2QseoMJF4JFLefYar3evxpS5Ee5Inal0UMuQs+RBkrsEEGobfGCojIHmPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794329; c=relaxed/simple;
	bh=AYi5moGaw2O4k/ov5gJgMzhIb2Ydu3TcmU8e5Rrefow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSXAMQaQ+I4qH04cLJEAOZOtgk6Z6DZ35gc6eDsdT3YfHHmUW5hcTv2Z3H7+6WGBpiWfyenrvbzoJ9oLHHR5ON7ow3/YaXHkMAxDGtmjK183W3gR/+HJUBV5zjLFCNaULTqyWfJYW1F7/9sy2Lnps61LdE08kFdYmCRB1aZOn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBaMXozn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBaMXozn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCFB1F000FF;
	Wed, 30 Sep 2026 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794327;
	bh=oD68Ew+up4OSk/oylKJFE8cbUfMebcdAoxcFSKBEwHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBaMXozn9jHsNQN5XHnowjy/fNDQzZLAsVTggKhssQglb6RPu3vOZfLmD+3xWtfTi
	 ICx4fhgNoxnTdUWTAvo/ig8DvZmlWd6eT/5A9rs/W5N5atNlXQU6out9u8TDclNiOj
	 e+s22dLD2evwXAfbzAxUt0cMG1BGhtZNzBsGONfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0172/1193] RDMA/irdma: Fix typo in SQ completions generation
Date: Wed, 30 Sep 2026 17:14:16 +0200
Message-ID: <20260930152438.015964514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0571544e045e8..21c83f000a786 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2478,7 +2478,7 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
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



