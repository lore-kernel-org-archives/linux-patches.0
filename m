Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A4915CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED94AC433D7;
	Tue,  8 Nov 2022 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916614;
	bh=aWWKt+ul8OJyODn7hJWxMis7sxtGLPT1ptklxe2XRB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6KvTG/3W8pO/0RpRQSF+k50LsTZc9dwN9PH7S79c5WKNzpgnDbYPE20mNeC21RuB
	 5LubxEsh0osWGGi4kkFHWxH3GDsnTvHvxr99b0YfhDGHmEqV5DePnO2oY4lMpTKVes
	 bzNw7VW27eoKMVlBGFB9kcx78qiz7u46bvTWKOIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 077/197] media: v4l: subdev: Fail graciously when getting try data for NULL state
Date: Tue,  8 Nov 2022 14:38:35 +0100
Message-Id: <20221108133358.349290488@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2ba3e38517f5a4ebf9c997168079dca01b7f9fc6 ]

The state argument for the functions for obtaining various parts of the
state is NULL if it is called by drivers for active state. Fail graciously
in that case instead of dereferencing a NULL pointer.

Suggested-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/v4l2-subdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9689f38a0af1..ec1896886dbd 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1046,6 +1046,8 @@ v4l2_subdev_get_pad_format(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_state *state,
 			   unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_fmt;
@@ -1064,6 +1066,8 @@ v4l2_subdev_get_pad_crop(struct v4l2_subdev *sd,
 			 struct v4l2_subdev_state *state,
 			 unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_crop;
@@ -1082,6 +1086,8 @@ v4l2_subdev_get_pad_compose(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_state *state,
 			    unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_compose;
-- 
2.35.1



