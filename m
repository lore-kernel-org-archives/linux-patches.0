Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4FB202F7C;
	Fri,  6 Dec 2024 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497202; cv=none; b=hHD3TECLo8jCmWKEMl1hV4Ax3nga07qgZHLOCGRdN6oFZ7QZvLa+ubFDkMUV4Rc+ctuPESgWV9z0Lq55wFX3/uvv8mtlX88ZhXBXCvxzS8iY7cXTFBRv+elOpqgOdFtqXKVJPEla2j+4vep+yEZ+V8Ibktzc+psPKTkip56VOh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497202; c=relaxed/simple;
	bh=mr336uKddIgfOvJ8FFu/pB/bG9Uf1ulA5gA6EQhZRKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ivWQinU+tzF4xGUNp7P21/yNUmAKsWneBUJ5zgTvnxvHvrRLnpay119Zy2VvMuVCMsj4zNeapoJdy0sZBNtCNIKhvi60r0iQ9NoCLNV2y4BuQHps+1K4LBnrIk7o+gqXjhsCVGdGJFqblTcy6yrXA8/6JFVXrLARG0wyD3N+TLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqvaKGQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqvaKGQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CCEC4CED1;
	Fri,  6 Dec 2024 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497201;
	bh=mr336uKddIgfOvJ8FFu/pB/bG9Uf1ulA5gA6EQhZRKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqvaKGQmYkfSz3bSFL76uPLa3kGdhamhHrotxt2qGj/ImAx0vT5TjWOn332RhbU8t
	 diSj4IsvMY4W1+Mib5Z6DAs3DZYCXHiY+vuG/5KnG5RvMWpM9XedPnlGPKqAW6LB7C
	 emAXfOreL9qZJawbli+RjBWY01hf/h2YDqJNkxAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/676] drm/vkms: Drop unnecessary call to drm_crtc_cleanup()
Date: Fri,  6 Dec 2024 15:30:43 +0100
Message-ID: <20241206143702.086619254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 1d43dddd7c38ea1aa93f78f7ee10087afb0a561f ]

CRTC creation uses drmm_crtc_init_with_planes(), which automatically
handles cleanup. However, an unnecessary call to drm_crtc_cleanup() is
still present in the vkms_output_init() error path.

Fixes: 99cc528ebe92 ("drm/vkms: Use drmm_crtc_init_with_planes()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241031183835.3633-1-jose.exposito89@gmail.com
Acked-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_output.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_output.c b/drivers/gpu/drm/vkms/vkms_output.c
index 5ce70dd946aa6..24589b947dea3 100644
--- a/drivers/gpu/drm/vkms/vkms_output.c
+++ b/drivers/gpu/drm/vkms/vkms_output.c
@@ -84,7 +84,7 @@ int vkms_output_init(struct vkms_device *vkmsdev, int index)
 				 DRM_MODE_CONNECTOR_VIRTUAL);
 	if (ret) {
 		DRM_ERROR("Failed to init connector\n");
-		goto err_connector;
+		return ret;
 	}
 
 	drm_connector_helper_add(connector, &vkms_conn_helper_funcs);
@@ -119,8 +119,5 @@ int vkms_output_init(struct vkms_device *vkmsdev, int index)
 err_encoder:
 	drm_connector_cleanup(connector);
 
-err_connector:
-	drm_crtc_cleanup(crtc);
-
 	return ret;
 }
-- 
2.43.0



