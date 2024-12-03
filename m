Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0271F8905;
	Tue,  3 Dec 2024 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238628; cv=none; b=nz6Kk6cl96xDZib/FmcZ2gIRZuKGGJbJJJGy3xLUL4H65t0Frk36v5GXYGE+6jbT0s0EmazezweVVrLQNHoIFfgzmJETaLugI2PwVwSQoYLR3e81i7Swu+RAuiXKa7SnMD27vDH8uRW0qSu7DJW6yR+45hBdz58BZ4MQYXTRvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238628; c=relaxed/simple;
	bh=i5Nb/ytEBxSrfBGPE4JkxWUFfbWtAkqdAYMrNHSxWOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFB9dgwcpFrN7L0RYTjkSSb5fqz2ar7cq+Iy1LvfUsXyXkj24z1nDwTEtmvr5sS3MvqEt+Juqe3hSgvozCnyjG85MdiKDGoWUXzKljvGdTKxqPqwqiAWzVmbujNfhebkF4pOg7sQuG9hrGMlgDsXNOSEY2CAFKfFZazOkKPlL2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YstJM8wM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YstJM8wM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AB7C4CECF;
	Tue,  3 Dec 2024 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238626;
	bh=i5Nb/ytEBxSrfBGPE4JkxWUFfbWtAkqdAYMrNHSxWOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YstJM8wMiPbzayScCSEtYdAxDIGpoygVW7t03nljFmatTbgmD8Vs/Req3sCVuh/iC
	 wdBrfqyAZRsZZpd2ULHpNFq23hs0Qgsyk3+urBWbgsVZOQgUTL0zWTyvpD4c0Z2VcL
	 71bzR112QFUoxDsYGI/JWqu+ImuKykbfHJ9+TUdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 311/817] drm/vkms: Drop unnecessary call to drm_crtc_cleanup()
Date: Tue,  3 Dec 2024 15:38:03 +0100
Message-ID: <20241203144007.956049390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



