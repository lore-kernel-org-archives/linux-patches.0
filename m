Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110EE168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2FBC433EF;
	Mon,  8 May 2023 11:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543874;
	bh=B517lV98URvzAzWW6x1EzZsCGBdfmnc2hlRypsbEHgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPbgfObds7u8+qK3N3yP6B3EiW+YFzkpQg8r84DDPfLTJ5tb4eLUEGtjaieMy6Lak
	 cHVb9MOKpRV7/klYZhSVpDpK9yAnd9Qv7J0N3Q+YklWJVbXeG1P8zsl2skXjRzO5kI
	 oT77pWqVZu6Ha4RBnJm0Xn8BwlyArRt8lVmk+vDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 212/694] media: max9286: Free control handler
Date: Mon,  8 May 2023 11:40:47 +0200
Message-Id: <20230508094439.248552619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit bfce6a12e5ba1edde95126aa06778027f16115d4 ]

The control handler is leaked in some probe-time error paths, as well as
in the remove path. Fix it.

Fixes: 66d8c9d2422d ("media: i2c: Add MAX9286 driver")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index 701038d6d19b1..13a986b885889 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -1122,6 +1122,7 @@ static int max9286_v4l2_register(struct max9286_priv *priv)
 static void max9286_v4l2_unregister(struct max9286_priv *priv)
 {
 	fwnode_handle_put(priv->sd.fwnode);
+	v4l2_ctrl_handler_free(&priv->ctrls);
 	v4l2_async_unregister_subdev(&priv->sd);
 	max9286_v4l2_notifier_unregister(priv);
 }
-- 
2.39.2



