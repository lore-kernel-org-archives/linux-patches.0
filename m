Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9203922B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22E8C433EF;
	Wed,  7 Jun 2023 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171158;
	bh=gp+VZ8i6KYmCDTuTEW/Nl3brvb4biazYO7VaJZ3s4OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmScsBoupIHED1QVUbkmJrEUVA+WBn7gmivyB6Ov2aTiAevfVrRF5XSdFfFSWdAiX
	 9N9Oby6D8AaYLXIVqz1upmOKPw87W5e3Jor+8+T/CZyegDNTr0FScMnMzdAV7iIAqm
	 qFeSeusuBuk/xQGtkk+e29jiAGR/uHxcqanOtxjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/99] RDMA/bnxt_re: Fix return value of bnxt_re_process_raw_qp_pkt_rx
Date: Wed,  7 Jun 2023 22:15:56 +0200
Message-ID: <20230607200900.360790564@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 0fa0d520e2a878cb4c94c4dc84395905d3f14f54 ]

bnxt_re_process_raw_qp_pkt_rx() always return 0 and ignores the return
value of bnxt_re_post_send_shadow_qp().

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/1684397461-23082-3-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index e3e1ea0c7666a..f0e96639850eb 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3165,9 +3165,7 @@ static int bnxt_re_process_raw_qp_pkt_rx(struct bnxt_re_qp *gsi_qp,
 	udwr.remote_qkey = gsi_sqp->qplib_qp.qkey;
 
 	/* post data received  in the send queue */
-	rc = bnxt_re_post_send_shadow_qp(rdev, gsi_sqp, swr);
-
-	return 0;
+	return bnxt_re_post_send_shadow_qp(rdev, gsi_sqp, swr);
 }
 
 static void bnxt_re_process_res_rawqp1_wc(struct ib_wc *wc,
-- 
2.39.2



