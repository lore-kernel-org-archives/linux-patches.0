Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64ABA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3694C4339B;
	Tue,  7 Mar 2023 18:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215505;
	bh=Gcrv+bwryH9PY7P5QlGAP6F8gAumfYw4tTtZSl1oExE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMcXE9wA3uep9V3zsrHEWYoFDJk7iYRxk3DNrNuK7ike8bhCrgsjHoiKTCrb0Bpj1
	 nFP1PcuG0CHMus5k/FjoOwBBQppPK0vBm0EfQ1bXna7r6iVsRqC65gXc3yB2Q9u2t/
	 SZHR8FdZYuwPRfWMW5aok4EvV57zlAlYZhOC+1AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/567] media: uvcvideo: Do not check for V4L2_CTRL_WHICH_DEF_VAL
Date: Tue,  7 Mar 2023 18:00:19 +0100
Message-Id: <20230307165918.171892508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit a2f8a484fbc96b8209a760cb3f2c95ca49c2cdb1 ]

The framework already checks for us if V4L2_CTRL_WHICH_DEF_VAL is
written.

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9f582f0418ed ("media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 63842eb223a18..d2e633f6ec671 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1106,10 +1106,6 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 	unsigned int i;
 	int ret;
 
-	/* Default value cannot be changed */
-	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL)
-		return -EINVAL;
-
 	ret = uvc_ctrl_begin(chain);
 	if (ret < 0)
 		return ret;
-- 
2.39.2



