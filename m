Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434B046A611;
	Tue, 21 Jul 2026 16:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649765; cv=none; b=DWCimf9JkDViooMguv5G8+SMxQgBK1PUx6SsMTgDgAnx+mfrPpxZ7zwJka6AHO9eyIYZM7lW1sMi33Xk/qnBJmxQsmNgcUGNAXYH6LMPb2jYblOizUme3axg9mnilFeba7Z/nifgWXtOLkt89NkYxPZJmdyuf9ulX7H0dF7IHFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649765; c=relaxed/simple;
	bh=4y3bIX/wktJspaaCVSeSIQaj+1pvWtkq2o/QLvECqvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csXKJYl+0uxzDnJcZwcDnA2MzHPWNUvPWktD789yR0qD+WBazxA2z2j9KxdTMaI9K/jFpCF4uq6viJQmwZTwLzZc4L3j1T7DZUOUEMUXECFTegXhYVcmYGW8vN6h6gArX9qA+iMdr6MN4ToEzGek08xs211Un1hzLUqqzaU9hkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLS/Qjbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLS/Qjbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D271F000E9;
	Tue, 21 Jul 2026 16:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649764;
	bh=Furv9Kgjq07zm8nb3kG+8TLNlODKfokyNqBPud+adcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLS/QjbxFmH3vuquiI3UVdaSeg17sLi2l/ahRAc37uupl7w91on70cGUeo5dZAuIo
	 S8sbYmfWgdGA4IyM90wuEmTE2VA4V0pnBR3A+ncOaZW5vEnC3T/W4PX8VvPyUV4cK5
	 VZZZy2/7ehKRpugE3V4ibo+DF981CtJwdGkPZzzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0699/2077] =?UTF-8?q?RDMA/mlx5:=20Release=20the=20HW=E2=80=91provided=20UAR?= =?UTF-8?q?=20index=20rather=20than=20the=20SW=20one?=
Date: Tue, 21 Jul 2026 17:06:12 +0200
Message-ID: <20260721152609.281076005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 449ae7927152e46acbe5f19f97eafdae6d3a96b1 ]

Free the UAR index returned by the hardware.

Fixes: 4ed131d0bb15 ("IB/mlx5: Expose dynamic mmap allocation")
Link: https://patch.msgid.link/r/20260611-fix-uar-release-v1-1-f5464d845dbf@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index aa2eb64ecf15e6..1144bfee58048d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2662,7 +2662,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_uar_dealloc(dev->mdev, idx, context->devx_uid);
+	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
-- 
2.53.0



