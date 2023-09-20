Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37013C687
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CDEC433C7;
	Wed, 20 Sep 2023 12:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213151;
	bh=ivjqjm4OQPr1jLKkuVKziKrFY5/tC6qDkV7eOSb5dyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaOeM+DfKtQDA3bVxXYckDgh8nofK8HmNxX0atZsGb9tLW4rypzYk5dJm6rglUy1f
	 6lEEMg/s1/fj5cK5WsKu+WvEGA8769T1zGlBL2XYE9NNUUbPIqSGUfYotJM1sgREdr
	 W7VinU4MBdIgnYXYbvdMHw5x4Sv5PyB3b0348gWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/367] media: i2c: ov2680: Set V4L2_CTRL_FLAG_MODIFY_LAYOUT on flips
Date: Wed, 20 Sep 2023 13:29:16 +0200
Message-ID: <20230920112903.269862041@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 66274280b2c745d380508dc27b9a4dfd736e5eda ]

The driver changes the Bayer order based on the flips, but
does not define the control correctly with the
V4L2_CTRL_FLAG_MODIFY_LAYOUT flag.

Add the V4L2_CTRL_FLAG_MODIFY_LAYOUT flag.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 7b5a42e6ae71 ("media: ov2680: Remove auto-gain and auto-exposure controls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 59cdbc33658ce..cd0c083a4768a 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -966,6 +966,8 @@ static int ov2680_v4l2_register(struct ov2680_dev *sensor)
 
 	ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrls->vflip->flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
+	ctrls->hflip->flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
 
 	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
 	v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
-- 
2.40.1



