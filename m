Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030389;
	b=fZYNF4MhL5vvM0mV5hhOeeraBx7UAqwxy3kptg/i1DOizPHIp/jMSXSwXsCrdGNYj6Su
	 iKzj7ybKOVhAG2NvIWJjC0XXhYt1KbetMci5YvzghxVjb3dxPGZRZ+89oDjqTDq3GuQdM
	 6y2wnGP1Ifxx86LPv/jSXIIZXqUBRUGWRxBVkAR2HYsD3z2o+fRF9Gh20w5d8DuNS+CI7
	 h71USFEGDp/sWlWu2G1Wnjq+1nKfnfQCpwk1UZDgv4omrgcdbdgXMOL0SSJjltUhL1WTT
	 /AAlGezFSfbOznEt7CkHQqhLbs8wLF/XSAAwZ0j/s6pP+i/ymAfcio2o1twDQLKrKDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+baG1S20f8kBGTqtpOyY2svXhb+QqweXo8GpCPWY4C0=;
	b=HVSF6XP3kKwozEuYMXVViNDi8bb+AFzJf3h6kszsf3Fy8n2Uk6Q3f2WEFU3L8lI0K2sF
	 lpWbCT/VbPmo4XV9T7GFKn0nxqAi4wMOsrKGmMeDzvX1BKwwMLMjtuQOlt/XpOl9eB06l
	 ATgYfVJqDhejR8VmEYAa8dri+m6lJVRBiIhC8EXxAqRUPgknolTzlPIWc1heXOQtSSry0
	 5DN6XDqJkCLEEVVCpu41BaVJSC5eC7jurHH6k1omqS+mzI1ytVb2Itctx1Snd3/tsqVRa
	 6MXgUNNfQexpBKYB6wuT4rc0BJ5lOIrJNt2rzS9pv2gFI5ZAxTW8G14CNSfRXaiogvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xxCuhx7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCC606A7F1;
	Wed, 18 Nov 2026 19:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xxCuhx7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2899B1F000C4;
	Wed, 18 Nov 2026 19:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030389;
	bh=+baG1S20f8kBGTqtpOyY2svXhb+QqweXo8GpCPWY4C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxCuhx7iTFLU3WhnleQPaZha4UcKdppMg5J3QOXWo04UUyh8vZ1A+/fVAGy6dLgpA
	 oofW823L6GbD0sgBeD0G2fITqR6xpwALJBobU3qGMe14JH/UvzSyKFS0sWFEnm1h3m
	 dyEaQpZH2DFgfEqmcY/4ihRGGbM2H/U7ZuLb9ras=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0685/1756] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118150036.505889253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 1894ed9a664d19c190ce1bd2146759efbae77e4b ]

bnxt_re_create_srq() stored attr.max_sge into srq->qplib_srq.max_sge
unvalidated, which defeats the num_sge check in
bnxt_re_post_srq_recv() since that check compares against this same
attacker-chosen value. Reject max_sge > dev_attr->max_srq_sges at
create time, and clamp dev_attr->max_srq_sges to BNXT_STATIC_MAX_SGE
since SRQ WQEs use the fixed-size SGE array.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c180936e908b3..cabed393390dc 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1791,6 +1791,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
+		ibdev_err(&rdev->ibdev,
+			  "Create SRQ failed - max_sge %d exceeds supported %d",
+			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
+		rc = -EINVAL;
+		goto exit;
+	}
+
 	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
 		rc = -EOPNOTSUPP;
 		goto exit;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index b09ac66e64466..f757cc10533ef 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -159,7 +159,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.53.0



