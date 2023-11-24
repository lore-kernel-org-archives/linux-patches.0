Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F2E39FD7;
	Fri, 24 Nov 2023 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRDHXUW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C56C433C8;
	Fri, 24 Nov 2023 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849153;
	bh=lVmOWCAK/gJPuR5FI9ErSF3Vq/Pu4zCbGpAO40Iv3Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRDHXUW6OCK8zB75gFHWmUKTlsxcUA7KMmNoZvgaN1ml9kUmyBC9zT5Jh5Uni/I88
	 +vlI5qQknQSbJ2nFaiC19mUWnWXcI4kvDpBdgLo1nG5isLFvZmP9/64qenXkVxp8Zx
	 euLnJc1sjpZc0rDB2r/6eK0Akcul6AY0ZecSXSF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/530] drm/panel/panel-tpo-tpg110: fix a possible null pointer dereference
Date: Fri, 24 Nov 2023 17:43:55 +0000
Message-ID: <20231124172030.162625842@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit f22def5970c423ea7f87d5247bd0ef91416b0658 ]

In tpg110_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a NULL pointer dereference on
failure of drm_mode_duplicate(). Add a check to avoid npd.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231009090446.4043798-1-make_ruc2021@163.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231009090446.4043798-1-make_ruc2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-tpo-tpg110.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-tpo-tpg110.c b/drivers/gpu/drm/panel/panel-tpo-tpg110.c
index 845304435e235..f6a212e542cb9 100644
--- a/drivers/gpu/drm/panel/panel-tpo-tpg110.c
+++ b/drivers/gpu/drm/panel/panel-tpo-tpg110.c
@@ -379,6 +379,8 @@ static int tpg110_get_modes(struct drm_panel *panel,
 	connector->display_info.bus_flags = tpg->panel_mode->bus_flags;
 
 	mode = drm_mode_duplicate(connector->dev, &tpg->panel_mode->mode);
+	if (!mode)
+		return -ENOMEM;
 	drm_mode_set_name(mode);
 	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 
-- 
2.42.0



