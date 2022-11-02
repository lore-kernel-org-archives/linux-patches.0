Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26991633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BDAC433C1;
	Wed,  2 Nov 2022 03:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360786;
	bh=gljs4CoSWjt6lTQdMUPkplTspBxHV3rEwGEo6EQwZT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7IAAKuY/1Yw71jt8DhelFgTfDnJ13oS7l73kyrSB6eOcGjFlKo3h+qPutmjdCo9U
	 m8G8VgufLcpVwsQeJ3PevgMkosO89rDEHvjA/tg2foEEMufT/HxwpfYT16qDCxyh/t
	 9pAOuS/yCzAnDe4TT8dc4Qnv0QTcHHlu2Tz6A/mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/44] media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check interlaced
Date: Wed,  2 Nov 2022 03:35:23 +0100
Message-Id: <20221102022050.369272535@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
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
index 7f34d3c67648..4a38dc2a61e6 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1318,7 +1318,8 @@ struct v4l2_bt_timings {
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



