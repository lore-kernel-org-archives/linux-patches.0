Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D226221FC7;
	Mon, 23 Jun 2025 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714762; cv=none; b=UZzz5Ikj1xbrY6MJbOkhxF6eXLxx6PUJTwBVckBtROutIgUgQ++M36Gxa+B3KU91Sm/uqFLs5GJllWoG+LzFVDZ7PzXpj4ZWOsjxqXQYdeMvFUKJnv17wtsEGlxhL47k/o7eIiYYaZ1090F2p7GS07TsnhB8GQbcPdoS4p+el9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714762; c=relaxed/simple;
	bh=wLdaf6nnx9oMRiEycURasWkYqH96PtNUqmc31/UnLBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cU6eN4gDCxNjf14Ypf8DJaevpfkQJk3bIMeQxExxd9C2hTgVjJoWokGHvjlQRd8g43QLr/mcA8y4TJk5EEqUh14IyPAYATr/mVHaLYxOybwdqedgRUdUaJNwqek0Ih0BoDmToSzp19/EL9alCKcy/69oWeEzOWfl/OWL2P3Ohpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOJBOibD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOJBOibD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C62C4CEEA;
	Mon, 23 Jun 2025 21:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714760;
	bh=wLdaf6nnx9oMRiEycURasWkYqH96PtNUqmc31/UnLBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOJBOibDMb+9OaOAl0Bt66EkkVVPXprscqsD4ZJbEVaxnj8j+d9YDihhhLIOv2Cdp
	 +eKgpUmW5lNcjbAhvTVTgo18ql3gvrmAiNysAUgxLOe744DhlNvpPjotlAfub925Wq
	 MZWyswFOQS99mc9b/hxL3v2N01hvZoUIdsbNq3Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/355] media: uapi: v4l: Fix V4L2_TYPE_IS_OUTPUT condition
Date: Mon, 23 Jun 2025 15:07:08 +0200
Message-ID: <20250623130633.568983675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1bbd81f031fe0..a0671e510bc4a 100644
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



