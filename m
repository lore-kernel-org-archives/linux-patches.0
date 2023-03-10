Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFFF8825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CB3C4339C;
	Fri, 10 Mar 2023 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460286;
	bh=GOO+5daKcvgCJqX2TW7Ow94BY1PLOJrsyOhdMpXME5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1vSOlF6tj9jNe72lfJD8rLhCTduE9XJKT3rfMc265tKcXiGrXNMM28LPzy6Gpw2v
	 JaDUDJQN0DeqE099cTte2GCL5m99EOiA0bXe7zVIKcY/hL53qV7jbc/ixBjr2RH0cP
	 brr4+qk+jvcXCLcXtLmAwf9zyLokYVDJf1/6+B+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/529] media: i2c: ov7670: 0 instead of -EINVAL was returned
Date: Fri, 10 Mar 2023 14:37:00 +0100
Message-Id: <20230310133817.789339279@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 6a4c664539e6de9b32b65ddcf767ec1bcc1d7f8a ]

If the media bus is unsupported, then return -EINVAL. Instead it
returned 'ret' which happened to be 0.

This fixes a smatch warning:

ov7670.c:1843 ov7670_parse_dt() warn: missing error code? 'ret'

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 01b8444828fc ("media: v4l2: i2c: ov7670: Implement OF mbus configuration")
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 154776d0069ea..e47800cb6c0f7 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1824,7 +1824,7 @@ static int ov7670_parse_dt(struct device *dev,
 
 	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
 		dev_err(dev, "Unsupported media bus type\n");
-		return ret;
+		return -EINVAL;
 	}
 	info->mbus_config = bus_cfg.bus.parallel.flags;
 
-- 
2.39.2



