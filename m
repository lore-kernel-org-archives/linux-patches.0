Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5508635D;
	Tue, 26 Aug 2025 14:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218455; cv=none; b=f2cuVjocbWFQI7prPYLQctzKyH6BDJKAurVNQnUTxZUDnlQjBFkgG/iFMxrOe9/sMoTfFc+K8pDVD5pW2A8GoLYyEvZeq9g4MShl13y6fuF5Sc093ZMcEHNICdGVqSK+AjYu+gkhTSVmAGL5vriOh8bD4ShrMhSCMCdn/uqYzxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218455; c=relaxed/simple;
	bh=QdtfZjIxppiX2J4a8zcuwoUwRhlbMufIfkm/L/WkUw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5Rvyf5cn+LrGAhOnPg2MTRjYRB+GCyO9U6lpYhj+tjBrIdWpAJ9tFoNpih+rHcEoSjm3pKJk7S44taJo8MjDjEvmybO+Q5ncZ2jq7Tj/9wMkJ2g1GksbNGARLriLCklrcswvfBUl6WqJMNSOcdkyLoH54w3WKSes4SGlm9CTjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcDzUMxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcDzUMxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C607DC4CEF1;
	Tue, 26 Aug 2025 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218455;
	bh=QdtfZjIxppiX2J4a8zcuwoUwRhlbMufIfkm/L/WkUw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcDzUMxMWXDDJXhSkQtc265YVjJ2r9uOBJtIo/exoo6ZPeaL4bduJ3Fwjzz8Yvj6z
	 1MnnRFc2BNHRLcWOceJ6pXBVdbEm3FaXp6KT1CI+qUjoWHNLoFrXOxWC22qIcXxkLg
	 0XoTreWoZx8tVeIrOrdkWyPhY1lpYc+SbUPovtsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anantha Prabhu <anantha.prabhu@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 509/523] RDMA/bnxt_re: Fix to initialize the PBL array
Date: Tue, 26 Aug 2025 13:11:59 +0200
Message-ID: <20250826110936.996428601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anantha Prabhu <anantha.prabhu@broadcom.com>

[ Upstream commit 806b9f494f62791ee6d68f515a8056c615a0e7b2 ]

memset the PBL page pointer and page map arrays before
populating the SGL addresses of the HWQ.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Signed-off-by: Anantha Prabhu <anantha.prabhu@broadcom.com>
Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250805101000.233310-5-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index af23e57fc78e..be98b23488b4 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -121,6 +121,7 @@ static int __alloc_pbl(struct bnxt_qplib_res *res,
 	pbl->pg_arr = vmalloc(pages * sizeof(void *));
 	if (!pbl->pg_arr)
 		return -ENOMEM;
+	memset(pbl->pg_arr, 0, pages * sizeof(void *));
 
 	pbl->pg_map_arr = vmalloc(pages * sizeof(dma_addr_t));
 	if (!pbl->pg_map_arr) {
@@ -128,6 +129,7 @@ static int __alloc_pbl(struct bnxt_qplib_res *res,
 		pbl->pg_arr = NULL;
 		return -ENOMEM;
 	}
+	memset(pbl->pg_map_arr, 0, pages * sizeof(dma_addr_t));
 	pbl->pg_count = 0;
 	pbl->pg_size = sginfo->pgsize;
 
-- 
2.50.1



