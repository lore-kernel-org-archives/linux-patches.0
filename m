Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4DD3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D98C433D2;
	Wed,  7 Jun 2023 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171379;
	bh=7s73vs/YZ8FRztctnfZ4aEM/BYXTrdu1ejkZVUgfaPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHArfhQgbpn6RiM38ZylopIRRx+g0MteJ+5kiKv2t5Kb0eN7ENvfaYfeVHReCG4d3
	 E0AQCbSl350XXblObzGSSyA8dPFkn4D/LB4x8jRDXWry+71E5uZwNWJslpFVhxFkoK
	 n3wg0EgFw9Uru9mvdKbM2K4cv33h3m/6BDQYg8+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	YueHaibing <yuehaibing@huawei.com>,
	Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 95/99] RDMA/bnxt_re: Remove set but not used variable dev_attr
Date: Wed,  7 Jun 2023 22:17:27 +0200
Message-ID: <20230607200903.229887396@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

commit a0b404a98e274b5fc0cfb7c108d99127d482e5ff upstream.

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function 'bnxt_re_create_gsi_qp':
drivers/infiniband/hw/bnxt_re/ib_verbs.c:1283:30: warning:
 variable 'dev_attr' set but not used [-Wunused-but-set-variable]

commit 8dae419f9ec7 ("RDMA/bnxt_re: Refactor queue pair creation code")
involved this, but not used, so remove it.

Link: https://lore.kernel.org/r/20200227064542.91205-1-yuehaibing@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1286,14 +1286,12 @@ out:
 static int bnxt_re_create_gsi_qp(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 				 struct ib_qp_init_attr *init_attr)
 {
-	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_re_dev *rdev;
 	struct bnxt_qplib_qp *qplqp;
 	int rc = 0;
 
 	rdev = qp->rdev;
 	qplqp = &qp->qplib_qp;
-	dev_attr = &rdev->dev_attr;
 
 	qplqp->rq_hdr_buf_size = BNXT_QPLIB_MAX_QP1_RQ_HDR_SIZE_V2;
 	qplqp->sq_hdr_buf_size = BNXT_QPLIB_MAX_QP1_SQ_HDR_SIZE_V2;


