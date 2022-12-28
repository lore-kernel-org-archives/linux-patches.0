Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5873C433EF;
	Wed, 28 Dec 2022 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241759;
	bh=x2g7E9UlzWKTY/F+tg+QfBMpwABdRey45PH/f6TAnQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YNFQa/JNfCHjCFVe8E88YNlPdiEljG9TMrXkbdtEKSi2BZEUNuB6oXdv50UCZhoh
	 vPU5aI6buUx37LP2/FdHz+kojH8FbKm+TiiqGZxihIRv0BnbKoyWatNUhEH4+7M5Vd
	 t3hSe5msAg7jNYYWHlKq8pvBgoOH1+A96CuIKI1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Granados <j.granados@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0324/1073] nvme: return err on nvme_init_non_mdts_limits fail
Date: Wed, 28 Dec 2022 15:31:52 +0100
Message-Id: <20221228144336.808631742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joel Granados <j.granados@samsung.com>

[ Upstream commit bcaf434b8f04e1ee82a8b1e1bce0de99fbff67fa ]

In nvme_init_non_mdts_limits function we were returning 0 when kzalloc
failed; it now returns -ENOMEM.

Fixes: 5befc7c26e5a ("nvme: implement non-mdts command limits")
Signed-off-by: Joel Granados <j.granados@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index aca50bb93750..cd2e2bfeae82 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3043,7 +3043,7 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (!id)
-		return 0;
+		return -ENOMEM;
 
 	c.identify.opcode = nvme_admin_identify;
 	c.identify.cns = NVME_ID_CNS_CS_CTRL;
-- 
2.35.1



