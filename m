Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E41DF756;
	Wed,  6 Nov 2024 12:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895877; cv=none; b=cCuE0LJ7FjKFOotgOLF5tUqRze/4i3Ejp7nY9/o9wRecYU7ZCdeFb4FsSsR7IImrfoBaBnVt4UMx2HHN8u6pjc++YTYK7R07QaDyjyl+O+5O+rfw4+sErkseI7H1tD/bbyfiVkD4qH9gD0+fA+rNd/xfbOLkYQbARrrfKQc7cpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895877; c=relaxed/simple;
	bh=0YHua6C07oSAqO7yAFM3igbNKhyIZ3fgaBQ+dJVYX98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qimrkav94Tb4tMXsViPQsKSZkHKEZ26wEbHuD/vrPQ9iwYGx470gczI6LQWqP0RH352lQXJJ+bEvg54xPaHsPTAWXCHaTX37wRhwlSTA8BhOu30mvvmaWjjP05/STLQ/V7YeZ7mYoxwNG1JnbVJYKKdhWc61N00MzFlCSjBjBbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bV5al14d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bV5al14d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3949C4CECD;
	Wed,  6 Nov 2024 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895877;
	bh=0YHua6C07oSAqO7yAFM3igbNKhyIZ3fgaBQ+dJVYX98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bV5al14dqawR6Xzxedy1GjSVNUWd21Ds7MBBSp13A00rtWFSkVZAsXB7x6zRitQz/
	 6F5s7QyA0iKyrVKYw2+UC+b6v3mSLdsYFApy1or4KEs4j8aIX+QtIxZqrhJaNTrRRC
	 y1ahHroOUFfCrO0xX4du43DOSiRC2ET3CYTXcGwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 015/245] RDMA/cxgb4: Dump vendor specific QP details
Date: Wed,  6 Nov 2024 13:01:08 +0100
Message-ID: <20241106120319.615965544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 89f8c6f197f480fe05edf91eb9359d5425869d04 ]

Restore the missing functionality to dump vendor specific QP details,
which was mistakenly removed in the commit mentioned in Fixes line.

Fixes: 5cc34116ccec ("RDMA: Add dedicated QP resource tracker function")
Link: https://patch.msgid.link/r/ed9844829135cfdcac7d64285688195a5cd43f82.1728323026.git.leonro@nvidia.com
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Closes: https://lore.kernel.org/all/Zv_4qAxuC0dLmgXP@gallifrey
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 246b739ddb2b2..9008584946c62 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -474,6 +474,7 @@ static const struct ib_device_ops c4iw_dev_ops = {
 	.fill_res_cq_entry = c4iw_fill_res_cq_entry,
 	.fill_res_cm_id_entry = c4iw_fill_res_cm_id_entry,
 	.fill_res_mr_entry = c4iw_fill_res_mr_entry,
+	.fill_res_qp_entry = c4iw_fill_res_qp_entry,
 	.get_dev_fw_str = get_dev_fw_str,
 	.get_dma_mr = c4iw_get_dma_mr,
 	.get_hw_stats = c4iw_get_mib,
-- 
2.43.0



