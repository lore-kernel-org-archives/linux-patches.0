Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46231863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689BCC433D2;
	Wed, 28 Dec 2022 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241087;
	bh=2DxtevfUGnzroDfGSDQldGWBBjQQKCg6fVF37FucOGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R24QAcSIAvnHoQZPG7mTBkQCt9BDnp8A07SoqTyYUMPiriBDiyv2mrvaXg3qxKmfA
	 jqsrr8VZGnOpytjYgq/d9jrCc4niFoXNZqjd1vkuZm1iuQLTgHPLvo8zmjfMQW1gyy
	 ZHSplR/pKi6wIZtkMTI0+tw31wY1A6ZCVMMRFrvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0238/1073] media: i2c: ov5648: Free V4L2 fwnode data on unbind
Date: Wed, 28 Dec 2022 15:30:26 +0100
Message-Id: <20221228144334.491931904@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit c95770e4fc172696dcb1450893cda7d6324d96fc ]

The V4L2 fwnode data structure doesn't get freed on unbind, which leads to
a memleak.

Fixes: e43ccb0a045f ("media: i2c: Add support for the OV5648 image sensor")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5648.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov5648.c b/drivers/media/i2c/ov5648.c
index dfcd33e9ee13..220c53565b0a 100644
--- a/drivers/media/i2c/ov5648.c
+++ b/drivers/media/i2c/ov5648.c
@@ -2597,6 +2597,7 @@ static int ov5648_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 	mutex_destroy(&sensor->mutex);
 	media_entity_cleanup(&subdev->entity);
+	v4l2_fwnode_endpoint_free(&sensor->endpoint);
 
 	return 0;
 }
-- 
2.35.1



