Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038155;
	b=vhW2+M3QVXxrbQP/+o5xmxYWGO3DbRRXvF34+O0wS0M7gm9ec0Klzr5DbSftjKkmCjGl
	 8g5T3mNjjR8U/8zMS7o+S6U0iDRYgTPHei4imG5YHMfRGdIKju5IG8LeYWsE0IHFkPK/U
	 P/5yMt1RDOHoErsvp5yaxkgsydoBRF/kgxAH+WQjZHuFtUqXcqcACy0BGijoqoedtbC+J
	 4s87Ez6Egl1AE9H8YFmUeOHmJonYOz76tRDFG9Pt0W1wRjQlz0WE/GcprYTnzXjGRCJ5q
	 UgMANxER4FJahkq6PjsWPw08RleEtgKGRiIP8FQUQrH7flb5D2TnA90yEmCcgof+DUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ChJcakPvIiRBgal1tg4ZY0uuIPqFqeaMgGWa6m2JbLU=;
	b=Q4H3vy8J53y/MqOI9IPxnZoKBz4+fty7/wk+ImMvxUwqr4Ix+gBW8fwGGV4k4ECydz4r
	 Lxe3pxB5bZ53BthJABlKqzTirtcoo2j8v6UdQGaIgsZC31deRG343+bFYrGGB1Peyo+pM
	 Xrm3oeR+9YGWmCupM3MBu0chErNntp/NQZwVHTOTcmTDKiZrQnMn7goPgrcS3IPnQC+dr
	 lXD1/nwA+3oOtes/j6wdC0/mfL117c3HN0Wsc6CC2Zh/jFhdQGJeyQnO9BzxR2VTNptFJ
	 EThPVja8dR4DoVcsPvwUDGqUL/E/ddbEpxCH11ypu6smvxilBENsya9l47uVgsW5GfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIINsW7V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D19606A31C;
	Wed, 18 Nov 2026 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIINsW7V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7A21F000C5;
	Wed, 18 Nov 2026 21:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038155;
	bh=ChJcakPvIiRBgal1tg4ZY0uuIPqFqeaMgGWa6m2JbLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIINsW7Visrxomec9IGqG9XYbPkFYl6ShQZKQs+YWfiCDIHQwMXv/pi5NdaD9DqcX
	 hVXggTtjKzhww7NC8a70M6wq+cItZ6MHs0LBeioaSobhdxxOnhbR5pySr0uR3/XQid
	 u6CQ+n7fqKV4feDLU6nfr4jjWboZm+VYwOqhB7h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1643/3318] drm/panel: Fix build error on !CONFIG_OF
Date: Wed, 18 Nov 2026 15:37:45 +0100
Message-ID: <20261118150411.051504677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Moved __devm_drm_panel_alloc() ahead of the #ifdef CONFIG_OF block, since the refcount helpers that upstream also moves don't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 50 ++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index ea1f42cee44dc..02bcaf52c9ec0 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -298,6 +298,31 @@ int drm_panel_get_modes(struct drm_panel *panel,
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
@@ -336,31 +361,6 @@ struct drm_panel *of_drm_find_panel(const struct device_node *np)
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



