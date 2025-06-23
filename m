Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682484C6E;
	Mon, 23 Jun 2025 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685862; cv=none; b=qa7CFtGjWlECxGcDToZP+078DHVU6H4fZMLVjkcGYWNAPptvrKdjhm2zsYZCmDhjdWVqFbpIyqbBoLZ/Wkml1LNuloWz06J1l/+nsst0WpnDV+5xivYFuHN3KTWcI9fDOEQln13dtgnAqjxSkYi3i68Jsi/HB0MGsA1QxmF9CQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685862; c=relaxed/simple;
	bh=zTcruN7qKVo66XTe50CGetfVBLWVpNHw5nIQt6CInUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIz71eFYgYfI+i9fOpxhQBzsPqywdnjdmDt3IPdiRE9M3OREKp/t+xKkW0BUFTfDJXqZCsBdKGy/GtFUVXdRm+Cg7+dcPiL5M0mgeUWBenmIT3AwF73VhvqEz8d7h8maRNSr+5BxzZY0a7rIZ0YTXrmsyHrUgT9+AUEKszuETVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxqNxX0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxqNxX0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04D6C4CEEA;
	Mon, 23 Jun 2025 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685862;
	bh=zTcruN7qKVo66XTe50CGetfVBLWVpNHw5nIQt6CInUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxqNxX0QtS5/X15PFXlyEB+9+0DxdVORZUN+6DrjIEywZczgFaDRM46yS4NEdBXM4
	 t5n1PPbEdNbhjI32Ai5S1+wEJorH0y+CFzBt6xntJ1pVUbeJ4v2xGK5lGhAFo0wmCD
	 APY5OiP5F8zU+8UgWnjFZFfKdX0KdFJMTSCEwY5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/222] media: uapi: v4l: Fix V4L2_TYPE_IS_OUTPUT condition
Date: Mon, 23 Jun 2025 15:08:00 +0200
Message-ID: <20250623130616.448019095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 895c5ba8b6ac2..5384c9d61d510 100644
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



