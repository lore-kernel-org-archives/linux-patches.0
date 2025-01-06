Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2373F83A14;
	Mon,  6 Jan 2025 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177653; cv=none; b=g/G53mHuterhGRHvQ5fu5G+QcMFFKcv6HvCpS+rkXaPRA/POUSI0I0FsDr8fw2N513CGT5qaOCrNoNd7HJyAv6qWKKncRrlbEXhT2hbRuX0ZcWp70+ZftDw1D/48CROD2khtED0H7mxFVdn11trbJdQhAYQ/FBYEWlxPj/tBnJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177653; c=relaxed/simple;
	bh=7rBFAzXqetaSSkLZBsKDEVnfwYWMod++Q26DvasYHVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LD7dQOwg1dh8CoxakQTnxUtAcf95ZN5CMHEnvdvNrqbTJ3dKQyxCJGNOkY+xofCrP2/a0ThLTQ9PC2JwdRRV5PpDUQf8XuzZ2Gl3lL7V0y8VqxS1tmaUdL7jDcgQqKPUQqFnMTXTIPgTqGVaXQRt81ZwcZaMiFm7870kK7n9GS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjUR8sRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjUR8sRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDCBC4CED2;
	Mon,  6 Jan 2025 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177653;
	bh=7rBFAzXqetaSSkLZBsKDEVnfwYWMod++Q26DvasYHVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjUR8sRXrcJyU1xBi9CQVWvEEviWv5/Wk62kK2XGq/4/25BeEB+Ulktslni2cSIoZ
	 jjRgivU1YtHO2B/SSft6/840HLbDXeqEufy30rRoNC6AQgVEHaj5RZripHoNn9qztz
	 qdR2HgNq/mncgn5PCsUtFlazjmQrOnBpZV36RHds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/156] RDMA/bnxt_re: Remove always true dattr validity check
Date: Mon,  6 Jan 2025 16:14:58 +0100
Message-ID: <20250106151142.208043355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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
index 7ad83566ab0f..be374d8ed430 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -999,9 +999,7 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
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



