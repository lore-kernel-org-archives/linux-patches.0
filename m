Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5B48F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22C1C433C8;
	Sun, 16 Jul 2023 20:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539543;
	bh=U5hc5LOkU1GWixynn+92ugxSHNp/FDSIkgGx2bbzTn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgIQ3AZJ0XN//x08tCucNNwbn1BCZk8duDQWEFrgDrWNsy/RdWTZVPfefONxKaZ+A
	 +UppmNypDiOTbTIKSXnzBqXHnQ1coGYAgZwHzuHGRxxy78tNPiBmoBNZ2RjR/Ac+nB
	 3rrfpBkps8aKf9xiV0eXZ4umMAq527uOUhiB4Uoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/591] nvme-auth: remove symbol export from nvme_auth_reset
Date: Sun, 16 Jul 2023 21:42:36 +0200
Message-ID: <20230716194924.309180265@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 100b555bc204fc754108351676297805f5affa49 ]

Only the nvme module calls it.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: a836ca33c5b0 ("nvme-core: fix memory leak in dhchap_secret_store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index e3e801e2b78d5..2f823c6b84fd3 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -932,7 +932,6 @@ void nvme_auth_reset(struct nvme_ctrl *ctrl)
 	}
 	mutex_unlock(&ctrl->dhchap_auth_mutex);
 }
-EXPORT_SYMBOL_GPL(nvme_auth_reset);
 
 static void nvme_ctrl_auth_work(struct work_struct *work)
 {
-- 
2.39.2



