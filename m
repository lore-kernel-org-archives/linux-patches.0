Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5DF1AC42C;
	Thu, 15 Aug 2024 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731347; cv=none; b=iw7afQ45AqdLIcVLzm5RoqUEgKL1f8NNkDeQvAq72o9qWFQmY1fYmdhFPDhls6Xa6Jk9v0or3JMgUF1lh5tStet8S/0ekfi9aLa2sgJJdn2ie8CihSxdkee8xTQnlXkQShvVqKlh4N+HiVA6E1ILyKdnGlyEVn9y8TCABnCICQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731347; c=relaxed/simple;
	bh=E0pTlMHPQQAaS36soUipgxDbnz8N7jpf+s4P02MQvd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ASrnrniV4Iv252cnYLSasNpBDBQ09OL0Xv/1L7eW81Q/ThV+y0d0tdol5rb9uKudwoNDkAb43XF8KFl9FT8+4/gvEf7VrfeCD0oO9Le053+1zSUoMcg4Z7XMb2cYOxc0DnO5CXpUkro7kEj6cWW65zKr3+x6Fwk8HSBoO1hP6hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWSU3EKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWSU3EKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB445C32786;
	Thu, 15 Aug 2024 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731347;
	bh=E0pTlMHPQQAaS36soUipgxDbnz8N7jpf+s4P02MQvd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWSU3EKgxynpIex04+zrsjfm2GiABweu0BZqgDRpvg1zVJbot0StzIa9Xf0ysm4Zp
	 QfqRC96zM8MJvtWlvyGlAQ0TiP8fX5UOHWNVS03j1UgUyFLZW2GADzZ4RCZl0x9HFz
	 lgLt/SYW4npWHncG8UxOQJeDGkonBH8UIN/esGtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/259] RDMA/mlx4: Fix truncated output warning in mad.c
Date: Thu, 15 Aug 2024 15:23:22 +0200
Message-ID: <20240815131905.469353750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 08eccf2b6967d..511e095aa5567 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -2167,7 +2167,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 				       struct mlx4_ib_demux_ctx *ctx,
 				       int port)
 {
-	char name[12];
+	char name[21];
 	int ret = 0;
 	int i;
 
-- 
2.43.0



