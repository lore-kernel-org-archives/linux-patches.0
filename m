Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3511F1714D0;
	Thu, 15 Aug 2024 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728665; cv=none; b=l8VFPeVUF/SKUgl/v2vKvZXDGIoOYpa3LvSUvJJ15WeVENzX/p2CtbBOmUxiZawUPJr7xxhygtdcgLXux68mbVjd2U0JU6NwXNuX6SiQroLniS7UgIi39Ru0VQUMjMXWGNBRswAbkP9zPM83+qi6YG9wHpko/5s//lOm8rqg3sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728665; c=relaxed/simple;
	bh=ZR7ngSpaI4tsHDFL5W9NiYkEf6YV9V2B2PzMGm/ZbWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wz4zTr0omZN1kPNLHkI0kn6Kr/zb/Rs4aUrJAef/8nMX16qam1C2KLGHi+fseBTBEZRBahmKh7RpQQoCBEwmm/3vwX7Gw/Xm2RuOTxleSPtYBgRx1kN3MID7k1mTIXfb/Q1mmvCq4fXLXs91BCuFyfsQ3KsB54H09bD1P8ui7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sMBcF++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sMBcF++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD407C32786;
	Thu, 15 Aug 2024 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728665;
	bh=ZR7ngSpaI4tsHDFL5W9NiYkEf6YV9V2B2PzMGm/ZbWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sMBcF++ZkyICqXkSnCUziibfDOxU9MGgbfMy6CmmUp/tWW0fMr1+zhBrNhRa1rQo
	 2GIRaANLKM/liclCzmfRPn4+aoriHFtV8YfwVdLDdbTM6YkMdB1sJblzctz/i4OgfZ
	 eIpntJ6fUtJtDO6waJfrFJ88cT6iUL0NCPjBeDZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/196] RDMA/mlx4: Fix truncated output warning in mad.c
Date: Thu, 15 Aug 2024 15:22:41 +0200
Message-ID: <20240815131853.770150018@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 418b9312fb2d7..a034cb3fa7cad 100644
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



