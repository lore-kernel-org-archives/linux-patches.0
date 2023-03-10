Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE38825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B7AC4339B;
	Fri, 10 Mar 2023 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460252;
	bh=H4+k/Z480BeGrJ8zw94AkGB9w6fmYN3hzRNi2vfHswc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0QfQx7mX/TP6MdYvt1bAovEafQBamhlfmqnoNzmAILiAq6gdYaGQ2qEdTBmkaFI9
	 8J/rMn8DPqP74mJxJcwKDIbfyM6OOVgZGqieiCwRLxy1FtA+VkGLbPqtrm1eGGl4L6
	 wfkaXsEpGrSDesi5cUMpsWT2MK8UyYd5AScF0CL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sameer Puri <purisame@spuri.io>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/529] media: i2c: imx219: remove redundant writes
Date: Fri, 10 Mar 2023 14:36:56 +0100
Message-Id: <20230310133817.615104780@linuxfoundation.org>
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

From: Sameer Puri <purisame@spuri.io>

[ Upstream commit fbef89886da6d7735d20fdde16a1ee6ed6c6ab56 ]

These writes to 0x162, 0x163 already appear earlier in the struct for
the 1920x1080 mode and do not need to be repeated.

Signed-off-by: Sameer Puri <purisame@spuri.io>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: ef86447e775f ("media: i2c: imx219: Fix binning for RAW8 capture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 4771d0ef2c46f..cad0a8df203ed 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -262,8 +262,6 @@ static const struct imx219_reg mode_1920_1080_regs[] = {
 	{0x4793, 0x10},
 	{0x4797, 0x0e},
 	{0x479b, 0x0e},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 };
 
 static const struct imx219_reg mode_1640_1232_regs[] = {
-- 
2.39.2



