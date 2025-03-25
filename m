Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA92561A2;
	Tue, 25 Mar 2025 12:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906090; cv=none; b=MbepdMtj5n8DQf59wRn/jFHrR8AmjW3kDhFDS11hXnP1fIewYNFMw6+3vtZkbWSAi/66hvmcitAHJjJ5aPCqFWd+VjOIVM2+4bp/YYDtGpbVeNCnMrl0k4Iv2r+TrOMy60do7v8rj1uRa6euSXDYgP5tPm02ew9r5HiU/hHdeCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906090; c=relaxed/simple;
	bh=TvuN9hri/3CetT5B9akYbdrkCozL0yPS7QW541hbFEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/yiKjZJ5GwfLd/ItIaCbkBoQXQDZeXuyEdzXTXaG6IyasbFkVPNEWMJsmletJ4r4gfS/stpeDDJgJVPRSH4BsdIDZLVHLHy0lYTMXUrQHrR0uxf2J84Tq4Jyoc0+xlHFvrzPYhXuxaXhYmSsktYo640QkfFi24J6rma1vYjTIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMmXw1VU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMmXw1VU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D03FC4CEE4;
	Tue, 25 Mar 2025 12:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906090;
	bh=TvuN9hri/3CetT5B9akYbdrkCozL0yPS7QW541hbFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMmXw1VUXuifjHIssNi62J4q3CIgCBACQ1+W+G8f90E03k3i0YkfD1/yUXldHyHJC
	 wiakw6mdoJ8MhRJfWHFLte7Unp43XuRWv8M00f5bPkNt5VpkAUjFCkAaame9EhUqsl
	 HcKvB4O5pvKBYdpxRcGdfPIEoALQi2fPnnFjTPXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/77] RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx
Date: Tue, 25 Mar 2025 08:22:05 -0400
Message-ID: <20250325122144.593693977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 67ee8d496511ad8e1cb88f72944847e7b3e4e47c ]

The modulo operation returns wrong result without the
paranthesis and that resulted in wrong QP table indexing.

Fixes: 84cf229f4001 ("RDMA/bnxt_re: Fix the qp table indexing")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1741021178-2569-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 07779aeb75759..a4deb45ec849f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -283,9 +283,10 @@ int bnxt_qplib_deinit_rcfw(struct bnxt_qplib_rcfw *rcfw);
 int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
 			 struct bnxt_qplib_ctx *ctx, int is_virtfn);
 void bnxt_qplib_mark_qp_error(void *qp_handle);
+
 static inline u32 map_qp_id_to_tbl_indx(u32 qid, struct bnxt_qplib_rcfw *rcfw)
 {
 	/* Last index of the qp_tbl is for QP1 ie. qp_tbl_size - 1*/
-	return (qid == 1) ? rcfw->qp_tbl_size - 1 : qid % rcfw->qp_tbl_size - 2;
+	return (qid == 1) ? rcfw->qp_tbl_size - 1 : (qid % (rcfw->qp_tbl_size - 2));
 }
 #endif /* __BNXT_QPLIB_RCFW_H__ */
-- 
2.39.5



