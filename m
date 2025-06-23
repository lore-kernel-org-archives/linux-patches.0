Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF485347DD;
	Mon, 23 Jun 2025 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685436; cv=none; b=UHelPza7X8LV6FgZ5VrWg9OYbqza4e1OOLAdn5LtWQhZox8gYHlA/b/AlwhZLdkUYVNMQGRAiDcyZ9i+LQqVliNc96Ewm8PT8umGghfUj3WTkNBLSIMvGoSG+xvDFVLkt8LX8K0595zVSAXIAjQLlB7Tfd6bUhWMG30NXpGY5PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685436; c=relaxed/simple;
	bh=Jc6nrkFdNfGnFJATxZLdf5IIR0oofmhiFBgDtRru+DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgqRUvfTn82wPX1JtsxTTS66bB/VV4JbNZ072ixkgoqV2Rq3xa9ErXwDI9KG0c+zqlOree2/7JdSwVazK6b2widtEcJvr4cPRl+lhGQfao1TW7CD+m1rXiY6l08jJif2NoebshmZ+0GKozAh8tUgjE4HGUP+2u+7eM8QGWxsjGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPOVPqra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPOVPqra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777FEC4CEEA;
	Mon, 23 Jun 2025 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685435;
	bh=Jc6nrkFdNfGnFJATxZLdf5IIR0oofmhiFBgDtRru+DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPOVPqra+yTuXiIZ7QHc927LWAEcgQmMHWkyWHYC62k14MEVHkO5nhpSC4BIALjuO
	 LhCnB05oeLY79O3S+Fgzqca+nZqRGcey37LqcVqUI9Yabhu66/Iv+YeCUPjl06INBl
	 /LbpzKesiT1UFavD0UVBN/ms+Ab7WaawniTvsiF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 260/592] media: uapi: v4l: Fix V4L2_TYPE_IS_OUTPUT condition
Date: Mon, 23 Jun 2025 15:03:38 +0200
Message-ID: <20250623130706.487623157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nas Chung <nas.chung@chipsnmedia.com>

[ Upstream commit f81f69a0e3da141bdd73a16b8676f4e542533d87 ]

V4L2_TYPE_IS_OUTPUT() returns true for V4L2_BUF_TYPE_VIDEO_OVERLAY
which definitely belongs to CAPTURE.

Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/videodev2.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8cb2796130f8..b0e1f660c5f72 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -164,7 +164,6 @@ enum v4l2_buf_type {
 #define V4L2_TYPE_IS_OUTPUT(type)				\
 	((type) == V4L2_BUF_TYPE_VIDEO_OUTPUT			\
 	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE		\
-	 || (type) == V4L2_BUF_TYPE_VIDEO_OVERLAY		\
 	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	\
 	 || (type) == V4L2_BUF_TYPE_VBI_OUTPUT			\
 	 || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT		\
-- 
2.39.5



