Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591367;
	b=3Bu/EGVrvNlsWCK/5yhmTSZq2JibXXIjGLTgFzxvLEaoDzYElkEv1dB8q9ndPm0cimKj
	 zMdl8L9q/9UKzEaOlpfr4sPHUhMvhX5iQqQZsTorfcdLcsMiPcmfxwsCB84AYsD5iL9ox
	 yv+NZ2Z0zEVtTWkq3CxtBpJJXOIIdetxJFrS3DQr/Cx6a1uCnFlalqPUJO0Zz6NYedzyu
	 YAj2thItbgs/p2+gmZG3NDZthbd3M2VtUwh8oCDRjKyURjQGdLFbgxeCcG5st3Z0smqmG
	 Y9R26TO/FyFj/IUe2E+BKfz4mu46Wp6FJbrQtzisDAxTcTqL7czLsiG4jM5BG5aKoZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WLUPxOGVVbJp4OILkE3PF7vGDU4K+qoEcS8Qx6/Di7A=;
	b=DS7MRW7aH/3JrqQA5an/mrlEqVfCx9kcvkkC5Tdod86nh4KIptyCZZyQJLJWzjxAmkhQ
	 /zPwtE6CIOLsiMxaVPWdTomjY07ZWw7mWqnnGy0+zeZ35YMLjkyELzbv9NevbxWuXUWim
	 JaeO9Gjvdylgjprvifdz6rFUvUHFNX/YbvxmYPM/qmvPycy8WYS/T1Z/lv6OfEoNkYC2h
	 mgA5TbIrQQCTIBJR9Z6dY4Bd62VrlzmpqGhG6nm7CSuL1UswhnCfyzrIwaUu/XA7+fn94
	 49v7sTeg1Kdw2OzfmYE+uKqnpV6Izw3kXxGc9gy8aABYUE6315NTMaQahnBIfsVel2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SEATqtl8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39BD606B22B;
	Fri, 13 Nov 2026 17:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SEATqtl8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F52C1F000C4;
	Fri, 13 Nov 2026 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591367;
	bh=WLUPxOGVVbJp4OILkE3PF7vGDU4K+qoEcS8Qx6/Di7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEATqtl8TM8LFfJ7f3X5Tsm5YNhr5nNB3fINXnDX4Pp0xZSHgwze+GJJEaKXOt4ym
	 cBlTk/V7gZvpFFH+twMcIACHBD7C2zj2p24GT1m4vOQy99dpWE8573MkZOgSwLFtZd
	 BAfVLqJFyuP5Lq27/R11k+D+UuWxe3Wzezud4dxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/670] drm/panel: Fix build error on !CONFIG_OF
Date: Fri, 13 Nov 2026 10:50:33 -0500
Message-ID: <20261113153827.858493486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 8f47efd68db3bd87941df1ea3a5b77c62db5632e ]

Move helpers outside of CONFIG_OF, so basic allocation also works
without it.

Fixes: ed9c594d495d ("drm/panel: Add new helpers for refcounted panel allocatons")
Fixes: dcba396f6907 ("drm/panel: Add refcount support")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/nyrjnvctqnk6f3x5q7rlmy5nb7iopoti56pgh43zqknici5ms4@cibpldh7epra
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
[ sashal: Moved __devm_drm_panel_alloc() up to just before #ifdef CONFIG_OF instead of moving of_drm_find_panel() down, because the refcount helpers the upstream hunks use are missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 50 ++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index 4d45b61e9a93a..7443aaacdd6c8 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -316,6 +316,31 @@ int drm_panel_get_modes(struct drm_panel *panel,
 }
 EXPORT_SYMBOL(drm_panel_get_modes);
 
+void *__devm_drm_panel_alloc(struct device *dev, size_t size, size_t offset,
+			     const struct drm_panel_funcs *funcs,
+			     int connector_type)
+{
+	void *container;
+	struct drm_panel *panel;
+
+	if (!funcs) {
+		dev_warn(dev, "Missing funcs pointer\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	container = devm_kzalloc(dev, size, GFP_KERNEL);
+	if (!container)
+		return ERR_PTR(-ENOMEM);
+
+	panel = container + offset;
+	panel->funcs = funcs;
+
+	drm_panel_init(panel, dev, funcs, connector_type);
+
+	return container;
+}
+EXPORT_SYMBOL(__devm_drm_panel_alloc);
+
 #ifdef CONFIG_OF
 /**
  * of_drm_find_panel - look up a panel using a device tree node
@@ -354,31 +379,6 @@ struct drm_panel *of_drm_find_panel(const struct device_node *np)
 }
 EXPORT_SYMBOL(of_drm_find_panel);
 
-void *__devm_drm_panel_alloc(struct device *dev, size_t size, size_t offset,
-			     const struct drm_panel_funcs *funcs,
-			     int connector_type)
-{
-	void *container;
-	struct drm_panel *panel;
-
-	if (!funcs) {
-		dev_warn(dev, "Missing funcs pointer\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	container = devm_kzalloc(dev, size, GFP_KERNEL);
-	if (!container)
-		return ERR_PTR(-ENOMEM);
-
-	panel = container + offset;
-	panel->funcs = funcs;
-
-	drm_panel_init(panel, dev, funcs, connector_type);
-
-	return container;
-}
-EXPORT_SYMBOL(__devm_drm_panel_alloc);
-
 /**
  * of_drm_get_panel_orientation - look up the orientation of the panel through
  * the "rotation" binding from a device tree node
-- 
2.53.0



