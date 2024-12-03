Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42A31F8AE0;
	Tue,  3 Dec 2024 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240987; cv=none; b=AmHTtTa69SlxNr8Q2WEE8a4BLIx1UmZzhEUTMFJIUQWmQJjiM4tGXooHuFMv9ho89EeP6HCFRbwcJDbPa7fuWsdxE6OboDUrtdOOgmtTf0K8bvZJPLjL6hBpmSCfZMiZhdApxvI0iEEWbrBI6y+a3lLqmnxseywaRf+BgsHtsZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240987; c=relaxed/simple;
	bh=QABDnYQX+q0ema5zQ2CuE9g1Diogj2K241t8M+cupqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/yhUohEp2ud79HqLIOUzTxCotRCeZjmeqpwzuIiNrfjeB2lXwnsJdAPSlsMCs+KduotZJe4GajaYbz9Nb02vaApiB2RcFC29zjzaiLdYkR2MnZdsLWbV9PiGQ969LbFF/qDCILmIcHpEwHHpfcbsrQ48NM1M1jRlAkDOUIc9Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU7S8p95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU7S8p95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3254FC4CECF;
	Tue,  3 Dec 2024 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240987;
	bh=QABDnYQX+q0ema5zQ2CuE9g1Diogj2K241t8M+cupqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SU7S8p95vKjx8Qe3kC7VxLsrAO/DhgBpVEcL9ueiAbuUsH5ptcE/FvpQe0kUIGJSh
	 KDJ6XsLPcO/FIeFjKi036xRWEB4992YyuZdfQXzo4DQvKe2kavKUYKFsL1YDPnwpCV
	 Wv1LWsUMNafJL20W4ddMYUlXHcu2mVGMKfzCFh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/826] drm/vkms: Drop unnecessary call to drm_crtc_cleanup()
Date: Tue,  3 Dec 2024 15:40:20 +0100
Message-ID: <20241203144755.196536447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



