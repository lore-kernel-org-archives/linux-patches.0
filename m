Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3EC200112;
	Tue, 26 Aug 2025 11:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208856; cv=none; b=hCGfpz4hMuRrfCl30uAqMzqO0HmpMfVJq5LMZv+wZLno+sYIRHkHiX6w+PZ1IrIKSVMOaXTbjiL/pKpxfQEQvUuwKrL4WiJ1zXqumGFp3v78u9KzVm58L7kfZf77g8tS3R9TaAgNeKcGRGqxxK5dTJK/IDq7GdgG20y4OR2fisc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208856; c=relaxed/simple;
	bh=qufcJ58lxYYbXKDaGZILcs9b8iLeoWl5Q36BDGxj/mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO7eWXLysVcH8eqPpKiZM/vaXbp6NRGpkJJ6/ramet5Rmf0C4QkN83zX6W+BI4j8J4GML9/uzUEThBu1PT2kma5+nUnk08V6/+TFMhM4kTHjQ5zXWEtayfGKoOMTbUoUbYZzaL7rFWK71mgC1F1szAX7GyNikw5Qeah0Qk0UxH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtwSqm3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtwSqm3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B3BC4CEF1;
	Tue, 26 Aug 2025 11:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208855;
	bh=qufcJ58lxYYbXKDaGZILcs9b8iLeoWl5Q36BDGxj/mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtwSqm3nJpQy2PSje9bAj33c5Ecw8Ss0shiAmpa4snt0iGgPNF8BQ7FHoMZxUpHSz
	 rQLTbkOkNJZlJzjZ/ZhxCJLb+xI+OA/FUt+ZRR9iwcPp//YHim3c+zLDxoOlTbM+sR
	 eS+HmYU0btfpBxDA+SFxYi8IWMVYOo3EtNm07ezE=
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
Subject: [PATCH 6.12 270/322] RDMA/bnxt_re: Fix to initialize the PBL array
Date: Tue, 26 Aug 2025 13:11:25 +0200
Message-ID: <20250826110922.595154032@linuxfoundation.org>
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
index 02922a0987ad..b785d9e7774c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -121,6 +121,7 @@ static int __alloc_pbl(struct bnxt_qplib_res *res,
 	pbl->pg_arr = vmalloc_array(pages, sizeof(void *));
 	if (!pbl->pg_arr)
 		return -ENOMEM;
+	memset(pbl->pg_arr, 0, pages * sizeof(void *));
 
 	pbl->pg_map_arr = vmalloc_array(pages, sizeof(dma_addr_t));
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



