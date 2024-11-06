Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A491E0499;
	Wed,  6 Nov 2024 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896945; cv=none; b=BBPKCW2mF8xNRoCxayw9EeTH1jtuEB8CjwJiOQc4H+icxXbfyASe9woOwvVdNt3BAM38rNfVlqL1zltR+p+QBN9amsc+iABQHsFUyucBVW8m6fy7EjxItLENZRs5SexuTdY087EL/rW9ANlHEK5jUJKaCS4FvYd+IhqGibxNTuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896945; c=relaxed/simple;
	bh=s50x93AB1LmYE16uLH8V0tpv/hTaKMxv+KQpsrgQRlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0qwnsqst8emDZ/2TKabwGQjL8Qo7ywrvfwP996ASst/dDa8LMQYR8kyJeFVmvMbcjQJxKVW9WNZZu2zKa0465CmbfDf8nJtoBraSKYnkDRZDQexuPYIFJAUCJbFMf3bO0NRDnkEc0cjBiwP6ZtO3e43NE6kErCvbPi8YvCY4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDey+z+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDey+z+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5793C4CED3;
	Wed,  6 Nov 2024 12:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896945;
	bh=s50x93AB1LmYE16uLH8V0tpv/hTaKMxv+KQpsrgQRlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDey+z+vUK6qbokWWZd79hlVkhkPsIwr4SfXVHiFEkCPXSk2UHkmRpegSRGl5DPeo
	 y0thT90ykPknDVeB0Jdjs9acuYMlddQArJH4+DFS3qbjycwD9s4RpGgvu0GzKQDsYk
	 ZOVcG8LSli8QccC2zDmzj8KlsJJUv9F+w4Ce80YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/126] RDMA/cxgb4: Dump vendor specific QP details
Date: Wed,  6 Nov 2024 13:03:36 +0100
Message-ID: <20241106120306.494841018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



