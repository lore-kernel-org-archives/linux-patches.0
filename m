Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF94C13B2B4;
	Tue, 27 Feb 2024 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042309; cv=none; b=IEPGnFr/Paq3KNYDrxq23f0Z2ahLIlCs9HlRDuSBzpbO8Do8cmpe37rwqciTcJWETZUrLKBKzf0GITlTkxtwK5/xGxrP/qPc2WMiLulHJPReCZn+02mV3SNzfgPOGxo6KwsQVtH3dwVcyGZpuCve5l7Tgz3pt2eEBuzrtDhp7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042309; c=relaxed/simple;
	bh=6H573TBLsvjGDzSoLX7GAOaLjrMxEzcb/gsKD9depcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjuVPRAjgzwxGtI6Tfco/EA5Hmzj1nnlgaIGPOCCXgx9XZ9I+83xTbPOj+LkuNUxQfK23b4R/9u5GGWsAO0F5lPX8wxWSu1s4aHvikN7LcZlBtZHD8XFtfbE/gvwpjvVVjcECrMEgcqTxbcQxJStrsRezONU1lgNwJVjGViRSc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zqz2OSGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zqz2OSGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77957C433F1;
	Tue, 27 Feb 2024 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042308;
	bh=6H573TBLsvjGDzSoLX7GAOaLjrMxEzcb/gsKD9depcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zqz2OSGm0g3xQ11qAJSZx3ZJVRdMxrj6gJA0IkqP+9pbwEzEM38iIPS1RPiP9d+uR
	 2tPsuO+4AEysmeP4kkJmYhi97i2gSVjM+ZkIG4d7lPj8HLuIQpFzKD08ldU4fMd+9/
	 bXG/MchxTkc0s1fgRi/Ro9onItyR5hB3BbLMgjEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/299] RDMA/bnxt_re: Add a missing check in bnxt_qplib_query_srq
Date: Tue, 27 Feb 2024 14:25:24 +0100
Message-ID: <20240227131632.640221809@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



