Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178B21B9C9;
	Mon, 23 Jun 2025 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715562; cv=none; b=nQ1Ar+ZytZ8Sc7020FJiXpujQgq//n/YoPky8+PIzI7v5DOtcYyIfzKcW30Ich28/5NvcrCM1TrRKIi4Y+n59+EPC9PlmsfewIwqQQJcQt1Nl3TvZLPUeiNhNoJneh39OM8hzwBKDxLjepVtXjXIcBwqC4obg9iAmpg0JNJiF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715562; c=relaxed/simple;
	bh=bEb0xE449hWiVRDoR9bYGAE7PsvmjN5qDOMh8WpLt8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqYC9jalLKaziW4s3gXA/mOf9X2fhWt5T22HpqfKNTk3X0gwk3PsVBuBvWWSP7pigUgMcYQvxsvx8UuTmzViwZcw6gLuVaiE7gizxVXD3rY4Ln0AO48CIYuBYAJfucAfiQsbr6e/NXIJsB/iGV4IIMKSyKOhnh3Bv0H5b6NIkko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXV7tcnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXV7tcnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0BBC4CEEA;
	Mon, 23 Jun 2025 21:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715562;
	bh=bEb0xE449hWiVRDoR9bYGAE7PsvmjN5qDOMh8WpLt8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXV7tcnWZvtb3zL6/k1/GRviSAsaEUBLfBpnoAJmk4qG3g5jWy6izo0DSASfdHP1y
	 yzJv/Yn5Utwns/M9uzka1+QJPGl03+RmEIsgt5CkIFE/7g4doYLNiPMrD0KNlpx1LL
	 va+UUoOgt6JdI2uWKDupVxoIa0xzFIVu28+onnyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/411] media: uapi: v4l: Change V4L2_TYPE_IS_CAPTURE condition
Date: Mon, 23 Jun 2025 15:07:09 +0200
Message-ID: <20250623130640.823732015@linuxfoundation.org>
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

[ Upstream commit ad2698efce37e910dcf3c3914263e6cb3e86f8cd ]

Explicitly compare a buffer type only with valid buffer types,
to avoid matching a buffer type outside of the valid buffer type set.

Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/videodev2.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4e305496edf27..96802f9b0955d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -153,10 +153,18 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
 	V4L2_BUF_TYPE_META_CAPTURE         = 13,
 	V4L2_BUF_TYPE_META_OUTPUT	   = 14,
+	/*
+	 * Note: V4L2_TYPE_IS_VALID and V4L2_TYPE_IS_OUTPUT must
+	 * be updated if a new type is added.
+	 */
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
 
+#define V4L2_TYPE_IS_VALID(type)		 \
+	((type) >= V4L2_BUF_TYPE_VIDEO_CAPTURE &&\
+	 (type) <= V4L2_BUF_TYPE_META_OUTPUT)
+
 #define V4L2_TYPE_IS_MULTIPLANAR(type)			\
 	((type) == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE	\
 	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
@@ -170,7 +178,8 @@ enum v4l2_buf_type {
 	 || (type) == V4L2_BUF_TYPE_SDR_OUTPUT			\
 	 || (type) == V4L2_BUF_TYPE_META_OUTPUT)
 
-#define V4L2_TYPE_IS_CAPTURE(type) (!V4L2_TYPE_IS_OUTPUT(type))
+#define V4L2_TYPE_IS_CAPTURE(type)	\
+	(V4L2_TYPE_IS_VALID(type) && !V4L2_TYPE_IS_OUTPUT(type))
 
 enum v4l2_tuner_type {
 	V4L2_TUNER_RADIO	     = 1,
-- 
2.39.5



