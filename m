Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9701A6192;
	Tue, 30 Jul 2024 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358996; cv=none; b=BcJinx7M/AC9mQAVn3vn6pJ2NtV5t6SiMYJQTX1nzULL5TjsqrFXJyluJ6mDwLifUW1aWonceEN2MSgoFRc/gbAm4ublg/bG4Fqz+KqV5G2lwf0Czjh90sQRh66L3kVHGLgSrXojTO9cHva1W/I5qABxbw91JWjWGgjuh3NxdGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358996; c=relaxed/simple;
	bh=Kkwn3PfgHSwSKtau51PxWQu4wjVcbvkLJGGVFBSlZdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kb/Fos9v6hKTtsD8Jnd4KovL0WiRc2eWRMVvvyAndLau7iKs6nO+MakmVz/gDhzwDGa5kjcW1nd7YpW7s6qJ0xS73Cq5C6fy1txP6sp3bnWSBTNCnLRsKbW8GYj2zAJv9SuPyj/0qoYvX21WJzSd+ACObAcfL3hG7DpFc4oRdbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYH2y3w+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYH2y3w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02149C32782;
	Tue, 30 Jul 2024 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358996;
	bh=Kkwn3PfgHSwSKtau51PxWQu4wjVcbvkLJGGVFBSlZdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYH2y3w+4NHlPI1Zhj6YlV/XFVCeoVL965AWD4Mb8TyZ4YxX2hJdYnBbHOFGvDC3X
	 8LtHvQjcX+0sDCouBfUoxA+FbjLAjZXrtpkMym3gFiPY0sgxyrUJt9XTd1k82Xf2Xf
	 ceqi6L5ZpwS5ZdgL8ZGmnfYeURSMz0K5EMY7wXoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 419/809] RDMA/mlx4: Fix truncated output warning in mad.c
Date: Tue, 30 Jul 2024 17:44:55 +0200
Message-ID: <20240730151741.245441995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 0d2e6992fc956e3308cd5376c18567def4cb3967 ]

Increase size of the name array to avoid truncated output warning.

drivers/infiniband/hw/mlx4/mad.c: In function ‘mlx4_ib_alloc_demux_ctx’:
drivers/infiniband/hw/mlx4/mad.c:2197:47: error: ‘%d’ directive output
may be truncated writing between 1 and 11 bytes into a region of size 4
[-Werror=format-truncation=]
 2197 |         snprintf(name, sizeof(name), "mlx4_ibt%d", port);
      |                                               ^~
drivers/infiniband/hw/mlx4/mad.c:2197:38: note: directive argument in
the range [-2147483645, 2147483647]
 2197 |         snprintf(name, sizeof(name), "mlx4_ibt%d", port);
      |                                      ^~~~~~~~~~~~
drivers/infiniband/hw/mlx4/mad.c:2197:9: note: ‘snprintf’ output between
10 and 20 bytes into a destination of size 12
 2197 |         snprintf(name, sizeof(name), "mlx4_ibt%d", port);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/mad.c:2205:48: error: ‘%d’ directive output
may be truncated writing between 1 and 11 bytes into a region of size 3
[-Werror=format-truncation=]
 2205 |         snprintf(name, sizeof(name), "mlx4_ibwi%d", port);
      |                                                ^~
drivers/infiniband/hw/mlx4/mad.c:2205:38: note: directive argument in
the range [-2147483645, 2147483647]
 2205 |         snprintf(name, sizeof(name), "mlx4_ibwi%d", port);
      |                                      ^~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/mad.c:2205:9: note: ‘snprintf’ output between
11 and 21 bytes into a destination of size 12
 2205 |         snprintf(name, sizeof(name), "mlx4_ibwi%d", port);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/mad.c:2213:48: error: ‘%d’ directive output
may be truncated writing between 1 and 11 bytes into a region of size 3
[-Werror=format-truncation=]
 2213 |         snprintf(name, sizeof(name), "mlx4_ibud%d", port);
      |                                                ^~
drivers/infiniband/hw/mlx4/mad.c:2213:38: note: directive argument in
the range [-2147483645, 2147483647]
 2213 |         snprintf(name, sizeof(name), "mlx4_ibud%d", port);
      |                                      ^~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/mad.c:2213:9: note: ‘snprintf’ output between
11 and 21 bytes into a destination of size 12
 2213 |         snprintf(name, sizeof(name), "mlx4_ibud%d", port);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:244: drivers/infiniband/hw/mlx4/mad.o] Error 1

Fixes: fc06573dfaf8 ("IB/mlx4: Initialize SR-IOV IB support for slaves in master context")
Link: https://lore.kernel.org/r/f3798b3ce9a410257d7e1ec7c9e285f1352e256a.1718554569.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index a37cfac5e23f9..dc9cf45d2d320 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -2158,7 +2158,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 				       struct mlx4_ib_demux_ctx *ctx,
 				       int port)
 {
-	char name[12];
+	char name[21];
 	int ret = 0;
 	int i;
 
-- 
2.43.0



