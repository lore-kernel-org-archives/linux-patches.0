Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7281AD3FA;
	Mon, 23 Jun 2025 21:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715800; cv=none; b=D2lsij2dxXqJSktaopU3Ta6yS0uttQ9FofgnmV0nZWOMFWFfJxnQx4YQogDhefFiOvp2gyFdGDOJ22Oc4UdBcLZpwOIvBHlXyBhHpQzy8pM4cxMc2w8iG+L1mDO5+cWq6bTkSobZ9unSm2QOVFuwIMkdP7BphKsxVxzB/JShsvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715800; c=relaxed/simple;
	bh=1setabICNrjYbrYEe06nyy04LeltsbD/X7eTWJVUfr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEMkstdHSr5zdhxcRMYK5pVq5DgdWzVZRuxKaZa5wBEgggCaXDG3zvNrp6LEXrLBgTJuoeF9nQOjQt9cWUEZl9+iSkZm0umJkdzStFRdhz9LN7jwBhf0LSxL5EohtyN7I9eyS4DwkmSdvqboGIVZk18/8M6dogu9DMYGFZcRfVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QHKPfjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QHKPfjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF31C4CEEA;
	Mon, 23 Jun 2025 21:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715797;
	bh=1setabICNrjYbrYEe06nyy04LeltsbD/X7eTWJVUfr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QHKPfjH/cTWdfmwd9poOKXA7t4JRk6oK0Kd227zuLgaSAcwjA2jxkYS1RwZ9EVgU
	 DWGUFMmzhvj+0LG1SQUTLZBwDkDFf9jVA3d22EnzlSwVh2epWKks7UJKSUtGl5S19+
	 WVpVTOEj+88081ZzlI2K8DDh1O8+Lc0TDwx0ZJEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/411] media: uapi: v4l: Fix V4L2_TYPE_IS_OUTPUT condition
Date: Mon, 23 Jun 2025 15:07:03 +0200
Message-ID: <20250623130640.673647127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f5c6758464f25..4e305496edf27 100644
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



