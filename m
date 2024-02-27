Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD713B295;
	Tue, 27 Feb 2024 13:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041141; cv=none; b=jazRdpHAx7C8qE/ANALawCUZwccvj2wCOGOPDfM6WouvDrYuVWh1QU8U4TdBbWEhCyT2gtPyky3uKyciUvRPIPneoA2a9d695FXbT+zS8lwgGrOBhxASgbCIMCGi0ck8y8JbT0vGBYO4Sh/zjm01smaxKmHTU95/HFDtHbOJFhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041141; c=relaxed/simple;
	bh=F81jRcePuzu7D72yKbmtanqTQe3wzjkiUAGiD2MUaQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo730Xno7MKwRo7Wf5lP7aeOyhe8UYtsjDrPJWiIjLBErIIM0C8dvzunXwuT9SqbcJ2fF9SfyC0ZPV9Op12rn6ppaF6MQajP6d9CYtCpbRWEUGq7D86l2eLSAOk8XAty3vm7u+xRU0bUeoiJIFBNP7o3pwFGxdamDG4pyZMTEUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jx6g3sRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jx6g3sRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBEC433F1;
	Tue, 27 Feb 2024 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041140;
	bh=F81jRcePuzu7D72yKbmtanqTQe3wzjkiUAGiD2MUaQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jx6g3sRrDjAMmY5dZZOBANQXO+rXuYS3MXd/ptOFuP4MrHXQYFXvOagaUTcIjJB2L
	 WhstYGCFgHbdo6V4i+o98haqPaaxvWcZbgUzBxcGAmSRiCcQDt748qpeUjC5z/XZ5E
	 bWUKGZ66NHrRzXR+prMsjGxVtfNRcourXVluO2vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 234/334] RDMA/bnxt_re: Add a missing check in bnxt_qplib_query_srq
Date: Tue, 27 Feb 2024 14:21:32 +0100
Message-ID: <20240227131638.393949657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 80dde187f734cf9ccf988d5c2ef1a46b990660fd ]

Before populating the response, driver has to check the status
of HWRM command.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-6-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index abbabea7f5fa3..2a62239187622 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -748,7 +748,8 @@ int bnxt_qplib_query_srq(struct bnxt_qplib_res *res,
 	bnxt_qplib_fill_cmdqmsg(&msg, &req, &resp, &sbuf, sizeof(req),
 				sizeof(resp), 0);
 	rc = bnxt_qplib_rcfw_send_message(rcfw, &msg);
-	srq->threshold = le16_to_cpu(sb->srq_limit);
+	if (!rc)
+		srq->threshold = le16_to_cpu(sb->srq_limit);
 	dma_free_coherent(&rcfw->pdev->dev, sbuf.size,
 			  sbuf.sb, sbuf.dma_addr);
 
-- 
2.43.0



