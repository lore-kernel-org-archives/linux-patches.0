Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F8749C;
	Tue, 26 Aug 2025 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208846; cv=none; b=H0fjyG+OYUnShXjRzG6MHaTyjiWlweSBfkP666Ha65drILX+oBYL7NnSkfyrZqPbvbeeVUAtIh3dhantbZVW4DFx6ihUg8aiEfrFAlZ4yt+kELGPMS7VjUVrFefY+URzJtuUAiBPjipjaoYrR1o8ZOFxyhuPub9mz/0kpgk2AQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208846; c=relaxed/simple;
	bh=RFMHr6fhGHK9ErDNtHSE1SggSZfCsk6nuyc8sjR/GCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0NQtlhelLfcOhPGWi7APYzLM7BzqMkNPuDLnlEktP5e4v5wHBEeCng8BzkqU/SIOsq5oEGkagZqnPWF9foZ1dieaRdwDWrBQHwk9yjKrOF7tOY0qhbBHq/7aRT1eNRNEckkGiObdQaqm8YfuQ1diCrgbCEOhPOc7XW7U/TEwd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M53xr4Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M53xr4Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FBFC4CEF1;
	Tue, 26 Aug 2025 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208845;
	bh=RFMHr6fhGHK9ErDNtHSE1SggSZfCsk6nuyc8sjR/GCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M53xr4ZpASyq5qU4cfvIQCb5qWfWnU6nYjq11RKZsqrPA6wBpN7N7JA3lDXq9toTl
	 4QOe/Eo/asOZgJNsjgx8IgyoNRDp0+2GkvkzPqtnTkaAW59zIGh50NPtCYHB9/JqJX
	 xiWHYGJppQ1JWS73jYjOs9vmBsq7cgv2pQDbLa9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/322] RDMA/bnxt_re: Fix to do SRQ armena by default
Date: Tue, 26 Aug 2025 13:11:22 +0200
Message-ID: <20250826110922.524293522@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 6296f9a5293ada28558f2867ac54c487e1e2b9f2 ]

Whenever SRQ is created, make sure SRQ arm enable is always
set. Driver is always ready to receive SRQ ASYNC event.

Additional note -
There is no need to do srq arm enable conditionally.
See bnxt_qplib_armen_db in bnxt_qplib_create_cq().

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Link: https://patch.msgid.link/20250805101000.233310-2-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 7436ce551579..3170a3e2df24 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -704,8 +704,7 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 	srq->dbinfo.db = srq->dpi->dbr;
 	srq->dbinfo.max_slot = 1;
 	srq->dbinfo.priv_db = res->dpi_tbl.priv_db;
-	if (srq->threshold)
-		bnxt_qplib_armen_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ_ARMENA);
+	bnxt_qplib_armen_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ_ARMENA);
 	srq->arm_req = false;
 
 	return 0;
-- 
2.50.1



