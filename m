Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809EC1A619B;
	Tue, 30 Jul 2024 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357587; cv=none; b=Sp77fGUOG9gkJlCyTyaQyjUE+REockz41K9SO7iBMksbwKhCGrObVSCCq2f1tfsNBO5sQQOD8mn3VM9V5risFityHI/JlxKUETtfeYctJujcfQYwVKnwn14KX7LqVnOrolcxLhpQyUAmivxB0FMFoT5JTIB94nsUohZA4VIAzVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357587; c=relaxed/simple;
	bh=iSC1P+jUzrJ9jM4/APPyIhKeV7OwXjZMl1kuJ72+5HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvFWMVOR1FWq+TXLcnDkkUU/3zseRmDbKr9QOp2ck7DIdh3SrYLrQgLhRbGCGgV0e9Yxf5M2U2OlBjVVrXCMexV0bFsz0Ego6lxSnltQ1UkuKkH1H9Rstpe+uiUkosmb6/5kbiOTnozTHQUHDNEi7Lgq6qQrk0RbR+05k8EMcVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzuNyckc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzuNyckc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B57C32782;
	Tue, 30 Jul 2024 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357587;
	bh=iSC1P+jUzrJ9jM4/APPyIhKeV7OwXjZMl1kuJ72+5HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzuNyckcq2tM8wFJ/Yn6DM8mtXlwl6cgpiy/6+dh2AsZFm2HGAFIo4NsogD2vXTLo
	 +I4QoHLvFFkCD8ODdWwrzM8Myi7fczaNiDraHz8MN0rpCYQpfY3V1R9Y3yRghEmy6C
	 LvFN7rtByAlL0XZtYQ6zD4J+VF6jx+FZoOVfx+jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/568] RDMA/mlx4: Fix truncated output warning in mad.c
Date: Tue, 30 Jul 2024 17:46:19 +0200
Message-ID: <20240730151650.512847099@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



