Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794B71D0420;
	Wed,  2 Oct 2024 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878355; cv=none; b=q6NBuw5FGsAYwXFgk/VWePh+F8dlj3pNfCdQbwk3O3Az1Qu77Tx++1qKYGKo2HKH7mBVzb4qld9ghmFkLAxvPn9fkuE0FAdeOo/APFXrXlMm0mgCZYYyFHcxjFZNifmfT/2JsA1G6RAC/6XyXL1nQfUVUQvlZwVnpKn0X2s4GGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878355; c=relaxed/simple;
	bh=r/HnLEW++eUUiSUivqLpsafXfopPcAEu8IrHZgRJVTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIjfYKSRqsPiI/juWGXWW36MUcWn8RFuWGbcUu34Q2bW0fwxOYmUpgz5z9v486uzdRqolBXehaWbfVkMvQECvmm28J2jm7ez9Ej5C+oCr2sCmQW/a0dV7qL5pszGM5eeWidkjFVtCM4AeIeFRih1sC5GZ69NkVnyOOqK1GFkxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cV+1WgwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cV+1WgwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02606C4CEC2;
	Wed,  2 Oct 2024 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878355;
	bh=r/HnLEW++eUUiSUivqLpsafXfopPcAEu8IrHZgRJVTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cV+1WgwESDkBpJe310EZ8SLgk3mzmzK2K3ywZ1nZliA1pk9bNpdSOl4zzq8OH+qfq
	 qxO0FJoUeH6SaDP8l1khkzWictIqJtRErEHnJGRivmTvtM0hqetkpQUqstqZPHfqvP
	 Wnj0/icR7yTkfGxrNbWyEUA1K5B6pgwA3BUOE6s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 386/634] RDMA/irdma: fix error message in irdma_modify_qp_roce()
Date: Wed,  2 Oct 2024 14:58:06 +0200
Message-ID: <20241002125826.339496411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@maxima.ru>

[ Upstream commit 9f0eafe86ea0a589676209d0cff1a1ed49a037d3 ]

Use a correct field max_dest_rd_atomic instead of max_rd_atomic for the
error output.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@maxima.ru>
Link: https://lore.kernel.org/stable/20240916165817.14691-1-v.shevtsov%40maxima.ru
Link: https://patch.msgid.link/20240916165817.14691-1-v.shevtsov@maxima.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 12704efb7b19a..954450195824c 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1347,7 +1347,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->max_dest_rd_atomic > dev->hw_attrs.max_hw_ird) {
 			ibdev_err(&iwdev->ibdev,
 				  "rd_atomic = %d, above max_hw_ird=%d\n",
-				   attr->max_rd_atomic,
+				   attr->max_dest_rd_atomic,
 				   dev->hw_attrs.max_hw_ird);
 			return -EINVAL;
 		}
-- 
2.43.0



