Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D174BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B03C433A0;
	Tue,  7 Mar 2023 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210705;
	bh=uw2nkjhNQx5+erk0stxMqkev2lIwAdl32LZRI5YipLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryLfAc89Q+tfOx+O0Y1exBkymJcfJuX5YZqMRA1BxrBA4odiFOmbqUmnW6cedNx0Y
	 9PW/ooa4sW7U1qXYDFdkrCbVwzCp8J/aAlVsh8Qdwe1a6jckuxDnS8EQlc8JSnFy0N
	 KGWR5/3ovH6BEZI2j32/bkFXYn9i0VPLQRSZC320=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0597/1001] media: mc: Get media_device directly from pad
Date: Tue,  7 Mar 2023 17:56:09 +0100
Message-Id: <20230307170047.400897309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit a967a3a788028f541e4db54beabcebc3648997db ]

Various functions access the media_device from a pad by going through
the entity the pad belongs to. Remove the level of indirection and get
the media_device from the pad directly.

Fixes: 9e3576a1ae2b ("media: mc: convert pipeline funcs to take media_pad")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/mc-entity.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index b8bcbc734eaf4..f268cf66053e1 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -703,7 +703,7 @@ static int media_pipeline_populate(struct media_pipeline *pipe,
 __must_check int __media_pipeline_start(struct media_pad *pad,
 					struct media_pipeline *pipe)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	struct media_pipeline_pad *err_ppad;
 	struct media_pipeline_pad *ppad;
 	int ret;
@@ -851,7 +851,7 @@ EXPORT_SYMBOL_GPL(__media_pipeline_start);
 __must_check int media_pipeline_start(struct media_pad *pad,
 				      struct media_pipeline *pipe)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
@@ -888,7 +888,7 @@ EXPORT_SYMBOL_GPL(__media_pipeline_stop);
 
 void media_pipeline_stop(struct media_pad *pad)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 
 	mutex_lock(&mdev->graph_mutex);
 	__media_pipeline_stop(pad);
@@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(media_pipeline_stop);
 
 __must_check int media_pipeline_alloc_start(struct media_pad *pad)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	struct media_pipeline *new_pipe = NULL;
 	struct media_pipeline *pipe;
 	int ret;
-- 
2.39.2



