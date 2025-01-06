Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BECE1DB951;
	Mon,  6 Jan 2025 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177421; cv=none; b=k29jKS8rf1nJqtfQwY7xvqZxyiIdSZTQQRkE8IWzbKd2oKf/QRrYkOiEvq+FWUUHjEQugwDbwR23Mc4PfyYa23nucYunszHvSNK44tdy3P5dh+VWLnMPkwWKAIalot4STSo73dq8b0wM5EDUIX/oPlMqgt7KIqdWG0WEaP1al6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177421; c=relaxed/simple;
	bh=uQ5vyDMmHGhtq17mS//JMg0mgMomudLMIoyAzuNcseI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaZvRv0NJVDNdjjYPese+dZYypZ9YZauiHPgPFZMuWgekHVgRghtVAwvzyt36pO1h99D96N47VVu1HYurKQ4dhJ4aW1gCpEIO9drX6NdlueHaikzsMsuLiETXPBtLDx5gR4w+M1ZY3G9QrMTmV6RuJ2wBZv4E2vymzzdaRvCqkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OghmATdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OghmATdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A50C4CED2;
	Mon,  6 Jan 2025 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177421;
	bh=uQ5vyDMmHGhtq17mS//JMg0mgMomudLMIoyAzuNcseI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OghmATdiStEbuffU0BwSYoc77CMnJ3T5oQ198smFqjxvSyhIicCcMgJTOevgUzdhh
	 JRK/qroZ5O9tl8ff3AI/7ZIwfLVv/DQ/p0z3SgnStdfQpxd86ROEJHBUoYI412lekV
	 E7ccqYh9/YV2EZ70nlgggfe0xSeBHssOAdlzu++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/222] RDMA/bnxt_re: Remove always true dattr validity check
Date: Mon,  6 Jan 2025 16:15:32 +0100
Message-ID: <20250106151155.606322645@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit eb867d797d294a00a092b5027d08439da68940b2 ]

res->dattr is always valid at this point as it was initialized
during device addition in bnxt_re_add_device().

This change is fixing the following smatch error:
drivers/infiniband/hw/bnxt_re/qplib_fp.c:1090 bnxt_qplib_create_qp()
     error: we previously assumed 'res->dattr' could be null (see line 985)

Fixes: 07f830ae4913 ("RDMA/bnxt_re: Adds MSN table capability for Gen P7 adapters")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202411222329.YTrwonWi-lkp@intel.com/
Link: https://patch.msgid.link/be0d8836b64cba3e479fbcbca717acad04aae02e.1732626579.git.leonro@nvidia.com
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 3e07500dcbcf..4098e01666d1 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -980,9 +980,7 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	u32 tbl_indx;
 	u16 nsge;
 
-	if (res->dattr)
-		qp->is_host_msn_tbl = _is_host_msn_table(res->dattr->dev_cap_flags2);
-
+	qp->is_host_msn_tbl = _is_host_msn_table(res->dattr->dev_cap_flags2);
 	sq->dbinfo.flags = 0;
 	bnxt_qplib_rcfw_cmd_prep((struct cmdq_base *)&req,
 				 CMDQ_BASE_OPCODE_CREATE_QP,
-- 
2.39.5



