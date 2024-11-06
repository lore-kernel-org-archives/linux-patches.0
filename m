Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D227F1EC017;
	Wed,  6 Nov 2024 12:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897315; cv=none; b=h4DDtQ+q3iU2Q392rAPXZmM8dDYu2ebStmxOmvL3nJ0Uzn7DWpJIPKDoo12AfWsA4k5aGZkGQSkRLom+l32tnVFTgOjf8Dm0HOI22NJNjfP2URUeS1aDGEFTEjyahrR0j8mrxka9OZkzk0Us9So10i2h2JjZUXP/JazYnl6efnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897315; c=relaxed/simple;
	bh=OJuOKpMC4IoypASuQ2XHLbIjvpOvSTzwKyhKNIYU4oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+PB1WseptFDmJ+8EhOxyzx0Xu0eF/OV97BdUiC60IsepTJUAdFUUphABu9+kCwTojf5AslPTPm1ssea0sRcpuK+3jlw8E+pLpjsKi3g/MO+tRcVQHjwkSYBE+eokK4GIk0wGEF0+1aD/9nnJPzBSnVKAXdqpm4qCm9GaJMVvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eO5D3ojX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eO5D3ojX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5882AC4CECD;
	Wed,  6 Nov 2024 12:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897315;
	bh=OJuOKpMC4IoypASuQ2XHLbIjvpOvSTzwKyhKNIYU4oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eO5D3ojXabRp+jVXWXyiayngfgmM+pIQB09dXqDLu8gPBfzHgCDqa2rzELjvhrpqK
	 M/RVdvge/Ez1CieZEQKg0hMlyFQT8ooR9kSS5si/NMvJl7kWKDyGkrtqH9qtTcgqc3
	 P3nK7D6WFDQUHHQLfqq0sXHye5NlsYCGj78D36MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/151] RDMA/cxgb4: Dump vendor specific QP details
Date: Wed,  6 Nov 2024 13:03:21 +0100
Message-ID: <20241106120309.203640522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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



