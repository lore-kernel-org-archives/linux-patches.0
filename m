Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024820;
	b=O5snyJvW1gt26G0AL3H3FRNXmUSd/ELORcVwvB+AQTnIY8fNELHJ8c1BzDt1wDCdqMBr
	 p8qkzY/drua0URy0SAmwFel488o1DRngKC1QFlFKK+6jLcx0HSb2e9b1VgGIsKq8YEVme
	 +pw1ITo+qKmyHPKlqcI5qOtnSVspjrzAxAHHv7PIoss2IWMRhjfjqBMwZAP04qNI+Km4H
	 JTU8eUirXwylQkIhFIMfygerEbatnbn8JziIlOOa7Vv3O56YyNPkwpFqQFaMn8P6NYwH3
	 Esr//mvwYiB/77+63NIIWSvCfPKDdaX2hQg2Wqb52LfFD77ReM5OyPU9p3ZgpgZaEpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEztKZDzA+zv2NbmWsNoJPyICpkVw5bXrIX43VNz3f0=;
	b=YwRXYuhZvFWqoKO1tf+94J0CcGqh68oFFHPkZEtDTy3nYrEMRgDfgTCg9erP9xhrrvn5
	 gjZkrC6dbvKQFZcRRlIMY/NJhYV/bMa0gJ8ladltc8nxwkwm9P90ULYIodS7hZZoINZn7
	 AlovFCiu0OT8PgcRAzsExG04tAqsuGdP894vv9QSReEkWDQG2zEL+bU8QA1e/0XulWHPA
	 Png6mh3jR0Gca2U1O8zsOzJvO+lp7hCEVii/90Ld/xoQjlZi20gBQu9hqLcivfAiaWkoL
	 4qDh0xafg01Ypa51UE5XRTQL/1jwu1Vphg0u9oEDFRBd6R3w0CkoNw85726s4U3oSJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFHROnmq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA7606A331;
	Wed, 18 Nov 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFHROnmq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540D31F000C4;
	Wed, 18 Nov 2026 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024819;
	bh=XEztKZDzA+zv2NbmWsNoJPyICpkVw5bXrIX43VNz3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFHROnmqKA1R76oOrSFjzghRKJ97M3VmS6tfHmfJ6GU5JrWKrDVq21EuJnpY70+Zo
	 ApkPgYOAJWUQwUzJBDQS3aC0SqfjVLHqVEcsVRCxd5/xeQAbENT0wMMm7o8+8x6YvA
	 NFVdmFYh6bObQFa6HgZI6qQVwH3t+buUPULCfftc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0859/2151] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Wed, 18 Nov 2026 15:43:14 +0100
Message-ID: <20261118150153.519115196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7c8aad8a12405..656b39753f353 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1897,6 +1897,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
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
index 408a34df26672..5036cc2c2cd6f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -160,7 +160,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.53.0



