Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038132;
	b=Pr+7pCVKWTF4avbCEFiMFvt7MqQfBKZGOlpFqueEWA8fBHO3Bz1kdJ1U3Oh0rR7yEp+n
	 v/uTRcBJpDQ+9HXkg08sObMO3vyrsrajfkhGEHLMmnyl/nCv7oGFy6rYCHhIpzAJMHQd1
	 T3zJmKYMfnakoLtvyszPc0tp4xt00xhBVi65orknhIbd7F4ee2GSGOh9MftSO7a/N4AA3
	 rykiSWLZYCydJDOaB3QM420EFoAsTCBfkEOJdGbGXGMc+GWR5N/aqQz3lZemFhnbIHvf8
	 isYBw3B2+W54y6BnIMJU22xb84+Xd97zWpNzF6nglBf5dxi4AzxQndB3DoED6utIWew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4uisT8p9JnTzIe9pr/uUPydYs8VxJnSgEI5rr4e6vQ=;
	b=hUinGibc3JrJgxTKl7ADkuweHA9hQnP+sI0PvrqqRPnUukt1GhQL83W1mfGyQiImg/X3
	 G6QucGN8O4i4k+w1RxtS+k7OiR3ZfDX1gT0wCeSwq8tAlxlljS7UecydeeIcVBMO6y3Bp
	 rewIy9T3aJ5MWIvSswSECuuL47+TroVudKpot7ZGu3r2qZNHb28o+ugNw/xfJk9e+WuSQ
	 qqAUuUqqpTIlitdX7e8q2760b+sMI20eRdTS4dLgr68LkZbGv+Xw83sZTy5tpcHx3XVBR
	 hIUwHEkju4Ux3AzPcGuiLl6UEWLvn+8SmcjMh/qE/rRnJTXM8IRnq7TmvWJMIKuwqJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZz2YK9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCC5606A32C;
	Wed, 18 Nov 2026 21:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZz2YK9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF1C1F000C4;
	Wed, 18 Nov 2026 21:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038132;
	bh=f4uisT8p9JnTzIe9pr/uUPydYs8VxJnSgEI5rr4e6vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZz2YK9GFPE12FQfGN2whj4kYhIO3LtPZZ8Dgt2QLo+p9XknjywjXIZj5IXgnQRMR
	 FE9Q9QGggSKWVQW42MIWNy1KaUTo/ruh2rM4cSVBdMcPVucZLb2yj3PBdgtuwfBdrL
	 SvCB6ZbLlEBK2J7iVl5e+GT7yfjKoJRKsuUtL9Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Anusha Srivatsa <asrivats@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1636/3318] drm/panel: Add new helpers for refcounted panel allocatons
Date: Wed, 18 Nov 2026 15:37:38 +0100
Message-ID: <20261118150410.833912073@linuxfoundation.org>
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

From: Anusha Srivatsa <asrivats@redhat.com>

[ Upstream commit ed9c594d495deb676825489032cee0a03ce29bf9 ]

Introduce reference counted allocations for panels to avoid
use-after-free. The patch adds the macro devm_drm_bridge_alloc()
to allocate a new refcounted panel. Followed the documentation for
drmm_encoder_alloc() and devm_drm_dev_alloc and other similar
implementations for this purpose.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Anusha Srivatsa <asrivats@redhat.com>
Link: https://lore.kernel.org/r/20250331-b4-panel-refcounting-v4-1-dad50c60c6c9@redhat.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: 4eeeac9d7c36 ("drm/panel: ebbg-ft8719: Set prepare_prev_first")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 25 +++++++++++++++++++++++++
 include/drm/drm_panel.h     | 22 ++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index 98df4788d096f..ea1f42cee44dc 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -336,6 +336,31 @@ struct drm_panel *of_drm_find_panel(const struct device_node *np)
 }
 EXPORT_SYMBOL(of_drm_find_panel);
 
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
 /**
  * of_drm_get_panel_orientation - look up the orientation of the panel through
  * the "rotation" binding from a device tree node
diff --git a/include/drm/drm_panel.h b/include/drm/drm_panel.h
index 10015891b056f..daaa259ef898f 100644
--- a/include/drm/drm_panel.h
+++ b/include/drm/drm_panel.h
@@ -269,6 +269,28 @@ struct drm_panel {
 	bool enabled;
 };
 
+void *__devm_drm_panel_alloc(struct device *dev, size_t size, size_t offset,
+			     const struct drm_panel_funcs *funcs,
+			     int connector_type);
+
+/**
+ * devm_drm_panel_alloc - Allocate and initialize a refcounted panel.
+ *
+ * @dev: struct device of the panel device
+ * @type: the type of the struct which contains struct &drm_panel
+ * @member: the name of the &drm_panel within @type
+ * @funcs: callbacks for this panel
+ * @connector_type: the connector type (DRM_MODE_CONNECTOR_*) corresponding to
+ * the panel interface
+ *
+ * Returns:
+ * Pointer to container structure embedding the panel, ERR_PTR on failure.
+ */
+#define devm_drm_panel_alloc(dev, type, member, funcs, connector_type) \
+	((type *)__devm_drm_panel_alloc(dev, sizeof(type), \
+					offsetof(type, member), funcs, \
+					connector_type))
+
 void drm_panel_init(struct drm_panel *panel, struct device *dev,
 		    const struct drm_panel_funcs *funcs,
 		    int connector_type);
-- 
2.53.0



