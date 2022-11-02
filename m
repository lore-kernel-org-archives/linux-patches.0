Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5526C7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6302FC4314A;
	Wed,  2 Nov 2022 02:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357607;
	bh=xfdeAinQ0BM6WBYqRRUMStvX5R0hOlCufeC3h7c++e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNJRhbmQNvrHhJJTo2umnrIoGX3oglyOX4QzHUbbvaXCjkAtnTnH5MaD6v2m/V5Ou
	 i3ElisZF6rVhwHqOBKngtm35VOY6NJP2BED20M0I182TivlYAtd+iz0E9tq8L1472Z
	 g5WYV2/ATA7n3vzpupfyOU/7sMWfIdKYTZ6gBm5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 199/240] media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check interlaced
Date: Wed,  2 Nov 2022 03:32:54 +0100
Message-Id: <20221102022115.896435752@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

[ Upstream commit 8da7f0976b9071b528c545008de9d10cc81883b1 ]

If it is a progressive (non-interlaced) format, then ignore the
interlaced timing values.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 7f68127fa11f ([media] videodev2.h: defines to calculate blanking and frame sizes)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 01e630f2ec78..fbe40307934d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1602,7 +1602,8 @@ struct v4l2_bt_timings {
 	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
 	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
-	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
+	 ((bt)->interlaced ? \
+	  ((bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch) : 0))
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
 	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
-- 
2.35.1



